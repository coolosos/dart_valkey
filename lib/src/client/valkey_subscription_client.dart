part of 'valkey_client.dart';

/// Represents a client for Valkey's Pub/Sub functionality.
///
/// This object manages a dedicated connection to the Valkey server for Pub/Sub
/// operations. A single client can subscribe to multiple channels and patterns,
/// and all messages are delivered through a single [messages] stream.
class ValkeySubscriptionClient extends BaseValkeyClient
    with
        RegularSubscriptionMixin,
        PatternSubscriptionMixin,
        ShardSubscriptionMixin {
  /// Creates a new [ValkeySubscriptionClient] instance.
  ///
  /// This constructor initializes the client but does not establish a connection.
  /// Call [connect] to establish the network connection to the server.
  new({
    required super.host,
    required super.port,
    super.secure,
    super.connectionTimeout,
    super.onBadCertificate,
    super.username,
    super.password,
    super.connection,
    super.maxReconnectAttempts = 5,
    super.respDecoder = const Resp3Decoder(),
    super.disableNagle = true,
  }) {
    _pendingCompleters = {};
    _commandQueue = Queue();
  }

  late final Map<Completer<dynamic>, ValkeyCommand<dynamic>> _pendingCompleters;
  late final Queue<Completer<dynamic>> _commandQueue;

  final _messageController = StreamController<PubSubMessage>.broadcast();

  /// A stream of [PubSubMessage]s received from all subscriptions.
  Stream<PubSubMessage> get messages => _messageController.stream;

  /// Unsubscribes from all channels and patterns and closes the connection.
  @override
  Future<void> close() async {
    unsubscribe();
    punsubscribe();
    sunsubscribe();
    await _connection.close();
    await _messageController.close();
  }

  @override
  Future<void> _onConnected() async {
    // Resubscribe to all channels and patterns if the connection is re-established.
    if (_subscribedChannels.isNotEmpty) {
      _sendSubscribeCommand(_subscribedChannels.toList());
    }
    if (_subscribedPatterns.isNotEmpty) {
      _sendPSubscribeCommand(_subscribedPatterns.toList());
    }
    if (_subscribedShardChannels.isNotEmpty) {
      _sendSsubscribeCommand(_subscribedShardChannels.toList());
    }
  }

  @override
  void _onData(dynamic data) {
    if (data is List && data.isNotEmpty) {
      final type = data[0] as String;
      switch (type) {
        case 'smessage':
          if (data.length == 3) {
            _messageController.add(
              PubSubMessage(
                type: type,
                channel: data[1] as String,
                message: data[2] as String?,
              ),
            );
          }
        case 'message':
          if (data.length == 3) {
            _messageController.add(
              PubSubMessage(
                type: type,
                channel: data[1] as String,
                message: data[2] as String?,
              ),
            );
          }
        case 'pmessage':
          if (data.length == 4) {
            _messageController.add(
              PubSubMessage(
                type: type,
                pattern: data[1] as String?,
                channel: data[2] as String,
                message: data[3] as String?,
              ),
            );
          }
        case 'subscribe':
        case 'psubscribe':
        case 'ssubscribe':
        case 'unsubscribe':
        case 'punsubscribe':
        case 'sunsubscribe':
          if (data.length == 3) {
            if (_commandQueue.isNotEmpty) {
              final completer = _commandQueue.removeFirst();
              final command = _pendingCompleters.remove(completer);
              if (command != null) {
                try {
                  completer.complete(command.parse(data) as Object?);
                } catch (e, s) {
                  completer.completeError(e, s);
                }
              }
            }
            _messageController.add(
              PubSubMessage(
                type: type,
                channel: data[1] as String, // channel or pattern
                count: data[2] as int?,
              ),
            );
          }
        default:
          _messageController.addError(
            ValkeyException('Unknown Pub/Sub message type: $data'),
          );
      }
    }
  }

  @override
  void _onError(Object error) {
    for (final completer in _commandQueue) {
      final command = _pendingCompleters.remove(completer);
      if (command != null && !completer.isCompleted) {
        completer.completeError(error);
      }
    }
    _commandQueue.clear();
    _pendingCompleters.clear();
    _messageController.addError(error);
  }

  @override
  void _onDone() {
    for (final completer in _commandQueue) {
      final command = _pendingCompleters.remove(completer);
      if (command != null && !completer.isCompleted) {
        completer.completeError(StateError('Connection lost.'));
      }
    }
    _commandQueue.clear();
    _pendingCompleters.clear();
    // The connection is closed.
  }

  @override
  @visibleForTesting
  void handleDataMock(dynamic data) => _onData(data);
}
