part of '../valkey_client.dart';

mixin ShardSubscriptionMixin on BaseValkeyClient {
  final Set<String> _subscribedShardChannels = {};

  List<String> get subscribedShardChannels => _subscribedShardChannels.toList();

  void ssubscribe(List<String> channels) {
    if (channels.isEmpty) return;
    final newChannels = channels
        .where((c) => !_subscribedShardChannels.contains(c))
        .toList();
    if (newChannels.isEmpty) return;
    _sendSsubscribeCommand(newChannels);
    _subscribedShardChannels.addAll(newChannels);
  }

  void sunsubscribe([List<String> channels = const []]) {
    final channelsToUnsubscribe = channels.isEmpty
        ? _subscribedShardChannels.toList()
        : channels;
    if (channelsToUnsubscribe.isEmpty) return;

    _sendSunsubscribeCommand(channelsToUnsubscribe);
    _subscribedShardChannels.removeAll(channelsToUnsubscribe);
  }

  void _sendSsubscribeCommand(List<String> channels) {
    final command = SsubscribeCommand(channels);
    _connection.send(command.encoded);
  }

  void _sendSunsubscribeCommand(List<String> channels) {
    final command = SunsubscribeCommand(channels);
    _connection.send(command.encoded);
  }
}
