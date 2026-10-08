import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'HGETALL key' command.
///
/// **Redis Command:**
/// ```text
/// HGETALL user:1
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// *4
/// $4
/// name
/// $5
/// Alice
/// $3
/// age
/// $2
/// 30
/// ```
///
/// **Dart Result (from parse method):**
/// `Map<String, String>` resolving to `{'name': 'Alice', 'age': '30'}`
///
/// Parameters:
/// - [key]: The key of the hash.
final class HGetAllCommand(final String key)
    extends ValkeyCommand<Map<String, String>>
    with KeyedCommand<Map<String, String>> {
  @override
  List<String> get commandParts => ['HGETALL', key];

  @override
  Map<String, String> parse(dynamic data) {
    if (data is Map) {
      return data.map((k, v) => MapEntry(k.toString(), v.toString()));
    }
    if (data is List) {
      if (data.isEmpty) return {};
      final map = <String, String>{};
      for (var i = 0; i < data.length; i += 2) {
        map[data[i] as String] = data[i + 1] as String;
      }
      return map;
    }
    throw ValkeyException(
      'Invalid response for HGETALL: expected a list or map, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<Map<String, String>> applyPrefix(String prefix) {
    return HGetAllCommand('$prefix$key');
  }
}
