import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'SINTER key [key ...]' command.
/// Returns the members of the intersection of all the given sets.
///
/// **Redis Command:**
/// ```text
/// SINTER set1 set2
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// *1
/// $7
/// member1
/// ```
///
/// **Dart Result (from parse method):**
/// `List<String>` resolving to `['member1']`
final class SInterCommand(final List<String> keys)
    extends ValkeyCommand<List<String>>
    with KeyedCommand<List<String>> {
  @override
  List<String> get commandParts => ['SINTER', ...keys];

  @override
  List<String> parse(dynamic data) {
    if (data is List) return data.map((e) => e as String).toList();
    throw ValkeyException(
      'Invalid response for SINTER: expected a list, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<List<String>> applyPrefix(String prefix) {
    return SInterCommand(keys.map((key) => '$prefix$key').toList());
  }
}
