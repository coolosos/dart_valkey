import 'package:meta/meta.dart';

import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the `JSON.DEBUG MEMORY key [path]` command.
///
/// Reports the memory usage in bytes of a JSON element.
@immutable
final class JsonDebugMemoryCommand(final String key, {final String? path})
    extends ValkeyCommand<List<int?>>
    with KeyedCommand<List<int?>> {
  @override
  List<String> get commandParts => ['JSON.DEBUG', 'MEMORY', key, ?path];

  @override
  List<int?> parse(dynamic data) {
    if (data is List) {
      return data.map((e) {
        if (e is int) return e;
        if (e is String) return int.tryParse(e);
        return null;
      }).toList();
    }
    if (data is int) return [data];
    if (data is String) {
      final val = int.tryParse(data);
      return val != null ? [val] : const [];
    }
    return const [];
  }

  @override
  JsonDebugMemoryCommand applyPrefix(String prefix) =>
      JsonDebugMemoryCommand('$prefix$key', path: path);
}

/// Represents the `JSON.DEBUG DEPTH key [path]` command.
///
/// Reports the nesting depth of a JSON element.
@immutable
final class JsonDebugDepthCommand(final String key, {final String? path})
    extends ValkeyCommand<List<int?>>
    with KeyedCommand<List<int?>> {
  @override
  List<String> get commandParts => ['JSON.DEBUG', 'DEPTH', key, ?path];

  @override
  List<int?> parse(dynamic data) {
    if (data is List) {
      return data.map((e) {
        if (e is int) return e;
        if (e is String) return int.tryParse(e);
        return null;
      }).toList();
    }
    if (data is int) return [data];
    if (data is String) {
      final val = int.tryParse(data);
      return val != null ? [val] : const [];
    }
    return const [];
  }

  @override
  JsonDebugDepthCommand applyPrefix(String prefix) =>
      JsonDebugDepthCommand('$prefix$key', path: path);
}

/// Represents the `JSON.DEBUG FIELDS key [path]` command.
///
/// Reports the number of fields in a JSON element.
@immutable
final class JsonDebugFieldsCommand(final String key, {final String? path})
    extends ValkeyCommand<List<int?>>
    with KeyedCommand<List<int?>> {
  @override
  List<String> get commandParts => ['JSON.DEBUG', 'FIELDS', key, ?path];

  @override
  List<int?> parse(dynamic data) {
    if (data is List) {
      return data.map((e) {
        if (e is int) return e;
        if (e is String) return int.tryParse(e);
        return null;
      }).toList();
    }
    if (data is int) return [data];
    if (data is String) {
      final val = int.tryParse(data);
      return val != null ? [val] : const [];
    }
    return const [];
  }

  @override
  JsonDebugFieldsCommand applyPrefix(String prefix) =>
      JsonDebugFieldsCommand('$prefix$key', path: path);
}

/// Represents the `JSON.DEBUG HELP` command.
///
/// Returns helpful documentation for JSON.DEBUG subcommands.
@immutable
final class JsonDebugHelpCommand extends ValkeyCommand<List<String>> {
  @override
  List<String> get commandParts => const ['JSON.DEBUG', 'HELP'];

  @override
  List<String> parse(dynamic data) {
    if (data is List) {
      return data.cast<String>();
    }
    if (data is String) {
      return [data];
    }
    throw ValkeyException(
      'Invalid response for JSON.DEBUG HELP: expected a list of strings, got ${data.runtimeType}',
    );
  }
}
