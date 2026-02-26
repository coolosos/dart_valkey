import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/hash/hset_command.dart';
import 'package:test/test.dart';

void main() {
  group('HSetCommand', () {
    test('should build the correct command', () {
      final command = HSetCommand('mykey', {'field1': 'value1', 'field2': 123});
      // Order of map entries is not guaranteed, so check parts individually
      expect(command.commandParts[0], 'HSET');
      expect(command.commandParts[1], 'mykey');
      expect(command.commandParts.sublist(2),
          containsAllInOrder(['field1', 'value1']));
      expect(command.commandParts.sublist(2),
          containsAllInOrder(['field2', '123']));
      expect(command.commandParts.length, 6);
    });

    test('should parse int response correctly', () {
      final command = HSetCommand('mykey', {'field1': 'value1'});
      expect(command.parse(1), 1);
    });

    test('should throw an exception for invalid response', () {
      final command = HSetCommand('mykey', {'field1': 'value1'});
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = HSetCommand('mykey', {'field1': 'value1'});
      final prefixedCommand = command.applyPrefix('myprefix:');
      // Order of map entries is not guaranteed, so check parts individually
      expect(prefixedCommand.commandParts[0], 'HSET');
      expect(prefixedCommand.commandParts[1], 'myprefix:mykey');
      expect(prefixedCommand.commandParts.sublist(2),
          containsAllInOrder(['field1', 'value1']));
      expect(prefixedCommand.commandParts.length, 4);
    });
  });
}
