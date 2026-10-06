import '../command.dart';

/// Represents the `UNSUBSCRIBE [channel [channel ...]]` command.
///
/// Unsubscribes the client from one or more channels.
/// This command is typically used internally by ValkeySubscriptionClient.
final class UnsubscribeCommand(final List<String> channels)
    extends PubSubCommand<void> {
  // Changed extends

  @override
  List<String> get commandParts => ['UNSUBSCRIBE', ...channels];
}
