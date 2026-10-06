import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/pubsub/pubsub_channels_command.dart';
import 'package:test/test.dart';

void main() {
  group('PubsubChannelsCommand', () {
    test('should build the correct command without pattern', () {
      final command = PubsubChannelsCommand();
      expect(command.commandParts, ['PUBSUB', 'CHANNELS']);
    });

    test('should build the correct command with pattern', () {
      final command = PubsubChannelsCommand('mychannel*');
      expect(command.commandParts, ['PUBSUB', 'CHANNELS', 'mychannel*']);
    });

    test('should parse list of strings correctly', () {
      final command = PubsubChannelsCommand();
      expect(command.parse(['channel1', 'channel2']), ['channel1', 'channel2']);
    });

    test('should parse empty list correctly', () {
      final command = PubsubChannelsCommand();
      expect(command.parse(<dynamic>[]), <String>[]);
    });

    test('should throw an exception for invalid response', () {
      final command = PubsubChannelsCommand();
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });
  });
}
