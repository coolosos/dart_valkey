import 'package:dart_valkey/src/commands/json/json_type_command.dart';
import 'package:test/test.dart';

void main() {
  group('JsonTypeCommand', () {
    test('should build the correct command with default path', () {
      final command = JsonTypeCommand('doc:1');
      expect(command.commandParts, ['JSON.TYPE', 'doc:1', r'$']);
    });

    test('should build the correct command with custom path', () {
      final command = JsonTypeCommand('doc:1', path: r'$.name');
      expect(command.commandParts, ['JSON.TYPE', 'doc:1', r'$.name']);
    });

    test('should build the correct command with null path', () {
      final command = JsonTypeCommand('doc:1', path: null);
      expect(command.commandParts, ['JSON.TYPE', 'doc:1']);
    });

    test('should parse list response correctly', () {
      final command = JsonTypeCommand('doc:1');
      expect(command.parse(['object', 'string', null]), [
        'object',
        'string',
        null,
      ]);
    });

    test('should parse single string response correctly', () {
      final command = JsonTypeCommand('doc:1');
      expect(command.parse('object'), ['object']);
    });

    test('should parse null response correctly', () {
      final command = JsonTypeCommand('doc:1');
      expect(command.parse(null), isEmpty);
    });

    test('should apply prefix to key', () {
      final command = JsonTypeCommand('doc:1', path: r'$.name');
      final prefixed = command.applyPrefix('prefix:');
      expect(prefixed.commandParts, ['JSON.TYPE', 'prefix:doc:1', r'$.name']);
    });
  });
}
