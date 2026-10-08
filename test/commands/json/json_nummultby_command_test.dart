import 'package:dart_valkey/src/commands/json/json_nummultby_command.dart';
import 'package:test/test.dart';

void main() {
  group('JsonNumMultByCommand', () {
    test('should build the correct command', () {
      final command = JsonNumMultByCommand('doc:1', r'$.age', 2);
      expect(command.commandParts, ['JSON.NUMMULTBY', 'doc:1', r'$.age', '2']);
    });

    test('should build the correct command with double', () {
      final command = JsonNumMultByCommand('doc:1', r'$.price', 1.5);
      expect(command.commandParts, [
        'JSON.NUMMULTBY',
        'doc:1',
        r'$.price',
        '1.5',
      ]);
    });

    test('should parse string response correctly', () {
      final command = JsonNumMultByCommand('doc:1', r'$.age', 2);
      expect(command.parse('[60]'), '[60]');
      expect(command.parse(null), isNull);
    });

    test('should apply prefix to key', () {
      final command = JsonNumMultByCommand('doc:1', r'$.age', 2);
      final prefixed = command.applyPrefix('prefix:');
      expect(prefixed.commandParts, [
        'JSON.NUMMULTBY',
        'prefix:doc:1',
        r'$.age',
        '2',
      ]);
    });
  });
}
