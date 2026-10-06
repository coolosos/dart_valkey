import '../command.dart';

/// Represents the 'CLIENT CACHING' command.
///
/// **Valkey Command:**
/// ``` valkey
/// CLIENT CACHING YES | NO
/// ```
///
/// **Valkey Reply:**
/// ``` valkey
/// OK
/// ```
///
/// **Dart Result (from parse method):**
/// `String` resolving to `'OK'`
final class ClientCachingCommand({required final bool enable})
    extends ValkeyCommand<String>
    with OkStringResponse {
  @override
  List<String> get commandParts => [
    'CLIENT',
    'CACHING',
    if (enable) 'YES' else 'NO',
  ];
}
