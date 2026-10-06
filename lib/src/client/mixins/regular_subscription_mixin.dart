part of '../valkey_client.dart';

mixin RegularSubscriptionMixin on BaseValkeyClient {
  final Set<String> _subscribedChannels = {};

  List<String> get subscribedChannels => _subscribedChannels.toList();

  void subscribe(List<String> channels) {
    if (channels.isEmpty) return;
    final newChannels = channels
        .where((c) => !_subscribedChannels.contains(c))
        .toList();
    if (newChannels.isEmpty) return;
    _sendSubscribeCommand(newChannels);
    _subscribedChannels.addAll(newChannels);
  }

  void unsubscribe([List<String> channels = const []]) {
    final channelsToUnsubscribe = channels.isEmpty
        ? _subscribedChannels.toList()
        : channels;
    if (channelsToUnsubscribe.isEmpty) return;

    _sendUnsubscribeCommand(channelsToUnsubscribe);
    _subscribedChannels.removeAll(channelsToUnsubscribe);
  }

  void _sendSubscribeCommand(List<String> channels) {
    final command = SubscribeCommand(channels);
    _connection.send(command.encoded);
  }

  void _sendUnsubscribeCommand(List<String> channels) {
    final command = UnsubscribeCommand(channels);
    _connection.send(command.encoded);
  }
}
