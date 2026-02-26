import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/connection/client_unblock_command.dart';
import 'package:test/test.dart';

void main() {
  group('ClientUnblockCommand', () {
    test('should build the correct command without unblockType', () {
      final command = ClientUnblockCommand(123);
      expect(command.commandParts, ['CLIENT', 'UNBLOCK', '123']);
    });

    test('should build the correct command with TIMEOUT unblockType', () {
      final command =
          ClientUnblockCommand(123, unblockType: UnblockType.timeout);
      expect(command.commandParts, ['CLIENT', 'UNBLOCK', '123', 'TIMEOUT']);
    });

    test('should build the correct command with ERROR unblockType', () {
      final command = ClientUnblockCommand(123, unblockType: UnblockType.error);
      expect(command.commandParts, ['CLIENT', 'UNBLOCK', '123', 'ERROR']);
    });

    test('should parse int response correctly', () {
      final command = ClientUnblockCommand(123);
      expect(command.parse(1), 1);
    });

    test('should throw an exception for invalid response', () {
      final command = ClientUnblockCommand(123);
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });
  });
}
