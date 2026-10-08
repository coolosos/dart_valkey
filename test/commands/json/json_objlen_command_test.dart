import 'package:dart_valkey/src/commands/json/json_objlen_command.dart';
import 'package:test/test.dart';

void main() {
  group('JsonObjLenCommand', () {
    test('should build the correct command with default path', () {
      final command = JsonObjLenCommand('doc:1');
      expect(command.commandParts, ['JSON.OBJLEN', 'doc:1', r'$']);
    });

    test('should build the correct command with custom path', () {
      final command = JsonObjLenCommand('doc:1', path: r'$.user');
      expect(command.commandParts, ['JSON.OBJLEN', 'doc:1', r'$.user']);
    });

    test('should parse list response correctly', () {
      final command = JsonObjLenCommand('doc:1');
      expect(command.parse([2, null, '3']), [2, null, 3]);
    });

    test('should parse single int response correctly', () {
      final command = JsonObjLenCommand('doc:1');
      expect(command.parse(2), [2]);
      expect(command.parse('2'), [2]);
      expect(command.parse('invalid'), isEmpty);
      expect(command.parse(null), isEmpty);
    });

    test('should apply prefix to key', () {
      final command = JsonObjLenCommand('doc:1', path: r'$.user');
      final prefixed = command.applyPrefix('prefix:');
      expect(prefixed.commandParts, ['JSON.OBJLEN', 'prefix:doc:1', r'$.user']);
    });
  });
}
