import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/set/sadd_command.dart';
import 'package:test/test.dart';

void main() {
  group('SAddCommand', () {
    test('should build the correct command', () {
      final command = SAddCommand('myset', ['member1', 'member2']);
      expect(command.commandParts, ['SADD', 'myset', 'member1', 'member2']);
    });

    test('should parse int response correctly', () {
      final command = SAddCommand('myset', ['member1']);
      expect(command.parse(2), 2);
    });

    test('should throw an exception for invalid response', () {
      final command = SAddCommand('myset', ['member1']);
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = SAddCommand('myset', ['member1']);
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(
        prefixedCommand.commandParts,
        ['SADD', 'myprefix:myset', 'member1'],
      );
    });
  });
}
