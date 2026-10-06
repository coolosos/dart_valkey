import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'ZRANGEBYSCORE key min max [LIMIT offset count] WITHSCORES' command.
/// Returns all the elements in the sorted set at key with a score between min and max (inclusive), with their scores.
///
/// **Redis Command:**
/// ```text
/// ZRANGEBYSCORE myzset -inf +inf LIMIT 0 1 WITHSCORES
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// *4
/// $7
/// member1
/// $3
/// 1.0
/// $7
/// member2
/// $3
/// 2.0
/// ```
///
/// **Dart Result (from parse method):**
/// `List<Map<String, String>>` resolving to `[{'member': 'member1', 'score': '1.0'}, {'member': 'member2', 'score': '2.0'}]`
final class ZRangeByScoreWithScoresCommand(
  final String key,
  final String min,
  final String max, {
  final int? limitOffset,
  final int? limitCount,
}) extends ValkeyCommand<List<Map<String, String>>>
    with KeyedCommand<List<Map<String, String>>> {
  @override
  List<String> get commandParts {
    final parts = ['ZRANGEBYSCORE', key, min, max];
    if (limitOffset != null && limitCount != null) {
      parts.addAll(['LIMIT', limitOffset!.toString(), limitCount!.toString()]);
    }
    parts.add('WITHSCORES');
    return parts;
  }

  @override
  List<Map<String, String>> parse(dynamic data) {
    if (data is List) {
      final result = <Map<String, String>>[];
      for (var i = 0; i < data.length; i += 2) {
        result.add({
          'member': data[i] as String,
          'score': data[i + 1] as String,
        });
      }
      return result;
    }
    throw ValkeyException(
      'Invalid response for ZRANGEBYSCORE WITHSCORES: expected a list, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<List<Map<String, String>>> applyPrefix(String prefix) {
    return ZRangeByScoreWithScoresCommand(
      '$prefix$key',
      min,
      max,
      limitOffset: limitOffset,
      limitCount: limitCount,
    );
  }
}
