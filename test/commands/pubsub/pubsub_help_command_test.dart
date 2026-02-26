import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/pubsub/pubsub_help_command.dart';
import 'package:test/test.dart';

void main() {
  group('PubsubHelpCommand', () {
    test('should build the correct command', () {
      final command = PubsubHelpCommand();
      expect(command.commandParts, ['PUBSUB', 'HELP']);
    });

    test('should parse list of strings correctly', () {
      final command = PubsubHelpCommand();
      expect(command.parse(['help text 1', 'help text 2']),
          ['help text 1', 'help text 2']);
    });

    test('should parse empty list correctly', () {
      final command = PubsubHelpCommand();
      expect(command.parse([]), []);
    });

    test('should throw an exception for invalid response', () {
      final command = PubsubHelpCommand();
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });
  });
}
