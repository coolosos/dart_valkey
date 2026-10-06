import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'DECR key' command.
/// Decrements the number stored at key by one.
///
/// **Redis Command:**
/// ```text
/// DECR mycounter
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// :0
/// ```
///
/// **Dart Result (from parse method):**
/// `int` resolving to `0`
///
/// Parameters:
/// - [key]: The key to decrement.
final class DecrCommand(final String key)
    extends ValkeyCommand<int>
    with KeyedCommand<int> {
  @override
  List<String> get commandParts => ['DECR', key];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    throw ValkeyException(
      'Invalid response for DECR: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<int> applyPrefix(String prefix) {
    return DecrCommand('$prefix$key');
  }
}
