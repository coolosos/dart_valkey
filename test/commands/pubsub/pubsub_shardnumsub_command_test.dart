import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/pubsub/pubsub_shardnumsub_command.dart';
import 'package:test/test.dart';

void main() {
  group('PubsubShardnumsubCommand', () {
    test('should build the correct command without channels', () {
      final command = PubsubShardnumsubCommand();
      expect(command.commandParts, ['PUBSUB', 'SHARDNUMSUB']);
    });

    test('should build the correct command with channels', () {
      final command = PubsubShardnumsubCommand(['channel1', 'channel2']);
      expect(
        command.commandParts,
        ['PUBSUB', 'SHARDNUMSUB', 'channel1', 'channel2'],
      );
    });

    test('should parse list response correctly', () {
      final command = PubsubShardnumsubCommand();
      expect(
        command.parse(['channel1', 5, 'channel2', 10]),
        {'channel1': 5, 'channel2': 10},
      );
    });

    test('should parse empty list response correctly', () {
      final command = PubsubShardnumsubCommand();
      expect(command.parse([]), {});
    });

    test('should throw an exception for invalid response', () {
      final command = PubsubShardnumsubCommand();
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });
  });
}
