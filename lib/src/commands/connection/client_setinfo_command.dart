import '../command.dart';

/// Represents the 'CLIENT SETINFO key value' command.
final class ClientSetinfoCommand(final String key, final String value)
    extends ValkeyCommand<bool>
    with ExpectOkBoolResponse {
  @override
  List<String> get commandParts => ['CLIENT', 'SETINFO', key, value];
}
