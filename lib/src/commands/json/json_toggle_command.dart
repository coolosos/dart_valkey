import 'package:meta/meta.dart';

import '../command.dart';

@immutable
final class JsonToggleCommand(final String key, {final String? path = r'$'})
    extends ValkeyCommand<List<bool?>>
    with KeyedCommand<List<bool?>> {
  @override
  List<String> get commandParts => ['JSON.TOGGLE', key, ?path];

  @override
  List<bool?> parse(dynamic data) {
    if (data is List) {
      return data.map((e) {
        if (e == 1 || e == true) return true;
        if (e == 0 || e == false) return false;
        return null;
      }).toList();
    }
    if (data == 1 || data == true) return [true];
    if (data == 0 || data == false) return [false];
    return const [];
  }

  @override
  JsonToggleCommand applyPrefix(String prefix) =>
      JsonToggleCommand('$prefix$key', path: path);
}
