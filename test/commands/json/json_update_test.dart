import 'package:dart_valkey/src/commands/json/json.dart';
import 'package:dart_valkey/src/commands/strings/set_command.dart';
import 'package:test/test.dart';

import '../../extensions/all_commands_test.dart';

void main() {
  group('JsonUpdateBuilder', () {
    test('initial state and properties', () {
      final builder = JsonUpdateBuilder('user:1');
      expect(builder.key, 'user:1');
      expect(builder.isEmpty, isTrue);
      expect(builder.isNotEmpty, isFalse);
      expect(builder.length, 0);
      expect(builder.commands, isEmpty);
    });

    test('queues all JSON update operations', () {
      final builder = JsonUpdateBuilder('user:1')
        ..set(r'$.name', 'Alice', strategyType: SetStrategyTypes.onlyIfExists)
        ..setRaw(r'$.meta', '{"version":1}')
        ..delete(r'$.oldField')
        ..delete()
        ..increment(r'$.age', 1)
        ..multiply(r'$.score', 2)
        ..toggle(r'$.isActive')
        ..toggle()
        ..merge({'city': 'Madrid'}, path: r'$.address')
        ..appendToString(r'$.bio', ' Developer')
        ..appendToArray(r'$.roles', ['admin', 'editor'])
        ..insertIntoArray(r'$.roles', 0, ['super'])
        ..trimArray(r'$.roles', 0, 2)
        ..clear(r'$.cache')
        ..clear();

      expect(builder.isEmpty, isFalse);
      expect(builder.isNotEmpty, isTrue);
      expect(builder.length, 15);

      final cmds = builder.commands;
      expect(cmds[0], isA<JsonSetCommand>());
      expect((cmds[0] as JsonSetCommand).commandParts, [
        'JSON.SET',
        'user:1',
        r'$.name',
        '"Alice"',
        'XX',
      ]);

      expect(cmds[1], isA<JsonSetCommand>());
      expect((cmds[1] as JsonSetCommand).commandParts, [
        'JSON.SET',
        'user:1',
        r'$.meta',
        '{"version":1}',
      ]);

      expect(cmds[2], isA<JsonDelCommand>());
      expect((cmds[2] as JsonDelCommand).commandParts, [
        'JSON.DEL',
        'user:1',
        r'$.oldField',
      ]);

      expect(cmds[3], isA<JsonDelCommand>());
      expect((cmds[3] as JsonDelCommand).commandParts, ['JSON.DEL', 'user:1']);

      expect(cmds[4], isA<JsonNumIncrByCommand>());
      expect((cmds[4] as JsonNumIncrByCommand).commandParts, [
        'JSON.NUMINCRBY',
        'user:1',
        r'$.age',
        '1',
      ]);

      expect(cmds[5], isA<JsonNumMultByCommand>());
      expect((cmds[5] as JsonNumMultByCommand).commandParts, [
        'JSON.NUMMULTBY',
        'user:1',
        r'$.score',
        '2',
      ]);

      expect(cmds[6], isA<JsonToggleCommand>());
      expect((cmds[6] as JsonToggleCommand).commandParts, [
        'JSON.TOGGLE',
        'user:1',
        r'$.isActive',
      ]);

      expect(cmds[7], isA<JsonToggleCommand>());
      expect((cmds[7] as JsonToggleCommand).commandParts, [
        'JSON.TOGGLE',
        'user:1',
        r'$',
      ]);

      expect(cmds[8], isA<JsonMergeCommand>());
      expect((cmds[8] as JsonMergeCommand).commandParts, [
        'JSON.MERGE',
        'user:1',
        r'$.address',
        '{"city":"Madrid"}',
      ]);

      expect(cmds[9], isA<JsonStrAppendCommand>());
      expect((cmds[9] as JsonStrAppendCommand).commandParts, [
        'JSON.STRAPPEND',
        'user:1',
        r'$.bio',
        '" Developer"',
      ]);

      expect(cmds[10], isA<JsonArrAppendCommand>());
      expect((cmds[10] as JsonArrAppendCommand).commandParts, [
        'JSON.ARRAPPEND',
        'user:1',
        r'$.roles',
        '"admin"',
        '"editor"',
      ]);

      expect(cmds[11], isA<JsonArrInsertCommand>());
      expect((cmds[11] as JsonArrInsertCommand).commandParts, [
        'JSON.ARRINSERT',
        'user:1',
        r'$.roles',
        '0',
        '"super"',
      ]);

      expect(cmds[12], isA<JsonArrTrimCommand>());
      expect((cmds[12] as JsonArrTrimCommand).commandParts, [
        'JSON.ARRTRIM',
        'user:1',
        r'$.roles',
        '0',
        '2',
      ]);

      expect(cmds[13], isA<JsonClearCommand>());
      expect((cmds[13] as JsonClearCommand).commandParts, [
        'JSON.CLEAR',
        'user:1',
        r'$.cache',
      ]);

      expect(cmds[14], isA<JsonClearCommand>());
      expect((cmds[14] as JsonClearCommand).commandParts, [
        'JSON.CLEAR',
        'user:1',
        r'$',
      ]);
    });

    test('executeOn runs all queued commands sequentially', () async {
      final mockClient = MockValkeyCommandClient()..mockResponse = 'OK';

      final builder = JsonUpdateBuilder('user:1')
        ..set(r'$.name', 'Alice')
        ..increment(r'$.age', 1);

      final results = await builder.executeOn(mockClient);

      expect(results.length, 2);
    });
  });
}
