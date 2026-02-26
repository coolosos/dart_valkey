import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/zset/zrange_with_scores_command.dart';
import 'package:test/test.dart';

void main() {
  group('ZRangeWithScoresCommand', () {
    test('should build the correct command', () {
      final command = ZRangeWithScoresCommand('myzset', 0, -1);
      expect(
          command.commandParts, ['ZRANGE', 'myzset', '0', '-1', 'WITHSCORES']);
    });

    test('should parse list of maps correctly', () {
      final command = ZRangeWithScoresCommand('myzset', 0, -1);
      expect(command.parse(['member1', '1.0', 'member2', '2.0']), [
        {'member': 'member1', 'score': '1.0'},
        {'member': 'member2', 'score': '2.0'},
      ]);
    });

    test('should parse empty list correctly', () {
      final command = ZRangeWithScoresCommand('myzset', 0, -1);
      expect(command.parse([]), []);
    });

    test('should throw an exception for invalid response', () {
      final command = ZRangeWithScoresCommand('myzset', 0, -1);
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = ZRangeWithScoresCommand('myzset', 0, -1);
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(prefixedCommand.commandParts,
          ['ZRANGE', 'myprefix:myzset', '0', '-1', 'WITHSCORES']);
    });
  });
}
