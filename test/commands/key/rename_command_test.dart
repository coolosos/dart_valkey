import 'package:dart_valkey/src/commands/key/rename_command.dart';
import 'package:test/test.dart';

void main() {
  group('RenameCommand', () {
    test('should build the correct command', () {
      final command = RenameCommand('oldkey', 'newkey');
      expect(command.commandParts, ['RENAME', 'oldkey', 'newkey']);
    });

    test('should parse OK response correctly', () {
      final command = RenameCommand('oldkey', 'newkey');
      expect(command.parse('OK'), isTrue);
    });

    test('should parse non-OK response correctly', () {
      final command = RenameCommand('oldkey', 'newkey');
      expect(command.parse('ERROR'), isFalse);
    });

    test('should apply prefix to keys', () {
      final command = RenameCommand('oldkey', 'newkey');
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(prefixedCommand.commandParts,
          ['RENAME', 'myprefix:oldkey', 'myprefix:newkey']);
    });
  });
}
