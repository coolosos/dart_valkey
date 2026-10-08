import 'package:dart_valkey/src/commands/json/json_set_command.dart';
import 'package:dart_valkey/src/commands/strings/set_command.dart';
import 'package:test/test.dart';

void main() {
  group('JsonSetCommand', () {
    test('should build the correct command for basic JSON.SET', () {
      final command = JsonSetCommand('doc:1', r'$', '{"name":"Alice"}');
      expect(command.commandParts, [
        'JSON.SET',
        'doc:1',
        r'$',
        '{"name":"Alice"}',
      ]);
    });

    test('should build the correct command with NX strategy', () {
      final command = JsonSetCommand(
        'doc:1',
        r'$',
        '{"name":"Alice"}',
        strategyType: SetStrategyTypes.onlyIfNotExists,
      );
      expect(command.commandParts, [
        'JSON.SET',
        'doc:1',
        r'$',
        '{"name":"Alice"}',
        'NX',
      ]);
    });

    test('should build the correct command with XX strategy', () {
      final command = JsonSetCommand(
        'doc:1',
        r'$.age',
        '30',
        strategyType: SetStrategyTypes.onlyIfExists,
      );
      expect(command.commandParts, ['JSON.SET', 'doc:1', r'$.age', '30', 'XX']);
    });

    test('should parse OK response correctly', () {
      final command = JsonSetCommand('doc:1', r'$', '{"name":"Alice"}');
      expect(command.parse('OK'), isTrue);
      expect(command.parse(null), isFalse);
      expect(command.parse('ERR'), isFalse);
    });

    test('should apply prefix to key', () {
      final command = JsonSetCommand(
        'doc:1',
        r'$',
        '{"name":"Alice"}',
        strategyType: SetStrategyTypes.onlyIfNotExists,
      );
      final prefixed = command.applyPrefix('prefix:');
      expect(prefixed.commandParts, [
        'JSON.SET',
        'prefix:doc:1',
        r'$',
        '{"name":"Alice"}',
        'NX',
      ]);
    });
  });
}
