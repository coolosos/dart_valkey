import 'package:meta/meta.dart';

import '../command.dart';

@immutable
final class JsonMGetCommand(final List<String> keys, {final String path = r'$'})
    extends ValkeyCommand<List<String?>>
    with KeyedCommand<List<String?>> {
  @override
  List<String> get commandParts => ['JSON.MGET', ...keys, path];

  @override
  List<String?> parse(dynamic data) {
    if (data is List) {
      return data.map((e) => e as String?).toList();
    }
    return const [];
  }

  @override
  JsonMGetCommand applyPrefix(String prefix) =>
      JsonMGetCommand(keys.map((k) => '$prefix$k').toList(), path: path);
}
