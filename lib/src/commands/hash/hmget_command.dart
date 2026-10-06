import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'HMGET key field [field ...]' command.
///
/// **Redis Command:**
/// ```text
/// HMGET user:1 name email
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// *2
/// $5
/// Alice
/// $-1
/// ```
///
/// **Dart Result (from parse method):**
/// `List<String?>` resolving to `['Alice', null]`
///
/// Parameters:
/// - [key]: The key of the hash.
/// - [fields]: A list of fields to retrieve values for.
final class HMGetCommand(final String key, final List<String> fields)
    extends ValkeyCommand<List<String?>>
    with KeyedCommand<List<String?>> {
  @override
  List<String> get commandParts => ['HMGET', key, ...fields];

  @override
  List<String?> parse(dynamic data) {
    if (data is List) return data.map((e) => e as String?).toList();
    throw ValkeyException(
      'Invalid response for HMGET: expected a list, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<List<String?>> applyPrefix(String prefix) {
    return HMGetCommand('$prefix$key', fields);
  }
}
