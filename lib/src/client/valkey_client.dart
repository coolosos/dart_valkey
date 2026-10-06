library;

import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:meta/meta.dart';

import '../codec/resp_decoder.dart';
import '../codec/valkey_exception.dart';
import '../commands/commands.dart';
import '../connection/connection.dart';
import '../connection/insecure_connection.dart';
import '../connection/secure_connection.dart';
import '../models/pubsub_message.dart';

export '../models/pubsub_message.dart';

part 'mixins/pattern_subscription_mixin.dart';
part 'mixins/regular_subscription_mixin.dart';
part 'mixins/shard_subscription_mixin.dart';
part 'valkey_command_client.dart';
part 'valkey_subscription_client.dart';

/// Base class for Valkey and Valkey Pub/Sub clients, providing common connection management.
sealed class BaseValkeyClient {
  new({
    required String host,
    required int port,
    bool secure = false,
    Duration connectionTimeout = const Duration(seconds: 5),
    bool Function(X509Certificate certificate)? onBadCertificate,
    this.username,
    this.password,
    int maxReconnectAttempts = 5,
    BaseRespCodec respDecoder = const Resp3Decoder(),
    Connection? connection,
    bool disableNagle = true,
  }) {
    _connection =
        connection ??
        (secure
            ? SecureConnection(
                host: host,
                port: port,
                connectionTimeout: connectionTimeout,
                onConnected: _onConnected,
                onData: _onData,
                onDone: _onDone,
                onError: _onError,
                onBadCertificate: onBadCertificate,
                maxReconnectAttempts: maxReconnectAttempts,
                respDecoder: respDecoder,
                disableNagle: disableNagle,
              )
            : InsecureConnection(
                host: host,
                port: port,
                connectionTimeout: connectionTimeout,
                onConnected: _onConnected,
                onData: _onData,
                onDone: _onDone,
                onError: _onError,
                maxReconnectAttempts: maxReconnectAttempts,
                respDecoder: respDecoder,
                disableNagle: disableNagle,
              ));
  }

  final String? username;
  final String? password;

  late final Connection _connection;

  /// Establishes the network connection to the Valkey/Redis server.
  Future<void> connect() async {
    if (!_connection.isConnected) {
      await _connection.connect(username: username, password: password);
    }
  }

  /// Closes the connection to the Valkey/Redis server and releases all associated resources.
  Future<void> close() => _connection.close();

  /// Sends raw encoded data over the connection.
  void _send(List<int> data) => _connection.send(data);

  /// Abstract method to be implemented by subclasses for handling connection establishment.
  Future<void> _onConnected();

  /// Abstract method to be implemented by subclasses for handling incoming data.
  void _onData(dynamic data);

  /// Abstract method to be implemented by subclasses for handling connection closure.
  void _onDone();

  /// Abstract method to be implemented by subclasses for handling connection errors.
  void _onError(Object error);

  @visibleForTesting
  Future<void> handleOnConnectedMock() => _onConnected();
  @visibleForTesting
  void handleDataMock(dynamic data) => _onData(data);
  @visibleForTesting
  void handleDoneMock() => _onDone();
  @visibleForTesting
  void handleErrorMock(Object error) => _onError(error);
}
