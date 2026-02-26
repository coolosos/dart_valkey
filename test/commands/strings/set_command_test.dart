import 'package:dart_valkey/src/commands/strings/set_command.dart';
import 'package:test/test.dart';

void main() {
  group('SetCommand', () {
    test('should build the correct command for basic set', () {
      final command = SetCommand('mykey', 'myvalue');
      expect(command.commandParts, ['SET', 'mykey', 'myvalue']);
    });

    test('should build the correct command with strategy', () {
      final command = SetCommand(
        'mykey',
        'myvalue',
        strategyType: SetStrategyTypes.onlyIfNotExists,
      );
      expect(command.commandParts, ['SET', 'mykey', 'myvalue', 'NX']);
    });

    test('should build the correct command with expire duration (EX)', () {
      final command = SetCommand(
        'mykey',
        'myvalue',
        expire: const ExpireDuration(Duration(seconds: 60)),
      );
      expect(command.commandParts, ['SET', 'mykey', 'myvalue', 'EX', '60']);
    });

    test('should build the correct command with expire duration (PX)', () {
      final command = SetCommand(
        'mykey',
        'myvalue',
        expire: const ExpireDuration(
          Duration(milliseconds: 60000),
          type: ExpireDurationTypes.PX,
        ),
      );
      expect(command.commandParts, ['SET', 'mykey', 'myvalue', 'PX', '60000']);
    });

    test('should build the correct command with expire at (EXAT)', () {
      final expireTime = DateTime.fromMillisecondsSinceEpoch(1700000000000);
      final command = SetCommand(
        'mykey',
        'myvalue',
        expire: ExpireAt(expireTime, type: ExpireTimeTypes.EXAT),
      );
      final parts = command.commandParts;
      expect(parts[0], 'SET');
      expect(parts[1], 'mykey');
      expect(parts[2], 'myvalue');
      expect(parts[3], 'EXAT');
    });

    test('should build the correct command with expire at (PXAT)', () {
      final expireTime = DateTime.fromMillisecondsSinceEpoch(1700000000000);
      final command = SetCommand(
        'mykey',
        'myvalue',
        expire: ExpireAt(expireTime, type: ExpireTimeTypes.PXAT),
      );
      final parts = command.commandParts;
      expect(parts[0], 'SET');
      expect(parts[1], 'mykey');
      expect(parts[2], 'myvalue');
      expect(parts[3], 'PXAT');
    });

    test('should build the correct command with KeepTtl', () {
      final command = SetCommand('mykey', 'myvalue', expire: const KeepTtl());
      expect(command.commandParts, ['SET', 'mykey', 'myvalue', 'KEEPTTL']);
    });

    test('should build correct command with strategy and expire', () {
      final command = SetCommand(
        'mykey',
        'myvalue',
        strategyType: SetStrategyTypes.onlyIfNotExists,
        expire: const ExpireDuration(Duration(seconds: 60)),
      );
      final parts = command.commandParts;
      expect(parts, contains('NX'));
      expect(parts, contains('EX'));
      expect(parts, contains('60'));
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
      final command = SetCommand(
        'mykey',
        'myvalue',
        strategyType: SetStrategyTypes.onlyIfExists,
      );
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(
        prefixedCommand.commandParts,
        ['SET', 'myprefix:mykey', 'myvalue', 'XX'],
      );
    });
  });
}
