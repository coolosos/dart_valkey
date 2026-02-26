import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/zset/zrank_command.dart';
import 'package:test/test.dart';

void main() {
  group('ZRankCommand', () {
    test('should build the correct command', () {
      final command = ZRankCommand('myzset', 'member1');
      expect(command.commandParts, ['ZRANK', 'myzset', 'member1']);
    });

    test('should parse int response correctly', () {
      final command = ZRankCommand('myzset', 'member1');
      expect(command.parse(0), 0);
    });

    test('should parse null response correctly', () {
      final command = ZRankCommand('myzset', 'member1');
      expect(command.parse(null), isNull);
    });

    test('should throw an exception for invalid response', () {
      final command = ZRankCommand('myzset', 'member1');
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = ZRankCommand('myzset', 'member1');
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(
        prefixedCommand.commandParts,
        ['ZRANK', 'myprefix:myzset', 'member1'],
      );
    });
  });
}
