import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/set/sdiffstore_command.dart';
import 'package:test/test.dart';

void main() {
  group('SDiffStoreCommand', () {
    test('should build the correct command', () {
      final command = SDiffStoreCommand('newset', ['set1', 'set2']);
      expect(command.commandParts, ['SDIFFSTORE', 'newset', 'set1', 'set2']);
    });

    test('should parse int response correctly', () {
      final command = SDiffStoreCommand('newset', ['set1']);
      expect(command.parse(1), 1);
    });

    test('should throw an exception for invalid response', () {
      final command = SDiffStoreCommand('newset', ['set1']);
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to keys', () {
      final command = SDiffStoreCommand('newset', ['set1', 'set2']);
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(
        prefixedCommand.commandParts,
        ['SDIFFSTORE', 'myprefix:newset', 'myprefix:set1', 'myprefix:set2'],
      );
    });
  });
}
