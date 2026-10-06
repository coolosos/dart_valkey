import '../command.dart';

/// Represents the 'CLIENT NO-TOUCH' command.
///
/// **Valkey Command:**
/// ```text
/// CLIENT NO-TOUCH ON | OFF
/// ```
///
/// **Valkey Reply:**
/// ```text
/// OK
/// ```
///
/// **Dart Result (from parse method):**
/// `String` resolving to `'OK'`
final class ClientNoTouchCommand({required final bool enable})
    extends ValkeyCommand<String>
    with OkStringResponse {
  @override
  List<String> get commandParts => [
    'CLIENT',
    'NO-TOUCH',
    if (enable) 'ON' else 'OFF',
  ];
}
