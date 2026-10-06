import '../command.dart';

/// Represents the `AUTH [username] password` command.
final class AuthCommand({
  required final String password,
  final String? username,
}) extends ValkeyCommand<String> with OkStringResponse {
  @override
  List<String> get commandParts {
    final parts = ['AUTH'];
    if (username != null) {
      parts.add(username!);
    }
    parts.add(password);
    return parts;
  }
}
