import 'package:dart_valkey/src/commands/json/json_merge_command.dart';
import 'package:test/test.dart';

void main() {
  group('JsonMergeCommand', () {
    test('should build the correct command', () {
      final command = JsonMergeCommand('doc:1', r'$.user', '{"age":31}');
      expect(command.commandParts, [
        'JSON.MERGE',
        'doc:1',
        r'$.user',
        '{"age":31}',
      ]);
    });

    test('should parse OK response correctly', () {
      final command = JsonMergeCommand('doc:1', r'$', '{"age":31}');
      expect(command.parse('OK'), isTrue);
      expect(command.parse(null), isFalse);
      expect(command.parse('ERR'), isFalse);
    });

    test('should apply prefix to key', () {
      final command = JsonMergeCommand('doc:1', r'$.user', '{"age":31}');
      final prefixed = command.applyPrefix('prefix:');
      expect(prefixed.commandParts, [
        'JSON.MERGE',
        'prefix:doc:1',
        r'$.user',
        '{"age":31}',
      ]);
    });
  });
}
