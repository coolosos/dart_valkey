import 'package:dart_valkey/src/commands/json/json_objkeys_command.dart';
import 'package:test/test.dart';

void main() {
  group('JsonObjKeysCommand', () {
    test('should build the correct command with default path', () {
      final command = JsonObjKeysCommand('doc:1');
      expect(command.commandParts, ['JSON.OBJKEYS', 'doc:1', r'$']);
    });

    test('should build the correct command with custom path', () {
      final command = JsonObjKeysCommand('doc:1', path: r'$.user');
      expect(command.commandParts, ['JSON.OBJKEYS', 'doc:1', r'$.user']);
    });

    test('should parse list response correctly', () {
      final command = JsonObjKeysCommand('doc:1');
      expect(
        command.parse([
          ['name', 'age'],
          null,
        ]),
        [
          ['name', 'age'],
          null,
        ],
      );
    });

    test('should parse legacy single array response correctly', () {
      final command = JsonObjKeysCommand('doc:1');
      expect(command.parse(['name', 'age']), [
        ['name', 'age'],
      ]);
    });

    test('should parse null response correctly', () {
      final command = JsonObjKeysCommand('doc:1');
      expect(command.parse(null), isEmpty);
    });

    test('should apply prefix to key', () {
      final command = JsonObjKeysCommand('doc:1', path: r'$.user');
      final prefixed = command.applyPrefix('prefix:');
      expect(prefixed.commandParts, [
        'JSON.OBJKEYS',
        'prefix:doc:1',
        r'$.user',
      ]);
    });
  });
}
