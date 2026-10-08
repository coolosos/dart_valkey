import 'package:meta/meta.dart';

import '../command.dart';

@immutable
final class JsonArrPopCommand(
  final String key, {
  final String? path = r'$',
  final int? index,
}) extends ValkeyCommand<List<String?>> with KeyedCommand<List<String?>> {
  @override
  List<String> get commandParts => [
    'JSON.ARRPOP',
    key,
    ?path,
    if (index != null) index.toString(),
  ];

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
  JsonArrPopCommand applyPrefix(String prefix) =>
      JsonArrPopCommand('$prefix$key', path: path, index: index);
}
