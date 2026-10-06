import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'SDIFF key [key ...]' command.
/// Returns the members of the set resulting from the difference between the first set and all the successive sets.
///
/// **Redis Command:**
/// ```text
/// SDIFF set1 set2
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// *1
/// $7
/// member2
/// ```
///
/// **Dart Result (from parse method):**
/// `List<String>` resolving to `['member2']`
final class SDiffCommand(final List<String> keys)
    extends ValkeyCommand<List<String>>
    with KeyedCommand<List<String>> {
  @override
  List<String> get commandParts => ['SDIFF', ...keys];

  @override
  List<String> parse(dynamic data) {
    if (data is List) return data.map((e) => e as String).toList();
    throw ValkeyException(
      'Invalid response for SDIFF: expected a list, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<List<String>> applyPrefix(String prefix) {
    return SDiffCommand(keys.map((key) => '$prefix$key').toList());
  }
}
