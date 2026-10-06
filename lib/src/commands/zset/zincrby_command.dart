import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'ZINCRBY key increment member' command.
///
/// **Redis Command:**
/// ```text
/// ZINCRBY myzset 1.5 member1
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// $4
/// 2.5
/// ```
///
/// **Dart Result (from parse method):**
/// `double` resolving to `2.5`
final class ZIncrByCommand(
  final String key,
  final double increment,
  final String member,
) extends ValkeyCommand<double> with KeyedCommand<double> {
  @override
  List<String> get commandParts => [
    'ZINCRBY',
    key,
    increment.toString(),
    member,
  ];

  @override
  double parse(dynamic data) {
    if (data is String) return double.parse(data);
    throw ValkeyException(
      'Invalid response for ZINCRBY: expected a string, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<double> applyPrefix(String prefix) {
    return ZIncrByCommand('$prefix$key', increment, member);
  }
}
