import 'package:dart_valkey/src/commands/json/json_arrpop_command.dart';
import 'package:test/test.dart';

void main() {
  group('JsonArrPopCommand', () {
    test('should build the correct command with default path and no index', () {
      final command = JsonArrPopCommand('doc:1');
      expect(command.commandParts, ['JSON.ARRPOP', 'doc:1', r'$']);
    });

    test('should build the correct command with custom path and index', () {
      final command = JsonArrPopCommand('doc:1', path: r'$.items', index: 0);
      expect(command.commandParts, ['JSON.ARRPOP', 'doc:1', r'$.items', '0']);
    });

    test('should parse list response correctly', () {
      final command = JsonArrPopCommand('doc:1');
      expect(command.parse(['"popped"', null]), ['"popped"', null]);
    });

    test('should parse single string response correctly', () {
      final command = JsonArrPopCommand('doc:1');
      expect(command.parse('"popped"'), ['"popped"']);
      expect(command.parse(null), isEmpty);
    });

    test('should apply prefix to key', () {
      final command = JsonArrPopCommand('doc:1', path: r'$.items', index: 1);
      final prefixed = command.applyPrefix('prefix:');
      expect(prefixed.commandParts, [
        'JSON.ARRPOP',
        'prefix:doc:1',
        r'$.items',
        '1',
      ]);
    });
  });
}
