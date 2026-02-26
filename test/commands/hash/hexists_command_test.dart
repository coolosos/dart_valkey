import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/hash/hexists_command.dart';
import 'package:test/test.dart';

void main() {
  group('HExistsCommand', () {
    test('should build the correct command', () {
      final command = HExistsCommand('mykey', 'myfield');
      expect(command.commandParts, ['HEXISTS', 'mykey', 'myfield']);
    });

    test('should parse true response correctly', () {
      final command = HExistsCommand('mykey', 'myfield');
      expect(command.parse(1), isTrue);
    });

    test('should parse false response correctly', () {
      final command = HExistsCommand('mykey', 'myfield');
      expect(command.parse(0), isFalse);
    });

    test('should throw an exception for invalid response', () {
      final command = HExistsCommand('mykey', 'myfield');
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = HExistsCommand('mykey', 'myfield');
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(prefixedCommand.commandParts,
          ['HEXISTS', 'myprefix:mykey', 'myfield']);
    });
  });
}
