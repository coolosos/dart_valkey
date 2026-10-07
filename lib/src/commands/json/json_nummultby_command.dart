import 'package:meta/meta.dart';

import '../command.dart';

@immutable
final class JsonNumMultByCommand(
  final String key,
  final String path,
  final num value,
) extends ValkeyCommand<String?> with KeyedCommand<String?> {
  @override
  List<String> get commandParts => [
    'JSON.NUMMULTBY',
    key,
    path,
    value.toString(),
  ];

  @override
  String? parse(dynamic data) => data as String?;

  @override
  JsonNumMultByCommand applyPrefix(String prefix) =>
      JsonNumMultByCommand('$prefix$key', path, value);
}
