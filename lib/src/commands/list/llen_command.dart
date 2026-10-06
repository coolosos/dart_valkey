import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'LLEN key' command.
///
/// **Redis Command:**
/// ```text
/// LLEN mylist
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
/// - [key]: The key of the list.
final class LLenCommand(final String key)
    extends ValkeyCommand<int>
    with KeyedCommand<int> {
  @override
  List<String> get commandParts => ['LLEN', key];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    throw ValkeyException(
      'Invalid response for LLEN: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<int> applyPrefix(String prefix) {
    return LLenCommand('$prefix$key');
  }
}
