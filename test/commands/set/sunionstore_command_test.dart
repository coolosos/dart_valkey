import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/set/sunionstore_command.dart';
import 'package:test/test.dart';

void main() {
  group('SUnionStoreCommand', () {
    test('should build the correct command', () {
      final command = SUnionStoreCommand('newset', ['set1', 'set2']);
      expect(command.commandParts, ['SUNIONSTORE', 'newset', 'set1', 'set2']);
    });

    test('should parse int response correctly', () {
      final command = SUnionStoreCommand('newset', ['set1']);
      expect(command.parse(3), 3);
    });

    test('should throw an exception for invalid response', () {
      final command = SUnionStoreCommand('newset', ['set1']);
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to keys', () {
      final command = SUnionStoreCommand('newset', ['set1', 'set2']);
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(
        prefixedCommand.commandParts,
        ['SUNIONSTORE', 'myprefix:newset', 'myprefix:set1', 'myprefix:set2'],
      );
    });
  });
}
