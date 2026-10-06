import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'LINDEX key index' command.
///
/// **Redis Command:**
/// ```text
/// LINDEX mylist 0
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// $5
/// item1
/// ```
///
/// **Dart Result (from parse method):**
/// `String?` resolving to `'item1'` or `null`
///
/// Parameters:
/// - [key]: The key of the list.
/// - [index]: The zero-based index of the element to retrieve.
final class LIndexCommand(final String key, final int index)
    extends ValkeyCommand<String?>
    with KeyedCommand<String?> {
  @override
  List<String> get commandParts => ['LINDEX', key, index.toString()];

  @override
  String? parse(dynamic data) {
    if (data == null || data is String) return data as String?;
    throw ValkeyException(
      'Invalid response for LINDEX: expected a string or null, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<String?> applyPrefix(String prefix) {
    return LIndexCommand('$prefix$key', index);
  }
}
