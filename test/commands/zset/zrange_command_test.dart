import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/zset/zrange_command.dart';
import 'package:test/test.dart';

void main() {
  group('ZRangeCommand', () {
    test('should build the correct command for basic ZRANGE', () {
      final command = ZRangeCommand('myzset', '0', '-1');
      expect(command.commandParts, ['ZRANGE', 'myzset', '0', '-1']);
    });

    test('should build the correct command with BYLEX', () {
      final command = ZRangeCommand('myzset', '[a', '[z', byLex: true);
      expect(command.commandParts, ['ZRANGE', 'myzset', '[a', '[z', 'BYLEX']);
    });

    test('should build the correct command with BYSCORE', () {
      final command = ZRangeCommand('myzset', '(1', '(5', byScore: true);
      expect(command.commandParts, ['ZRANGE', 'myzset', '(1', '(5', 'BYSCORE']);
    });

    test('should build the correct command with REV', () {
      final command = ZRangeCommand('myzset', '0', '-1', rev: true);
      expect(command.commandParts, ['ZRANGE', 'myzset', '0', '-1', 'REV']);
    });

    test('should build the correct command with LIMIT', () {
      final command =
          ZRangeCommand('myzset', '0', '-1', limitOffset: 0, limitCount: 1);
      expect(command.commandParts,
          ['ZRANGE', 'myzset', '0', '-1', 'LIMIT', '0', '1']);
    });

    test('should build the correct command with WITHSCORES', () {
      final command = ZRangeCommand('myzset', '0', '-1', withScores: true);
      expect(
          command.commandParts, ['ZRANGE', 'myzset', '0', '-1', 'WITHSCORES']);
    });

    test('should parse list of strings correctly (without scores)', () {
      final command = ZRangeCommand('myzset', '0', '-1');
      expect(command.parse(['member1', 'member2']), ['member1', 'member2']);
    });

    test('should parse list of maps correctly (with scores)', () {
      final command = ZRangeCommand('myzset', '0', '-1', withScores: true);
      expect(command.parse(['member1', '1.0', 'member2', '2.0']), [
        {'member': 'member1', 'score': '1.0'},
        {'member': 'member2', 'score': '2.0'},
      ]);
    });

    test('should throw an exception for invalid response', () {
      final command = ZRangeCommand('myzset', '0', '-1');
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = ZRangeCommand('myzset', '0', '-1');
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(prefixedCommand.commandParts,
          ['ZRANGE', 'myprefix:myzset', '0', '-1']);
    });
  });
}
