import 'package:dart_valkey/src/commands/command.dart';
import 'package:dart_valkey/src/commands/json/json.dart';
import 'package:dart_valkey/src/commands/key/ttl_command.dart';
import 'package:dart_valkey/src/commands/strings/expire_command.dart';
import 'package:test/test.dart';

import '../../extensions/all_commands_test.dart';

class User {
  new({required this.id, required this.name, required this.age});

  new fromJson(dynamic json)
    : id = (json as Map<String, dynamic>)['id'] as String,
      name = json['name'] as String,
      age = json['age'] as int;

  final String id;
  final String name;
  final int age;

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'age': age};
}

class StoreMockClient extends MockValkeyCommandClient {
  @override
  Future<T> execute<T>(ValkeyCommand<T> command, {Duration? timeout}) async {
    lastExecutedCommand = command;
    if (command is ExpireCommand) {
      return command.parse(1);
    }
    return command.parse(mockResponse);
  }
}

void main() {
  group('ValkeyJsonStore', () {
    late StoreMockClient mockClient;
    late ValkeyJsonStore<User> store;

    setUp(() {
      mockClient = StoreMockClient();
      store = ValkeyJsonStore<User>(
        mockClient,
        prefix: 'users',
        fromJson: User.fromJson,
        toJson: (u) => u.toJson(),
      );
    });

    test('keyFor with default and custom keyBuilder', () {
      expect(store.keyFor('100'), 'users:100');

      final customStore = ValkeyJsonStore<User>(
        mockClient,
        prefix: 'users',
        keyBuilder: (id) => 'usr_$id',
        fromJson: User.fromJson,
      );
      expect(customStore.keyFor('100'), 'usr_100');
    });

    test('save saves document and optional TTL', () async {
      mockClient.mockResponse = 'OK';
      final user = User(id: '1', name: 'Alice', age: 30);

      final ok = await store.save('1', user, ttl: const Duration(seconds: 60));
      expect(ok, isTrue);
      expect(mockClient.lastExecutedCommand, isA<ExpireCommand>());

      final noTtlOk = await store.save('1', user);
      expect(noTtlOk, isTrue);
      expect(mockClient.lastExecutedCommand, isA<JsonSetCommand>());
    });

    test('save without toJson uses item directly', () async {
      mockClient.mockResponse = 'OK';
      final mapStore = ValkeyJsonStore<Map<String, dynamic>>(
        mockClient,
        prefix: 'maps',
        fromJson: (j) => j as Map<String, dynamic>,
      );

      final ok = await mapStore.save('1', {'key': 'value'});
      expect(ok, isTrue);
      final cmd = mockClient.lastExecutedCommand! as JsonSetCommand;
      expect(cmd.value, '{"key":"value"}');
    });

    test('find returns document or null', () async {
      mockClient.mockResponse = '{"id":"1","name":"Alice","age":30}';
      final user = await store.find('1');
      expect(user, isNotNull);
      expect(user!.name, 'Alice');
      expect(user.age, 30);

      // JSONPath v2 array wrapped response
      mockClient.mockResponse = '[{"id":"1","name":"Alice","age":30}]';
      final userWrapped = await store.find('1');
      expect(userWrapped, isNotNull);
      expect(userWrapped!.name, 'Alice');

      mockClient.mockResponse = null;
      final notFound = await store.find('999');
      expect(notFound, isNull);
    });

    test('findPath retrieves sub-path with optional mapper', () async {
      mockClient.mockResponse = '["Alice"]';
      final name = await store.findPath<List<dynamic>>('1', r'$.name');
      expect(name, ['Alice']);

      mockClient.mockResponse = '30';
      final age = await store.findPath<int>(
        '1',
        r'$.age',
        mapper: (j) => (j as num).toInt(),
      );
      expect(age, 30);

      mockClient.mockResponse = null;
      final notFound = await store.findPath<String>('1', r'$.missing');
      expect(notFound, isNull);
    });

    test('findMany retrieves multiple documents', () async {
      expect(await store.findMany([]), isEmpty);

      mockClient.mockResponse = [
        '{"id":"1","name":"Alice","age":30}',
        '[{"id":"2","name":"Bob","age":25}]',
        null,
      ];

      final users = await store.findMany(['1', '2', '3']);
      expect(users.length, 3);
      expect(users[0]?.name, 'Alice');
      expect(users[1]?.name, 'Bob');
      expect(users[2], isNull);
    });

    test('delete removes document or sub-path', () async {
      mockClient.mockResponse = 1;
      expect(await store.delete('1'), isTrue);

      mockClient.mockResponse = 0;
      expect(await store.delete('1', path: r'$.extra'), isFalse);
    });

    test('exists checks document presence', () async {
      mockClient.mockResponse = 1;
      expect(await store.exists('1'), isTrue);

      mockClient.mockResponse = 0;
      expect(await store.exists('2'), isFalse);
    });

    test('increment, multiply, toggle, merge, appendToArray, clear', () async {
      mockClient.mockResponse = '31';
      expect(await store.increment('1', r'$.age', 1), '31');

      mockClient.mockResponse = '62';
      expect(await store.multiply('1', r'$.age', 2), '62');

      mockClient.mockResponse = [true];
      expect(await store.toggle('1', r'$.isActive'), [true]);

      mockClient.mockResponse = 'OK';
      expect(await store.merge('1', {'status': 'active'}), isTrue);

      mockClient.mockResponse = [2];
      expect(await store.appendToArray('1', r'$.tags', ['vip']), [2]);

      mockClient.mockResponse = 1;
      expect(await store.clear('1'), 1);
    });

    test('update and updateAndGet', () async {
      mockClient.mockResponse = 'OK';
      final results = await store.update('1', (u) {
        u
          ..increment(r'$.age', 1)
          ..toggle(r'$.verified');
      });
      expect(results.length, 2);

      mockClient.mockResponse = '{"id":"1","name":"Alice","age":31}';
      final updated = await store.updateAndGet('1', (u) {
        u.increment(r'$.age', 1);
      });
      expect(updated, isNotNull);
      expect(updated!.age, 31);
    });

    test('setTtl and getTtl', () async {
      mockClient.mockResponse = 1;
      expect(await store.setTtl('1', const Duration(seconds: 300)), isTrue);

      mockClient.mockResponse = 300;
      expect(await store.getTtl('1'), 300);
      expect(mockClient.lastExecutedCommand, isA<TtlCommand>());
    });
  });
}
