import 'package:meta/meta.dart';

import '../command.dart';

@immutable
final class JsonNumIncrByCommand(
  final String key,
  final String path,
  final num value,
) extends ValkeyCommand<String?> with KeyedCommand<String?> {
  @override
  List<String> get commandParts => [
    'JSON.NUMINCRBY',
    key,
    path,
    value.toString(),
  ];

  @override
  String? parse(dynamic data) => data as String?;

  @override
  JsonNumIncrByCommand applyPrefix(String prefix) =>
      JsonNumIncrByCommand('$prefix$key', path, value);
}
