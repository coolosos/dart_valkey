import '../command.dart';

/// Represents the `SUBSCRIBE channel [channel ...]` command.
///
/// Subscribes the client to one or more channels.
/// This command is typically used internally by ValkeySubscriptionClient.
final class SubscribeCommand(final List<String> channels)
    extends PubSubCommand<void> {
  // Changed extends

  @override
  List<String> get commandParts => ['SUBSCRIBE', ...channels];
}
