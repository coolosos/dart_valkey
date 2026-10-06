import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'HSET key field value [field value ...]' command.
///
/// **Redis Command:**
/// ```text
/// HSET user:1 name Alice age 30
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// :2
/// ```
///
/// **Dart Result (from parse method):**
/// `int` resolving to `2` (number of fields added)
///
/// Parameters:
/// - [key]: The key of the hash.
/// - [fields]: A map of field-value pairs to set.
final class HSetCommand(final String key, final Map<String, Object> fields)
    extends ValkeyCommand<int>
    with KeyedCommand<int> {
  @override
  List<String> get commandParts {
    final parts = <String>['HSET', key];
    fields.forEach((field, value) {
      parts
        ..add(field)
        ..add(value.toString());
    });
    return parts;
  }

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    throw ValkeyException(
      'Invalid response for HSET: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<int> applyPrefix(String prefix) {
    return HSetCommand('$prefix$key', fields);
  }
}
