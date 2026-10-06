import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'HSTRLEN key field' command.
/// Returns the string length of the value associated with field in the hash stored at key.
///
/// **Redis Command:**
/// ```text
/// HSTRLEN user:1 name
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// :5
/// ```
///
/// **Dart Result (from parse method):**
/// `int` resolving to `5`
/// Represents the 'HSTRLEN key field' command.
/// Returns the string length of the value associated with field in the hash stored at key.
///
/// **Redis Command:**
/// ```text
/// HSTRLEN user:1 name
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
/// - [key]: The key of the hash.
/// - [field]: The field to get the length of.
final class HStrLenCommand(final String key, final String field)
    extends ValkeyCommand<int>
    with KeyedCommand<int> {
  @override
  List<String> get commandParts => ['HSTRLEN', key, field];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    throw ValkeyException(
      'Invalid response for HSTRLEN: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<int> applyPrefix(String prefix) {
    return HStrLenCommand('$prefix$key', field);
  }
}
