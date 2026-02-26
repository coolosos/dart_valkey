import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/set/sdiff_command.dart';
import 'package:test/test.dart';

void main() {
  group('SDiffCommand', () {
    test('should build the correct command', () {
      final command = SDiffCommand(['set1', 'set2']);
      expect(command.commandParts, ['SDIFF', 'set1', 'set2']);
    });

    test('should parse list of strings correctly', () {
      final command = SDiffCommand(['set1']);
      expect(command.parse(['member2']), ['member2']);
    });

    test('should parse empty list correctly', () {
      final command = SDiffCommand(['set1']);
      expect(command.parse([]), []);
    });

    test('should throw an exception for invalid response', () {
      final command = SDiffCommand(['set1']);
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to keys', () {
      final command = SDiffCommand(['set1', 'set2']);
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(prefixedCommand.commandParts,
          ['SDIFF', 'myprefix:set1', 'myprefix:set2']);
    });
  });
}
