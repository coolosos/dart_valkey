import 'package:dart_valkey/src/commands/json/json_del_command.dart';
import 'package:test/test.dart';

void main() {
  group('JsonDelCommand', () {
    test('should build the correct command without path', () {
      final command = JsonDelCommand('doc:1');
      expect(command.commandParts, ['JSON.DEL', 'doc:1']);
    });

    test('should build the correct command with path', () {
      final command = JsonDelCommand('doc:1', path: r'$.name');
      expect(command.commandParts, ['JSON.DEL', 'doc:1', r'$.name']);
    });

    test('should parse int response correctly', () {
      final command = JsonDelCommand('doc:1');
      expect(command.parse(1), 1);
      expect(command.parse(0), 0);
      expect(command.parse('2'), 2);
      expect(command.parse(null), 0);
    });

    test('should apply prefix to key', () {
      final command = JsonDelCommand('doc:1', path: r'$.name');
      final prefixed = command.applyPrefix('prefix:');
      expect(prefixed.commandParts, ['JSON.DEL', 'prefix:doc:1', r'$.name']);
    });
  });
}
