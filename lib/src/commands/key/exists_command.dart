import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'EXISTS key [key ...]' command.
/// Determines if one or more keys exist.
///
/// **Redis Command:**
/// ```text
/// EXISTS mykey1 mykey2
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// :1
/// ```
///
/// **Dart Result (from parse method):**
/// `int` resolving to `1` (number of keys that exist)
final class ExistsCommand(final List<String> keys)
    extends ValkeyCommand<int>
    with KeyedCommand<int> {
  @override
  List<String> get commandParts => ['EXISTS', ...keys];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    throw ValkeyException(
      'Invalid response for EXISTS: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<int> applyPrefix(String prefix) {
    return ExistsCommand(keys.map((key) => '$prefix$key').toList());
  }
}
