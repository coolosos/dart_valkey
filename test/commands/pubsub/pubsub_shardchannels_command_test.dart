import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/pubsub/pubsub_shardchannels_command.dart';
import 'package:test/test.dart';

void main() {
  group('PubsubShardchannelsCommand', () {
    test('should build the correct command without pattern', () {
      final command = PubsubShardchannelsCommand();
      expect(command.commandParts, ['PUBSUB', 'SHARDCHANNELS']);
    });

    test('should build the correct command with pattern', () {
      final command = PubsubShardchannelsCommand('mychannel*');
      expect(command.commandParts, ['PUBSUB', 'SHARDCHANNELS', 'mychannel*']);
    });

    test('should parse list of strings correctly', () {
      final command = PubsubShardchannelsCommand();
      expect(command.parse(['channel1', 'channel2']), ['channel1', 'channel2']);
    });

    test('should parse empty list correctly', () {
      final command = PubsubShardchannelsCommand();
      expect(command.parse(<dynamic>[]), <String>[]);
    });

    test('should throw an exception for invalid response', () {
      final command = PubsubShardchannelsCommand();
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });
  });
}
