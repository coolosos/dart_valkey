import '../command.dart';

/// Represents the 'PING [message]' command.
///
/// **Redis Command:**
/// ```text
/// PING
/// ```
///
/// **Redis Reply (Example):**
/// ```text
/// +PONG
/// ```
///
/// **Dart Result (from parse method):**
/// `String` resolving to `'PONG'`
///
/// Parameters:
/// - [message]: (Optional) A message to be echoed back by the server.
final class PingCommand([final String? message])
    extends ValkeyCommand<bool>
    with PongBoolResponse {
  @override
  List<String> get commandParts => ['PING', ?message];
}
