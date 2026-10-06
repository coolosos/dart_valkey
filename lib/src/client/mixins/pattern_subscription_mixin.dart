part of '../valkey_client.dart';

mixin PatternSubscriptionMixin on BaseValkeyClient {
  final Set<String> _subscribedPatterns = {};

  List<String> get subscribedPatterns => _subscribedPatterns.toList();

  void psubscribe(List<String> patterns) {
    if (patterns.isEmpty) return;
    final newPatterns = patterns
        .where((p) => !_subscribedPatterns.contains(p))
        .toList();
    if (newPatterns.isEmpty) return;
    _sendPSubscribeCommand(newPatterns);
    _subscribedPatterns.addAll(newPatterns);
  }

  void punsubscribe([List<String> patterns = const []]) {
    final patternsToUnsubscribe = patterns.isEmpty
        ? _subscribedPatterns.toList()
        : patterns;
    if (patternsToUnsubscribe.isEmpty) return;

    _sendPUnsubscribeCommand(patternsToUnsubscribe);
    _subscribedPatterns.removeAll(patternsToUnsubscribe);
  }

  void _sendPSubscribeCommand(List<String> patterns) {
    final command = PSubscribeCommand(patterns);
    _connection.send(command.encoded);
  }

  void _sendPUnsubscribeCommand(List<String> patterns) {
    final command = PUnsubscribeCommand(patterns);
    _connection.send(command.encoded);
  }
}
