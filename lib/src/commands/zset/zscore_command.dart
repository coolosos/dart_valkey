import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'ZSCORE key member' command.
///
/// **Redis Command:**
/// ```text
/// ZSCORE myzset member1
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// $3
/// 1.0
/// ```
///
/// **Dart Result (from parse method):**
/// `double?` resolving to `1.0` or `null`
final class ZScoreCommand(final String key, final String member)
    extends ValkeyCommand<double?>
    with KeyedCommand<double?> {
  @override
  List<String> get commandParts => ['ZSCORE', key, member];

  @override
  double? parse(dynamic data) {
    if (data == null) return null;
    if (data is String) {
      if (double.tryParse(data) case final value?) {
        return value;
      }
    }
    throw ValkeyException(
      'Invalid response for ZSCORE: expected a parsable string or null, got ${data.runtimeType} "$data"',
    );
  }

  @override
  ValkeyCommand<double?> applyPrefix(String prefix) {
    return ZScoreCommand('$prefix$key', member);
  }
}
