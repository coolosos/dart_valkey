import 'package:dart_valkey/src/commands/list/ltrim_command.dart';
import 'package:test/test.dart';

void main() {
  group('LTrimCommand', () {
    test('should build the correct command', () {
      final command = LTrimCommand('mylist', 0, 0);
      expect(command.commandParts, ['LTRIM', 'mylist', '0', '0']);
    });

    test('should parse OK response correctly', () {
      final command = LTrimCommand('mylist', 0, 0);
      expect(command.parse('OK'), isTrue);
    });

    test('should parse non-OK response correctly', () {
      final command = LTrimCommand('mylist', 0, 0);
      expect(command.parse('ERROR'), isFalse);
    });

    test('should apply prefix to key', () {
      final command = LTrimCommand('mylist', 0, 0);
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(
        prefixedCommand.commandParts,
        ['LTRIM', 'myprefix:mylist', '0', '0'],
      );
    });
  });
}
