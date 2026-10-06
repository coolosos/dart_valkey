import '../../codec/valkey_exception.dart';
import '../command.dart';
import 'zrange_command.dart';

/// Represents the 'ZRANGE key start stop WITHSCORES' command.
/// Returns the specified range of elements in the sorted set stored at key, with their scores.
///
/// **Redis Command:**
/// ```text
/// ZRANGE myzset 0 -1 WITHSCORES
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
final class ZRangeWithScoresCommand(
  final String key,
  final int start,
  final int stop,
) extends ValkeyCommand<List<Map<String, String>>>
    with KeyedCommand<List<Map<String, String>>> {
  @override
  List<String> get commandParts => ZRangeCommand(
    key,
    start.toString(),
    stop.toString(),
    withScores: true,
  ).commandParts;

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
      'Invalid response for ZRANGE WITHSCORES: expected a list, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<List<Map<String, String>>> applyPrefix(String prefix) {
    return ZRangeWithScoresCommand('$prefix$key', start, stop);
  }
}
