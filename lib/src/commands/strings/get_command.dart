import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'GET key' command.
///
/// **Redis Command:**
/// ```text
/// GET mykey
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// $5
/// hello
/// ```
///
/// **Dart Result (from parse method):**
/// `String?` resolving to `'hello'` or `null`
///
/// Parameters:
/// - [key]: The key to retrieve the value from.
final class GetCommand(final String key)
    extends ValkeyCommand<String?>
    with KeyedCommand<String?> {
  @override
  List<String> get commandParts => ['GET', key];

  @override
  String? parse(dynamic data) {
    if (data == null || data is String) return data as String?;
    throw ValkeyException(
      'Invalid response for GET: expected a string or null, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<String?> applyPrefix(String prefix) {
    return GetCommand('$prefix$key');
  }
}
