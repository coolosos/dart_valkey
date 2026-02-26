import 'package:dart_valkey/src/commands/set/sismember_command.dart';
import 'package:test/test.dart';

void main() {
  group('SIsMemberCommand', () {
    test('should build the correct command', () {
      final command = SIsMemberCommand('myset', 'member1');
      expect(command.commandParts, ['SISMEMBER', 'myset', 'member1']);
    });

    test('should parse true response correctly', () {
      final command = SIsMemberCommand('myset', 'member1');
      expect(command.parse(1), isTrue);
    });

    test('should parse false response correctly', () {
      final command = SIsMemberCommand('myset', 'member1');
      expect(command.parse(0), isFalse);
    });

    test('should apply prefix to key', () {
      final command = SIsMemberCommand('myset', 'member1');
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(
        prefixedCommand.commandParts,
        ['SISMEMBER', 'myprefix:myset', 'member1'],
      );
    });
  });
}
