import 'package:dart_valkey/dart_valkey.dart';
import 'package:test/test.dart';

class TestUser {
  new({
    required this.id,
    required this.name,
    required this.age,
    required this.roles,
    required this.active,
  });

  new fromJson(dynamic json)
    : id = (json as Map<String, dynamic>)['id'] as String,
      name = json['name'] as String,
      age = json['age'] as int,
      roles = (json['roles'] as List<dynamic>).cast<String>(),
      active = json['active'] as bool;

  final String id;
  final String name;
  final int age;
  final List<String> roles;
  final bool active;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'age': age,
    'roles': roles,
    'active': active,
  };
}

void main() {
  group('JSON Integration Tests', tags: 'integration', () {
    late ValkeyCommandClient client;
    var jsonModuleAvailable = false;

    void jsonTest(String description, Future<void> Function() body) {
      test(description, () async {
        if (!jsonModuleAvailable) {
          markTestSkipped('Valkey server does not have JSON module loaded.');
          return;
        }
        await body();
      });
    }

    setUpAll(() async {
      client = ValkeyCommandClient(
        host: 'localhost',
        port: 6379,
        respDecoder: const Resp3Decoder(),
      );
      try {
        await client.connect();
        // Probe if server has JSON module loaded
        final probeResult = await client.jsonSet('__test:probe__', {'ok': true});
        jsonModuleAvailable = probeResult;
        await client.del(['__test:probe__']);
      } catch (e) {
        jsonModuleAvailable = false;
      }
    });

    tearDownAll(() async {
      if (jsonModuleAvailable) {
        await client.del([
          'test:json:doc1',
          'test:json:doc2',
          'test:json:arr',
          'test:json:store:100',
          'test:json:store:101',
          'test:json:stream',
          'test:json:update',
        ]);
      }
      await client.close();
    });

    test('verifies connection and JSON module support on server', () async {
      final pong = await client.ping();
      expect(pong, isTrue);

      if (!jsonModuleAvailable) {
        // Integration test diagnostic log to notify developers about module status.
        // ignore: avoid_print
        print(
          'ℹ️ Valkey server is running on localhost:6379, but JSON module is not loaded. '
          'To run full JSON integration tests, start server with JSON module enabled.',
        );
      }
    });

    group('Live JSON Operations', () {
      jsonTest('JSON.SET and JSON.GET basic operations', () async {
        const key = 'test:json:doc1';

        // 1. Store JSON document
        final setOk = await client.jsonSet(key, {
          'name': 'Alice',
          'age': 30,
          'roles': ['developer', 'architect'],
          'active': true,
        });
        expect(setOk, isTrue);

        // 2. Query full document
        final doc = await client.jsonGet<Map<String, dynamic>>(key);
        expect(doc, isNotNull);
        expect(doc!['name'], 'Alice');
        expect(doc['age'], 30);

        // 3. Query with typed mapping and Pattern Matching
        final user = await client.jsonGetTyped<(String, int)>(
          key,
          fromJson: (json) => switch (json) {
            {'name': final String name, 'age': final int age} => (name, age),
            _ => throw const FormatException('Unexpected schema'),
          },
        );
        expect(user, isNotNull);
        expect(user!.$1, 'Alice');
        expect(user.$2, 30);

        // 4. Query specific sub-path
        final rawAge = await client.jsonGetRaw(key, paths: [r'$.age']);
        expect(rawAge, '[30]');
      });

      jsonTest('JSON.NUMINCRBY and JSON.NUMMULTBY numeric modifications', () async {
        const key = 'test:json:doc1';

        final incremented = await client.jsonNumIncrBy(key, r'$.age', 5);
        expect(incremented, '[35]');

        final multiplied = await client.jsonNumMultBy(key, r'$.age', 2);
        expect(multiplied, '[70]');
      });

      jsonTest('JSON.TOGGLE boolean modification', () async {
        const key = 'test:json:doc1';

        final toggled = await client.jsonToggle(key, path: r'$.active');
        expect(toggled, [false]);

        final toggledBack = await client.jsonToggle(key, path: r'$.active');
        expect(toggledBack, [true]);
      });

      jsonTest('JSON.STRAPPEND and JSON.STRLEN string operations', () async {
        const key = 'test:json:doc1';

        final newLens = await client.jsonStrAppend(
          key,
          ' Wonderland',
          path: r'$.name',
        );
        expect(newLens.isNotEmpty, isTrue);

        final strLens = await client.jsonStrLen(key, path: r'$.name');
        expect(strLens, [16]);
      });

      jsonTest('JSON array operations: ARRAPPEND, ARRINSERT, ARRLEN, ARRPOP, ARRINDEX, ARRTRIM', () async {
        const key = 'test:json:arr';
        await client.jsonSet(key, [10, 20, 30]);

        // ARRAPPEND
        final appendRes = await client.jsonArrAppend(key, [40, 50]);
        expect(appendRes, [5]);

        // ARRLEN
        final len = await client.jsonArrLen(key);
        expect(len, [5]);

        // ARRINDEX
        final idx = await client.jsonArrIndex(key, r'$', 30);
        expect(idx, [2]);

        // ARRINSERT
        final insertRes = await client.jsonArrInsert(key, r'$', 1, [15]);
        expect(insertRes, [6]);

        // ARRTRIM
        final trimRes = await client.jsonArrTrim(key, r'$', 0, 3);
        expect(trimRes, [4]);

        // ARRPOP
        final popped = await client.jsonArrPop<int>(key);
        expect(popped, [isNotNull]);
      });

      jsonTest('JSON object operations: OBJKEYS and OBJLEN', () async {
        const key = 'test:json:doc1';

        final keys = await client.jsonObjKeys(key);
        expect(keys.isNotEmpty, isTrue);
        expect(keys.first, containsAll(['name', 'age', 'roles', 'active']));

        final objLen = await client.jsonObjLen(key);
        expect(objLen.first, 4);
      });

      jsonTest('JSON.MERGE and JSON.CLEAR', () async {
        const key = 'test:json:doc2';
        await client.jsonSet(key, {'foo': 'bar', 'count': 10});

        final mergeOk = await client.jsonMerge(key, {'status': 'active'});
        expect(mergeOk, isTrue);

        final merged = await client.jsonGet<Map<String, dynamic>>(key);
        expect(merged!['foo'], 'bar');
        expect(merged['status'], 'active');

        final clearCount = await client.jsonClear(key);
        expect(clearCount, 1);
      });

      jsonTest('JSON.MGET multiple key retrieval', () async {
        await client.jsonSet('test:json:doc1', {'name': 'Doc1'});
        await client.jsonSet('test:json:doc2', {'name': 'Doc2'});

        final results = await client.jsonMGet<Map<String, dynamic>>([
          'test:json:doc1',
          'test:json:doc2',
          'test:json:non_existent',
        ]);
        expect(results.length, 3);
        expect(results[0]?['name'], 'Doc1');
        expect(results[1]?['name'], 'Doc2');
        expect(results[2], isNull);
      });

      jsonTest('JSON.DEL and JSON.FORGET', () async {
        const key = 'test:json:doc2';
        final delCount = await client.jsonDel(key);
        expect(delCount, 1);

        final afterDel = await client.jsonGetRaw(key);
        expect(afterDel, isNull);
      });

      jsonTest('ValkeyJsonStore typed repository CRUD and sub-operations', () async {
        final userStore = client.jsonStore<TestUser>(
          prefix: 'test:json:store',
          fromJson: TestUser.fromJson,
          toJson: (u) => u.toJson(),
        );

        final alice = TestUser(
          id: '100',
          name: 'Alice',
          age: 28,
          roles: ['dev'],
          active: true,
        );

        // Save
        final saveOk = await userStore.save('100', alice, ttl: const Duration(seconds: 120));
        expect(saveOk, isTrue);

        // Exists
        expect(await userStore.exists('100'), isTrue);

        // Find
        final found = await userStore.find('100');
        expect(found, isNotNull);
        expect(found!.name, 'Alice');
        expect(found.age, 28);
        expect(found.roles, ['dev']);

        // Find sub-path
        final name = await userStore.findPath<List<dynamic>>('100', JsonPath.root['name']);
        expect(name, ['Alice']);

        // Increment sub-path
        await userStore.increment('100', JsonPath.root['age'], 1);

        // Toggle sub-path
        await userStore.toggle('100', JsonPath.root['active']);

        // Append to array sub-path
        await userStore.appendToArray('100', JsonPath.root['roles'], ['lead']);

        // Verify updated
        final updated = await userStore.find('100');
        expect(updated!.age, 29);
        expect(updated.active, isFalse);
        expect(updated.roles, ['dev', 'lead']);

        // Delete
        final deleteOk = await userStore.delete('100');
        expect(deleteOk, isTrue);
        expect(await userStore.find('100'), isNull);
      });

      jsonTest('jsonUpdate fluent builder execution', () async {
        const key = 'test:json:update';
        await client.jsonSet(key, {
          'counter': 0,
          'tags': <String>[],
          'ready': false,
        });

        await client.jsonUpdate(key, (doc) {
          doc
            ..increment(r'$.counter', 10)
            ..appendToArray(r'$.tags', ['tagA', 'tagB'])
            ..toggle(r'$.ready');
        });

        final doc = await client.jsonGet<Map<String, dynamic>>(key);
        expect(doc!['counter'], 10);
        expect(doc['tags'], ['tagA', 'tagB']);
        expect(doc['ready'], isTrue);
      });

      jsonTest('jsonStreamArray paginated streaming', () async {
        const key = 'test:json:stream';
        final initialItems = List.generate(20, (i) => 'item_$i');
        await client.jsonSet(key, initialItems);

        final streamed = <String>[];
        await for (final item in client.jsonStreamArray<String>(key, chunkSize: 6)) {
          streamed.add(item);
        }

        expect(streamed.length, 20);
        expect(streamed, equals(initialItems));
      });
    });
  });
}
