import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'HLEN key' command.
///
/// **Redis Command:**
/// ```text
/// HLEN user:1
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// :2
/// ```
///
/// **Dart Result (from parse method):**
/// `int` resolving to `2`
///
/// Parameters:
/// - [key]: The key of the hash.
final class HLenCommand(final String key)
    extends ValkeyCommand<int>
    with KeyedCommand<int> {
  @override
  List<String> get commandParts => ['HLEN', key];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    throw ValkeyException(
      'Invalid response for HLEN: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<int> applyPrefix(String prefix) {
    return HLenCommand('$prefix$key');
  }
}
