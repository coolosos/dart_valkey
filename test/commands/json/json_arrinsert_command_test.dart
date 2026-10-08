import 'package:dart_valkey/src/commands/json/json_arrinsert_command.dart';
import 'package:test/test.dart';

void main() {
  group('JsonArrInsertCommand', () {
    test('should build the correct command', () {
      final command = JsonArrInsertCommand('doc:1', r'$.items', 1, const [
        '"inserted"',
        'true',
      ]);
      expect(command.commandParts, [
        'JSON.ARRINSERT',
        'doc:1',
        r'$.items',
        '1',
        '"inserted"',
        'true',
      ]);
    });

    test('should parse list response correctly', () {
      final command = JsonArrInsertCommand('doc:1', r'$.items', 0, const ['1']);
      expect(command.parse([4, null, '6']), [4, null, 6]);
    });

    test('should parse single int response correctly', () {
      final command = JsonArrInsertCommand('doc:1', r'$.items', 0, const ['1']);
      expect(command.parse(4), [4]);
      expect(command.parse('4'), [4]);
      expect(command.parse('invalid'), isEmpty);
      expect(command.parse(null), isEmpty);
    });

    test('should apply prefix to key', () {
      final command = JsonArrInsertCommand('doc:1', r'$.items', 0, const ['1']);
      final prefixed = command.applyPrefix('prefix:');
      expect(prefixed.commandParts, [
        'JSON.ARRINSERT',
        'prefix:doc:1',
        r'$.items',
        '0',
        '1',
      ]);
    });
  });
}
