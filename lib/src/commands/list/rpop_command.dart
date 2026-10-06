import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'RPOP key [count]' command.
///
/// **Redis Command:**
/// ```text
/// RPOP mylist
/// RPOP mylist 2
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// $5
/// item1
/// ```
///
/// **Dart Result (from parse method):**
/// `String?` resolving to `'item1'` or `null` (if count is not provided)
/// `List<String>?` resolving to `['item1', 'item2']` or `null` (if count is provided)
///
/// Parameters:
/// - [key]: The key of the list.
/// - [count]: (Optional) The number of elements to pop.
final class RPopCommand(final String key, [final int? count])
    extends ValkeyCommand<List<String>>
    with KeyedCommand<List<String>> {
  @override
  List<String> get commandParts => [
    'RPOP',
    key,
    if (count != null) count!.toString(),
  ];

  @override
  List<String> parse(dynamic data) {
    if (data == null) return List.empty();
    if (data is String) return [data];

    if (data is List) return data.map((e) => e as String).toList();

    throw ValkeyException(
      'Invalid response for RPOP: expected a string/null or list, got ${data.runtimeType}',
    );
  }

  @override
  RPopCommand applyPrefix(String prefix) {
    return RPopCommand('$prefix$key', count);
  }
}
