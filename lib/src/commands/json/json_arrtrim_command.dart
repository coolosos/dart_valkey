import 'package:meta/meta.dart';

import '../command.dart';

@immutable
final class JsonArrTrimCommand(
  final String key,
  final String path,
  final int start,
  final int stop,
) extends ValkeyCommand<List<int?>> with KeyedCommand<List<int?>> {
  @override
  List<String> get commandParts => [
    'JSON.ARRTRIM',
    key,
    path,
    start.toString(),
    stop.toString(),
  ];

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
  JsonArrTrimCommand applyPrefix(String prefix) =>
      JsonArrTrimCommand('$prefix$key', path, start, stop);
}
