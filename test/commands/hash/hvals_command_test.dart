import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/hash/hvals_command.dart';
import 'package:test/test.dart';

void main() {
  group('HValsCommand', () {
    test('should build the correct command', () {
      final command = HValsCommand('mykey');
      expect(command.commandParts, ['HVALS', 'mykey']);
    });

    test('should parse list of strings correctly', () {
      final command = HValsCommand('mykey');
      expect(command.parse(['Alice', '30']), ['Alice', '30']);
    });

    test('should parse empty list correctly', () {
      final command = HValsCommand('mykey');
      expect(command.parse(<dynamic>[]), <String>[]);
    });

    test('should throw an exception for invalid response', () {
      final command = HValsCommand('mykey');
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = HValsCommand('mykey');
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(prefixedCommand.commandParts, ['HVALS', 'myprefix:mykey']);
    });
  });
}
