import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'TTL key' command.
/// Gets the time to live for a key in seconds.
///
/// **Redis Command:**
/// ```text
/// TTL mykey
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// :60
/// ```
///
/// **Dart Result (from parse method):**
/// `int` resolving to `60` (TTL in seconds), `-1` (no expire), or `-2` (key does not exist)
final class TtlCommand(final String key)
    extends ValkeyCommand<int>
    with KeyedCommand<int> {
  @override
  List<String> get commandParts => ['TTL', key];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    throw ValkeyException(
      'Invalid response for TTL: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<int> applyPrefix(String prefix) {
    return TtlCommand('$prefix$key');
  }
}
