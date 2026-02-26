import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/list/lrem_command.dart';
import 'package:test/test.dart';

void main() {
  group('LRemCommand', () {
    test('should build the correct command', () {
      final command = LRemCommand('mylist', 1, 'item1');
      expect(command.commandParts, ['LREM', 'mylist', '1', 'item1']);
    });

    test('should parse int response correctly', () {
      final command = LRemCommand('mylist', 1, 'item1');
      expect(command.parse(1), 1);
    });

    test('should throw an exception for invalid response', () {
      final command = LRemCommand('mylist', 1, 'item1');
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = LRemCommand('mylist', 1, 'item1');
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(prefixedCommand.commandParts,
          ['LREM', 'myprefix:mylist', '1', 'item1']);
    });
  });
}
