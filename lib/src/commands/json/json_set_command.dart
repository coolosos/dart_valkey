import 'package:meta/meta.dart';

import '../command.dart';
import '../strings/set_command.dart';

@immutable
final class JsonSetCommand(
  final String key,
  final String path,
  final String value, {
  final SetStrategyTypes strategyType = SetStrategyTypes.always,
}) extends ValkeyCommand<bool> with KeyedCommand<bool> {
  @override
  List<String> get commandParts {
    final parts = <String>['JSON.SET', key, path, value];
    if (strategyType != SetStrategyTypes.always) {
      parts.add(strategyType.command);
    }
    return parts;
  }

  @override
  bool parse(dynamic data) => data == 'OK';

  @override
  JsonSetCommand applyPrefix(String prefix) =>
      JsonSetCommand('$prefix$key', path, value, strategyType: strategyType);
}
