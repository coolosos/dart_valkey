import '../command.dart';

/// Represents the 'EVAL' command.
///
/// **Valkey Command:**
/// ```text
/// EVAL script numKeys key [key ...] arg [arg ...]
/// ```
///
/// **Valkey Reply:**
/// ```text
/// The result of the script execution.
/// ```
final class EvalCommand({
  required final String script,
  required final int numberOfKeys,
  final List<String> keys = const [],
  final List<String> args = const [],
}) extends ValkeyCommand<dynamic> {
  @override
  List<String> get commandParts {
    final parts = ['EVAL', script, numberOfKeys.toString(), ...keys, ...args];
    return parts;
  }

  @override
  dynamic parse(dynamic data) {
    // EVAL can return any RESP type. The decoder handles the parsing.
    // We just return the raw parsed data.
    return data;
  }
}
