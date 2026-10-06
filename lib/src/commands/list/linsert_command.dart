import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'LINSERT key BEFORE|AFTER pivot value' command.
/// Inserts an element before or after another element in a list.
///
/// **Redis Command:**
/// ```text
/// LINSERT mylist BEFORE item2 newitem
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// :3
/// ```
///
/// **Dart Result (from parse method):**
/// `int` resolving to `3` (new length of the list)
///
/// Parameters:
/// - [key]: The key of the list.
/// - [before]: If true, insert before the pivot; otherwise, insert after.
/// - [pivot]: The element to insert relative to.
/// - [value]: The value to insert.
final class LInsertCommand(
  final String key,
  final String pivot,
  final String value, {
  required final bool before,
}) extends ValkeyCommand<int> with KeyedCommand<int> {
  @override
  List<String> get commandParts => [
    'LINSERT',
    key,
    if (before) 'BEFORE' else 'AFTER',
    pivot,
    value,
  ];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    throw ValkeyException(
      'Invalid response for LINSERT: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<int> applyPrefix(String prefix) {
    return LInsertCommand('$prefix$key', pivot, value, before: before);
  }
}
