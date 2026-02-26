import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/set/sunion_command.dart';
import 'package:test/test.dart';

void main() {
  group('SUnionCommand', () {
    test('should build the correct command', () {
      final command = SUnionCommand(['set1', 'set2']);
      expect(command.commandParts, ['SUNION', 'set1', 'set2']);
    });

    test('should parse list of strings correctly', () {
      final command = SUnionCommand(['set1']);
      expect(
        command.parse(['member1', 'member2', 'member3']),
        ['member1', 'member2', 'member3'],
      );
    });

    test('should parse empty list correctly', () {
      final command = SUnionCommand(['set1']);
      expect(command.parse([]), []);
    });

    test('should throw an exception for invalid response', () {
      final command = SUnionCommand(['set1']);
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to keys', () {
      final command = SUnionCommand(['set1', 'set2']);
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(
        prefixedCommand.commandParts,
        ['SUNION', 'myprefix:set1', 'myprefix:set2'],
      );
    });
  });
}
