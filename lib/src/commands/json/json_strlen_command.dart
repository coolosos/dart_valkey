import 'package:meta/meta.dart';

import '../command.dart';

@immutable
final class JsonStrLenCommand(final String key, {final String? path = r'$'})
    extends ValkeyCommand<List<int?>>
    with KeyedCommand<List<int?>> {
  @override
  List<String> get commandParts => ['JSON.STRLEN', key, ?path];

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
  JsonStrLenCommand applyPrefix(String prefix) =>
      JsonStrLenCommand('$prefix$key', path: path);
}
