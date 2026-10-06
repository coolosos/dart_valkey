import '../command.dart';

/// Represents the 'CLIENT NO-EVICT' command.
///
/// **Valkey Command:**
/// ```text
/// CLIENT NO-EVICT ON | OFF
/// ```
///
/// **Valkey Reply:**
/// ```text
/// OK
/// ```
///
/// **Dart Result (from parse method):**
/// `String` resolving to `'OK'`
final class ClientNoEvictCommand({required final bool enable})
    extends ValkeyCommand<String>
    with OkStringResponse {
  @override
  List<String> get commandParts => [
    'CLIENT',
    'NO-EVICT',
    if (enable) 'ON' else 'OFF',
  ];
}
