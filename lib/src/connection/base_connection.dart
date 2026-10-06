import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:meta/meta.dart';

import '../../dart_valkey.dart';

/// Base implementation of a Valkey connection, containing all the common
/// reconnection and error handling logic.
///
/// This class uses the Template Method pattern, requiring subclasses to only
/// implement how the socket is physically created (insecure vs secure).
abstract class BaseConnection implements Connection {
  new({
    required this.respDecoder,
    this.host = '127.00.1',
    this.port = 6379,
    this.connectionTimeout = const Duration(seconds: 10),
    this.onConnected,
    this.onData,
    this.onDone,
    this.onError,
    this.maxReconnectAttempts = 5,
    this.disableNagle = true,
  });

  final String host;
  final int port;
  final Duration connectionTimeout;
  final int maxReconnectAttempts;

  final Future<void> Function()? onConnected;
  final void Function(dynamic data)? onData;
  final void Function()? onDone;
  final void Function(Object error)? onError;

  final bool disableNagle;
  @visibleForTesting
  final BaseRespCodec respDecoder;

  String? username;
  String? password;

  Socket? _socket;
  StreamSubscription<dynamic>? _socketSubscription;

  @visibleForTesting
  Socket? get testSocket => _socket;

  int _reconnectAttempts = 0;
  Timer? _reconnectTimer;

  @override
  bool get isConnected => _socket != null;
  @override
  Future<void> connect({String? username, String? password}) async {
    if (isConnected) return;
    _reconnectAttempts = 0;
    this.username = username;
    this.password = password;
    await _performConnection();
  }

  /// The template method that subclasses must implement to provide a connected socket.
  @protected
  Future<Socket> performSocketConnection();

  Future<void> _performConnection() async {
    try {
      final socket = await performSocketConnection();
      if (disableNagle) {
        socket.setOption(SocketOption.tcpNoDelay, true);
      }

      final decoder = respDecoder.bind(socket).asBroadcastStream();

      final initialCommand = switch (respDecoder) {
        Resp2Decoder() when (password?.isNotEmpty ?? false) => AuthCommand(
          username: username,
          password: password!,
        ),
        Resp3Decoder() => HelloCommand(
          protocolVersion: 3,
          username: username,
          password: password,
        ),
        _ => null,
      };

      if (initialCommand case final ValkeyCommand<dynamic> initialCommand) {
        socket.add(initialCommand.encoded);
        final response = await decoder.first;
        final parsedResponse = initialCommand.parse(response);

        final authSuccess = switch (initialCommand) {
          AuthCommand() => parsedResponse == 'OK',
          HelloCommand() =>
            parsedResponse is Map<String, dynamic> &&
                parsedResponse['proto'] == 3,
          _ => false, // Should not happen for these commands
        };

        if (!authSuccess) {
          throw ValkeyException('Authentication failed: $response');
        }
      }

      _socketSubscription = decoder.listen(
        onData,
        onError: (Object error) {
          onError?.call(error);
          _handleDisconnect();
        },
        onDone: () {
          onDone?.call();
          _handleDisconnect();
        },
        cancelOnError: true,
      );
      _socket = socket;
      _reconnectAttempts = 0;
      await onConnected?.call();
    } catch (e) {
      onError?.call(e);
      _handleDisconnect();
    }
  }

  void _handleDisconnect() {
    _socketSubscription?.cancel();
    _socket?.destroy();
    _socket = null;

    if (_reconnectAttempts < maxReconnectAttempts) {
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    if (_reconnectTimer != null) return;

    final milliseconds =
        min(30000, 500 * pow(2, _reconnectAttempts)).toInt() +
        Random().nextInt(500);

    _reconnectTimer = Timer(Duration(milliseconds: milliseconds), () {
      _reconnectAttempts++;
      _performConnection();

      _reconnectTimer = null;
    });
  }

  @override
  void send(List<int> data) {
    try {
      _socket?.add(data);
    } catch (e) {
      onError?.call(e);
      _handleDisconnect();
    }
  }

  @override
  Future<void> close() async {
    _reconnectTimer?.cancel();
    await _socketSubscription?.cancel();
    _socket?.destroy();
  }
}
