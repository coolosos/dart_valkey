import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/hash/hkeys_command.dart';
import 'package:test/test.dart';

void main() {
  group('HKeysCommand', () {
    test('should build the correct command', () {
      final command = HKeysCommand('mykey');
      expect(command.commandParts, ['HKEYS', 'mykey']);
    });

    test('should parse list of strings correctly', () {
      final command = HKeysCommand('mykey');
      expect(command.parse(['name', 'age']), ['name', 'age']);
    });

    test('should parse empty list correctly', () {
      final command = HKeysCommand('mykey');
      expect(command.parse(<dynamic>[]), <String>[]);
    });

    test('should throw an exception for invalid response', () {
      final command = HKeysCommand('mykey');
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = HKeysCommand('mykey');
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(prefixedCommand.commandParts, ['HKEYS', 'myprefix:mykey']);
    });
  });
}
