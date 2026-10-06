import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'INCRBY key increment' command.
/// Increments the number stored at key by increment.
///
/// **Redis Command:**
/// ```text
/// INCRBY mycounter 5
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// :15
/// ```
///
/// **Dart Result (from parse method):**
/// `int` resolving to `15`
///
/// Parameters:
/// - [key]: The key to increment.
/// - [increment]: The amount to increment by.
final class IncrByCommand(final String key, final int increment)
    extends ValkeyCommand<int>
    with KeyedCommand<int> {
  @override
  List<String> get commandParts => ['INCRBY', key, increment.toString()];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    throw ValkeyException(
      'Invalid response for INCRBY: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<int> applyPrefix(String prefix) {
    return IncrByCommand('$prefix$key', increment);
  }
}
