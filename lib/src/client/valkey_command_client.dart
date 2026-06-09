part of 'valkey_client.dart';

/// A type-safe, robust, and modular client for Valkey and Redis.
///
/// This client provides a clean API for interacting with Valkey/Redis servers.
/// It handles connection management, command pipelining, and type-safe responses.
///
/// Command methods are exposed via Dart extensions, allowing for a modular API.
/// For example, to use String commands, you would typically import:
/// `import 'package:dart_valkey/dart_valkey.dart';`
///
/// Example usage:
/// ```dart
/// final client = ValkeyClient(host: 'localhost', port: 6379);
/// await client.connect();
///
/// // Use extension methods for commands
/// final pong = await client.ping();
/// print(pong);
///
/// await client.close();
/// ```

class ValkeyCommandClient extends BaseValkeyClient {
  /// Creates a new [ValkeyCommandClient] instance.
  ///
  /// This constructor initializes the client but does not establish a connection.
  /// Call [connect] to establish the network connection to the server.
  ///
  /// - [host]: The hostname or IP address of the Valkey/Redis server.
  /// - [port]: The port number of the Valkey/Redis server (default is 6379).
  /// - [db]: The database index to select upon connection (defaults to 0).
  /// - [keyPrefix]: An optional prefix to apply to all keys sent to the server.
  /// - [secure]: If `true`, a TLS/SSL connection will be used. Defaults to `false`.
  /// - [connectionTimeout]: The maximum duration to wait for the initial connection to be established.
  /// - [onBadCertificate]: A callback function for handling bad TLS certificates when [secure] is `true`.
  ValkeyCommandClient({
    required super.host,
    required super.port,
    int db = 0,
    String? keyPrefix,
    super.secure,
    super.connectionTimeout,
    super.onBadCertificate,
    super.username,
    super.password,
    super.connection,
    super.maxReconnectAttempts = 5,
    super.respDecoder = const Resp3Decoder(),
    super.disableNagle = true,
    this.commandTimeout = const Duration(seconds: 1),
  })  : _db = db,
        keyPrefix =
            (keyPrefix?.endsWith(':') ?? false) ? keyPrefix : '$keyPrefix:';

  final int _db;
  final String? keyPrefix;
  final Duration? commandTimeout;
  final Queue<Completer<dynamic>> _commandQueue = Queue();
  final Map<Completer<dynamic>, ValkeyCommand<dynamic>> _pendingCompleters = {};

  /// Executes a [ValkeyCommand] and returns a [Future] that completes with the command\'s result.
  /// - [command]: The [ValkeyCommand] instance to execute.

  Future<T> execute<T>(ValkeyCommand<T> command, {Duration? timeout}) {
    final commandToExecute = switch (command) {
      final KeyedCommand<T> c when (keyPrefix?.isNotEmpty ?? false) =>
        c.applyPrefix(keyPrefix!),
      _ => command,
    };
    final completer = Completer<T>();
    _pendingCompleters[completer] = commandToExecute;
    _commandQueue.add(completer);
    _send(commandToExecute.encoded);

    final effectiveTimeout = timeout ?? commandTimeout;
    if (effectiveTimeout == null || effectiveTimeout <= Duration.zero) {
      return completer.future;
    }

    return completer.future.timeout(
      effectiveTimeout,
      onTimeout: () {
        _commandQueue.remove(completer);
        _pendingCompleters.remove(completer);
        throw TimeoutException('Command timed out after $effectiveTimeout');
      },
    );
  }

  @override
  Future<void> _onConnected() async {
    // Always send SELECT command to ensure the correct database is selected.
    await execute(SelectCommand(_db));
    // Resend any commands that were queued before connection
    for (final completer in _commandQueue) {
      final cmd = _pendingCompleters[completer];
      if (cmd != null) {
        _send(cmd.encoded);
      }
    }
  }

  @override
  void _onData(dynamic data) {
    if (_commandQueue.isNotEmpty) {
      final completer = _commandQueue.removeFirst();
      final command = _pendingCompleters.remove(completer);
      if (command != null) {
        try {
          completer.complete(command.parse(data));
        } catch (e, s) {
          completer.completeError(e, s);
        }
      }
    }
  }

  @override
  void _onDone() {
    _clearQueueWithError(StateError('Connection lost.'));
  }

  @override
  void _onError(Object error) {
    _clearQueueWithError(error);
  }

  void _clearQueueWithError(Object error) {
    for (final completer in _commandQueue) {
      final command = _pendingCompleters.remove(completer);
      if (command != null && !completer.isCompleted) {
        completer.completeError(error);
      }
    }
    _commandQueue.clear();
    _pendingCompleters.clear();
  }
}
