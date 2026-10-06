import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'HGET key field' command.
///
/// **Redis Command:**
/// ```text
/// HGET user:1 name
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// $5
/// Alice
/// ```
///
/// **Dart Result (from parse method):**
/// `String?` resolving to `'Alice'` or `null`
///
/// Parameters:
/// - [key]: The key of the hash.
/// - [field]: The field to retrieve.
final class HGetCommand(final String key, final String field)
    extends ValkeyCommand<String?>
    with KeyedCommand<String?> {
  @override
  List<String> get commandParts => ['HGET', key, field];

  @override
  String? parse(dynamic data) {
    if (data == null || data is String) return data as String?;
    throw ValkeyException(
      'Invalid response for HGET: expected a string or null, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<String?> applyPrefix(String prefix) {
    return HGetCommand('$prefix$key', field);
  }
}
