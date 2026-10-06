import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'SMEMBERS key' command.
///
/// **Redis Command:**
/// ```text
/// SMEMBERS myset
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
final class SMembersCommand(final String key)
    extends ValkeyCommand<List<String>>
    with KeyedCommand<List<String>> {
  @override
  List<String> get commandParts => ['SMEMBERS', key];

  @override
  List<String> parse(dynamic data) {
    if (data is List) return data.map((e) => e as String).toList();
    throw ValkeyException(
      'Invalid response for SMEMBERS: expected a list, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<List<String>> applyPrefix(String prefix) {
    return SMembersCommand('$prefix$key');
  }
}
