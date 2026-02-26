import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/list/rpush_command.dart';
import 'package:test/test.dart';

void main() {
  group('RPushCommand', () {
    test('should build the correct command', () {
      final command = RPushCommand('mylist', ['item1', 'item2']);
      expect(command.commandParts, ['RPUSH', 'mylist', 'item1', 'item2']);
    });

    test('should parse int response correctly', () {
      final command = RPushCommand('mylist', ['item1']);
      expect(command.parse(2), 2);
    });

    test('should throw an exception for invalid response', () {
      final command = RPushCommand('mylist', ['item1']);
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = RPushCommand('mylist', ['item1']);
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(
        prefixedCommand.commandParts,
        ['RPUSH', 'myprefix:mylist', 'item1'],
      );
    });
  });
}
