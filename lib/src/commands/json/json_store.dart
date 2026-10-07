import '../../client/valkey_client.dart';
import '../../extensions/all_commands.dart';
import '../strings/set_command.dart';
import 'json_mset_command.dart';
import 'json_path.dart';
import 'json_types.dart';
import 'json_update.dart';

/// A strongly-typed Repository/Document Store pattern for Valkey/Redis JSON documents of type [T].
///
/// Example:
/// ```dart
/// final userStore = ValkeyJsonStore<User>(
///   client,
///   prefix: 'users',
///   fromJson: User.fromJson,
///   toJson: (u) => u.toJson(),
/// );
///
/// await userStore.save('100', user);
/// final found = await userStore.find('100');
/// ```
final class ValkeyJsonStore<T>(
  final ValkeyCommandClient client, {
  required final String prefix,
  required final T Function(dynamic json) fromJson,
  final Object? Function(T value)? toJson,
  final String Function(String id)? keyBuilder,
  final JsonEncoderFn encoder = defaultJsonEncoder,
  final JsonDecoderFn decoder = defaultJsonDecoder,
}) {
  /// Resolves the full Valkey/Redis key for a given document [id].
  String keyFor(String id) {
    if (keyBuilder case final kb?) {
      return kb(id);
    }
    return '$prefix:$id';
  }

  /// Saves document [item] under [id].
  ///
  /// Optionally accepts [strategy] and an expiration [ttl].
  Future<bool> save(
    String id,
    T item, {
    SetStrategyTypes strategy = SetStrategyTypes.always,
    Duration? ttl,
    Duration? timeout,
  }) async {
    final key = keyFor(id);
    final payload = switch (toJson) {
      final tj? => tj(item),
      _ => item,
    };
    final jsonString = encoder(payload);
    final ok = await client.jsonSetRaw(
      key,
      jsonString,
      strategyType: strategy,
      timeout: timeout,
    );
    if (ok && ttl != null) {
      await client.expire(key, ttl.inSeconds, timeout: timeout);
    }
    return ok;
  }

  /// Saves multiple documents in a single atomic operation using `JSON.MSET`.
  Future<bool> saveMany(Map<String, T> items, {Duration? timeout}) {
    if (items.isEmpty) return Future.value(true);
    final entries = items.entries.map((entry) {
      final key = keyFor(entry.key);
      final payload = switch (toJson) {
        final tj? => tj(entry.value),
        _ => entry.value,
      };
      return JsonMSetEntry(key: key, path: r'$', value: encoder(payload));
    }).toList();
    return client.jsonMSetRaw(entries, timeout: timeout);
  }

  /// Retrieves and deserializes the document stored at [id].
  ///
  /// Returns `null` if the key does not exist.
  Future<T?> find(String id, {Duration? timeout}) async {
    final raw = await client.jsonGetRaw(keyFor(id), timeout: timeout);
    if (raw == null) return null;
    final decoded = decoder(raw);
    return _mapItem(decoded);
  }

  /// Retrieves a specific sub-path from document [id].
  Future<R?> findPath<R>(
    String id,
    Object path, {
    R Function(dynamic json)? mapper,
    Duration? timeout,
  }) async {
    final raw = await client.jsonGetRaw(
      keyFor(id),
      paths: [resolveJsonPath(path)],
      timeout: timeout,
    );
    if (raw == null) return null;
    final decoded = decoder(raw);
    if (mapper case final m?) return m(decoded);
    if (decoded is R) return decoded;
    return decoded as R?;
  }

  /// Retrieves multiple documents by their [ids].
  Future<List<T?>> findMany(List<String> ids, {Duration? timeout}) async {
    if (ids.isEmpty) return const [];
    final keys = ids.map(keyFor).toList();
    final rawList = await client.jsonMGetRaw(keys, timeout: timeout);
    return rawList.map((raw) {
      if (raw == null) return null;
      final decoded = decoder(raw);
      if (decoded is List && decoded.isNotEmpty) {
        return fromJson(decoded.first);
      }
      return fromJson(decoded);
    }).toList();
  }

  /// Deletes the document or sub-path at [id].
  Future<bool> delete(String id, {Object? path, Duration? timeout}) async {
    final count = await client.jsonDel(
      keyFor(id),
      path: path != null ? resolveJsonPath(path) : null,
      timeout: timeout,
    );
    return count > 0;
  }

  /// Checks if document [id] exists.
  Future<bool> exists(String id, {Duration? timeout}) async {
    final count = await client.exists([keyFor(id)], timeout: timeout);
    return count > 0;
  }

  /// Increments the numeric value at [path] in document [id].
  Future<String?> increment(
    String id,
    Object path,
    num value, {
    Duration? timeout,
  }) => client.jsonNumIncrBy(
    keyFor(id),
    resolveJsonPath(path),
    value,
    timeout: timeout,
  );

  /// Multiplies the numeric value at [path] in document [id].
  Future<String?> multiply(
    String id,
    Object path,
    num value, {
    Duration? timeout,
  }) => client.jsonNumMultBy(
    keyFor(id),
    resolveJsonPath(path),
    value,
    timeout: timeout,
  );

  /// Toggles a boolean value at [path] in document [id].
  Future<List<bool?>> toggle(String id, Object path, {Duration? timeout}) =>
      client.jsonToggle(
        keyFor(id),
        path: resolveJsonPath(path),
        timeout: timeout,
      );

  /// Merges [value] into document [id] at [path] (defaults to root).
  Future<bool> merge(
    String id,
    Object value, {
    Object path = JsonPath.root,
    Duration? timeout,
  }) => client.jsonMerge(
    keyFor(id),
    value,
    path: resolveJsonPath(path),
    encoder: encoder,
    timeout: timeout,
  );

  /// Appends [values] to the array at [path] in document [id].
  Future<List<int?>> appendToArray(
    String id,
    Object path,
    List<Object?> values, {
    Duration? timeout,
  }) => client.jsonArrAppend(
    keyFor(id),
    values,
    path: resolveJsonPath(path),
    encoder: encoder,
    timeout: timeout,
  );

  /// Clears container values (arrays/objects) or sets numeric values to 0 at [path].
  Future<int> clear(
    String id, {
    Object path = JsonPath.root,
    Duration? timeout,
  }) => client.jsonClear(
    keyFor(id),
    path: resolveJsonPath(path),
    timeout: timeout,
  );

  /// Performs multiple updates on document [id] using a fluent builder.
  Future<List<dynamic>> update(
    String id,
    void Function(JsonUpdateBuilder updater) builder, {
    Duration? timeout,
  }) {
    final updater = JsonUpdateBuilder(keyFor(id), encoder: encoder);
    builder(updater);
    return updater.executeOn(client, timeout: timeout);
  }

  /// Performs updates on document [id] and returns the refreshed document.
  Future<T?> updateAndGet(
    String id,
    void Function(JsonUpdateBuilder updater) builder, {
    Duration? timeout,
  }) => update(
    id,
    builder,
    timeout: timeout,
  ).then((_) => find(id, timeout: timeout));

  /// Sets TTL expiration on document [id].
  Future<bool> setTtl(String id, Duration ttl, {Duration? timeout}) =>
      client.expire(keyFor(id), ttl.inSeconds, timeout: timeout);

  /// Gets TTL expiration on document [id].
  Future<int> getTtl(String id, {Duration? timeout}) =>
      client.ttl(keyFor(id), timeout: timeout);

  T _mapItem(dynamic decoded) {
    if (decoded is List &&
        decoded.isNotEmpty &&
        T != dynamic &&
        T != Object &&
        !T.toString().startsWith('List')) {
      return fromJson(decoded.first);
    }
    return fromJson(decoded);
  }
}
