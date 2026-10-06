import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'RENAMENX key newkey' command.
/// Renames a key, only if the new key does not exist.
///
/// **Redis Command:**
/// ```text
/// RENAMENX oldkey newkey
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// :1
/// ```
///
/// **Dart Result (from parse method):**
/// `bool` resolving to `true` (key renamed) or `false` (newkey already exists)
final class RenameNxCommand(final String key, final String newKey)
    extends ValkeyCommand<bool>
    with KeyedCommand<bool> {
  @override
  List<String> get commandParts => ['RENAMENX', key, newKey];

  @override
  bool parse(dynamic data) {
    if (data is int) return data == 1;

    throw ValkeyException(
      'Invalid response for RENAMENX: expected 0 or 1, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<bool> applyPrefix(String prefix) {
    return RenameNxCommand('$prefix$key', '$prefix$newKey');
  }
}
