import '../command.dart';

/// Represents the `CLIENT SETNAME connection-name` command.
final class ClientSetnameCommand(final String name)
    extends ValkeyCommand<String>
    with OkStringResponse {
  @override
  List<String> get commandParts => ['CLIENT', 'SETNAME', name];
}
