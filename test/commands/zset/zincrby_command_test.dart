import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/zset/zincrby_command.dart';
import 'package:test/test.dart';

void main() {
  group('ZIncrByCommand', () {
    test('should build the correct command', () {
      final command = ZIncrByCommand('myzset', 1.5, 'member1');
      expect(command.commandParts, ['ZINCRBY', 'myzset', '1.5', 'member1']);
    });

    test('should parse double response correctly', () {
      final command = ZIncrByCommand('myzset', 1.5, 'member1');
      expect(command.parse('2.5'), 2.5);
    });

    test('should throw an exception for invalid response', () {
      final command = ZIncrByCommand('myzset', 1.5, 'member1');
      expect(() => command.parse(123), throwsA(isA<ValkeyException>()));
      expect(() => command.parse('invalid'), throwsA(isA<FormatException>()));
    });

    test('should apply prefix to key', () {
      final command = ZIncrByCommand('myzset', 1.5, 'member1');
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(
        prefixedCommand.commandParts,
        ['ZINCRBY', 'myprefix:myzset', '1.5', 'member1'],
      );
    });
  });
}
