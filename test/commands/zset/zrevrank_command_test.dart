import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/zset/zrevrank_command.dart';
import 'package:test/test.dart';

void main() {
  group('ZRevRankCommand', () {
    test('should build the correct command', () {
      final command = ZRevRankCommand('myzset', 'member2');
      expect(command.commandParts, ['ZREVRANK', 'myzset', 'member2']);
    });

    test('should parse int response correctly', () {
      final command = ZRevRankCommand('myzset', 'member2');
      expect(command.parse(0), 0);
    });

    test('should parse null response correctly', () {
      final command = ZRevRankCommand('myzset', 'member2');
      expect(command.parse(null), isNull);
    });

    test('should throw an exception for invalid response', () {
      final command = ZRevRankCommand('myzset', 'member2');
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = ZRevRankCommand('myzset', 'member2');
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(
        prefixedCommand.commandParts,
        ['ZREVRANK', 'myprefix:myzset', 'member2'],
      );
    });
  });
}
