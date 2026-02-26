import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/strings/mset_command.dart';
import 'package:test/test.dart';

void main() {
  group('MSetCommand', () {
    test('should build the correct command', () {
      final command = MSetCommand({'key1': 'value1', 'key2': 'value2'});
      // Order of map entries is not guaranteed, so check parts individually
      expect(command.commandParts[0], 'MSET');
      expect(command.commandParts.sublist(1),
          containsAllInOrder(['key1', 'value1']));
      expect(command.commandParts.sublist(1),
          containsAllInOrder(['key2', 'value2']));
      expect(command.commandParts.length, 5);
    });

    test('should parse OK response correctly', () {
      final command = MSetCommand({'key1': 'value1'});
      expect(command.parse('OK'), 'OK');
    });

    test('should throw an exception for invalid response', () {
      final command = MSetCommand({'key1': 'value1'});
      expect(() => command.parse('ERROR'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to keys', () {
      final command = MSetCommand({'key1': 'value1', 'key2': 'value2'});
      final prefixedCommand = command.applyPrefix('myprefix:');
      // Order of map entries is not guaranteed, so check parts individually
      expect(prefixedCommand.commandParts[0], 'MSET');
      expect(prefixedCommand.commandParts.sublist(1),
          containsAllInOrder(['myprefix:key1', 'value1']));
      expect(prefixedCommand.commandParts.sublist(1),
          containsAllInOrder(['myprefix:key2', 'value2']));
      expect(prefixedCommand.commandParts.length, 5);
    });
  });
}
