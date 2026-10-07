import 'package:meta/meta.dart';

import '../command.dart';

@immutable
final class JsonObjLenCommand(final String key, {final String? path = r'$'})
    extends ValkeyCommand<List<int?>>
    with KeyedCommand<List<int?>> {
  @override
  List<String> get commandParts => ['JSON.OBJLEN', key, ?path];

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
  JsonObjLenCommand applyPrefix(String prefix) =>
      JsonObjLenCommand('$prefix$key', path: path);
}
