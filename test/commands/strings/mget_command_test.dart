import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/strings/mget_command.dart';
import 'package:test/test.dart';

void main() {
  group('MGetCommand', () {
    test('should build the correct command', () {
      final command = MGetCommand(['key1', 'key2']);
      expect(command.commandParts, ['MGET', 'key1', 'key2']);
    });

    test('should parse list of strings and nulls correctly', () {
      final command = MGetCommand(['key1', 'key2']);
      expect(command.parse(['value1', null]), ['value1', null]);
    });

    test('should throw an exception for invalid response', () {
      final command = MGetCommand(['key1', 'key2']);
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to keys', () {
      final command = MGetCommand(['key1', 'key2']);
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(prefixedCommand.commandParts,
          ['MGET', 'myprefix:key1', 'myprefix:key2']);
    });
  });
}
