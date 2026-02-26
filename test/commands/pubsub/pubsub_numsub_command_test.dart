import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/pubsub/pubsub_numsub_command.dart';
import 'package:test/test.dart';

void main() {
  group('PubsubNumsubCommand', () {
    test('should build the correct command without channels', () {
      final command = PubsubNumsubCommand();
      expect(command.commandParts, ['PUBSUB', 'NUMSUB']);
    });

    test('should build the correct command with channels', () {
      final command = PubsubNumsubCommand(['channel1', 'channel2']);
      expect(
        command.commandParts,
        ['PUBSUB', 'NUMSUB', 'channel1', 'channel2'],
      );
    });

    test('should parse list response correctly', () {
      final command = PubsubNumsubCommand();
      expect(
        command.parse(['channel1', 5, 'channel2', 10]),
        {'channel1': 5, 'channel2': 10},
      );
    });

    test('should parse empty list response correctly', () {
      final command = PubsubNumsubCommand();
      expect(command.parse([]), {});
    });

    test('should throw an exception for invalid response', () {
      final command = PubsubNumsubCommand();
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });
  });
}
