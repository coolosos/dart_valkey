import '../command.dart';

/// Represents the 'SISMEMBER key member' command.
///
/// **Redis Command:**
/// ```text
/// SISMEMBER myset member1
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// :1
/// ```
///
/// **Dart Result (from parse method):**
/// `bool` resolving to `true`
final class SIsMemberCommand(final String key, final String member)
    extends ValkeyCommand<bool>
    with KeyedCommand<bool> {
  @override
  List<String> get commandParts => ['SISMEMBER', key, member];

  @override
  bool parse(dynamic data) {
    return data == 1;
    // throw ValkeyException(
    //     'Invalid response for SISMEMBER: expected an integer, got ${data.runtimeType}');
  }

  @override
  ValkeyCommand<bool> applyPrefix(String prefix) {
    return SIsMemberCommand('$prefix$key', member);
  }
}
