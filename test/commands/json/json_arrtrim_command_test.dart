import 'package:dart_valkey/src/commands/json/json_arrtrim_command.dart';
import 'package:test/test.dart';

void main() {
  group('JsonArrTrimCommand', () {
    test('should build the correct command', () {
      final command = JsonArrTrimCommand('doc:1', r'$.items', 1, 3);
      expect(command.commandParts, [
        'JSON.ARRTRIM',
        'doc:1',
        r'$.items',
        '1',
        '3',
      ]);
    });

    test('should parse list response correctly', () {
      final command = JsonArrTrimCommand('doc:1', r'$.items', 1, 3);
      expect(command.parse([3, null, '4']), [3, null, 4]);
    });

    test('should parse single int response correctly', () {
      final command = JsonArrTrimCommand('doc:1', r'$.items', 1, 3);
      expect(command.parse(3), [3]);
      expect(command.parse('3'), [3]);
      expect(command.parse('invalid'), isEmpty);
      expect(command.parse(null), isEmpty);
    });

    test('should apply prefix to key', () {
      final command = JsonArrTrimCommand('doc:1', r'$.items', 1, 3);
      final prefixed = command.applyPrefix('prefix:');
      expect(prefixed.commandParts, [
        'JSON.ARRTRIM',
        'prefix:doc:1',
        r'$.items',
        '1',
        '3',
      ]);
    });
  });
}
