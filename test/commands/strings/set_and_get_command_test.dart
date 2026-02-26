import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/strings/set_and_get_command.dart';
import 'package:dart_valkey/src/commands/strings/set_command.dart'; // For SetStrategyTypes
import 'package:test/test.dart';

void main() {
  group('SetAndGetCommand', () {
    test('should build the correct command for basic set and get', () {
      final command = SetAndGetCommand('mykey', 'myvalue');
      expect(command.commandParts, ['SET', 'mykey', 'myvalue', 'GET']);
    });

    test('should build the correct command with strategy', () {
      final command = SetAndGetCommand('mykey', 'myvalue',
          strategyType: SetStrategyTypes.onlyIfExists);
      expect(command.commandParts, ['SET', 'mykey', 'myvalue', 'XX', 'GET']);
    });

    test('should parse string response correctly', () {
      final command = SetAndGetCommand('mykey', 'myvalue');
      expect(command.parse('oldvalue'), 'oldvalue');
    });

    test('should parse null response correctly', () {
      final command = SetAndGetCommand('mykey', 'myvalue');
      expect(command.parse(null), isNull);
    });

    test('should throw an exception for invalid response', () {
      final command = SetAndGetCommand('mykey', 'myvalue');
      expect(() => command.parse(123), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = SetAndGetCommand('mykey', 'myvalue');
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(prefixedCommand.commandParts,
          ['SET', 'myprefix:mykey', 'myvalue', 'GET']);
    });
  });
}
