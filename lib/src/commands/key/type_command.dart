import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'TYPE key' command.
/// Determines the type of a key.
///
/// **Redis Command:**
/// ```text
/// TYPE mykey
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// +string
/// ```
///
/// **Dart Result (from parse method):**
/// `String` resolving to `'string'`, `'hash'`, `'list'`, `'set'`, `'zset'`, or `'none'`
final class TypeCommand(final String key)
    extends ValkeyCommand<String>
    with KeyedCommand<String> {
  @override
  List<String> get commandParts => ['TYPE', key];

  @override
  String parse(dynamic data) {
    if (data is String) return data;
    throw ValkeyException(
      'Invalid response for TYPE: expected a string, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<String> applyPrefix(String prefix) {
    return TypeCommand('$prefix$key');
  }
}
