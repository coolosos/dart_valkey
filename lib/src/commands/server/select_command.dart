import '../command.dart';

/// Represents the `SELECT` command in Valkey.
///
/// Selects the database with the specified zero-based index.
final class SelectCommand(final int index)
    extends ValkeyCommand<bool>
    with OkBoolResponse {
  @override
  List<String> get commandParts => ['SELECT', index.toString()];
}
