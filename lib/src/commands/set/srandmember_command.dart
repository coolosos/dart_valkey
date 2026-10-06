import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'SRANDMEMBER key' command.
/// Returns a random member from the set stored at key.
///
/// **Redis Command:**
/// ```text
/// SRANDMEMBER myset
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// $7
/// member1
/// ```
///
/// **Dart Result (from parse method):**
/// `String?` resolving to `'member1'` or `null`
final class SRandMemberCommand(final String key)
    extends ValkeyCommand<String?>
    with KeyedCommand<String?> {
  @override
  List<String> get commandParts => ['SRANDMEMBER', key];

  @override
  String? parse(dynamic data) {
    if (data == null || data is String) return data as String?;
    throw ValkeyException(
      'Invalid response for SRANDMEMBER: expected a string or null, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<String?> applyPrefix(String prefix) {
    return SRandMemberCommand('$prefix$key');
  }
}
