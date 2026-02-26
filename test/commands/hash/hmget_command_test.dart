import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/hash/hmget_command.dart';
import 'package:test/test.dart';

void main() {
  group('HMGetCommand', () {
    test('should build the correct command', () {
      final command = HMGetCommand('mykey', ['field1', 'field2']);
      expect(command.commandParts, ['HMGET', 'mykey', 'field1', 'field2']);
    });

    test('should parse list of strings and nulls correctly', () {
      final command = HMGetCommand('mykey', ['field1', 'field2']);
      expect(command.parse(['value1', null]), ['value1', null]);
    });

    test('should throw an exception for invalid response', () {
      final command = HMGetCommand('mykey', ['field1', 'field2']);
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = HMGetCommand('mykey', ['field1', 'field2']);
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(prefixedCommand.commandParts,
          ['HMGET', 'myprefix:mykey', 'field1', 'field2']);
    });
  });
}
