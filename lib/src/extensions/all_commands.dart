import 'dart:async';

import '../client/valkey_client.dart';
import '../commands/commands.dart';

/// Extends [ValkeyCommandClient] with all commands.
extension ValkeyCommands on ValkeyCommandClient {
  // Connection
  Future<bool> ping([String? message, Duration? timeout]) =>
      execute(PingCommand(message), timeout: timeout);
  Future<String> echo(String message, {Duration? timeout}) =>
      execute(EchoCommand(message), timeout: timeout);
  Future<String?> clientGetname({Duration? timeout}) =>
      execute(ClientGetnameCommand(), timeout: timeout);
  Future<int> clientId({Duration? timeout}) =>
      execute(ClientIdCommand(), timeout: timeout);
  Future<String> clientHelp({Duration? timeout}) =>
      execute(ClientHelpCommand(), timeout: timeout);
  Future<String> auth({
    required String password,
    String? username,
    Duration? timeout,
  }) =>
      execute(
        AuthCommand(username: username, password: password),
        timeout: timeout,
      );
  Future<String> clientSetname(String name, {Duration? timeout}) =>
      execute(ClientSetnameCommand(name), timeout: timeout);
  Future<void> quit({Duration? timeout}) async {
    try {
      await execute(QuitCommand(), timeout: timeout);
    } finally {
      await close();
    }
  }

  Future<String> reset({Duration? timeout}) =>
      execute(ResetCommand(), timeout: timeout);
  Future<String> clientCaching({required bool enable, Duration? timeout}) =>
      execute(ClientCachingCommand(enable: enable), timeout: timeout);
  Future<int> clientGetredir({Duration? timeout}) =>
      execute(ClientGetredirCommand(), timeout: timeout);
  Future<String> clientNoEvict({required bool enable, Duration? timeout}) =>
      execute(ClientNoEvictCommand(enable: enable), timeout: timeout);
  Future<String> clientNoTouch({required bool enable, Duration? timeout}) =>
      execute(ClientNoTouchCommand(enable: enable), timeout: timeout);
  Future<int> clientUnblock(
    int clientId, {
    UnblockType? unblockType,
    Duration? timeout,
  }) =>
      execute(
        ClientUnblockCommand(clientId, unblockType: unblockType),
        timeout: timeout,
      );
  Future<String> clientUnpause({Duration? timeout}) =>
      execute(ClientUnpauseCommand(), timeout: timeout);
  Future<Map<String, dynamic>> hello({
    int? protocolVersion,
    String? username,
    String? password,
    String? clientName,
    Duration? timeout,
  }) =>
      execute(
        HelloCommand(
          protocolVersion: protocolVersion,
          username: username,
          password: password,
          clientName: clientName,
        ),
        timeout: timeout,
      );

  // Hashes
  Future<int> hset(
    String key,
    Map<String, Object> fields, {
    Duration? timeout,
  }) =>
      execute(HSetCommand(key, fields), timeout: timeout);
  Future<String?> hget(String key, String field, {Duration? timeout}) =>
      execute(HGetCommand(key, field), timeout: timeout);
  Future<Map<String, String>> hgetall(String key, {Duration? timeout}) =>
      execute(HGetAllCommand(key), timeout: timeout);
  Future<int> hdel(String key, List<String> fields, {Duration? timeout}) =>
      execute(HDelCommand(key, fields), timeout: timeout);
  Future<bool> hexists(String key, String field, {Duration? timeout}) =>
      execute(HExistsCommand(key, field), timeout: timeout);
  Future<int> hincrby(
    String key,
    String field,
    int increment, {
    Duration? timeout,
  }) =>
      execute(HIncrByCommand(key, field, increment), timeout: timeout);
  Future<int> hlen(String key, {Duration? timeout}) =>
      execute(HLenCommand(key), timeout: timeout);
  Future<List<String?>> hmget(
    String key,
    List<String> fields, {
    Duration? timeout,
  }) =>
      execute(HMGetCommand(key, fields), timeout: timeout);
  Future<bool> hsetnx(
    String key,
    String field,
    String value, {
    Duration? timeout,
  }) =>
      execute(HSetNxCommand(key, field, value), timeout: timeout);
  Future<List<String>> hkeys(String key, {Duration? timeout}) =>
      execute(HKeysCommand(key), timeout: timeout);
  Future<List<String>> hvals(String key, {Duration? timeout}) =>
      execute(HValsCommand(key), timeout: timeout);
  Future<double> hincrbyfloat(
    String key,
    String field,
    double increment, {
    Duration? timeout,
  }) =>
      execute(HIncrByFloatCommand(key, field, increment), timeout: timeout);
  Future<int> hstrlen(String key, String field, {Duration? timeout}) =>
      execute(HStrLenCommand(key, field), timeout: timeout);

  // Keys
  Future<int> del(List<String> keys, {Duration? timeout}) =>
      execute(DelCommand(keys), timeout: timeout);
  Future<int> exists(List<String> keys, {Duration? timeout}) =>
      execute(ExistsCommand(keys), timeout: timeout);
  Future<int> ttl(String key, {Duration? timeout}) =>
      execute(TtlCommand(key), timeout: timeout);
  Future<bool> persist(String key, {Duration? timeout}) =>
      execute(PersistCommand(key), timeout: timeout);
  Future<String> type(String key, {Duration? timeout}) =>
      execute(TypeCommand(key), timeout: timeout);
  Future<bool> rename(String key, String newKey, {Duration? timeout}) =>
      execute(RenameCommand(key, newKey), timeout: timeout);
  Future<bool> renamenx(String key, String newKey, {Duration? timeout}) =>
      execute(RenameNxCommand(key, newKey), timeout: timeout);
  Future<bool> expire(
    String key,
    int seconds, {
    ExpireStrategyTypes strategyType = ExpireStrategyTypes.always,
    Duration? timeout,
  }) =>
      execute(
        ExpireCommand(key, seconds, strategyType: strategyType),
        timeout: timeout,
      );

  // Lists
  Future<int> lpush(String key, List<String> values, {Duration? timeout}) =>
      execute(LPushCommand(key, values), timeout: timeout);
  Future<int> rpush(String key, List<String> values, {Duration? timeout}) =>
      execute(RPushCommand(key, values), timeout: timeout);
  Future<dynamic> lpop(String key, [int? count, Duration? timeout]) =>
      execute(LPopCommand(key, count), timeout: timeout);
  Future<dynamic> rpop(String key, [int? count, Duration? timeout]) =>
      execute(RPopCommand(key, count), timeout: timeout);
  Future<int> llen(String key, {Duration? timeout}) =>
      execute(LLenCommand(key), timeout: timeout);
  Future<List<String>> lrange(
    String key,
    int start,
    int stop, {
    Duration? timeout,
  }) =>
      execute(LRangeCommand(key, start, stop), timeout: timeout);
  Future<String?> lindex(String key, int index, {Duration? timeout}) =>
      execute(LIndexCommand(key, index), timeout: timeout);
  Future<bool> ltrim(String key, int start, int stop, {Duration? timeout}) =>
      execute(LTrimCommand(key, start, stop), timeout: timeout);
  Future<int> linsert(
    String key,
    String pivot,
    String value, {
    required bool before,
    Duration? timeout,
  }) =>
      execute(
        LInsertCommand(key, pivot, value, before: before),
        timeout: timeout,
      );
  Future<int> lrem(String key, int count, String value, {Duration? timeout}) =>
      execute(LRemCommand(key, count, value), timeout: timeout);
  Future<String?> rpoplpush(
    String source,
    String destination, {
    Duration? timeout,
  }) =>
      execute(RPopLPushCommand(source, destination), timeout: timeout);

  // Sets
  Future<int> sadd(String key, List<String> members, {Duration? timeout}) =>
      execute(SAddCommand(key, members), timeout: timeout);
  Future<int> srem(String key, List<String> members, {Duration? timeout}) =>
      execute(SRemCommand(key, members), timeout: timeout);
  Future<bool> sismember(String key, String member, {Duration? timeout}) =>
      execute(SIsMemberCommand(key, member), timeout: timeout);
  Future<int> scard(String key, {Duration? timeout}) =>
      execute(SCardCommand(key), timeout: timeout);
  Future<List<String>> smembers(String key, {Duration? timeout}) =>
      execute(SMembersCommand(key), timeout: timeout);
  Future<String?> srandmember(String key, {Duration? timeout}) =>
      execute(SRandMemberCommand(key), timeout: timeout);
  Future<List<String>> srandmemberCount(
    String key,
    int count, {
    Duration? timeout,
  }) =>
      execute(SRandMemberCountCommand(key, count), timeout: timeout);
  Future<String?> spop(String key, {Duration? timeout}) =>
      execute(SPopCommand(key), timeout: timeout);
  Future<List<String>> spopCount(String key, int count, {Duration? timeout}) =>
      execute(SPopCountCommand(key, count), timeout: timeout);
  Future<List<String>> sunion(List<String> keys, {Duration? timeout}) =>
      execute(SUnionCommand(keys), timeout: timeout);
  Future<List<String>> sinter(List<String> keys, {Duration? timeout}) =>
      execute(SInterCommand(keys), timeout: timeout);
  Future<List<String>> sdiff(List<String> keys, {Duration? timeout}) =>
      execute(SDiffCommand(keys), timeout: timeout);
  Future<bool> smove(
    String source,
    String destination,
    String member, {
    Duration? timeout,
  }) =>
      execute(SMoveCommand(source, destination, member), timeout: timeout);
  Future<int> sunionstore(
    String destination,
    List<String> keys, {
    Duration? timeout,
  }) =>
      execute(SUnionStoreCommand(destination, keys), timeout: timeout);
  Future<int> sinterstore(
    String destination,
    List<String> keys, {
    Duration? timeout,
  }) =>
      execute(SInterStoreCommand(destination, keys), timeout: timeout);
  Future<int> sdiffstore(
    String destination,
    List<String> keys, {
    Duration? timeout,
  }) =>
      execute(SDiffStoreCommand(destination, keys), timeout: timeout);

  // Strings
  Future<String?> get(String key, {Duration? timeout}) =>
      execute(GetCommand(key), timeout: timeout);
  Future<bool?> set(
    String key,
    String value, {
    ExpireOption? expire,
    SetStrategyTypes strategyType = SetStrategyTypes.always,
    Duration? timeout,
  }) =>
      execute(
        SetCommand(
          key,
          value,
          expire: expire,
          strategyType: strategyType,
        ),
        timeout: timeout,
      );
  Future<String?> setAndGet(
    String key,
    String value, {
    ExpireOption? expire,
    SetStrategyTypes strategyType = SetStrategyTypes.always,
    Duration? timeout,
  }) =>
      execute(
        SetAndGetCommand(
          key,
          value,
          expire: expire,
          strategyType: strategyType,
        ),
        timeout: timeout,
      );
  Future<int> incr(String key, {Duration? timeout}) =>
      execute(IncrCommand(key), timeout: timeout);
  Future<int> decr(String key, {Duration? timeout}) =>
      execute(DecrCommand(key), timeout: timeout);
  Future<int> decrby(String key, int decrement, {Duration? timeout}) =>
      execute(DecrByCommand(key, decrement), timeout: timeout);
  Future<int> incrby(String key, int increment, {Duration? timeout}) =>
      execute(IncrByCommand(key, increment), timeout: timeout);
  Future<List<String?>> mget(List<String> keys, {Duration? timeout}) =>
      execute(MGetCommand(keys), timeout: timeout);
  Future<String> mset(Map<String, String> keyValuePairs, {Duration? timeout}) =>
      execute(MSetCommand(keyValuePairs), timeout: timeout);
  Future<int> append(String key, String value, {Duration? timeout}) =>
      execute(AppendCommand(key, value), timeout: timeout);
  Future<String> getrange(
    String key,
    int start,
    int end, {
    Duration? timeout,
  }) =>
      execute(GetRangeCommand(key, start, end), timeout: timeout);
  Future<int> setrange(
    String key,
    int offset,
    String value, {
    Duration? timeout,
  }) =>
      execute(SetRangeCommand(key, offset, value), timeout: timeout);
  Future<String?> getset(String key, String value, {Duration? timeout}) =>
      execute(GetSetCommand(key, value), timeout: timeout);
  Future<int> strlen(String key, {Duration? timeout}) =>
      execute(StrLenCommand(key), timeout: timeout);

  // ZSets
  Future<dynamic> zadd(
    String key,
    Map<String, double> membersWithScores, {
    bool onlyIfNotExists = false,
    bool onlyIfAlreadyExists = false,
    bool changed = false,
    bool incr = false,
    Duration? timeout,
  }) =>
      execute(
        ZAddCommand(
          key,
          membersWithScores,
          onlyIfNotExists: onlyIfNotExists,
          onlyIfAlreadyExists: onlyIfAlreadyExists,
          changed: changed,
          incr: incr,
        ),
        timeout: timeout,
      );
  Future<dynamic> zrange(
    String key,
    String start,
    String stop, {
    bool byLex = false,
    bool byScore = false,
    bool rev = false,
    int? limitOffset,
    int? limitCount,
    bool withScores = false,
    Duration? timeout,
  }) =>
      execute(
        ZRangeCommand(
          key,
          start,
          stop,
          byLex: byLex,
          byScore: byScore,
          rev: rev,
          limitOffset: limitOffset,
          limitCount: limitCount,
          withScores: withScores,
        ),
        timeout: timeout,
      );
  Future<List> zrangeWithScores(
    String key,
    String start,
    String stop, {
    bool byLex = false,
    bool byScore = false,
    bool rev = false,
    int? limitOffset,
    int? limitCount,
    Duration? timeout,
  }) =>
      execute(
        ZRangeCommand(
          key,
          start,
          stop,
          byLex: byLex,
          byScore: byScore,
          rev: rev,
          limitOffset: limitOffset,
          limitCount: limitCount,
          withScores: true,
        ),
        timeout: timeout,
      );
  Future<dynamic> zrangebyscore(
    String key,
    String min,
    String max, {
    bool withScores = false,
    int? limitOffset,
    int? limitCount,
    Duration? timeout,
  }) =>
      execute(
        ZRangeByScoreCommand(
          key,
          min,
          max,
          withScores: withScores,
          limitOffset: limitOffset,
          limitCount: limitCount,
        ),
        timeout: timeout,
      );
  Future<List> zrangebyscoreWithScores(
    String key,
    String min,
    String max, {
    int? limitOffset,
    int? limitCount,
    Duration? timeout,
  }) =>
      execute(
        ZRangeByScoreWithScoresCommand(
          key,
          min,
          max,
          limitOffset: limitOffset,
          limitCount: limitCount,
        ),
        timeout: timeout,
      );
  Future<int> zrem(String key, List<String> members, {Duration? timeout}) =>
      execute(ZRemCommand(key, members), timeout: timeout);
  Future<int> zcard(String key, {Duration? timeout}) =>
      execute(ZCardCommand(key), timeout: timeout);
  Future<double?> zscore(String key, String member, {Duration? timeout}) =>
      execute(ZScoreCommand(key, member), timeout: timeout);
  Future<double> zincrby(
    String key,
    double increment,
    String member, {
    Duration? timeout,
  }) =>
      execute(ZIncrByCommand(key, increment, member), timeout: timeout);
  Future<int> zcount(String key, String min, String max, {Duration? timeout}) =>
      execute(ZCountCommand(key, min, max), timeout: timeout);
  Future<int?> zrank(String key, String member, {Duration? timeout}) =>
      execute(ZRankCommand(key, member), timeout: timeout);
  Future<int?> zrevrank(String key, String member, {Duration? timeout}) =>
      execute(ZRevRankCommand(key, member), timeout: timeout);
  Future<dynamic> zrevrange(
    String key,
    String start,
    String stop, {
    bool byLex = false,
    bool byScore = false,
    int? limitOffset,
    int? limitCount,
    bool withScores = false,
    Duration? timeout,
  }) =>
      execute(
        ZRevRangeCommand(
          key,
          start,
          stop,
          byLex: byLex,
          byScore: byScore,
          limitOffset: limitOffset,
          limitCount: limitCount,
          withScores: withScores,
        ),
        timeout: timeout,
      );
  Future<List> zrevrangeWithScores(
    String key,
    String start,
    String stop, {
    bool byLex = false,
    bool byScore = false,
    int? limitOffset,
    int? limitCount,
    Duration? timeout,
  }) =>
      execute(
        ZRevRangeCommand(
          key,
          start,
          stop,
          byLex: byLex,
          byScore: byScore,
          limitOffset: limitOffset,
          limitCount: limitCount,
          withScores: true,
        ),
        timeout: timeout,
      );
  Future<dynamic> zrevrangebyscore(
    String key,
    String max,
    String min, {
    bool withScores = false,
    int? limitOffset,
    int? limitCount,
    Duration? timeout,
  }) =>
      execute(
        ZRevRangeByScoreCommand(
          key,
          max,
          min,
          withScores: withScores,
          limitOffset: limitOffset,
          limitCount: limitCount,
        ),
        timeout: timeout,
      );
  Future<List> zrevrangebyscoreWithScores(
    String key,
    String max,
    String min, {
    int? limitOffset,
    int? limitCount,
    Duration? timeout,
  }) =>
      execute(
        ZRevRangeByScoreWithScoresCommand(
          key,
          max,
          min,
          limitOffset: limitOffset,
          limitCount: limitCount,
        ),
        timeout: timeout,
      );

  // Pub/Sub
  /// Posts a [message] to a given [channel].
  ///
  /// Returns a [Future] that completes with the number of clients that received the message.
  Future<int> publish(String channel, String message, {Duration? timeout}) =>
      execute(PublishCommand(channel, message), timeout: timeout);

  /// Lists the currently active channels.
  ///
  /// Optionally a [pattern] can be specified to match channel names.
  Future<List<String>> pubsubChannels([String? pattern, Duration? timeout]) =>
      execute(PubsubChannelsCommand(pattern), timeout: timeout);

  /// Returns the number of subscriptions to patterns.
  Future<int> pubsubNumpat({Duration? timeout}) =>
      execute(PubsubNumpatCommand(), timeout: timeout);

  /// Returns the number of subscribers for the specified channels.
  Future<Map<String, int>> pubsubNumsub([
    List<String> channels = const [],
    Duration? timeout,
  ]) =>
      execute(PubsubNumsubCommand(channels), timeout: timeout);

  /// Returns the help text for the PUBSUB command.
  Future<List<String>> pubsubHelp({Duration? timeout}) =>
      execute(PubsubHelpCommand(), timeout: timeout);

  /// Posts a message to a shard channel.
  Future<int> spublish(String channel, String message, {Duration? timeout}) =>
      execute(SpublishCommand(channel, message), timeout: timeout);

  /// Lists the currently active shard channels.
  Future<List<String>> pubsubShardChannels([
    String? pattern,
    Duration? timeout,
  ]) =>
      execute(PubsubShardchannelsCommand(pattern), timeout: timeout);

  /// Returns the number of subscribers for the specified shard channels.
  Future<Map<String, int>> pubsubShardNumsub([
    List<String> channels = const [],
    Duration? timeout,
  ]) =>
      execute(PubsubShardnumsubCommand(channels), timeout: timeout);
}
