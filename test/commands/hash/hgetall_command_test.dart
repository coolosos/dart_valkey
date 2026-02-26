import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/hash/hgetall_command.dart';
import 'package:test/test.dart';

void main() {
  group('HGetAllCommand', () {
    test('should build the correct command', () {
      final command = HGetAllCommand('mykey');
      expect(command.commandParts, ['HGETALL', 'mykey']);
    });

    test('should parse list response correctly', () {
      final command = HGetAllCommand('mykey');
      expect(
        command.parse(['name', 'Alice', 'age', '30']),
        {'name': 'Alice', 'age': '30'},
      );
    });

    test('should parse empty list response correctly', () {
      final command = HGetAllCommand('mykey');
      expect(command.parse([]), {});
    });

    test('should throw an exception for invalid response', () {
      final command = HGetAllCommand('mykey');
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = HGetAllCommand('mykey');
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(prefixedCommand.commandParts, ['HGETALL', 'myprefix:mykey']);
    });
  });
}
