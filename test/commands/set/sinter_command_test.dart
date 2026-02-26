import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/set/sinter_command.dart';
import 'package:test/test.dart';

void main() {
  group('SInterCommand', () {
    test('should build the correct command', () {
      final command = SInterCommand(['set1', 'set2']);
      expect(command.commandParts, ['SINTER', 'set1', 'set2']);
    });

    test('should parse list of strings correctly', () {
      final command = SInterCommand(['set1']);
      expect(command.parse(['member1']), ['member1']);
    });

    test('should parse empty list correctly', () {
      final command = SInterCommand(['set1']);
      expect(command.parse([]), []);
    });

    test('should throw an exception for invalid response', () {
      final command = SInterCommand(['set1']);
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to keys', () {
      final command = SInterCommand(['set1', 'set2']);
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(prefixedCommand.commandParts,
          ['SINTER', 'myprefix:set1', 'myprefix:set2']);
    });
  });
}
