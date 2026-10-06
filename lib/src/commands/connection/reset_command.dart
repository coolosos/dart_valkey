import '../command.dart';

/// Represents the 'RESET' command.
final class ResetCommand extends ValkeyCommand<String>
    with ResetStringResponse {
  @override
  List<String> get commandParts => ['RESET'];
}
