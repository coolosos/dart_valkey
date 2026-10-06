import '../../codec/valkey_exception.dart';
import '../command.dart';

enum ExpireStrategyTypes {
  onlyIfNotExists('NX'),
  onlyIfExists('XX'),
  greaterThanCurrent('GT'),
  lessThanCurrent('LT'),
  always('');

  new(this.command);

  final String command;
}

/// Represents the 'EXPIRE key seconds [NX|XX|GT|LT]' command.
///
/// **Redis Command:**
/// ```text
/// EXPIRE mykey 60 NX
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// :1
/// ```
///
/// **Dart Result (from parse method):**
/// `bool` resolving to `true` (timeout set) or `false` (key does not exist)
///
/// Parameters:
/// - [key]: The key to set the expiration for.
/// - [seconds]: The time to live in seconds.
/// - [strategyType]: Set expire strategy.
final class ExpireCommand(
  final String key,
  final int seconds, {
  final ExpireStrategyTypes strategyType = ExpireStrategyTypes.always,
}) extends ValkeyCommand<bool> with KeyedCommand<bool> {
  @override
  List<String> get commandParts {
    final parts = ['EXPIRE', key, seconds.toString()];
    if (strategyType != ExpireStrategyTypes.always) {
      parts.add(strategyType.command);
    }
    return parts;
  }

  @override
  bool parse(dynamic data) {
    if (data is int) return data == 1;
    if (data is String) {
      if (data == '1') return true;
      if (data == '0') return false;
    }
    throw ValkeyException(
      'Invalid response for EXPIRE: expected an integer or "0"/"1", got ${data.runtimeType} "$data"',
    );
  }

  @override
  ValkeyCommand<bool> applyPrefix(String prefix) {
    return ExpireCommand('$prefix$key', seconds, strategyType: strategyType);
  }
}
