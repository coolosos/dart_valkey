import 'package:meta/meta.dart';

import '../command.dart';

@immutable
final class JsonRespCommand(final String key, {final String? path = r'$'})
    extends ValkeyCommand<dynamic>
    with KeyedCommand<dynamic> {
  @override
  List<String> get commandParts => ['JSON.RESP', key, ?path];

  @override
  dynamic parse(dynamic data) => data;

  @override
  JsonRespCommand applyPrefix(String prefix) =>
      JsonRespCommand('$prefix$key', path: path);
}
