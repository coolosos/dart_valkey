import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'PUBSUB SHARDCHANNELS [pattern]' command.
/// Lists the currently active shard channels.
final class PubsubShardchannelsCommand([final String? pattern])
    extends ValkeyCommand<List<String>> {
  @override
  List<String> get commandParts => ['PUBSUB', 'SHARDCHANNELS', ?pattern];

  @override
  List<String> parse(dynamic data) {
    if (data is List) {
      return data.cast<String>();
    }
    throw ValkeyException(
      'Invalid response for PUBSUB SHARDCHANNELS: expected a list of strings, got ${data.runtimeType}',
    );
  }
}
