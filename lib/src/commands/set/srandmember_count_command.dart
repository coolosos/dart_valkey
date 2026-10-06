import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'SRANDMEMBER key count' command.
/// Returns an array of count random members from the set stored at key.
///
/// **Redis Command:**
/// ```text
/// SRANDMEMBER myset 2
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
final class SRandMemberCountCommand(final String key, final int count)
    extends ValkeyCommand<List<String>>
    with KeyedCommand<List<String>> {
  @override
  List<String> get commandParts => ['SRANDMEMBER', key, count.toString()];

  @override
  List<String> parse(dynamic data) {
    if (data is List) return data.map((e) => e as String).toList();
    throw ValkeyException(
      'Invalid response for SRANDMEMBER count: expected a list, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<List<String>> applyPrefix(String prefix) {
    return SRandMemberCountCommand('$prefix$key', count);
  }
}
