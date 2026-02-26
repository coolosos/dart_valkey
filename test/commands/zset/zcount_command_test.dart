import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/zset/zcount_command.dart';
import 'package:test/test.dart';

void main() {
  group('ZCountCommand', () {
    test('should build the correct command', () {
      final command = ZCountCommand('myzset', '0', '10');
      expect(command.commandParts, ['ZCOUNT', 'myzset', '0', '10']);
    });

    test('should parse int response correctly', () {
      final command = ZCountCommand('myzset', '0', '10');
      expect(command.parse(2), 2);
    });

    test('should throw an exception for invalid response', () {
      final command = ZCountCommand('myzset', '0', '10');
      expect(() => command.parse('invalid'), throwsA(isA<ValkeyException>()));
    });

    test('should apply prefix to key', () {
      final command = ZCountCommand('myzset', '0', '10');
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(
        prefixedCommand.commandParts,
        ['ZCOUNT', 'myprefix:myzset', '0', '10'],
      );
    });
  });
}
