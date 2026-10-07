import 'package:dart_valkey/src/commands/json/json_numincrby_command.dart';
import 'package:test/test.dart';

void main() {
  group('JsonNumIncrByCommand', () {
    test('should build the correct command', () {
      final command = JsonNumIncrByCommand('doc:1', r'$.age', 5);
      expect(command.commandParts, ['JSON.NUMINCRBY', 'doc:1', r'$.age', '5']);
    });

    test('should build the correct command with double', () {
      final command = JsonNumIncrByCommand('doc:1', r'$.price', 2.5);
      expect(command.commandParts, [
        'JSON.NUMINCRBY',
        'doc:1',
        r'$.price',
        '2.5',
      ]);
    });

    test('should parse string response correctly', () {
      final command = JsonNumIncrByCommand('doc:1', r'$.age', 5);
      expect(command.parse('[35]'), '[35]');
      expect(command.parse(null), isNull);
    });

    test('should apply prefix to key', () {
      final command = JsonNumIncrByCommand('doc:1', r'$.age', 5);
      final prefixed = command.applyPrefix('prefix:');
      expect(prefixed.commandParts, [
        'JSON.NUMINCRBY',
        'prefix:doc:1',
        r'$.age',
        '5',
      ]);
    });
  });
}
