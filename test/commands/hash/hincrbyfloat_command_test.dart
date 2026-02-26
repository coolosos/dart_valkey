import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/hash/hincrbyfloat_command.dart';
import 'package:test/test.dart';

void main() {
  group('HIncrByFloatCommand', () {
    test('should build the correct command', () {
      final command = HIncrByFloatCommand('mykey', 'myfield', 1.5);
      expect(command.commandParts, ['HINCRBYFLOAT', 'mykey', 'myfield', '1.5']);
    });

    test('should parse double response correctly', () {
      final command = HIncrByFloatCommand('mykey', 'myfield', 1.5);
      expect(command.parse('1.5'), 1.5);
    });

    test('should throw an exception for invalid response', () {
      final command = HIncrByFloatCommand('mykey', 'myfield', 1.5);
      expect(() => command.parse(123), throwsA(isA<ValkeyException>()));
      expect(() => command.parse('invalid'), throwsA(isA<FormatException>()));
    });

    test('should apply prefix to key', () {
      final command = HIncrByFloatCommand('mykey', 'myfield', 1.5);
      final prefixedCommand = command.applyPrefix('myprefix:');
      expect(
        prefixedCommand.commandParts,
        ['HINCRBYFLOAT', 'myprefix:mykey', 'myfield', '1.5'],
      );
    });
  });
}
