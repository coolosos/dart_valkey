import '../command.dart';

/// Represents the `PSUBSCRIBE pattern [pattern ...]` command.
///
/// Subscribes the client to channels matching one or more glob-style patterns.
/// This command is typically used internally by ValkeySubscriptionClient.
final class PSubscribeCommand(final List<String> patterns)
    extends PubSubCommand<void> {
  @override
  List<String> get commandParts => ['PSUBSCRIBE', ...patterns];
}
