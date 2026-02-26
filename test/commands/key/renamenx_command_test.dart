import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/key/renamenx_command.dart';
import 'package:test/test.dart';

void main() {
  group('RenameNxCommand', () {
    test('should build the correct command', () {
      final command = RenameNxCommand('oldkey', 'newkey');
      expect(command.commandParts, ['RENAMENX', 'oldkey', 'newkey']);
    });

    test('should parse true response correctly', () {
      final command = RenameNxCommand('oldkey', 'newkey');
      expect(command.parse(1), isTrue);
    });

    test('should parse false response correctly', () {
      final command = RenameNxCommand('oldkey', 'newkey');
      expect(command.parse(0), isFalse);
    });

    test('should throw an exception for invalid response', () {
      final command = RenameNxCommand('oldkey', 'newkey');
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to keys', () {
      final command = RenameNxCommand('oldkey', 'newkey');
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(
        prefixedCommand.commandParts,
        ['RENAMENX', 'myprefix:oldkey', 'myprefix:newkey'],
      );
    });
  });
}
