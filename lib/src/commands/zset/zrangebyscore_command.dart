import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'ZRANGEBYSCORE key min max [WITHSCORES] [LIMIT offset count]' command.
/// Returns all the elements in the sorted set at key with a score between min and max (inclusive).
///
/// **Redis Command:**
/// ```text
/// ZRANGEBYSCORE myzset -inf +inf WITHSCORES LIMIT 0 1
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// *2
/// $7
/// member1
/// $3
/// 1.0
/// ```
///
/// **Dart Result (from parse method):**
/// `List<String>` or `List<Map<String, String>>` (if WITHSCORES is true)
final class ZRangeByScoreCommand(
  final String key,
  final String min,
  final String max, {
  final bool withScores = false,
  final int? limitOffset,
  final int? limitCount,
}) extends ValkeyCommand<dynamic> with KeyedCommand<dynamic> {
  @override
  List<String> get commandParts {
    final parts = ['ZRANGEBYSCORE', key, min, max];
    if (withScores) {
      parts.add('WITHSCORES');
    }
    if (limitOffset != null && limitCount != null) {
      parts.addAll(['LIMIT', limitOffset!.toString(), limitCount!.toString()]);
    }
    return parts;
  }

  @override
  dynamic parse(dynamic data) {
    if (data is List) {
      if (withScores) {
        final result = <Map<String, String>>[];
        for (var i = 0; i < data.length; i += 2) {
          result.add({
            'member': data[i] as String,
            'score': data[i + 1] as String,
          });
        }
        return result;
      } else {
        return data.map((e) => e as String).toList();
      }
    }
    throw ValkeyException(
      'Invalid response for ZRANGEBYSCORE: expected a list, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<dynamic> applyPrefix(String prefix) {
    return ZRangeByScoreCommand(
      '$prefix$key',
      min,
      max,
      withScores: withScores,
      limitOffset: limitOffset,
      limitCount: limitCount,
    );
  }
}
