import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/strings/getrange_command.dart';
import 'package:test/test.dart';

void main() {
  group('GetRangeCommand', () {
    test('should build the correct command', () {
      final command = GetRangeCommand('mykey', 0, 4);
      expect(command.commandParts, ['GETRANGE', 'mykey', '0', '4']);
    });

    test('should parse string response correctly', () {
      final command = GetRangeCommand('mykey', 0, 4);
      expect(command.parse('Hello'), 'Hello');
    });

    test('should throw an exception for invalid response', () {
      final command = GetRangeCommand('mykey', 0, 4);
      expect(() => command.parse(123), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = GetRangeCommand('mykey', 0, 4);
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(
        prefixedCommand.commandParts,
        ['GETRANGE', 'myprefix:mykey', '0', '4'],
      );
    });
  });
}
