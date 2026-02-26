import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/connection/client_list_command.dart';
import 'package:test/test.dart';

void main() {
  group('ClientListCommand', () {
    test('should build the correct command', () {
      final command = ClientListCommand();
      expect(command.commandParts, ['CLIENT', 'LIST']);
    });

    test('should parse string response correctly', () {
      final command = ClientListCommand();
      expect(command.parse('id=1 addr=127.0.0.1:50000 fd=6 name=myclient'),
          'id=1 addr=127.0.0.1:50000 fd=6 name=myclient');
    });

    test('should throw an exception for invalid response', () {
      final command = ClientListCommand();
      expect(() => command.parse(123), throwsA(isA<ValkeyException>()));
    });
  });
}
