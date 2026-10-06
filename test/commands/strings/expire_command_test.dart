import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/strings/expire_command.dart';
import 'package:test/test.dart';

void main() {
  group('ExpireCommand', () {
    test('should build the correct command without strategy', () {
      final command = ExpireCommand('mykey', 60);
      expect(command.commandParts, ['EXPIRE', 'mykey', '60']);
    });

    test('should build the correct command with strategy', () {
      final command = ExpireCommand(
        'mykey',
        60,
        strategyType: ExpireStrategyTypes.onlyIfNotExists,
      );
      expect(command.commandParts, ['EXPIRE', 'mykey', '60', 'NX']);
    });

    test('should parse int response correctly (true)', () {
      final command = ExpireCommand('mykey', 60);
      expect(command.parse(1), isTrue);
    });

    test('should parse int response correctly (false)', () {
      final command = ExpireCommand('mykey', 60);
      expect(command.parse(0), isFalse);
    });

    test('should parse string response correctly (true)', () {
      final command = ExpireCommand('mykey', 60);
      expect(command.parse('1'), isTrue);
    });

    test('should parse string response correctly (false)', () {
      final command = ExpireCommand('mykey', 60);
      expect(command.parse('0'), isFalse);
    });

    test('should throw an exception for invalid response', () {
      final command = ExpireCommand('mykey', 60);
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = ExpireCommand(
        'mykey',
        60,
        strategyType: ExpireStrategyTypes.onlyIfExists,
      );
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(prefixedCommand.commandParts, [
        'EXPIRE',
        'myprefix:mykey',
        '60',
        'XX',
      ]);
    });
  });
}
