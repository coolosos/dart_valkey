import 'package:meta/meta.dart';

import '../command.dart';

@immutable
final class JsonDelCommand(final String key, {final String? path})
    extends ValkeyCommand<int>
    with KeyedCommand<int> {
  @override
  List<String> get commandParts => ['JSON.DEL', key, ?path];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    if (data is String) return int.tryParse(data) ?? 0;
    return 0;
  }

  @override
  JsonDelCommand applyPrefix(String prefix) =>
      JsonDelCommand('$prefix$key', path: path);
}

/// Alias for [JsonDelCommand] matching Valkey/Redis `JSON.FORGET`.
typedef JsonForgetCommand = JsonDelCommand;
