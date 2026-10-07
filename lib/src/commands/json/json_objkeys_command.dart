import 'package:meta/meta.dart';

import '../command.dart';

@immutable
final class JsonObjKeysCommand(final String key, {final String? path = r'$'})
    extends ValkeyCommand<List<List<String>?>>
    with KeyedCommand<List<List<String>?>> {
  @override
  List<String> get commandParts => ['JSON.OBJKEYS', key, ?path];

  @override
  List<List<String>?> parse(dynamic data) {
    if (data is List) {
      if (data.isNotEmpty && data.every((e) => e is String)) {
        return [data.map((e) => e.toString()).toList()];
      }
      return data.map((e) {
        if (e is List) {
          return e.map((k) => k.toString()).toList();
        }
        return null;
      }).toList();
    }
    return const [];
  }

  @override
  JsonObjKeysCommand applyPrefix(String prefix) =>
      JsonObjKeysCommand('$prefix$key', path: path);
}
