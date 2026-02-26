import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/zset/zscore_command.dart';
import 'package:test/test.dart';

void main() {
  group('ZScoreCommand', () {
    test('should build the correct command', () {
      final command = ZScoreCommand('myzset', 'member1');
      expect(command.commandParts, ['ZSCORE', 'myzset', 'member1']);
    });

    test('should parse double response correctly', () {
      final command = ZScoreCommand('myzset', 'member1');
      expect(command.parse('1.0'), 1.0);
    });

    test('should parse null response correctly', () {
      final command = ZScoreCommand('myzset', 'member1');
      expect(command.parse(null), isNull);
    });

    test('should throw an exception for invalid response', () {
      final command = ZScoreCommand('myzset', 'member1');
      expect(() => command.parse(123), throwsA(isA<ValkeyException>()));
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = ZScoreCommand('myzset', 'member1');
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(prefixedCommand.commandParts,
          ['ZSCORE', 'myprefix:myzset', 'member1']);
    });
  });
}
