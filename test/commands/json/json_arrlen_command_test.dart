import 'package:dart_valkey/src/commands/json/json_arrlen_command.dart';
import 'package:test/test.dart';

void main() {
  group('JsonArrLenCommand', () {
    test('should build the correct command with default path', () {
      final command = JsonArrLenCommand('doc:1');
      expect(command.commandParts, ['JSON.ARRLEN', 'doc:1', r'$']);
    });

    test('should build the correct command with custom path', () {
      final command = JsonArrLenCommand('doc:1', path: r'$.items');
      expect(command.commandParts, ['JSON.ARRLEN', 'doc:1', r'$.items']);
    });

    test('should parse list response correctly', () {
      final command = JsonArrLenCommand('doc:1');
      expect(command.parse([3, null, '5']), [3, null, 5]);
    });

    test('should parse single int response correctly', () {
      final command = JsonArrLenCommand('doc:1');
      expect(command.parse(3), [3]);
      expect(command.parse('3'), [3]);
      expect(command.parse('invalid'), isEmpty);
      expect(command.parse(null), isEmpty);
    });

    test('should apply prefix to key', () {
      final command = JsonArrLenCommand('doc:1', path: r'$.items');
      final prefixed = command.applyPrefix('prefix:');
      expect(prefixed.commandParts, [
        'JSON.ARRLEN',
        'prefix:doc:1',
        r'$.items',
      ]);
    });
  });
}
