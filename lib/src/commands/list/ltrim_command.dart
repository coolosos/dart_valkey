import '../command.dart';

/// Represents the 'LTRIM key start stop' command.
///
/// **Redis Command:**
/// ```text
/// LTRIM mylist 0 0
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// +OK
/// ```
///
/// **Dart Result (from parse method):**
/// `String` resolving to `'OK'`
///
/// Parameters:
/// - [key]: The key of the list.
/// - [start]: The starting offset.
/// - [stop]: The ending offset (inclusive).
final class LTrimCommand(final String key, final int start, final int stop)
    extends ValkeyCommand<bool>
    with KeyedCommand<bool>, OkBoolResponse {
  @override
  List<String> get commandParts => [
    'LTRIM',
    key,
    start.toString(),
    stop.toString(),
  ];

  @override
  ValkeyCommand<bool> applyPrefix(String prefix) {
    return LTrimCommand('$prefix$key', start, stop);
  }
}
