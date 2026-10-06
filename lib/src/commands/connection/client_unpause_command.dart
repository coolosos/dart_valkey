import '../command.dart';

/// Represents the 'CLIENT UNPAUSE' command.
///
/// **Valkey Command:**
/// ```text
/// CLIENT UNPAUSE
/// ```
///
/// **Valkey Reply:**
/// ```text
/// OK
/// ```
///
/// **Dart Result (from parse method):**
/// `String` resolving to `'OK'`
final class ClientUnpauseCommand extends ValkeyCommand<String>
    with OkStringResponse {
  new();

  @override
  List<String> get commandParts => ['CLIENT', 'UNPAUSE'];
}
