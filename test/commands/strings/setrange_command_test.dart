import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/strings/setrange_command.dart';
import 'package:test/test.dart';

void main() {
  group('SetRangeCommand', () {
    test('should build the correct command', () {
      final command = SetRangeCommand('mykey', 6, 'World');
      expect(command.commandParts, ['SETRANGE', 'mykey', '6', 'World']);
    });

    test('should parse int response correctly', () {
      final command = SetRangeCommand('mykey', 6, 'World');
      expect(command.parse(11), 11);
    });

    test('should throw an exception for invalid response', () {
      final command = SetRangeCommand('mykey', 6, 'World');
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = SetRangeCommand('mykey', 6, 'World');
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(prefixedCommand.commandParts,
          ['SETRANGE', 'myprefix:mykey', '6', 'World']);
    });
  });
}
