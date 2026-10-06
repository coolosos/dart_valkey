import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'CLIENT GETREDIR' command.
///
/// **Valkey Command:**
/// ```text
/// CLIENT GETREDIR
/// ```
///
/// **Valkey Reply:**
/// ```text
/// Integer reply: the client ID to which the current connection's tracking
/// notifications are being redirected, or 0 if no redirection is active,
/// or -1 if client tracking is not enabled.
/// ```
///
/// **Dart Result (from parse method):**
/// `int` resolving to the client ID, 0, or -1.
final class ClientGetredirCommand extends ValkeyCommand<int> {
  new();

  @override
  List<String> get commandParts => ['CLIENT', 'GETREDIR'];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    throw ValkeyException(
      'Invalid response for CLIENT GETREDIR: expected an integer, got ${data.runtimeType}',
    );
  }
}
