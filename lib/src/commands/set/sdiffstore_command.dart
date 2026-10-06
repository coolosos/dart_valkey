import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'SDIFFSTORE destination key [key ...]' command.
/// Stores the members of the set resulting from the difference between the first set and all the successive sets in destination.
///
/// **Redis Command:**
/// ```text
/// SDIFFSTORE newset set1 set2
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// :1
/// ```
///
/// **Dart Result (from parse method):**
/// `int` resolving to `1` (number of elements in the resulting set)
final class SDiffStoreCommand(final String destination, final List<String> keys)
    extends ValkeyCommand<int>
    with KeyedCommand<int> {
  @override
  List<String> get commandParts => ['SDIFFSTORE', destination, ...keys];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    throw ValkeyException(
      'Invalid response for SDIFFSTORE: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<int> applyPrefix(String prefix) {
    return SDiffStoreCommand(
      '$prefix$destination',
      keys.map((key) => '$prefix$key').toList(),
    );
  }
}
