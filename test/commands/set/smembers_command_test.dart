import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/set/smembers_command.dart';
import 'package:test/test.dart';

void main() {
  group('SMembersCommand', () {
    test('should build the correct command', () {
      final command = SMembersCommand('myset');
      expect(command.commandParts, ['SMEMBERS', 'myset']);
    });

    test('should parse list of strings correctly', () {
      final command = SMembersCommand('myset');
      expect(command.parse(['member1', 'member2']), ['member1', 'member2']);
    });

    test('should parse empty list correctly', () {
      final command = SMembersCommand('myset');
      expect(command.parse(<dynamic>[]), <String>[]);
    });

    test('should throw an exception for invalid response', () {
      final command = SMembersCommand('myset');
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = SMembersCommand('myset');
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(prefixedCommand.commandParts, ['SMEMBERS', 'myprefix:myset']);
    });
  });
}
