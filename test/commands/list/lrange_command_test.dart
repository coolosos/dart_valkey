import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/list/lrange_command.dart';
import 'package:test/test.dart';

void main() {
  group('LRangeCommand', () {
    test('should build the correct command', () {
      final command = LRangeCommand('mylist', 0, -1);
      expect(command.commandParts, ['LRANGE', 'mylist', '0', '-1']);
    });

    test('should parse list of strings correctly', () {
      final command = LRangeCommand('mylist', 0, -1);
      expect(command.parse(['item1', 'item2']), ['item1', 'item2']);
    });

    test('should parse empty list correctly', () {
      final command = LRangeCommand('mylist', 0, -1);
      expect(command.parse([]), []);
    });

    test('should throw an exception for invalid response', () {
      final command = LRangeCommand('mylist', 0, -1);
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = LRangeCommand('mylist', 0, -1);
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(
        prefixedCommand.commandParts,
        ['LRANGE', 'myprefix:mylist', '0', '-1'],
      );
    });
  });
}
