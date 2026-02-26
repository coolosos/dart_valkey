import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/hash/hincrby_command.dart';
import 'package:test/test.dart';

void main() {
  group('HIncrByCommand', () {
    test('should build the correct command', () {
      final command = HIncrByCommand('mykey', 'myfield', 1);
      expect(command.commandParts, ['HINCRBY', 'mykey', 'myfield', '1']);
    });

    test('should parse int response correctly', () {
      final command = HIncrByCommand('mykey', 'myfield', 1);
      expect(command.parse(31), 31);
    });

    test('should throw an exception for invalid response', () {
      final command = HIncrByCommand('mykey', 'myfield', 1);
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = HIncrByCommand('mykey', 'myfield', 1);
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(
        prefixedCommand.commandParts,
        ['HINCRBY', 'myprefix:mykey', 'myfield', '1'],
      );
    });
  });
}
