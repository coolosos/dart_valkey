import '../command.dart';

/// Represents the `PUNSUBSCRIBE [pattern [pattern ...]]` command.
///
/// Unsubscribes the client from channels matching one or more glob-style patterns.
/// This command is typically used internally by ValkeySubscriptionClient.
final class PUnsubscribeCommand(final List<String> patterns)
    extends PubSubCommand<void> {
  // Changed extends

  @override
  List<String> get commandParts => ['PUNSUBSCRIBE', ...patterns];
}
