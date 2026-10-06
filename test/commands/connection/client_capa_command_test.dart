import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/connection/client_capa_command.dart';
import 'package:test/test.dart';

void main() {
  group('ClientCapaCommand', () {
    test('should build the correct command', () {
      final command = ClientCapaCommand();
      expect(command.commandParts, ['CLIENT', 'CAPA']);
    });

    test('should parse list of strings correctly', () {
      final command = ClientCapaCommand();
      expect(command.parse(['RESP3', 'PUBSUB']), ['RESP3', 'PUBSUB']);
    });

    test('should parse empty list correctly', () {
      final command = ClientCapaCommand();
      expect(command.parse(<dynamic>[]), <String>[]);
    });

    test('should throw an exception for invalid response', () {
      final command = ClientCapaCommand();
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });
  });
}
