import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'LREM key count value' command.
/// Removes the first count occurrences of elements equal to value from the list stored at key.
///
/// **Redis Command:**
/// ```text
/// LREM mylist 1 item1
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// :1
/// ```
///
/// **Dart Result (from parse method):**
/// `int` resolving to `1` (number of elements removed)
final class LRemCommand(final String key, final int count, final String value)
    extends ValkeyCommand<int>
    with KeyedCommand<int> {
  @override
  List<String> get commandParts => ['LREM', key, count.toString(), value];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    throw ValkeyException(
      'Invalid response for LREM: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<int> applyPrefix(String prefix) {
    return LRemCommand('$prefix$key', count, value);
  }
}
