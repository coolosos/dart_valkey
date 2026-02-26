import 'package:dart_valkey/src/commands/scripting/eval_command.dart';
import 'package:test/test.dart';

void main() {
  group('EvalCommand', () {
    test('should build the correct command with no keys or args', () {
      final command = EvalCommand(script: 'return 1', numberOfKeys: 0);
      expect(command.commandParts, ['EVAL', 'return 1', '0']);
    });

    test('should build the correct command with keys and args', () {
      final command = EvalCommand(
        script: 'return {KEYS[1], ARGV[1]}',
        numberOfKeys: 1,
        keys: ['mykey'],
        args: ['myarg'],
      );
      expect(
        command.commandParts,
        ['EVAL', 'return {KEYS[1], ARGV[1]}', '1', 'mykey', 'myarg'],
      );
    });

    test('should parse string response correctly', () {
      final command = EvalCommand(script: '', numberOfKeys: 0);
      expect(command.parse('hello'), 'hello');
    });

    test('should parse int response correctly', () {
      final command = EvalCommand(script: '', numberOfKeys: 0);
      expect(command.parse(123), 123);
    });

    test('should parse list response correctly', () {
      final command = EvalCommand(script: '', numberOfKeys: 0);
      expect(command.parse(['a', 'b']), ['a', 'b']);
    });

    test('should parse null response correctly', () {
      final command = EvalCommand(script: '', numberOfKeys: 0);
      expect(command.parse(null), isNull);
    });
  });
}
