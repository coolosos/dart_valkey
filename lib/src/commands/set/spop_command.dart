import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'SPOP key' command.
/// Removes and returns a random member from the set value stored at key.
///
/// **Redis Command:**
/// ```text
/// SPOP myset
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
final class SPopCommand(final String key)
    extends ValkeyCommand<String?>
    with KeyedCommand<String?> {
  @override
  List<String> get commandParts => ['SPOP', key];

  @override
  String? parse(dynamic data) {
    if (data == null || data is String) return data as String?;
    throw ValkeyException(
      'Invalid response for SPOP: expected a string or null, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<String?> applyPrefix(String prefix) {
    return SPopCommand('$prefix$key');
  }
}
