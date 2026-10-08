import 'package:meta/meta.dart';

import '../command.dart';

@immutable
final class JsonClearCommand(final String key, {final String? path = r'$'})
    extends ValkeyCommand<int>
    with KeyedCommand<int> {
  @override
  List<String> get commandParts => ['JSON.CLEAR', key, ?path];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    if (data is String) return int.tryParse(data) ?? 0;
    return 0;
  }

  @override
  JsonClearCommand applyPrefix(String prefix) =>
      JsonClearCommand('$prefix$key', path: path);
}
