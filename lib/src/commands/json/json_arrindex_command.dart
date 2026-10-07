import 'package:meta/meta.dart';

import '../command.dart';

@immutable
final class JsonArrIndexCommand(
  final String key,
  final String path,
  final String value, {
  final int? start,
  final int? stop,
}) extends ValkeyCommand<List<int?>> with KeyedCommand<List<int?>> {
  @override
  List<String> get commandParts => [
    'JSON.ARRINDEX',
    key,
    path,
    value,
    if (start != null) start.toString(),
    if (stop != null) stop.toString(),
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
  JsonArrIndexCommand applyPrefix(String prefix) =>
      JsonArrIndexCommand('$prefix$key', path, value, start: start, stop: stop);
}
