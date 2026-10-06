import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'SCARD key' command.
///
/// **Redis Command:**
/// ```text
/// SCARD myset
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// :2
/// ```
///
/// **Dart Result (from parse method):**
/// `int` resolving to `2`
final class SCardCommand(final String key)
    extends ValkeyCommand<int>
    with KeyedCommand<int> {
  @override
  List<String> get commandParts => ['SCARD', key];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    throw ValkeyException(
      'Invalid response for SCARD: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<int> applyPrefix(String prefix) {
    return SCardCommand('$prefix$key');
  }
}
