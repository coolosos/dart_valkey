import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/hash/hsetnx_command.dart';
import 'package:test/test.dart';

void main() {
  group('HSetNxCommand', () {
    test('should build the correct command', () {
      final command = HSetNxCommand('mykey', 'myfield', 'myvalue');
      expect(command.commandParts, ['HSETNX', 'mykey', 'myfield', 'myvalue']);
    });

    test('should parse true response correctly', () {
      final command = HSetNxCommand('mykey', 'myfield', 'myvalue');
      expect(command.parse(1), isTrue);
    });

    test('should parse false response correctly', () {
      final command = HSetNxCommand('mykey', 'myfield', 'myvalue');
      expect(command.parse(0), isFalse);
    });

    test('should throw an exception for invalid response', () {
      final command = HSetNxCommand('mykey', 'myfield', 'myvalue');
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = HSetNxCommand('mykey', 'myfield', 'myvalue');
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(prefixedCommand.commandParts,
          ['HSETNX', 'myprefix:mykey', 'myfield', 'myvalue']);
    });
  });
}
