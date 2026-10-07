import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the `ZADD key [NX|XX] [CH] [INCR] score member [score member ...]` command.
///
/// **Redis Command:**
/// ```text
/// ZADD myzset 1.0 member1 2.0 member2
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// :2
/// ```
///
/// **Dart Result (from parse method):**
/// `int` resolving to `2` (number of elements added) or `double` (if INCR is true)
final class ZAddCommand extends ValkeyCommand<dynamic>
    with KeyedCommand<dynamic> {
  new(
    this.key,
    this.membersWithScores, {
    this.onlyIfNotExists = false,
    this.onlyIfAlreadyExists = false,
    this.changed = false,
    this.incr = false,
  }) : assert(
         !(onlyIfNotExists && onlyIfAlreadyExists),
         'Only one of onlyIfNotExists or onlyIfAlreadyExists can be specified.',
       );
  final String key;
  final Map<String, double> membersWithScores;

  /// Only add new elements. Don't update existing scores.
  final bool onlyIfNotExists;

  /// Only update existing elements. Don't add new elements.
  final bool onlyIfAlreadyExists;

  /// Return the number of elements that were changed (added or updated).
  final bool changed;

  /// When this option is used, ZADD acts like ZINCRBY.
  final bool incr;

  @override
  List<String> get commandParts {
    final parts = <String>['ZADD', key];

    if (onlyIfNotExists) {
      parts.add('NX');
    }
    if (onlyIfAlreadyExists) {
      parts.add('XX');
    }
    if (changed) {
      parts.add('CH');
    }
    if (incr) {
      parts.add('INCR');
    }

    membersWithScores.forEach((member, score) {
      parts
        ..add(score.toString())
        ..add(member);
    });
    return parts;
  }

  @override
  dynamic parse(dynamic data) {
    if (incr) {
      if (data is String) return double.parse(data);
    } else {
      if (data is int) return data;
    }
    throw ValkeyException(
      'Invalid response for ZADD: expected an integer or double, got ${data.runtimeType}',
    );
  }

  @override
  ValkeyCommand<dynamic> applyPrefix(String prefix) {
    return ZAddCommand(
      '$prefix$key',
      membersWithScores,
      onlyIfNotExists: onlyIfNotExists,
      onlyIfAlreadyExists: onlyIfAlreadyExists,
      changed: changed,
      incr: incr,
    );
  }
}
