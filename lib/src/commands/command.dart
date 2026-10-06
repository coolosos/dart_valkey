import '../codec/resp_encoder.dart';
import '../codec/valkey_exception.dart';

/// The base class for all commands in the Valkey client.
///
/// This is a sealed class, allowing for exhaustive pattern matching
/// on its direct subclasses (e.g., [ValkeyCommand] for regular commands
/// and [PubSubCommand] for Pub/Sub commands).
sealed class Command<T> {
  /// The command and its arguments, to be implemented by each subclass.
  List<String> get commandParts;

  /// Returns the human-readable command name (e.g., 'AUTH', 'CLIENT SETNAME', 'QUIT').
  String get commandName {
    if (commandParts.isEmpty) return 'command';
    if (commandParts.first == 'CLIENT' && commandParts.length > 1) {
      return '${commandParts[0]} ${commandParts[1]}';
    }
    return commandParts.first;
  }

  late final List<int> encoded = RespEncoder.encode(commandParts);
}

/// The base class for all Pub/Sub specific commands.
///
/// These commands are typically used with a dedicated Pub/Sub client
/// and should not be used with the main command client.
abstract base class PubSubCommand<T> extends Command<T> {
  // No additional members needed here, just serves as a marker interface
  // and base class for Pub/Sub commands.
}

/// The base class for all Valkey commands.
///
/// It is abstract and generic over the return type `T`.
abstract base class ValkeyCommand<T> extends Command<T> {
  // commandParts, parse, and encoded are inherited from Command<T>
  /// The parser for the response, to be implemented by each subclass.
  T parse(dynamic data);
}

base mixin KeyedCommand<T> on ValkeyCommand<T> {
  ValkeyCommand<T> applyPrefix(String prefix);
}

/// Mixin for commands that expect 'OK' and return 'OK'.
base mixin OkStringResponse on ValkeyCommand<String> {
  @override
  String parse(dynamic data) {
    if (data == 'OK') return 'OK';
    throw ValkeyException(
      'Invalid response for $commandName: expected OK, got ${data.runtimeType} "$data"',
    );
  }
}

/// Mixin for commands that expect 'OK' and return boolean `true` (evaluates `data == 'OK'`).
base mixin OkBoolResponse on ValkeyCommand<bool> {
  @override
  bool parse(dynamic data) => data == 'OK';
}

/// Mixin for commands that strictly require 'OK' returning `true` or throwing [ValkeyException].
base mixin ExpectOkBoolResponse on ValkeyCommand<bool> {
  @override
  bool parse(dynamic data) {
    if (data == 'OK') return true;
    throw ValkeyException(
      'Invalid response for $commandName: expected OK, got ${data.runtimeType} "$data"',
    );
  }
}

/// Mixin for PING commands that expect 'PONG' and return boolean `true`.
base mixin PongBoolResponse on ValkeyCommand<bool> {
  @override
  bool parse(dynamic data) => data == 'PONG';
}

/// Mixin for commands that expect 'RESET' and return 'RESET'.
base mixin ResetStringResponse on ValkeyCommand<String> {
  @override
  String parse(dynamic data) {
    if (data == 'RESET') return 'RESET';
    throw ValkeyException(
      'Invalid response for $commandName: expected RESET, got ${data.runtimeType} "$data"',
    );
  }
}
