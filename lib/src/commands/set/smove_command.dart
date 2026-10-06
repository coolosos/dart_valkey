import '../command.dart';

/// Represents the 'SMOVE source destination member' command.
/// Moves member from the set at source to the set at destination.
///
/// **Redis Command:**
/// ```text
/// SMOVE set1 set2 member1
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// :1
/// ```
///
/// **Dart Result (from parse method):**
/// `bool` resolving to `true`
final class SMoveCommand(
  final String source,
  final String destination,
  final String member,
) extends ValkeyCommand<bool> with KeyedCommand<bool> {
  @override
  List<String> get commandParts => ['SMOVE', source, destination, member];

  @override
  bool parse(dynamic data) {
    return data == 1;
    // throw ValkeyException(
    //     'Invalid response for SMOVE: expected an integer, got ${data.runtimeType}');
  }

  @override
  ValkeyCommand<bool> applyPrefix(String prefix) {
    return SMoveCommand('$prefix$source', '$prefix$destination', member);
  }
}
