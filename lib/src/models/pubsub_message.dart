/// Represents a message received from a Pub/Sub channel.
class PubSubMessage({
  /// The type of the Pub/Sub message ('message', 'pmessage', 'subscribe', etc.).
  required final String type,

  /// The channel the message was received on.
  required final String channel,

  /// The pattern that matched the channel (only for 'pmessage' type).
  final String? pattern,

  /// The actual message content (only for 'message' and 'pmessage' types).
  final String? message,

  /// The number of channels currently subscribed to.
  final int? count,
}) {
  @override
  String toString() {
    return 'PubSubMessage(type: $type, channel: $channel, pattern: $pattern, message: $message)';
  }
}
