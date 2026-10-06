import '../command.dart';

/// Represents the `MSET key value [key value ...]` command.
/// Sets multiple key-value pairs in a single atomic operation.
///
/// **Redis Command:**
/// ```text
/// MSET key1 value1 key2 value2
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// +OK
/// ```
///
/// **Dart Result (from parse method):**
/// `String` resolving to `'OK'`
///
/// Parameters:
/// - [keyValuePairs]: A map of key-value pairs to set.
final class MSetCommand(final Map<String, String> keyValuePairs)
    extends ValkeyCommand<String>
    with KeyedCommand<String>, OkStringResponse {
  @override
  List<String> get commandParts {
    final parts = <String>['MSET'];
    keyValuePairs.forEach((key, value) {
      parts
        ..add(key)
        ..add(value);
    });
    return parts;
  }

  @override
  ValkeyCommand<String> applyPrefix(String prefix) {
    final prefixedPairs = <String, String>{};
    keyValuePairs.forEach((key, value) {
      prefixedPairs['$prefix$key'] = value;
    });
    return MSetCommand(prefixedPairs);
  }
}
