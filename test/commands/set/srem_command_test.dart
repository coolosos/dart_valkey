import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/set/srem_command.dart';
import 'package:test/test.dart';

void main() {
  group('SRemCommand', () {
    test('should build the correct command', () {
      final command = SRemCommand('myset', ['member1', 'member2']);
      expect(command.commandParts, ['SREM', 'myset', 'member1', 'member2']);
    });

    test('should parse int response correctly', () {
      final command = SRemCommand('myset', ['member1']);
      expect(command.parse(1), 1);
    });

    test('should throw an exception for invalid response', () {
      final command = SRemCommand('myset', ['member1']);
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = SRemCommand('myset', ['member1']);
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(
          prefixedCommand.commandParts, ['SREM', 'myprefix:myset', 'member1']);
    });
  });
}
