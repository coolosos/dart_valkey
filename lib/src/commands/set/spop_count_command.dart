import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'SPOP key count' command.
/// Removes and returns multiple random members from the set value stored at key.
///
/// **Redis Command:**
/// ```text
/// SPOP myset 2
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// *2
/// $7
/// member1
/// $7
/// member2
/// ```
///
/// **Dart Result (from parse method):**
/// `List<String>` resolving to `['member1', 'member2']`
final class SPopCountCommand(final String key, final int count)
    extends ValkeyCommand<List<String>>
    with KeyedCommand<List<String>> {
  @override
  List<String> get commandParts => ['SPOP', key, count.toString()];

  @override
  List<String> parse(dynamic data) {
    if (data is List) return data.map((e) => e as String).toList();
    throw ValkeyException(
      'Invalid response for SPOP count: expected a list, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<List<String>> applyPrefix(String prefix) {
    return SPopCountCommand('$prefix$key', count);
  }
}
