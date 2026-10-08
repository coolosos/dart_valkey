import 'package:dart_valkey/src/commands/json/json_clear_command.dart';
import 'package:test/test.dart';

void main() {
  group('JsonClearCommand', () {
    test('should build the correct command with default path', () {
      final command = JsonClearCommand('doc:1');
      expect(command.commandParts, ['JSON.CLEAR', 'doc:1', r'$']);
    });

    test('should build the correct command with custom path', () {
      final command = JsonClearCommand('doc:1', path: r'$.items');
      expect(command.commandParts, ['JSON.CLEAR', 'doc:1', r'$.items']);
    });

    test('should parse int response correctly', () {
      final command = JsonClearCommand('doc:1');
      expect(command.parse(1), 1);
      expect(command.parse('2'), 2);
      expect(command.parse(null), 0);
    });

    test('should apply prefix to key', () {
      final command = JsonClearCommand('doc:1', path: r'$.items');
      final prefixed = command.applyPrefix('prefix:');
      expect(prefixed.commandParts, ['JSON.CLEAR', 'prefix:doc:1', r'$.items']);
    });
  });
}
