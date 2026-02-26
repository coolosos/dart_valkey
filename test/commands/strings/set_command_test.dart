import 'package:dart_valkey/src/commands/strings/set_command.dart';
import 'package:test/test.dart';

void main() {
  group('SetCommand', () {
    test('should build the correct command for basic set', () {
      final command = SetCommand('mykey', 'myvalue');
      expect(command.commandParts, ['SET', 'mykey', 'myvalue']);
    });

    test('should build the correct command with strategy', () {
      final command = SetCommand('mykey', 'myvalue',
          strategyType: SetStrategyTypes.onlyIfNotExists);
      expect(command.commandParts, ['SET', 'mykey', 'myvalue', 'NX']);
    });

    test('should build the correct command with expire duration', () {
      final command = SetCommand('mykey', 'myvalue',
          expire: const ExpireDuration(Duration(seconds: 60)));
      expect(command.commandParts, ['SET', 'mykey', 'myvalue', 'EX', '60']);
    });

    test('should parse OK response correctly', () {
      final command = SetCommand('mykey', 'myvalue');
      expect(command.parse('OK'), isTrue);
    });

    test('should parse non-OK response correctly', () {
      final command = SetCommand('mykey', 'myvalue');
      expect(command.parse(null), isFalse);
    });

    test('should apply prefix to key', () {
      final command = SetCommand('mykey', 'myvalue',
          strategyType: SetStrategyTypes.onlyIfExists);
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(prefixedCommand.commandParts,
          ['SET', 'myprefix:mykey', 'myvalue', 'XX']);
    });
  });
}
