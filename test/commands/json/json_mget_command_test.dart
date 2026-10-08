import 'package:dart_valkey/src/commands/json/json_mget_command.dart';
import 'package:test/test.dart';

void main() {
  group('JsonMGetCommand', () {
    test('should build the correct command with default path', () {
      final command = JsonMGetCommand(const ['doc:1', 'doc:2']);
      expect(command.commandParts, ['JSON.MGET', 'doc:1', 'doc:2', r'$']);
    });

    test('should build the correct command with custom path', () {
      final command = JsonMGetCommand(const [
        'doc:1',
        'doc:2',
      ], path: r'$.name');
      expect(command.commandParts, ['JSON.MGET', 'doc:1', 'doc:2', r'$.name']);
    });

    test('should parse list response correctly', () {
      final command = JsonMGetCommand(const ['doc:1', 'doc:2']);
      expect(command.parse(['{"name":"Alice"}', null, '{"name":"Bob"}']), [
        '{"name":"Alice"}',
        null,
        '{"name":"Bob"}',
      ]);
      expect(command.parse(null), isEmpty);
    });

    test('should apply prefix to all keys', () {
      final command = JsonMGetCommand(const [
        'doc:1',
        'doc:2',
      ], path: r'$.name');
      final prefixed = command.applyPrefix('prefix:');
      expect(prefixed.commandParts, [
        'JSON.MGET',
        'prefix:doc:1',
        'prefix:doc:2',
        r'$.name',
      ]);
    });
  });
}
