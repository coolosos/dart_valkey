import 'package:meta/meta.dart';

import '../command.dart';

@immutable
final class JsonGetCommand(
  final String key, {
  final List<String> paths = const [],
  final String? indent,
  final String? newline,
  final String? space,
}) extends ValkeyCommand<String?> with KeyedCommand<String?> {
  @override
  List<String> get commandParts {
    final parts = <String>['JSON.GET', key];
    if (indent case final indent?) {
      parts.addAll(['INDENT', indent]);
    }
    if (newline case final newline?) {
      parts.addAll(['NEWLINE', newline]);
    }
    if (space case final space?) {
      parts.addAll(['SPACE', space]);
    }
    parts.addAll(paths);
    return parts;
  }

  @override
  String? parse(dynamic data) => data as String?;

  @override
  JsonGetCommand applyPrefix(String prefix) => JsonGetCommand(
    '$prefix$key',
    paths: paths,
    indent: indent,
    newline: newline,
    space: space,
  );
}
