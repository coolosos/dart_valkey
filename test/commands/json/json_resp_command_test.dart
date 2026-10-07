import 'package:dart_valkey/src/commands/json/json_resp_command.dart';
import 'package:test/test.dart';

void main() {
  group('JsonRespCommand', () {
    test('should build the correct command with default path', () {
      final command = JsonRespCommand('doc:1');
      expect(command.commandParts, ['JSON.RESP', 'doc:1', r'$']);
    });

    test('should build the correct command with custom path', () {
      final command = JsonRespCommand('doc:1', path: r'$.user');
      expect(command.commandParts, ['JSON.RESP', 'doc:1', r'$.user']);
    });

    test('should return raw data unchanged from parse', () {
      final command = JsonRespCommand('doc:1');
      final data = ['{', 'name', 'Alice', '}'];
      expect(command.parse(data), equals(data));
      expect(command.parse(null), isNull);
    });

    test('should apply prefix to key', () {
      final command = JsonRespCommand('doc:1', path: r'$.user');
      final prefixed = command.applyPrefix('prefix:');
      expect(prefixed.commandParts, ['JSON.RESP', 'prefix:doc:1', r'$.user']);
    });
  });
}
