import 'package:dart_valkey/src/codec/valkey_exception.dart';
import 'package:dart_valkey/src/commands/json/json_debug_command.dart';
import 'package:test/test.dart';

void main() {
  group('JsonDebugMemoryCommand', () {
    test('should build the correct commandParts without path', () {
      final command = JsonDebugMemoryCommand('doc:1');
      expect(command.commandParts, ['JSON.DEBUG', 'MEMORY', 'doc:1']);
    });

    test('should build the correct commandParts with path', () {
      final command = JsonDebugMemoryCommand('doc:1', path: r'$.name');
      expect(command.commandParts, [
        'JSON.DEBUG',
        'MEMORY',
        'doc:1',
        r'$.name',
      ]);
    });

    test('should parse responses correctly', () {
      final command = JsonDebugMemoryCommand('doc:1');

      expect(command.parse(128), [128]);
      expect(command.parse('256'), [256]);
      expect(command.parse([100, 200]), [100, 200]);
      expect(command.parse(['100', 'invalid', null]), [100, null, null]);
      expect(command.parse(null), isEmpty);
      expect(command.parse('invalid'), isEmpty);
    });

    test('should apply prefix to key', () {
      final command = JsonDebugMemoryCommand('doc:1', path: r'$.name');
      final prefixed = command.applyPrefix('app:');

      expect(prefixed.commandParts, [
        'JSON.DEBUG',
        'MEMORY',
        'app:doc:1',
        r'$.name',
      ]);
    });
  });

  group('JsonDebugDepthCommand', () {
    test('should build the correct commandParts without path', () {
      final command = JsonDebugDepthCommand('doc:1');
      expect(command.commandParts, ['JSON.DEBUG', 'DEPTH', 'doc:1']);
    });

    test('should build the correct commandParts with path', () {
      final command = JsonDebugDepthCommand('doc:1', path: r'$.items');
      expect(command.commandParts, [
        'JSON.DEBUG',
        'DEPTH',
        'doc:1',
        r'$.items',
      ]);
    });

    test('should parse responses correctly', () {
      final command = JsonDebugDepthCommand('doc:1');

      expect(command.parse(3), [3]);
      expect(command.parse('5'), [5]);
      expect(command.parse([2, 4]), [2, 4]);
      expect(command.parse(['1', 'invalid', null]), [1, null, null]);
      expect(command.parse(null), isEmpty);
      expect(command.parse('invalid'), isEmpty);
    });

    test('should apply prefix to key', () {
      final command = JsonDebugDepthCommand('doc:1', path: r'$.items');
      final prefixed = command.applyPrefix('app:');

      expect(prefixed.commandParts, [
        'JSON.DEBUG',
        'DEPTH',
        'app:doc:1',
        r'$.items',
      ]);
    });
  });

  group('JsonDebugFieldsCommand', () {
    test('should build the correct commandParts without path', () {
      final command = JsonDebugFieldsCommand('doc:1');
      expect(command.commandParts, ['JSON.DEBUG', 'FIELDS', 'doc:1']);
    });

    test('should build the correct commandParts with path', () {
      final command = JsonDebugFieldsCommand('doc:1', path: r'$.user');
      expect(command.commandParts, [
        'JSON.DEBUG',
        'FIELDS',
        'doc:1',
        r'$.user',
      ]);
    });

    test('should parse responses correctly', () {
      final command = JsonDebugFieldsCommand('doc:1');

      expect(command.parse(10), [10]);
      expect(command.parse('8'), [8]);
      expect(command.parse([3, 6]), [3, 6]);
      expect(command.parse(['4', 'invalid', null]), [4, null, null]);
      expect(command.parse(null), isEmpty);
      expect(command.parse('invalid'), isEmpty);
    });

    test('should apply prefix to key', () {
      final command = JsonDebugFieldsCommand('doc:1', path: r'$.user');
      final prefixed = command.applyPrefix('app:');

      expect(prefixed.commandParts, [
        'JSON.DEBUG',
        'FIELDS',
        'app:doc:1',
        r'$.user',
      ]);
    });
  });

  group('JsonDebugHelpCommand', () {
    test('should build the correct commandParts', () {
      final command = JsonDebugHelpCommand();
      expect(command.commandParts, ['JSON.DEBUG', 'HELP']);
    });

    test('should parse list response correctly', () {
      final command = JsonDebugHelpCommand();
      expect(command.parse(['MEMORY <key> [path]', 'HELP']), [
        'MEMORY <key> [path]',
        'HELP',
      ]);
    });

    test('should parse string response correctly', () {
      final command = JsonDebugHelpCommand();
      expect(command.parse('MEMORY <key> [path]\nHELP'), [
        'MEMORY <key> [path]\nHELP',
      ]);
    });

    test('should throw ValkeyException for unexpected response', () {
      final command = JsonDebugHelpCommand();
      expect(() => command.parse(123), throwsA(isA<ValkeyException>()));
    });
  });
}
