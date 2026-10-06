import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/strings/append_command.dart';
import 'package:test/test.dart';

void main() {
  group('AppendCommand', () {
    test('should build the correct command', () {
      final command = AppendCommand('mykey', 'myvalue');
      expect(command.commandParts, ['APPEND', 'mykey', 'myvalue']);
    });

    test('should parse the response correctly', () {
      final command = AppendCommand('mykey', 'myvalue');
      expect(command.parse(11), 11);
    });

    test('should throw an exception for invalid response', () {
      final command = AppendCommand('mykey', 'myvalue');
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = AppendCommand('mykey', 'myvalue');
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(prefixedCommand.commandParts, [
        'APPEND',
        'myprefix:mykey',
        'myvalue',
      ]);
    });
  });
}
