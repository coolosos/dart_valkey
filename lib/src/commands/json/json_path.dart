import 'package:meta/meta.dart';

/// Helper to extract string path from either a [String], a [JsonPath], or any [Object].
String resolveJsonPath(Object path) {
  if (path is JsonPath) return path.value;
  if (path is String) return path;
  return path.toString();
}

/// A type-safe, fluent builder for JSONPath expressions used in Valkey / Redis JSON commands.
///
/// Example:
/// ```dart
/// final path = JsonPath.root['user']['profile']['address'][0];
/// print(path); // $.user.profile.address[0]
///
/// final filtered = JsonPath.root['items'].filter('@.price < 50');
/// print(filtered); // $.items[?(@.price < 50)]
/// ```
@immutable
final class JsonPath {
  /// Creates a [JsonPath] with the given raw [value].
  ///
  /// Defaults to root `$` (`r'$'`).
  const new([this.value = r'$']);

  /// Represents the root document path `$` (`r'$'`).
  static const JsonPath root = JsonPath();

  /// The raw JSONPath string.
  final String value;

  /// Alias for [value].
  String get path => value;

  /// Accesses a sub-property or array element.
  ///
  /// If [key] is [int], accesses array index (e.g. `[0]`).
  /// If [key] is [String], accesses property (e.g. `.field`).
  /// If [key] is [JsonPath], appends the path.
  JsonPath operator [](Object key) {
    if (key is int) {
      return index(key);
    }
    if (key is String) {
      return field(key);
    }
    if (key is JsonPath) {
      return append(key.value);
    }
    throw ArgumentError.value(key, 'key', 'Must be int, String, or JsonPath');
  }

  /// Appends a field access (`.name` or `name`) to the path.
  JsonPath field(String name) {
    if (name.startsWith('.') || name.startsWith('[')) {
      return JsonPath('$value$name');
    }
    return JsonPath('$value.$name');
  }

  /// Appends an array index (`[index]`) to the path.
  JsonPath index(int idx) => JsonPath('$value[$idx]');

  /// Appends a wildcard element (`[*]`) to the path.
  JsonPath all() => JsonPath('$value[*]');

  /// Appends recursive descent (`..name`) to the path.
  JsonPath recursive(String name) {
    final clean = name.startsWith('..') ? name.substring(2) : name;
    return JsonPath('$value..$clean');
  }

  /// Appends an array slice (`[start:end:step]`) to the path.
  JsonPath slice({int? start, int? end, int? step}) {
    final s = start?.toString() ?? '';
    final e = end?.toString() ?? '';
    final st = step != null ? ':$step' : '';
    return JsonPath('$value[$s:$e$st]');
  }

  /// Appends a filter expression (`[?(expression)]`) to the path.
  JsonPath filter(String expression) {
    final expr = expression.trim();
    if (expr.startsWith('[?') && expr.endsWith(']')) {
      return JsonPath('$value$expr');
    }
    if (expr.startsWith('?(') && expr.endsWith(')')) {
      return JsonPath('$value[$expr]');
    }
    return JsonPath('$value[?($expr)]');
  }

  /// Appends a raw sub-path to the current path.
  JsonPath append(String subPath) {
    if (subPath.startsWith('.') || subPath.startsWith('[')) {
      return JsonPath('$value$subPath');
    }
    if (subPath.startsWith(r'$')) {
      final stripped = subPath.substring(1);
      if (stripped.isEmpty) return this;
      if (stripped.startsWith('.') || stripped.startsWith('[')) {
        return JsonPath('$value$stripped');
      }
      return JsonPath('$value.$stripped');
    }
    return JsonPath('$value.$subPath');
  }

  @override
  String toString() => value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is JsonPath && other.value == value);

  @override
  int get hashCode => value.hashCode;
}
