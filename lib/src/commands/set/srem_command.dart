import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'SREM key member [member ...]' command.
///
/// **Redis Command:**
/// ```text
/// SREM myset member1
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// :1
/// ```
///
/// **Dart Result (from parse method):**
/// `int` resolving to `1` (number of members removed)
final class SRemCommand(final String key, final List<String> members)
    extends ValkeyCommand<int>
    with KeyedCommand<int> {
  @override
  List<String> get commandParts => ['SREM', key, ...members];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    throw ValkeyException(
      'Invalid response for SREM: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<int> applyPrefix(String prefix) {
    return SRemCommand('$prefix$key', members);
  }
}
