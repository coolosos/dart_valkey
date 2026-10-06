import '../command.dart';

enum ClientReplyMode { on, off, skip }

/// Represents the 'CLIENT REPLY ON|OFF|SKIP' command.
final class ClientReplyCommand(final ClientReplyMode mode)
    extends ValkeyCommand<bool>
    with ExpectOkBoolResponse {
  @override
  List<String> get commandParts => ['CLIENT', 'REPLY', mode.name.toUpperCase()];
}
