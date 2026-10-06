import '../command.dart';

/// Represents the 'QUIT' command.
final class QuitCommand extends ValkeyCommand<String> with OkStringResponse {
  @override
  List<String> get commandParts => ['QUIT'];
}
