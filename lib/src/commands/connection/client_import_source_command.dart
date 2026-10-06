import '../command.dart';

/// Represents the 'CLIENT IMPORT-SOURCE' command.
final class ClientImportSourceCommand extends ValkeyCommand<bool>
    with ExpectOkBoolResponse {
  @override
  List<String> get commandParts => ['CLIENT', 'IMPORT-SOURCE'];
}
