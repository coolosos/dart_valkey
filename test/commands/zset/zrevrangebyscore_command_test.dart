import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/zset/zrevrangebyscore_command.dart';
import 'package:test/test.dart';

void main() {
  group('ZRevRangeByScoreCommand', () {
    test('should build the correct command for basic ZREVRANGEBYSCORE', () {
      final command = ZRevRangeByScoreCommand('myzset', '+inf', '-inf');
      expect(
        command.commandParts,
        ['ZREVRANGEBYSCORE', 'myzset', '+inf', '-inf'],
      );
    });

    test('should build the correct command with WITHSCORES', () {
      final command =
          ZRevRangeByScoreCommand('myzset', '+inf', '-inf', withScores: true);
      expect(
        command.commandParts,
        ['ZREVRANGEBYSCORE', 'myzset', '+inf', '-inf', 'WITHSCORES'],
      );
    });

    test('should build the correct command with LIMIT', () {
      final command = ZRevRangeByScoreCommand(
        'myzset',
        '+inf',
        '-inf',
        limitOffset: 0,
        limitCount: 1,
      );
      expect(
        command.commandParts,
        ['ZREVRANGEBYSCORE', 'myzset', '+inf', '-inf', 'LIMIT', '0', '1'],
      );
    });

    test('should parse list of strings correctly (without scores)', () {
      final command = ZRevRangeByScoreCommand('myzset', '+inf', '-inf');
      expect(command.parse(['member2', 'member1']), ['member2', 'member1']);
    });

    test('should parse list of maps correctly (with scores)', () {
      final command =
          ZRevRangeByScoreCommand('myzset', '+inf', '-inf', withScores: true);
      expect(command.parse(['member2', '2.0', 'member1', '1.0']), [
        {'member': 'member2', 'score': '2.0'},
        {'member': 'member1', 'score': '1.0'},
      ]);
    });

    test('should throw an exception for invalid response', () {
      final command = ZRevRangeByScoreCommand('myzset', '+inf', '-inf');
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = ZRevRangeByScoreCommand('myzset', '+inf', '-inf');
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(
        prefixedCommand.commandParts,
        ['ZREVRANGEBYSCORE', 'myprefix:myzset', '+inf', '-inf'],
      );
    });
  });
}
