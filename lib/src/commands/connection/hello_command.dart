import '../../codec/valkey_exception.dart';
import '../command.dart';

/// Represents the 'HELLO' command.
///
/// **Valkey Command:**
/// ```text
/// HELLO
/// ```
///
/// **Valkey Reply:**
/// ```text
/// A list of current server and connection properties.
/// ```
///
/// **Dart Result (from parse method):**
/// `Map<String, dynamic>` resolving to the server properties.
final class HelloCommand({
  final int? protocolVersion,
  final String? username,
  final String? password,
  final String? clientName,
}) extends ValkeyCommand<Map<String, dynamic>> {
  @override
  List<String> get commandParts {
    final parts = ['HELLO'];
    if (protocolVersion case final protocolVersion?) {
      parts.add(protocolVersion.toString());

      if (username != null && password != null) {
        parts.addAll(['AUTH', username!, password!]);
      } else if (username == null && password != null) {
        parts.addAll(['AUTH', 'default', password!]);
      }
      if (clientName != null) {
        parts.addAll(['SETNAME', clientName!]);
      }
    }

    return parts;
  }

  @override
  Map<String, dynamic> parse(dynamic data) {
    if (data is Map) {
      return data.cast<String, dynamic>();
    } else if (data is List) {
      final result = <String, dynamic>{};
      for (var i = 0; i < data.length; i += 2) {
        if (i + 1 < data.length) {
          result[data[i].toString()] = data[i + 1];
        }
      }
      return result;
    }
    throw ValkeyException(
      'Invalid response for HELLO: expected a list or map, got ${data.runtimeType}',
    );
  }
}
