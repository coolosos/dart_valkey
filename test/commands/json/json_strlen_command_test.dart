import 'package:dart_valkey/src/commands/json/json_strlen_command.dart';
import 'package:test/test.dart';

void main() {
  group('JsonStrLenCommand', () {
    test('should build the correct command with default path', () {
      final command = JsonStrLenCommand('doc:1');
      expect(command.commandParts, ['JSON.STRLEN', 'doc:1', r'$']);
    });

    test('should build the correct command with custom path', () {
      final command = JsonStrLenCommand('doc:1', path: r'$.greeting');
      expect(command.commandParts, ['JSON.STRLEN', 'doc:1', r'$.greeting']);
    });

    test('should parse list response correctly', () {
      final command = JsonStrLenCommand('doc:1');
      expect(command.parse([5, null, '10']), [5, null, 10]);
    });

    test('should parse single int response correctly', () {
      final command = JsonStrLenCommand('doc:1');
      expect(command.parse(5), [5]);
      expect(command.parse('5'), [5]);
      expect(command.parse('invalid'), isEmpty);
      expect(command.parse(null), isEmpty);
    });

    test('should apply prefix to key', () {
      final command = JsonStrLenCommand('doc:1', path: r'$.greeting');
      final prefixed = command.applyPrefix('prefix:');
      expect(prefixed.commandParts, [
        'JSON.STRLEN',
        'prefix:doc:1',
        r'$.greeting',
      ]);
    });
  });
}
