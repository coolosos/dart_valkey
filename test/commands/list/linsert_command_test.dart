import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/list/linsert_command.dart';
import 'package:test/test.dart';

void main() {
  group('LInsertCommand', () {
    test('should build the correct command with BEFORE', () {
      final command =
          LInsertCommand('mylist', 'item2', 'newitem', before: true);
      expect(
        command.commandParts,
        ['LINSERT', 'mylist', 'BEFORE', 'item2', 'newitem'],
      );
    });

    test('should build the correct command with AFTER', () {
      final command =
          LInsertCommand('mylist', 'item2', 'newitem', before: false);
      expect(
        command.commandParts,
        ['LINSERT', 'mylist', 'AFTER', 'item2', 'newitem'],
      );
    });

    test('should parse int response correctly', () {
      final command =
          LInsertCommand('mylist', 'item2', 'newitem', before: true);
      expect(command.parse(3), 3);
    });

    test('should throw an exception for invalid response', () {
      final command =
          LInsertCommand('mylist', 'item2', 'newitem', before: true);
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command =
          LInsertCommand('mylist', 'item2', 'newitem', before: true);
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(
        prefixedCommand.commandParts,
        ['LINSERT', 'myprefix:mylist', 'BEFORE', 'item2', 'newitem'],
      );
    });
  });
}
