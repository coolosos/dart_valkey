import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'APPEND key value' command.
/// Appends a value to a key.
///
/// **Redis Command:**
/// ```text
/// APPEND mykey " World"
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// :11
/// ```
///
/// **Dart Result (from parse method):**
/// `int` resolving to `11` (new length of the string)
///
/// Parameters:
/// - [key]: The key to append to.
/// - [value]: The string to append.
final class AppendCommand(final String key, final String value)
    extends ValkeyCommand<int>
    with KeyedCommand<int> {
  @override
  List<String> get commandParts => ['APPEND', key, value];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    throw ValkeyException(
      'Invalid response for APPEND: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<int> applyPrefix(String prefix) {
    return AppendCommand('$prefix$key', value);
  }
}
