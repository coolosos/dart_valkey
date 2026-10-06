import '../command.dart';

/// Represents the `SSUBSCRIBE channel [channel ...]` command.
/// Subscribes the client to one or more shard channels.
final class SsubscribeCommand(final List<String> channels)
    extends PubSubCommand<void> {
  @override
  List<String> get commandParts => ['SSUBSCRIBE', ...channels];
}
