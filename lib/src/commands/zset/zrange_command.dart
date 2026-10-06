import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the `ZRANGE key start stop [BYLEX|BYSCORE] [REV] [LIMIT offset count] [WITHSCORES]` command.
/// Returns the specified range of elements in the sorted set stored at key.
///
/// **Redis Command:**
/// ```text
/// ZRANGE myzset 0 -1
/// ZRANGE myzset (1 (5 BYSCORE
/// ZRANGE myzset [a [z BYLEX REV LIMIT 0 1 WITHSCORES
/// ```
///
/// **Dart Result (from parse method):**
/// `List<String>` or `List<Map<String, String>>` (if WITHSCORES is true)
final class ZRangeCommand(
  final String key,
  final String start,
  final String stop, {
  final bool byLex = false,
  final bool byScore = false,
  final bool rev = false,
  final int? limitOffset,
  final int? limitCount,
  final bool withScores = false,
}) extends ValkeyCommand<List<dynamic>> with KeyedCommand<List<dynamic>> {
  @override
  List<String> get commandParts {
    final parts = ['ZRANGE', key, start, stop];
    if (byLex) {
      parts.add('BYLEX');
    } else if (byScore) {
      parts.add('BYSCORE');
    }
    if (rev) {
      parts.add('REV');
    }
    if (limitOffset != null && limitCount != null) {
      parts.addAll(['LIMIT', limitOffset!.toString(), limitCount!.toString()]);
    }
    if (withScores) {
      parts.add('WITHSCORES');
    }
    return parts;
  }

  @override
  List<dynamic> parse(dynamic data) {
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
      'Invalid response for ZRANGE: expected a list, got ${data.runtimeType}',
    );
  }

  @override
  ZRangeCommand applyPrefix(String prefix) {
    return ZRangeCommand(
      '$prefix$key',
      start,
      stop,
      byLex: byLex,
      byScore: byScore,
      rev: rev,
      limitOffset: limitOffset,
      limitCount: limitCount,
      withScores: withScores,
    );
  }
}
