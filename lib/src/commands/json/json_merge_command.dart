import 'package:meta/meta.dart';

import '../command.dart';

@immutable
final class JsonMergeCommand(
  final String key,
  final String path,
  final String value,
) extends ValkeyCommand<bool> with KeyedCommand<bool> {
  @override
  List<String> get commandParts => ['JSON.MERGE', key, path, value];

  @override
  bool parse(dynamic data) => data == 'OK';

  @override
  JsonMergeCommand applyPrefix(String prefix) =>
      JsonMergeCommand('$prefix$key', path, value);
}
