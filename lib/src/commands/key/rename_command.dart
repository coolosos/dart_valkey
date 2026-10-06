import '../command.dart';

/// Represents the 'RENAME key newkey' command.
/// Renames a key.
///
/// **Redis Command:**
/// ```text
/// RENAME oldkey newkey
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// +OK
/// ```
///
/// **Dart Result (from parse method):**
/// `String` resolving to `'OK'`
final class RenameCommand(final String key, final String newKey)
    extends ValkeyCommand<bool>
    with KeyedCommand<bool>, OkBoolResponse {
  @override
  List<String> get commandParts => ['RENAME', key, newKey];

  @override
  ValkeyCommand<bool> applyPrefix(String prefix) {
    return RenameCommand('$prefix$key', '$prefix$newKey');
  }
}
