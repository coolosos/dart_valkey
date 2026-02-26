import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/hash/hget_command.dart';
import 'package:test/test.dart';

void main() {
  group('HGetCommand', () {
    test('should build the correct command', () {
      final command = HGetCommand('mykey', 'myfield');
      expect(command.commandParts, ['HGET', 'mykey', 'myfield']);
    });

    test('should parse string response correctly', () {
      final command = HGetCommand('mykey', 'myfield');
      expect(command.parse('myvalue'), 'myvalue');
    });

    test('should parse null response correctly', () {
      final command = HGetCommand('mykey', 'myfield');
      expect(command.parse(null), isNull);
    });

    test('should throw an exception for invalid response', () {
      final command = HGetCommand('mykey', 'myfield');
      expect(() => command.parse(123), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = HGetCommand('mykey', 'myfield');
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(
          prefixedCommand.commandParts, ['HGET', 'myprefix:mykey', 'myfield']);
    });
  });
}
