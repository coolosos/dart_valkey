import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'HINCRBY key field increment' command.
///
/// **Redis Command:**
/// ```text
/// HINCRBY user:1 age 1
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// :31
/// ```
///
/// **Dart Result (from parse method):**
/// `int` resolving to `31`
///
/// Parameters:
/// - [key]: The key of the hash.
/// - [field]: The field to increment.
/// - [increment]: The amount to increment by.
final class HIncrByCommand(
  final String key,
  final String field,
  final int increment,
) extends ValkeyCommand<int> with KeyedCommand<int> {
  @override
  List<String> get commandParts => [
    'HINCRBY',
    key,
    field,
    increment.toString(),
  ];

  @override
  int parse(dynamic data) {
    if (data is int) return data;
    throw ValkeyException(
      'Invalid response for HINCRBY: expected an integer, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<int> applyPrefix(String prefix) {
    return HIncrByCommand('$prefix$key', field, increment);
  }
}
