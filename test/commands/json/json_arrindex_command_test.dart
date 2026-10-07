import 'package:dart_valkey/src/commands/json/json_arrindex_command.dart';
import 'package:test/test.dart';

void main() {
  group('JsonArrIndexCommand', () {
    test('should build the correct command without range', () {
      final command = JsonArrIndexCommand('doc:1', r'$.items', '"target"');
      expect(command.commandParts, [
        'JSON.ARRINDEX',
        'doc:1',
        r'$.items',
        '"target"',
      ]);
    });

    test('should build the correct command with start and stop', () {
      final command = JsonArrIndexCommand(
        'doc:1',
        r'$.items',
        '"target"',
        start: 0,
        stop: 5,
      );
      expect(command.commandParts, [
        'JSON.ARRINDEX',
        'doc:1',
        r'$.items',
        '"target"',
        '0',
        '5',
      ]);
    });

    test('should parse list response correctly', () {
      final command = JsonArrIndexCommand('doc:1', r'$.items', '"target"');
      expect(command.parse([2, -1, null, '3']), [2, -1, null, 3]);
    });

    test('should parse single int response correctly', () {
      final command = JsonArrIndexCommand('doc:1', r'$.items', '"target"');
      expect(command.parse(2), [2]);
      expect(command.parse('2'), [2]);
      expect(command.parse('invalid'), isEmpty);
      expect(command.parse(null), isEmpty);
    });

    test('should apply prefix to key', () {
      final command = JsonArrIndexCommand('doc:1', r'$.items', '"target"');
      final prefixed = command.applyPrefix('prefix:');
      expect(prefixed.commandParts, [
        'JSON.ARRINDEX',
        'prefix:doc:1',
        r'$.items',
        '"target"',
      ]);
    });
  });
}
