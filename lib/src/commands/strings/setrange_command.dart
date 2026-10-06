import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'SETRANGE key offset value' command.
/// Overwrites part of the string stored at key, starting at the specified offset, for the entire length of value.
///
/// **Redis Command:**
/// ```text
/// SETRANGE mykey 6 World
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// :11
/// ```
///
/// **Dart Result (from parse method):**
/// `int` resolving to `11` (new length of the string)
///
/// Parameters:
/// - [key]: The key to modify.
/// - [offset]: The zero-based offset at which to start overwriting.
/// - [value]: The string to overwrite with.
final class SetRangeCommand(
  final String key,
  final int offset,
  final String value,
) extends ValkeyCommand<int> with KeyedCommand<int> {
  @override
  List<String> get commandParts => ['SETRANGE', key, offset.toString(), value];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    throw ValkeyException(
      'Invalid response for SETRANGE: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<int> applyPrefix(String prefix) {
    return SetRangeCommand('$prefix$key', offset, value);
  }
}
