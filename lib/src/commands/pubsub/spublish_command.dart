import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'SPUBLISH channel message' command.
/// Posts a message to a shard channel.
final class SpublishCommand(final String channel, final String message)
    extends ValkeyCommand<int> {
  @override
  List<String> get commandParts => ['SPUBLISH', channel, message];

  @override
  int parse(dynamic data) {
    if (data is int) {
      return data;
    }
    throw ValkeyException(
      'Invalid response for SPUBLISH: expected an integer, got ${data.runtimeType}',
    );
  }
}
