import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'RPUSH key value [value ...]' command.
///
/// **Redis Command:**
/// ```text
/// RPUSH mylist item1 item2
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// :2
/// ```
///
/// **Dart Result (from parse method):**
/// `int` resolving to `2`
///
/// Parameters:
/// - [key]: The key of the list.
/// - [values]: The values to push to the list.
final class RPushCommand(final String key, final List<String> values)
    extends ValkeyCommand<int>
    with KeyedCommand<int> {
  @override
  List<String> get commandParts => ['RPUSH', key, ...values];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    throw ValkeyException(
      'Invalid response for RPUSH: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<int> applyPrefix(String prefix) {
    return RPushCommand('$prefix$key', values);
  }
}
