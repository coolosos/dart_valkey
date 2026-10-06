import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'PUBSUB CHANNELS [pattern]' command.
/// Lists the currently active channels.
final class PubsubChannelsCommand([final String? pattern])
    extends ValkeyCommand<List<String>> {
  @override
  List<String> get commandParts => ['PUBSUB', 'CHANNELS', ?pattern];

  @override
  List<String> parse(dynamic data) {
    if (data is List) {
      return data.cast<String>();
    }
    throw ValkeyException(
      'Invalid response for PUBSUB CHANNELS: expected a list of strings, got ${data.runtimeType}',
    );
  }
}
