import '../command.dart';

/// Represents the `SUNSUBSCRIBE [channel [channel ...]]` command.
/// Unsubscribes the client from one or more shard channels.
final class SunsubscribeCommand([final List<String> channels = const []])
    extends PubSubCommand<void> {
  @override
  List<String> get commandParts => ['SUNSUBSCRIBE', ...channels];
}
