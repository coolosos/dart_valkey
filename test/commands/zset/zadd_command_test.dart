import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/zset/zadd_command.dart';
import 'package:test/test.dart';

void main() {
  group('ZAddCommand', () {
    test('should build the correct command for basic ZADD', () {
      final command = ZAddCommand('myzset', {'member1': 1.0, 'member2': 2.0});
      expect(
        command.commandParts,
        ['ZADD', 'myzset', '1.0', 'member1', '2.0', 'member2'],
      );
    });

    test('should build the correct command with NX flag', () {
      final command =
          ZAddCommand('myzset', {'member1': 1.0}, onlyIfNotExists: true);
      expect(command.commandParts, ['ZADD', 'myzset', 'NX', '1.0', 'member1']);
    });

    test('should build the correct command with XX flag', () {
      final command =
          ZAddCommand('myzset', {'member1': 1.0}, onlyIfAlreadyExists: true);
      expect(command.commandParts, ['ZADD', 'myzset', 'XX', '1.0', 'member1']);
    });

    test('should build the correct command with CH flag', () {
      final command = ZAddCommand('myzset', {'member1': 1.0}, changed: true);
      expect(command.commandParts, ['ZADD', 'myzset', 'CH', '1.0', 'member1']);
    });

    test('should build the correct command with INCR flag', () {
      final command = ZAddCommand('myzset', {'member1': 1.0}, incr: true);
      expect(
        command.commandParts,
        ['ZADD', 'myzset', 'INCR', '1.0', 'member1'],
      );
    });

    test('should parse int response correctly (without INCR)', () {
      final command = ZAddCommand('myzset', {'member1': 1.0});
      expect(command.parse(2), 2);
    });

    test('should parse double response correctly (with INCR)', () {
      final command = ZAddCommand('myzset', {'member1': 1.0}, incr: true);
      expect(command.parse('1.5'), 1.5);
    });

    test('should throw an exception for invalid int response', () {
      final command = ZAddCommand('myzset', {'member1': 1.0});
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should throw an exception for invalid double response (with INCR)',
        () {
      final command = ZAddCommand('myzset', {'member1': 1.0}, incr: true);
      expect(() => command.parse(123), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = ZAddCommand('myzset', {'member1': 1.0});
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(
        prefixedCommand.commandParts,
        ['ZADD', 'myprefix:myzset', '1.0', 'member1'],
      );
    });
  });
}
