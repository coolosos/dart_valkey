import 'package:meta/meta.dart';

import '../command.dart';

/// Represents an item entry for [JsonMSetCommand].
@immutable
final class JsonMSetEntry {
  const new({required this.key, required this.path, required this.value});

  /// The document key.
  final String key;

  /// The JSONPath (e.g. `$` or `$.field`).
  final String path;

  /// The serialized JSON string value.
  final String value;

  /// Creates a copy with [prefix] prepended to [key].
  JsonMSetEntry applyPrefix(String prefix) =>
      JsonMSetEntry(key: '$prefix$key', path: path, value: value);
}

/// Represents the `JSON.MSET key path value [key path value ...]` command.
///
/// Sets or updates the JSON value at specified paths across multiple keys atomically.
@immutable
final class JsonMSetCommand(final List<JsonMSetEntry> entries)
    extends ValkeyCommand<bool>
    with KeyedCommand<bool> {
  @override
  List<String> get commandParts {
    final parts = <String>['JSON.MSET'];
    for (final entry in entries) {
      parts
        ..add(entry.key)
        ..add(entry.path)
        ..add(entry.value);
    }
    return parts;
  }

  @override
  bool parse(dynamic data) => data == 'OK';

  @override
  JsonMSetCommand applyPrefix(String prefix) =>
      JsonMSetCommand(entries.map((e) => e.applyPrefix(prefix)).toList());
}
