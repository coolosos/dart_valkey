import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'GETRANGE key start end' command.
/// Returns the substring of the string value stored at key, determined by the offsets start and end (both are inclusive).
///
/// **Redis Command:**
/// ```text
/// GETRANGE mykey 0 4
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// $5
/// Hello
/// ```
///
/// **Dart Result (from parse method):**
/// `String` resolving to `'Hello'`
///
/// Parameters:
/// - [key]: The key to retrieve the substring from.
/// - [start]: The starting offset.
/// - [end]: The ending offset (inclusive).
final class GetRangeCommand(final String key, final int start, final int end)
    extends ValkeyCommand<String>
    with KeyedCommand<String> {
  @override
  List<String> get commandParts => [
    'GETRANGE',
    key,
    start.toString(),
    end.toString(),
  ];

  @override
  String parse(dynamic data) {
    if (data is String) return data;
    throw ValkeyException(
      'Invalid response for GETRANGE: expected a string, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<String> applyPrefix(String prefix) {
    return GetRangeCommand('$prefix$key', start, end);
  }
}
