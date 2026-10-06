import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'HKEYS key' command.
/// Returns all field names in the hash stored at key.
///
/// **Redis Command:**
/// ```text
/// HKEYS user:1
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// *2
/// $4
/// name
/// $3
/// age
/// ```
///
/// **Dart Result (from parse method):**
/// `List<String>` resolving to `['name', 'age']`
///
/// Parameters:
/// - [key]: The key of the hash.
final class HKeysCommand(final String key)
    extends ValkeyCommand<List<String>>
    with KeyedCommand<List<String>> {
  @override
  List<String> get commandParts => ['HKEYS', key];

  @override
  List<String> parse(dynamic data) {
    if (data is List) return data.map((e) => e as String).toList();
    throw ValkeyException(
      'Invalid response for HKEYS: expected a list, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<List<String>> applyPrefix(String prefix) {
    return HKeysCommand('$prefix$key');
  }
}
