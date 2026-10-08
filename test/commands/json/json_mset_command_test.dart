import 'package:dart_valkey/src/commands/json/json_mset_command.dart';
import 'package:test/test.dart';

void main() {
  group('JsonMSetCommand', () {
    test('should build the correct commandParts for multiple entries', () {
      final command = JsonMSetCommand(const [
        JsonMSetEntry(key: 'user:1', path: r'$', value: '{"name":"Alice"}'),
        JsonMSetEntry(key: 'user:2', path: r'$.age', value: '30'),
      ]);

      expect(command.commandParts, [
        'JSON.MSET',
        'user:1',
        r'$',
        '{"name":"Alice"}',
        'user:2',
        r'$.age',
        '30',
      ]);
    });

    test('should parse OK response correctly', () {
      final command = JsonMSetCommand(const [
        JsonMSetEntry(key: 'user:1', path: r'$', value: '{"name":"Alice"}'),
      ]);

      expect(command.parse('OK'), isTrue);
      expect(command.parse(null), isFalse);
      expect(command.parse('ERR'), isFalse);
    });

    test('should apply prefix to all entries', () {
      final command = JsonMSetCommand(const [
        JsonMSetEntry(key: 'user:1', path: r'$', value: '{"name":"Alice"}'),
        JsonMSetEntry(key: 'user:2', path: r'$.city', value: '"Madrid"'),
      ]);

      final prefixed = command.applyPrefix('v:');
      expect(prefixed.commandParts, [
        'JSON.MSET',
        'v:user:1',
        r'$',
        '{"name":"Alice"}',
        'v:user:2',
        r'$.city',
        '"Madrid"',
      ]);
    });
  });
}
