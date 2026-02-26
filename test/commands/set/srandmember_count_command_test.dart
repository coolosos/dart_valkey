import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/set/srandmember_count_command.dart';
import 'package:test/test.dart';

void main() {
  group('SRandMemberCountCommand', () {
    test('should build the correct command', () {
      final command = SRandMemberCountCommand('myset', 2);
      expect(command.commandParts, ['SRANDMEMBER', 'myset', '2']);
    });

    test('should parse list of strings correctly', () {
      final command = SRandMemberCountCommand('myset', 2);
      expect(command.parse(['member1', 'member2']), ['member1', 'member2']);
    });

    test('should parse empty list correctly', () {
      final command = SRandMemberCountCommand('myset', 2);
      expect(command.parse([]), []);
    });

    test('should throw an exception for invalid response', () {
      final command = SRandMemberCountCommand('myset', 2);
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = SRandMemberCountCommand('myset', 2);
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(
        prefixedCommand.commandParts,
        ['SRANDMEMBER', 'myprefix:myset', '2'],
      );
    });
  });
}
