import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/hash/hdel_command.dart';
import 'package:test/test.dart';

void main() {
  group('HDelCommand', () {
    test('should build the correct command', () {
      final command = HDelCommand('mykey', ['field1', 'field2']);
      expect(command.commandParts, ['HDEL', 'mykey', 'field1', 'field2']);
    });

    test('should parse int response correctly', () {
      final command = HDelCommand('mykey', ['field1']);
      expect(command.parse(1), 1);
    });

    test('should throw an exception for invalid response', () {
      final command = HDelCommand('mykey', ['field1']);
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = HDelCommand('mykey', ['field1']);
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(
        prefixedCommand.commandParts,
        ['HDEL', 'myprefix:mykey', 'field1'],
      );
    });
  });
}
