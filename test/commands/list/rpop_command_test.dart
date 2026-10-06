import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/list/rpop_command.dart';
import 'package:test/test.dart';

void main() {
  group('RPopCommand', () {
    test('should build the correct command without count', () {
      final command = RPopCommand('mylist');
      expect(command.commandParts, ['RPOP', 'mylist']);
    });

    test('should build the correct command with count', () {
      final command = RPopCommand('mylist', 2);
      expect(command.commandParts, ['RPOP', 'mylist', '2']);
    });

    test('should parse string response correctly', () {
      final command = RPopCommand('mylist');
      expect(command.parse('item1'), ['item1']);
    });

    test('should parse null response correctly', () {
      final command = RPopCommand('mylist');
      expect(command.parse(null), <String>[]);
    });

    test('should parse list response correctly', () {
      final command = RPopCommand('mylist', 2);
      expect(command.parse(['item1', 'item2']), ['item1', 'item2']);
    });

    test('should throw an exception for invalid response', () {
      final command = RPopCommand('mylist');
      expect(() => command.parse(123), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = RPopCommand('mylist', 2);
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(prefixedCommand.commandParts, ['RPOP', 'myprefix:mylist', '2']);
    });
  });
}
