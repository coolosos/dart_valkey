import '../command.dart';

enum ClientTrackingMode { on, off }

/// Represents the 'CLIENT TRACKING ON|OFF' command.
final class ClientTrackingCommand(final ClientTrackingMode mode)
    extends ValkeyCommand<bool>
    with ExpectOkBoolResponse {
  @override
  List<String> get commandParts => [
    'CLIENT',
    'TRACKING',
    mode.name.toUpperCase(),
  ];
}
