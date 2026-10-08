import 'package:dart_valkey/src/commands/json/json_toggle_command.dart';
import 'package:test/test.dart';

void main() {
  group('JsonToggleCommand', () {
    test('should build the correct command with default path', () {
      final command = JsonToggleCommand('doc:1');
      expect(command.commandParts, ['JSON.TOGGLE', 'doc:1', r'$']);
    });

    test('should build the correct command with custom path', () {
      final command = JsonToggleCommand('doc:1', path: r'$.active');
      expect(command.commandParts, ['JSON.TOGGLE', 'doc:1', r'$.active']);
    });

    test('should parse list of integers (1/0/null) correctly', () {
      final command = JsonToggleCommand('doc:1');
      expect(command.parse([1, 0, null]), [true, false, null]);
    });

    test('should parse list of booleans correctly', () {
      final command = JsonToggleCommand('doc:1');
      expect(command.parse([true, false]), [true, false]);
    });

    test('should parse single values correctly', () {
      final command = JsonToggleCommand('doc:1');
      expect(command.parse(1), [true]);
      expect(command.parse(0), [false]);
      expect(command.parse(null), isEmpty);
    });

    test('should apply prefix to key', () {
      final command = JsonToggleCommand('doc:1', path: r'$.active');
      final prefixed = command.applyPrefix('prefix:');
      expect(prefixed.commandParts, [
        'JSON.TOGGLE',
        'prefix:doc:1',
        r'$.active',
      ]);
    });
  });
}
