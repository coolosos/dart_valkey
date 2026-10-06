import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'ZCOUNT key min max' command.
///
/// **Redis Command:**
/// ```text
/// ZCOUNT myzset 0 10
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// :2
/// ```
///
/// **Dart Result (from parse method):**
/// `int` resolving to `2`
final class ZCountCommand(final String key, final String min, final String max)
    extends ValkeyCommand<int>
    with KeyedCommand<int> {
  @override
  List<String> get commandParts => ['ZCOUNT', key, min, max];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    throw ValkeyException(
      'Invalid response for ZCOUNT: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<int> applyPrefix(String prefix) {
    return ZCountCommand('$prefix$key', min, max);
  }
}
