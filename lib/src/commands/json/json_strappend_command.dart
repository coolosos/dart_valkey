import 'package:meta/meta.dart';

import '../command.dart';

@immutable
final class JsonStrAppendCommand(
  final String key,
  final String value, {
  final String? path,
}) extends ValkeyCommand<List<int?>> with KeyedCommand<List<int?>> {
  @override
  List<String> get commandParts => ['JSON.STRAPPEND', key, ?path, value];

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
  JsonStrAppendCommand applyPrefix(String prefix) =>
      JsonStrAppendCommand('$prefix$key', value, path: path);
}
