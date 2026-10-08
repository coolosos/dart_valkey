import '../../client/valkey_client.dart';
import '../command.dart';
import '../strings/set_command.dart';
import 'json_arrappend_command.dart';
import 'json_arrinsert_command.dart';
import 'json_arrtrim_command.dart';
import 'json_clear_command.dart';
import 'json_del_command.dart';
import 'json_merge_command.dart';
import 'json_numincrby_command.dart';
import 'json_nummultby_command.dart';
import 'json_path.dart';
import 'json_set_command.dart';
import 'json_strappend_command.dart';
import 'json_toggle_command.dart';
import 'json_types.dart';

/// A fluent builder for chaining and applying multiple atomic JSON mutations to a document at [key].
///
/// Example:
/// ```dart
/// await client.jsonUpdate('user:100', (doc) {
///   doc
///     ..increment('$.loginCount', 1)
///     ..appendToArray('$.roles', ['admin'])
///     ..toggle('$.verified');
/// });
/// ```
final class JsonUpdateBuilder {
  /// Creates a [JsonUpdateBuilder] targeting [key].
  new(this.key, {this.encoder = defaultJsonEncoder});

  /// The Valkey/Redis key being modified.
  final String key;

  /// The JSON encoder function used to serialize values.
  final JsonEncoderFn encoder;

  final List<ValkeyCommand<dynamic>> _commands = [];

  /// The unmodifiable list of queued commands.
  List<ValkeyCommand<dynamic>> get commands => List.unmodifiable(_commands);

  /// The number of queued mutation commands.
  int get length => _commands.length;

  /// Whether no commands have been queued.
  bool get isEmpty => _commands.isEmpty;

  /// Whether at least one command has been queued.
  bool get isNotEmpty => _commands.isNotEmpty;

  /// Sets the JSON value at [path].
  void set(
    Object path,
    Object? value, {
    SetStrategyTypes strategyType = SetStrategyTypes.always,
  }) {
    _commands.add(
      JsonSetCommand(
        key,
        resolveJsonPath(path),
        encoder(value),
        strategyType: strategyType,
      ),
    );
  }

  /// Sets a raw pre-encoded JSON string at [path].
  void setRaw(
    Object path,
    String rawJson, {
    SetStrategyTypes strategyType = SetStrategyTypes.always,
  }) {
    _commands.add(
      JsonSetCommand(
        key,
        resolveJsonPath(path),
        rawJson,
        strategyType: strategyType,
      ),
    );
  }

  /// Deletes the value at [path] (or the entire document if omitted).
  void delete([Object? path]) {
    _commands.add(
      JsonDelCommand(key, path: path != null ? resolveJsonPath(path) : null),
    );
  }

  /// Increments the numeric value at [path] by [value].
  void increment(Object path, num value) {
    _commands.add(JsonNumIncrByCommand(key, resolveJsonPath(path), value));
  }

  /// Multiplies the numeric value at [path] by [value].
  void multiply(Object path, num value) {
    _commands.add(JsonNumMultByCommand(key, resolveJsonPath(path), value));
  }

  /// Toggles a boolean value at [path].
  void toggle([Object path = JsonPath.root]) {
    _commands.add(JsonToggleCommand(key, path: resolveJsonPath(path)));
  }

  /// Merges [value] into the JSON document at [path] (defaults to root).
  void merge(Object value, {Object path = JsonPath.root}) {
    _commands.add(JsonMergeCommand(key, resolveJsonPath(path), encoder(value)));
  }

  /// Appends [value] to the string at [path].
  void appendToString(Object path, String value) {
    _commands.add(
      JsonStrAppendCommand(key, encoder(value), path: resolveJsonPath(path)),
    );
  }

  /// Appends [values] to the array at [path].
  void appendToArray(Object path, List<Object?> values) {
    _commands.add(
      JsonArrAppendCommand(
        key,
        values.map(encoder).toList(),
        path: resolveJsonPath(path),
      ),
    );
  }

  /// Inserts [values] into the array at [path] at [index].
  void insertIntoArray(Object path, int index, List<Object?> values) {
    _commands.add(
      JsonArrInsertCommand(
        key,
        resolveJsonPath(path),
        index,
        values.map(encoder).toList(),
      ),
    );
  }

  /// Trims the array at [path] to between [start] and [stop] indices.
  void trimArray(Object path, int start, int stop) {
    _commands.add(JsonArrTrimCommand(key, resolveJsonPath(path), start, stop));
  }

  /// Clears container values (arrays/objects) or sets numeric values to 0 at [path].
  void clear([Object path = JsonPath.root]) {
    _commands.add(JsonClearCommand(key, path: resolveJsonPath(path)));
  }

  /// Executes all queued commands sequentially on [client].
  Future<List<dynamic>> executeOn(
    ValkeyCommandClient client, {
    Duration? timeout,
  }) async {
    final results = <dynamic>[];
    for (final command in _commands) {
      final result = await client.execute(command, timeout: timeout);
      results.add(result);
    }
    return results;
  }
}
