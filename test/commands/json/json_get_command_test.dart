import 'package:dart_valkey/src/commands/json/json_get_command.dart';
import 'package:test/test.dart';

void main() {
  group('JsonGetCommand', () {
    test(
      'should build the correct command for basic JSON.GET without paths',
      () {
        final command = JsonGetCommand('doc:1');
        expect(command.commandParts, ['JSON.GET', 'doc:1']);
      },
    );

    test('should build the correct command with single path', () {
      final command = JsonGetCommand('doc:1', paths: const [r'$']);
      expect(command.commandParts, ['JSON.GET', 'doc:1', r'$']);
    });

    test('should build the correct command with multiple paths', () {
      final command = JsonGetCommand(
        'doc:1',
        paths: const [r'$.name', r'$.age'],
      );
      expect(command.commandParts, ['JSON.GET', 'doc:1', r'$.name', r'$.age']);
    });

    test('should build the correct command with formatting options', () {
      final command = JsonGetCommand(
        'doc:1',
        paths: const [r'$'],
        indent: '  ',
        newline: '\n',
        space: ' ',
      );
      expect(command.commandParts, [
        'JSON.GET',
        'doc:1',
        'INDENT',
        '  ',
        'NEWLINE',
        '\n',
        'SPACE',
        ' ',
        r'$',
      ]);
    });

    test('should parse string response correctly', () {
      final command = JsonGetCommand('doc:1');
      expect(command.parse('{"name":"Alice"}'), '{"name":"Alice"}');
      expect(command.parse(null), isNull);
    });

    test('should apply prefix to key', () {
      final command = JsonGetCommand(
        'doc:1',
        paths: const [r'$'],
        indent: '  ',
      );
      final prefixed = command.applyPrefix('prefix:');
      expect(prefixed.commandParts, [
        'JSON.GET',
        'prefix:doc:1',
        'INDENT',
        '  ',
        r'$',
      ]);
    });
  });
}
