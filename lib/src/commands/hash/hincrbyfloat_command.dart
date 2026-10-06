import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'HINCRBYFLOAT key field increment' command.
/// Increments the float value of a field in a hash by the given amount.
///
/// **Redis Command:**
/// ```text
/// HINCRBYFLOAT myhash field 1.5
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// $4
/// 1.5
/// ```
///
/// **Dart Result (from parse method):**
/// `double` resolving to `1.5`
///
/// Parameters:
/// - [key]: The key of the hash.
/// - [field]: The field to increment.
/// - [increment]: The amount to increment by.
final class HIncrByFloatCommand(
  final String key,
  final String field,
  final double increment,
) extends ValkeyCommand<double> with KeyedCommand<double> {
  @override
  List<String> get commandParts => [
    'HINCRBYFLOAT',
    key,
    field,
    increment.toString(),
  ];

  @override
  double parse(dynamic data) {
    if (data is String) return double.parse(data);
    throw ValkeyException(
      'Invalid response for HINCRBYFLOAT: expected a string, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<double> applyPrefix(String prefix) {
    return HIncrByFloatCommand('$prefix$key', field, increment);
  }
}
