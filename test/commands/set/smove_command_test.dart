import 'package:dart_valkey/src/commands/set/smove_command.dart';
import 'package:test/test.dart';

void main() {
  group('SMoveCommand', () {
    test('should build the correct command', () {
      final command = SMoveCommand('mysource', 'mydestination', 'mymember');
      expect(command.commandParts,
          ['SMOVE', 'mysource', 'mydestination', 'mymember']);
    });

    test('should parse true response correctly', () {
      final command = SMoveCommand('mysource', 'mydestination', 'mymember');
      expect(command.parse(1), isTrue);
    });

    test('should parse false response correctly', () {
      final command = SMoveCommand('mysource', 'mydestination', 'mymember');
      expect(command.parse(0), isFalse);
    });

    test('should apply prefix to keys', () {
      final command = SMoveCommand('mysource', 'mydestination', 'mymember');
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(prefixedCommand.commandParts,
          ['SMOVE', 'myprefix:mysource', 'myprefix:mydestination', 'mymember']);
    });
  });
}
