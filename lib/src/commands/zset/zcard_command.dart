import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'ZCARD key' command.
///
/// **Redis Command:**
/// ```text
/// ZCARD myzset
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// :2
/// ```
///
/// **Dart Result (from parse method):**
/// `int` resolving to `2`
final class ZCardCommand(final String key)
    extends ValkeyCommand<int>
    with KeyedCommand<int> {
  @override
  List<String> get commandParts => ['ZCARD', key];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    throw ValkeyException(
      'Invalid response for ZCARD: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<int> applyPrefix(String prefix) {
    return ZCardCommand('$prefix$key');
  }
}
