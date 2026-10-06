import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'CLIENT KILL ID clientid' command.
final class ClientKillCommand(final int clientId) extends ValkeyCommand<int> {
  @override
  List<String> get commandParts => [
    'CLIENT',
    'KILL',
    'ID',
    clientId.toString(),
  ];

  @override
  int parse(dynamic data) {
    if (data is int) {
      return data;
    }
    throw ValkeyException(
      'Invalid response for CLIENT KILL: expected an integer, got ${data.runtimeType}',
    );
  }
}
