import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/zset/zrevrange_command.dart';
import 'package:test/test.dart';

void main() {
  group('ZRevRangeCommand', () {
    test('should build the correct command for basic ZREVRANGE', () {
      final command = ZRevRangeCommand('myzset', '0', '-1');
      expect(command.commandParts, ['ZREVRANGE', 'myzset', '0', '-1']);
    });

    test('should build the correct command with BYLEX', () {
      final command = ZRevRangeCommand('myzset', '[z', '[a', byLex: true);
      expect(
          command.commandParts, ['ZREVRANGE', 'myzset', '[z', '[a', 'BYLEX']);
    });

    test('should build the correct command with BYSCORE', () {
      final command = ZRevRangeCommand('myzset', '(5', '(1', byScore: true);
      expect(
          command.commandParts, ['ZREVRANGE', 'myzset', '(5', '(1', 'BYSCORE']);
    });

    test('should build the correct command with LIMIT', () {
      final command =
          ZRevRangeCommand('myzset', '0', '-1', limitOffset: 0, limitCount: 1);
      expect(command.commandParts,
          ['ZREVRANGE', 'myzset', '0', '-1', 'LIMIT', '0', '1']);
    });

    test('should build the correct command with WITHSCORES', () {
      final command = ZRevRangeCommand('myzset', '0', '-1', withScores: true);
      expect(command.commandParts,
          ['ZREVRANGE', 'myzset', '0', '-1', 'WITHSCORES']);
    });

    test('should parse list of strings correctly (without scores)', () {
      final command = ZRevRangeCommand('myzset', '0', '-1');
      expect(command.parse(['member2', 'member1']), ['member2', 'member1']);
    });

    test('should parse list of maps correctly (with scores)', () {
      final command = ZRevRangeCommand('myzset', '0', '-1', withScores: true);
      expect(command.parse(['member2', '2.0', 'member1', '1.0']), [
        {'member': 'member2', 'score': '2.0'},
        {'member': 'member1', 'score': '1.0'},
      ]);
    });

    test('should throw an exception for invalid response', () {
      final command = ZRevRangeCommand('myzset', '0', '-1');
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = ZRevRangeCommand('myzset', '0', '-1');
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(prefixedCommand.commandParts,
          ['ZREVRANGE', 'myprefix:myzset', '0', '-1']);
    });
  });
}
