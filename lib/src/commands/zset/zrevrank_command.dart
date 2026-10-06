import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'ZREVRANK key member' command.
/// Returns the rank of member in the sorted set at key, with the scores ordered from high to low.
///
/// **Redis Command:**
/// ```text
/// ZREVRANK myzset member2
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// :0
/// ```
///
/// **Dart Result (from parse method):**
/// `int?` resolving to `0` or `null`
final class ZRevRankCommand(final String key, final String member)
    extends ValkeyCommand<int?>
    with KeyedCommand<int?> {
  @override
  List<String> get commandParts => ['ZREVRANK', key, member];

  @override
  int? parse(dynamic data) {
    if (data == null || data is int) return data as int?;
    throw ValkeyException(
      'Invalid response for ZREVRANK: expected an integer or null, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<int?> applyPrefix(String prefix) {
    return ZRevRankCommand('$prefix$key', member);
  }
}
