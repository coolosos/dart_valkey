import '../command.dart';

/// Represents the `CLIENT PAUSE timeout [WRITE]` command.
final class ClientPauseCommand(final int timeout, {final bool write = false})
    extends ValkeyCommand<bool>
    with ExpectOkBoolResponse {
  @override
  List<String> get commandParts => [
    'CLIENT',
    'PAUSE',
    timeout.toString(),
    if (write) 'WRITE',
  ];
}
