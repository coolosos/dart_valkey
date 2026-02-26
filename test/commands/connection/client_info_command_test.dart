import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/connection/client_info_command.dart';
import 'package:test/test.dart';

void main() {
  group('ClientInfoCommand', () {
    test('should build the correct command', () {
      final command = ClientInfoCommand();
      expect(command.commandParts, ['CLIENT', 'INFO']);
    });

    test('should parse string response correctly', () {
      final command = ClientInfoCommand();
      expect(
        command.parse('id=1 addr=127.0.0.1:50000 fd=6 name=myclient'),
        'id=1 addr=127.0.0.1:50000 fd=6 name=myclient',
      );
    });

    test('should throw an exception for invalid response', () {
      final command = ClientInfoCommand();
      expect(() => command.parse(123), throwsA(isA<ValkeyException>()));
    });
  });
}
