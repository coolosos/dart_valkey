import 'package:dart_valkey/src/commands/json/json_arrappend_command.dart';
import 'package:test/test.dart';

void main() {
  group('JsonArrAppendCommand', () {
    test('should build the correct command with default path', () {
      final command = JsonArrAppendCommand('doc:1', const [
        '"item1"',
        '{"id":2}',
      ]);
      expect(command.commandParts, [
        'JSON.ARRAPPEND',
        'doc:1',
        r'$',
        '"item1"',
        '{"id":2}',
      ]);
    });

    test('should build the correct command with custom path', () {
      final command = JsonArrAppendCommand('doc:1', const [
        '"item1"',
      ], path: r'$.items');
      expect(command.commandParts, [
        'JSON.ARRAPPEND',
        'doc:1',
        r'$.items',
        '"item1"',
      ]);
    });

    test('should parse list response correctly', () {
      final command = JsonArrAppendCommand('doc:1', const ['"item1"']);
      expect(command.parse([3, null, '5']), [3, null, 5]);
    });

    test('should parse single int response correctly', () {
      final command = JsonArrAppendCommand('doc:1', const ['"item1"']);
      expect(command.parse(3), [3]);
      expect(command.parse('3'), [3]);
      expect(command.parse('invalid'), isEmpty);
      expect(command.parse(null), isEmpty);
    });

    test('should apply prefix to key', () {
      final command = JsonArrAppendCommand('doc:1', const [
        '"item1"',
      ], path: r'$.items');
      final prefixed = command.applyPrefix('prefix:');
      expect(prefixed.commandParts, [
        'JSON.ARRAPPEND',
        'prefix:doc:1',
        r'$.items',
        '"item1"',
      ]);
    });
  });
}
