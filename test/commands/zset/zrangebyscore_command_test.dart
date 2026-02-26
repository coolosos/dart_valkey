import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/zset/zrangebyscore_command.dart';
import 'package:test/test.dart';

void main() {
  group('ZRangeByScoreCommand', () {
    test('should build the correct command for basic ZRANGEBYSCORE', () {
      final command = ZRangeByScoreCommand('myzset', '-inf', '+inf');
      expect(command.commandParts, ['ZRANGEBYSCORE', 'myzset', '-inf', '+inf']);
    });

    test('should build the correct command with WITHSCORES', () {
      final command =
          ZRangeByScoreCommand('myzset', '-inf', '+inf', withScores: true);
      expect(
        command.commandParts,
        ['ZRANGEBYSCORE', 'myzset', '-inf', '+inf', 'WITHSCORES'],
      );
    });

    test('should build the correct command with LIMIT', () {
      final command = ZRangeByScoreCommand(
        'myzset',
        '-inf',
        '+inf',
        limitOffset: 0,
        limitCount: 1,
      );
      expect(
        command.commandParts,
        ['ZRANGEBYSCORE', 'myzset', '-inf', '+inf', 'LIMIT', '0', '1'],
      );
    });

    test('should parse list of strings correctly (without scores)', () {
      final command = ZRangeByScoreCommand('myzset', '-inf', '+inf');
      expect(command.parse(['member1', 'member2']), ['member1', 'member2']);
    });

    test('should parse list of maps correctly (with scores)', () {
      final command =
          ZRangeByScoreCommand('myzset', '-inf', '+inf', withScores: true);
      expect(command.parse(['member1', '1.0', 'member2', '2.0']), [
        {'member': 'member1', 'score': '1.0'},
        {'member': 'member2', 'score': '2.0'},
      ]);
    });

    test('should throw an exception for invalid response', () {
      final command = ZRangeByScoreCommand('myzset', '-inf', '+inf');
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = ZRangeByScoreCommand('myzset', '-inf', '+inf');
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(
        prefixedCommand.commandParts,
        ['ZRANGEBYSCORE', 'myprefix:myzset', '-inf', '+inf'],
      );
    });
  });
}
