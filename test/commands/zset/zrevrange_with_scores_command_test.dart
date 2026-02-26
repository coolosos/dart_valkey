import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/zset/zrevrange_with_scores_command.dart';
import 'package:test/test.dart';

void main() {
  group('ZRevRangeWithScoresCommand', () {
    test('should build the correct command for basic ZREVRANGE WITHSCORES', () {
      final command = ZRevRangeWithScoresCommand('myzset', '0', '-1');
      expect(command.commandParts,
          ['ZREVRANGE', 'myzset', '0', '-1', 'WITHSCORES']);
    });

    test('should build the correct command with BYLEX', () {
      final command =
          ZRevRangeWithScoresCommand('myzset', '[z', '[a', byLex: true);
      expect(command.commandParts,
          ['ZREVRANGE', 'myzset', '[z', '[a', 'BYLEX', 'WITHSCORES']);
    });

    test('should build the correct command with BYSCORE', () {
      final command =
          ZRevRangeWithScoresCommand('myzset', '(5', '(1', byScore: true);
      expect(command.commandParts,
          ['ZREVRANGE', 'myzset', '(5', '(1', 'BYSCORE', 'WITHSCORES']);
    });

    test('should build the correct command with LIMIT', () {
      final command = ZRevRangeWithScoresCommand('myzset', '0', '-1',
          limitOffset: 0, limitCount: 1);
      expect(command.commandParts,
          ['ZREVRANGE', 'myzset', '0', '-1', 'LIMIT', '0', '1', 'WITHSCORES']);
    });

    test('should parse list of maps correctly', () {
      final command = ZRevRangeWithScoresCommand('myzset', '0', '-1');
      expect(command.parse(['member2', '2.0', 'member1', '1.0']), [
        {'member': 'member2', 'score': '2.0'},
        {'member': 'member1', 'score': '1.0'},
      ]);
    });

    test('should parse empty list correctly', () {
      final command = ZRevRangeWithScoresCommand('myzset', '0', '-1');
      expect(command.parse([]), []);
    });

    test('should throw an exception for invalid response', () {
      final command = ZRevRangeWithScoresCommand('myzset', '0', '-1');
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = ZRevRangeWithScoresCommand('myzset', '0', '-1');
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(prefixedCommand.commandParts,
          ['ZREVRANGE', 'myprefix:myzset', '0', '-1', 'WITHSCORES']);
    });
  });
}
