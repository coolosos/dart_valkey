import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/strings/getset_command.dart';
import 'package:test/test.dart';

void main() {
  group('GetSetCommand', () {
    test('should build the correct command', () {
      final command = GetSetCommand('mykey', 'newvalue');
      expect(command.commandParts, ['GETSET', 'mykey', 'newvalue']);
    });

    test('should parse string response correctly', () {
      final command = GetSetCommand('mykey', 'newvalue');
      expect(command.parse('oldvalue'), 'oldvalue');
    });

    test('should parse null response correctly', () {
      final command = GetSetCommand('mykey', 'newvalue');
      expect(command.parse(null), isNull);
    });

    test('should throw an exception for invalid response', () {
      final command = GetSetCommand('mykey', 'newvalue');
      expect(() => command.parse(123), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = GetSetCommand('mykey', 'newvalue');
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(
        prefixedCommand.commandParts,
        ['GETSET', 'myprefix:mykey', 'newvalue'],
      );
    });
  });
}
