import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'ZREVRANGEBYSCORE key max min [LIMIT offset count] WITHSCORES' command.
/// Returns all the elements in the sorted set at key with a score between max and min (inclusive), with scores ordered from high to low, with their scores.
///
/// **Redis Command:**
/// ```text
/// ZREVRANGEBYSCORE myzset +inf -inf LIMIT 0 1 WITHSCORES
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// *4
/// $7
/// member2
/// $3
/// 2.0
/// $7
/// member1
/// $3
/// 1.0
/// ```
///
/// **Dart Result (from parse method):**
/// `List<Map<String, String>>` resolving to `[{'member': 'member2', 'score': '2.0'}, {'member': 'member1', 'score': '1.0'}]`
final class ZRevRangeByScoreWithScoresCommand(
  final String key,
  final String max,
  final String min, {
  final int? limitOffset,
  final int? limitCount,
}) extends ValkeyCommand<List<Map<String, String>>>
    with KeyedCommand<List<Map<String, String>>> {
  @override
  List<String> get commandParts {
    final parts = ['ZREVRANGEBYSCORE', key, max, min];
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
      'Invalid response for ZREVRANGEBYSCORE WITHSCORES: expected a list, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<List<Map<String, String>>> applyPrefix(String prefix) {
    return ZRevRangeByScoreWithScoresCommand(
      '$prefix$key',
      max,
      min,
      limitOffset: limitOffset,
      limitCount: limitCount,
    );
  }
}
