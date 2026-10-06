import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the `PUBLISH channel message` command.
///
/// Posts a message to the given channel.
final class PublishCommand(final String channel, final String message)
    extends ValkeyCommand<int> {
  // Changed extends

  @override
  List<String> get commandParts => ['PUBLISH', channel, message];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    throw ValkeyException(
      'Invalid response for PUBLISH: expected an integer, got ${data.runtimeType}',
    );
  }
}
