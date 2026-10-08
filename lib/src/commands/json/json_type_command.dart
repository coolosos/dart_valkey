import 'package:meta/meta.dart';

import '../command.dart';

@immutable
final class JsonTypeCommand(final String key, {final String? path = r'$'})
    extends ValkeyCommand<List<String?>>
    with KeyedCommand<List<String?>> {
  @override
  List<String> get commandParts => ['JSON.TYPE', key, ?path];

  @override
  List<String?> parse(dynamic data) {
    if (data is List) {
      return data.map((e) => e as String?).toList();
    }
    if (data is String) {
      return [data];
    }
    return const [];
  }

  @override
  JsonTypeCommand applyPrefix(String prefix) =>
      JsonTypeCommand('$prefix$key', path: path);
}
