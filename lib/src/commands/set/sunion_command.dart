import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'SUNION key [key ...]' command.
/// Returns the members of the union of all the given sets.
///
/// **Redis Command:**
/// ```text
/// SUNION set1 set2
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// *3
/// $7
/// member1
/// $7
/// member2
/// $7
/// member3
/// ```
///
/// **Dart Result (from parse method):**
/// `List<String>` resolving to `['member1', 'member2', 'member3']`
final class SUnionCommand(final List<String> keys)
    extends ValkeyCommand<List<String>>
    with KeyedCommand<List<String>> {
  @override
  List<String> get commandParts => ['SUNION', ...keys];

  @override
  List<String> parse(dynamic data) {
    if (data is List) return data.map((e) => e as String).toList();
    throw ValkeyException(
      'Invalid response for SUNION: expected a list, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<List<String>> applyPrefix(String prefix) {
    return SUnionCommand(keys.map((key) => '$prefix$key').toList());
  }
}
