import 'package:dart_valkey/src/commands/json/json_types.dart';
import 'package:test/test.dart';

void main() {
  group('JsonTypes', () {
    test('defaultJsonEncoder encodes Dart map to JSON string', () {
      final jsonStr = defaultJsonEncoder({'name': 'Alice', 'age': 30});
      expect(jsonStr, '{"name":"Alice","age":30}');
    });

    test('defaultJsonDecoder decodes JSON string to Dart map/list', () {
      final decoded = defaultJsonDecoder('{"name":"Alice","age":30}');
      expect(decoded, {'name': 'Alice', 'age': 30});
    });
  });
}
