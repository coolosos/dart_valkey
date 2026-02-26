import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/zset/zrangebyscore_with_scores_command.dart';
import 'package:test/test.dart';

void main() {
  group('ZRangeByScoreWithScoresCommand', () {
    test('should build the correct command for basic ZRANGEBYSCORE WITHSCORES',
        () {
      final command = ZRangeByScoreWithScoresCommand('myzset', '-inf', '+inf');
      expect(
        command.commandParts,
        ['ZRANGEBYSCORE', 'myzset', '-inf', '+inf', 'WITHSCORES'],
      );
    });

    test('should build the correct command with LIMIT', () {
      final command = ZRangeByScoreWithScoresCommand(
        'myzset',
        '-inf',
        '+inf',
        limitOffset: 0,
        limitCount: 1,
      );
      expect(command.commandParts, [
        'ZRANGEBYSCORE',
        'myzset',
        '-inf',
        '+inf',
        'LIMIT',
        '0',
        '1',
        'WITHSCORES',
      ]);
    });

    test('should parse list of maps correctly', () {
      final command = ZRangeByScoreWithScoresCommand('myzset', '-inf', '+inf');
      expect(command.parse(['member1', '1.0', 'member2', '2.0']), [
        {'member': 'member1', 'score': '1.0'},
        {'member': 'member2', 'score': '2.0'},
      ]);
    });

    test('should parse empty list correctly', () {
      final command = ZRangeByScoreWithScoresCommand('myzset', '-inf', '+inf');
      expect(command.parse([]), []);
    });

    test('should throw an exception for invalid response', () {
      final command = ZRangeByScoreWithScoresCommand('myzset', '-inf', '+inf');
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = ZRangeByScoreWithScoresCommand('myzset', '-inf', '+inf');
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(
        prefixedCommand.commandParts,
        ['ZRANGEBYSCORE', 'myprefix:myzset', '-inf', '+inf', 'WITHSCORES'],
      );
    });
  });
}
