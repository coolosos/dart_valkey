import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/key/exists_command.dart';
import 'package:test/test.dart';

void main() {
  group('ExistsCommand', () {
    test('should build the correct command', () {
      final command = ExistsCommand(['key1', 'key2']);
      expect(command.commandParts, ['EXISTS', 'key1', 'key2']);
    });

    test('should parse int response correctly', () {
      final command = ExistsCommand(['key1']);
      expect(command.parse(1), 1);
    });

    test('should throw an exception for invalid response', () {
      final command = ExistsCommand(['key1']);
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to keys', () {
      final command = ExistsCommand(['key1', 'key2']);
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(prefixedCommand.commandParts,
          ['EXISTS', 'myprefix:key1', 'myprefix:key2']);
    });
  });
}
