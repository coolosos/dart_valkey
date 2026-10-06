import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'ZREVRANGEBYSCORE key max min [WITHSCORES] [LIMIT offset count]' command.
/// Returns all the elements in the sorted set at key with a score between max and min (inclusive), with scores ordered from high to low.
///
/// **Redis Command:**
/// ```text
/// ZREVRANGEBYSCORE myzset +inf -inf WITHSCORES LIMIT 0 1
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// *2
/// $7
/// member2
/// $7
/// member1
/// ```
///
/// **Dart Result (from parse method):**
/// `List<String>` or `List<Map<String, String>>` (if WITHSCORES is true)
final class ZRevRangeByScoreCommand(
  final String key,
  final String max,
  final String min, {
  final bool withScores = false,
  final int? limitOffset,
  final int? limitCount,
}) extends ValkeyCommand<dynamic> with KeyedCommand<dynamic> {
  @override
  List<String> get commandParts {
    final parts = ['ZREVRANGEBYSCORE', key, max, min];
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
      'Invalid response for ZREVRANGEBYSCORE: expected a list, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<dynamic> applyPrefix(String prefix) {
    return ZRevRangeByScoreCommand(
      '$prefix$key',
      max,
      min,
      withScores: withScores,
      limitOffset: limitOffset,
      limitCount: limitCount,
    );
  }
}
