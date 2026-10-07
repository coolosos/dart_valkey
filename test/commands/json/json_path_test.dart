import 'package:dart_valkey/src/commands/json/json_path.dart';
import 'package:test/test.dart';

void main() {
  group('JsonPath Builder', () {
    test('root path and constructors', () {
      expect(JsonPath.root.value, r'$');
      expect(JsonPath.root.path, r'$');
      expect(JsonPath.root.value, r'$');
      expect(const JsonPath(r'$.custom').value, r'$.custom');
      expect(JsonPath.root.toString(), r'$');
    });

    test('operator [] with int index', () {
      final path = JsonPath.root[0];
      expect(path.value, r'$[0]');
      expect(path[1].value, r'$[0][1]');
    });

    test('operator [] with String field', () {
      final path = JsonPath.root['user']['profile'];
      expect(path.value, r'$.user.profile');

      final withDot = JsonPath.root['.user'];
      expect(withDot.value, r'$.user');

      final withBrackets = JsonPath.root['[0]'];
      expect(withBrackets.value, r'$[0]');
    });

    test('operator [] with JsonPath', () {
      const sub = JsonPath(r'$.items[0]');
      final path = JsonPath.root['store'][sub];
      expect(path.value, r'$.store.items[0]');
    });

    test('operator [] with invalid type throws ArgumentError', () {
      expect(() => JsonPath.root[3.14], throwsArgumentError);
    });

    test('field() chaining', () {
      expect(JsonPath.root.field('name').value, r'$.name');
      expect(JsonPath.root.field('.name').value, r'$.name');
      expect(JsonPath.root.field('[0]').value, r'$[0]');
    });

    test('index()', () {
      expect(JsonPath.root.field('items').index(5).value, r'$.items[5]');
    });

    test('all() wildcard', () {
      expect(JsonPath.root.field('items').all().value, r'$.items[*]');
    });

    test('recursive() descent', () {
      expect(JsonPath.root.recursive('name').value, r'$..name');
      expect(JsonPath.root.recursive('..name').value, r'$..name');
    });

    test('slice() with variations', () {
      expect(
        JsonPath.root.field('arr').slice(start: 0, end: 5).value,
        r'$.arr[0:5]',
      );
      expect(
        JsonPath.root.field('arr').slice(start: 1, end: 10, step: 2).value,
        r'$.arr[1:10:2]',
      );
      expect(JsonPath.root.field('arr').slice(end: 3).value, r'$.arr[:3]');
      expect(JsonPath.root.field('arr').slice(start: 2).value, r'$.arr[2:]');
      expect(JsonPath.root.field('arr').slice().value, r'$.arr[:]');
    });

    test('filter() with various formats', () {
      expect(
        JsonPath.root.field('users').filter('@.age > 18').value,
        r'$.users[?(@.age > 18)]',
      );
      expect(
        JsonPath.root.field('users').filter('?(@.age > 18)').value,
        r'$.users[?(@.age > 18)]',
      );
      expect(
        JsonPath.root.field('users').filter('[?(@.age > 18)]').value,
        r'$.users[?(@.age > 18)]',
      );
    });

    test('append() with various formats', () {
      expect(JsonPath.root.append('.foo').value, r'$.foo');
      expect(JsonPath.root.append('[0]').value, r'$[0]');
      expect(JsonPath.root.append(r'$').value, r'$');
      expect(JsonPath.root.append(r'$.bar').value, r'$.bar');
      expect(JsonPath.root.append(r'$[1]').value, r'$[1]');
      expect(JsonPath.root.append(r'$bar').value, r'$.bar');
      expect(JsonPath.root.append('baz').value, r'$.baz');
    });

    test('equality and hashCode', () {
      const p1 = JsonPath(r'$.user.name');
      const p2 = JsonPath(r'$.user.name');
      const p3 = JsonPath(r'$.user.age');

      expect(p1, equals(p2));
      expect(p1.hashCode, equals(p2.hashCode));
      expect(p1, isNot(equals(p3)));
      expect(p1 == Object(), isFalse);
    });

    test('resolveJsonPath helper', () {
      expect(resolveJsonPath(const JsonPath(r'$.name')), r'$.name');
      expect(resolveJsonPath(r'$.age'), r'$.age');
      expect(resolveJsonPath(123), '123');
    });
  });
}
