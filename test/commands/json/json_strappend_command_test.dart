import 'package:dart_valkey/src/commands/json/json_strappend_command.dart';
import 'package:test/test.dart';

void main() {
  group('JsonStrAppendCommand', () {
    test('should build the correct command without path', () {
      final command = JsonStrAppendCommand('doc:1', '" world"');
      expect(command.commandParts, ['JSON.STRAPPEND', 'doc:1', '" world"']);
    });

    test('should build the correct command with path', () {
      final command = JsonStrAppendCommand(
        'doc:1',
        '" world"',
        path: r'$.greeting',
      );
      expect(command.commandParts, [
        'JSON.STRAPPEND',
        'doc:1',
        r'$.greeting',
        '" world"',
      ]);
    });

    test('should parse list response correctly', () {
      final command = JsonStrAppendCommand('doc:1', '" world"');
      expect(command.parse([12, null, '15']), [12, null, 15]);
    });

    test('should parse single int response correctly', () {
      final command = JsonStrAppendCommand('doc:1', '" world"');
      expect(command.parse(12), [12]);
      expect(command.parse('12'), [12]);
      expect(command.parse(null), isEmpty);
    });

    test('should apply prefix to key', () {
      final command = JsonStrAppendCommand(
        'doc:1',
        '" world"',
        path: r'$.greeting',
      );
      final prefixed = command.applyPrefix('prefix:');
      expect(prefixed.commandParts, [
        'JSON.STRAPPEND',
        'prefix:doc:1',
        r'$.greeting',
        '" world"',
      ]);
    });
  });
}
