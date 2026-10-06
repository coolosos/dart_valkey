import '../../codec/valkey_exception.dart';
import '../command.dart';
import 'set_command.dart';

/// Represents the 'SET key value GET' command.
///
/// This returns the old value stored at key, or null if the key did not exist.
///
/// Note: This command variant is only available on Redis >= 6.2.
///
/// **Redis Command:**
/// ```text
/// SET mykey myvalue GET
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// $5
/// oldval
/// ```
///
/// **Dart Result (from parse method):**
/// `String?` resolving to `'oldval'` or `null`
///
/// Parameters:
/// - [key]: The key to set.
/// - [value]: The value to set.
final class SetAndGetCommand extends BaseSetCommand<String?> {
  new(
    super.key,
    super.value, {
    super.expire,
    super.strategyType = SetStrategyTypes.always,
  });

  @override
  List<String> get commandParts {
    final parts = <String>['SET', key, value];

    if (strategyType != SetStrategyTypes.always) {
      parts.add(strategyType.command);
    }
    parts.add('GET');
    if (expire case final expire?) {
      parts.addAll(expire.commandParts);
    }

    return parts;
  }

  @override
  String? parse(dynamic data) {
    if (data == null || data is String) return data as String?;
    throw ValkeyException(
      'Invalid response for SET...GET: expected a string or null, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<String?> applyPrefix(String prefix) {
    return SetAndGetCommand('$prefix$key', value);
  }
}
