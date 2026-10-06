import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'RPOPLPUSH source destination' command.
/// Atomically removes the last element from source, and pushes it to the head of destination.
///
/// **Redis Command:**
/// ```text
/// RPOPLPUSH mylist myotherlist
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// $5
/// itemX
/// ```
///
/// **Dart Result (from parse method):**
/// `String?` resolving to `'itemX'` or `null`
final class RPopLPushCommand(final String source, final String destination)
    extends ValkeyCommand<String?>
    with KeyedCommand<String?> {
  @override
  List<String> get commandParts => ['RPOPLPUSH', source, destination];

  @override
  String? parse(dynamic data) {
    if (data == null || data is String) return data as String?;
    throw ValkeyException(
      'Invalid response for RPOPLPUSH: expected a string or null, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<String?> applyPrefix(String prefix) {
    return RPopLPushCommand('$prefix$source', '$prefix$destination');
  }
}
