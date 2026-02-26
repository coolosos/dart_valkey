import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/connection/client_trackinginfo_command.dart';
import 'package:test/test.dart';

void main() {
  group('ClientTrackinginfoCommand', () {
    test('should build the correct command', () {
      final command = ClientTrackinginfoCommand();
      expect(command.commandParts, ['CLIENT', 'TRACKINGINFO']);
    });

    test('should parse list response correctly', () {
      final command = ClientTrackinginfoCommand();
      expect(command.parse(['redirect', 0, 'prefixes', []]),
          {'redirect': 0, 'prefixes': []});
    });

    test('should parse empty list response correctly', () {
      final command = ClientTrackinginfoCommand();
      expect(command.parse([]), {});
    });

    test('should throw an exception for invalid response', () {
      final command = ClientTrackinginfoCommand();
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });
  });
}
