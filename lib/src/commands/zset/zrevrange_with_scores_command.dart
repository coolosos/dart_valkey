import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'ZREVRANGE key start stop [BYLEX|BYSCORE] [LIMIT offset count] WITHSCORES' command.
/// Returns the specified range of elements in the sorted set stored at key, with scores ordered from high to low, with their scores.
///
/// **Redis Command:**
/// ```text
/// ZREVRANGE myzset 0 -1 WITHSCORES
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
final class ZRevRangeWithScoresCommand(
  final String key,
  final String start,
  final String stop, {
  final bool byLex = false,
  final bool byScore = false,
  final int? limitOffset,
  final int? limitCount,
}) extends ValkeyCommand<List<Map<String, String>>>
    with KeyedCommand<List<Map<String, String>>> {
  @override
  List<String> get commandParts {
    final parts = ['ZREVRANGE', key, start, stop];
    if (byLex) {
      parts.add('BYLEX');
    } else if (byScore) {
      parts.add('BYSCORE');
    }
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
      'Invalid response for ZREVRANGE WITHSCORES: expected a list, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<List<Map<String, String>>> applyPrefix(String prefix) {
    return ZRevRangeWithScoresCommand(
      '$prefix$key',
      start,
      stop,
      byLex: byLex,
      byScore: byScore,
      limitOffset: limitOffset,
      limitCount: limitCount,
    );
  }
}
