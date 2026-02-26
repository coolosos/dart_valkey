import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/hash/hstrlen_command.dart';
import 'package:test/test.dart';

void main() {
  group('HStrLenCommand', () {
    test('should build the correct command', () {
      final command = HStrLenCommand('mykey', 'myfield');
      expect(command.commandParts, ['HSTRLEN', 'mykey', 'myfield']);
    });

    test('should parse int response correctly', () {
      final command = HStrLenCommand('mykey', 'myfield');
      expect(command.parse(5), 5);
    });

    test('should throw an exception for invalid response', () {
      final command = HStrLenCommand('mykey', 'myfield');
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = HStrLenCommand('mykey', 'myfield');
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(prefixedCommand.commandParts,
          ['HSTRLEN', 'myprefix:mykey', 'myfield']);
    });
  });
}
