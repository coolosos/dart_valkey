import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/connection/hello_command.dart';
import 'package:test/test.dart';

void main() {
  group('HelloCommand', () {
    test('should build the correct command with no parameters', () {
      final command = HelloCommand();
      expect(command.commandParts, ['HELLO']);
    });

    test('should build the correct command with protocol version', () {
      final command = HelloCommand(protocolVersion: 3);
      expect(command.commandParts, ['HELLO', '3']);
    });

    test(
        'should build the correct command with protocol, username, and password',
        () {
      final command = HelloCommand(
          protocolVersion: 3, username: 'myuser', password: 'mypass');
      expect(command.commandParts, ['HELLO', '3', 'AUTH', 'myuser', 'mypass']);
    });

    test(
        'should build the correct command with protocol and password (default user)',
        () {
      final command = HelloCommand(protocolVersion: 3, password: 'mypass');
      expect(command.commandParts, ['HELLO', '3', 'AUTH', 'default', 'mypass']);
    });

    test('should build the correct command with protocol and client name', () {
      final command = HelloCommand(protocolVersion: 3, clientName: 'myclient');
      expect(command.commandParts, ['HELLO', '3', 'SETNAME', 'myclient']);
    });

    test('should parse map response correctly', () {
      final command = HelloCommand();
      expect(command.parse({'server': 'valkey', 'version': '7.2.0'}),
          {'server': 'valkey', 'version': '7.2.0'});
    });

    test('should parse list response correctly', () {
      final command = HelloCommand();
      expect(
        command.parse(['server', 'valkey', 'version', '7.2.0']),
        {'server': 'valkey', 'version': '7.2.0'},
      );
    });

    test('should throw an exception for invalid response', () {
      final command = HelloCommand();
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });
  });
}
