import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'STRLEN key' command.
/// Returns the length of the string value stored at key.
///
/// **Redis Command:**
/// ```text
/// STRLEN mykey
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// :5
/// ```
///
/// **Dart Result (from parse method):**
/// `int` resolving to `5`
///
/// Parameters:
/// - [key]: The key to get the length of.
final class StrLenCommand(final String key)
    extends ValkeyCommand<int>
    with KeyedCommand<int> {
  @override
  List<String> get commandParts => ['STRLEN', key];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    throw ValkeyException(
      'Invalid response for STRLEN: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<int> applyPrefix(String prefix) {
    return StrLenCommand('$prefix$key');
  }
}
