import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/zset/zrem_command.dart';
import 'package:test/test.dart';

void main() {
  group('ZRemCommand', () {
    test('should build the correct command', () {
      final command = ZRemCommand('myzset', ['member1', 'member2']);
      expect(command.commandParts, ['ZREM', 'myzset', 'member1', 'member2']);
    });

    test('should parse int response correctly', () {
      final command = ZRemCommand('myzset', ['member1']);
      expect(command.parse(1), 1);
    });

    test('should throw an exception for invalid response', () {
      final command = ZRemCommand('myzset', ['member1']);
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = ZRemCommand('myzset', ['member1']);
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(
          prefixedCommand.commandParts, ['ZREM', 'myprefix:myzset', 'member1']);
    });
  });
}
