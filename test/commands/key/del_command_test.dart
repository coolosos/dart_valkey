import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/key/del_command.dart';
import 'package:test/test.dart';

void main() {
  group('DelCommand', () {
    test('should build the correct command', () {
      final command = DelCommand(['key1', 'key2']);
      expect(command.commandParts, ['DEL', 'key1', 'key2']);
    });

    test('should parse int response correctly', () {
      final command = DelCommand(['key1']);
      expect(command.parse(2), 2);
    });

    test('should throw an exception for invalid response', () {
      final command = DelCommand(['key1']);
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to keys', () {
      final command = DelCommand(['key1', 'key2']);
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(
        prefixedCommand.commandParts,
        ['DEL', 'myprefix:key1', 'myprefix:key2'],
      );
    });
  });
}
