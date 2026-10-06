import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'LRANGE key start stop' command.
///
/// **Redis Command:**
/// ```text
/// LRANGE mylist 0 -1
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// *2
/// $5
/// item1
/// $5
/// item2
/// ```
///
/// **Dart Result (from parse method):**
/// `List<String>` resolving to `['item1', 'item2']`
///
/// Parameters:
/// - [key]: The key of the list.
/// - [start]: The starting offset.
/// - [stop]: The ending offset (inclusive).
final class LRangeCommand(final String key, final int start, final int stop)
    extends ValkeyCommand<List<String>>
    with KeyedCommand<List<String>> {
  @override
  List<String> get commandParts => [
    'LRANGE',
    key,
    start.toString(),
    stop.toString(),
  ];

  @override
  List<String> parse(dynamic data) {
    if (data is List) return data.map((e) => e as String).toList();
    throw ValkeyException(
      'Invalid response for LRANGE: expected a list, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<List<String>> applyPrefix(String prefix) {
    return LRangeCommand('$prefix$key', start, stop);
  }
}
