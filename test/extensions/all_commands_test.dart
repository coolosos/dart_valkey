import 'dart:async';

import 'package:dart_valkey/src/client/valkey_client.dart';
import 'package:dart_valkey/src/commands/command.dart';
import 'package:dart_valkey/src/commands/connection/auth_command.dart';
import 'package:dart_valkey/src/commands/connection/client_caching_command.dart';
import 'package:dart_valkey/src/commands/connection/client_getname_command.dart';
import 'package:dart_valkey/src/commands/connection/client_getredir_command.dart';
import 'package:dart_valkey/src/commands/connection/client_help_command.dart';
import 'package:dart_valkey/src/commands/connection/client_id_command.dart';
import 'package:dart_valkey/src/commands/connection/client_no_evict_command.dart';
import 'package:dart_valkey/src/commands/connection/client_no_touch_command.dart';
import 'package:dart_valkey/src/commands/connection/client_setname_command.dart';
import 'package:dart_valkey/src/commands/connection/client_unblock_command.dart';
import 'package:dart_valkey/src/commands/connection/client_unpause_command.dart';
import 'package:dart_valkey/src/commands/connection/echo_command.dart';
import 'package:dart_valkey/src/commands/connection/hello_command.dart';
import 'package:dart_valkey/src/commands/connection/ping_command.dart';
import 'package:dart_valkey/src/commands/connection/quit_command.dart';
import 'package:dart_valkey/src/commands/connection/reset_command.dart';
import 'package:dart_valkey/src/commands/hash/hdel_command.dart';
import 'package:dart_valkey/src/commands/hash/hexists_command.dart';
import 'package:dart_valkey/src/commands/hash/hget_command.dart';
import 'package:dart_valkey/src/commands/hash/hgetall_command.dart';
import 'package:dart_valkey/src/commands/hash/hincrby_command.dart';
import 'package:dart_valkey/src/commands/hash/hincrbyfloat_command.dart';
import 'package:dart_valkey/src/commands/hash/hkeys_command.dart';
import 'package:dart_valkey/src/commands/hash/hlen_command.dart';
import 'package:dart_valkey/src/commands/hash/hmget_command.dart';
import 'package:dart_valkey/src/commands/hash/hset_command.dart';
import 'package:dart_valkey/src/commands/hash/hsetnx_command.dart';
import 'package:dart_valkey/src/commands/hash/hstrlen_command.dart';
import 'package:dart_valkey/src/commands/hash/hvals_command.dart';
import 'package:dart_valkey/src/commands/key/del_command.dart';
import 'package:dart_valkey/src/commands/key/exists_command.dart';
import 'package:dart_valkey/src/commands/key/persist_command.dart';
import 'package:dart_valkey/src/commands/key/rename_command.dart';
import 'package:dart_valkey/src/commands/key/renamenx_command.dart';
import 'package:dart_valkey/src/commands/key/ttl_command.dart';
import 'package:dart_valkey/src/commands/key/type_command.dart';
import 'package:dart_valkey/src/commands/list/lindex_command.dart';
import 'package:dart_valkey/src/commands/list/linsert_command.dart';
import 'package:dart_valkey/src/commands/list/llen_command.dart';
import 'package:dart_valkey/src/commands/list/lpop_command.dart';
import 'package:dart_valkey/src/commands/list/lpush_command.dart';
import 'package:dart_valkey/src/commands/list/lrange_command.dart';
import 'package:dart_valkey/src/commands/list/lrem_command.dart';
import 'package:dart_valkey/src/commands/list/ltrim_command.dart';
import 'package:dart_valkey/src/commands/list/rpop_command.dart';
import 'package:dart_valkey/src/commands/list/rpoplpush_command.dart';
import 'package:dart_valkey/src/commands/list/rpush_command.dart';
import 'package:dart_valkey/src/commands/pubsub/publish_command.dart';
import 'package:dart_valkey/src/commands/pubsub/pubsub_channels_command.dart';
import 'package:dart_valkey/src/commands/pubsub/pubsub_help_command.dart';
import 'package:dart_valkey/src/commands/pubsub/pubsub_numpat_command.dart';
import 'package:dart_valkey/src/commands/pubsub/pubsub_numsub_command.dart';
import 'package:dart_valkey/src/commands/pubsub/pubsub_shardchannels_command.dart';
import 'package:dart_valkey/src/commands/pubsub/pubsub_shardnumsub_command.dart';
import 'package:dart_valkey/src/commands/pubsub/spublish_command.dart';
import 'package:dart_valkey/src/commands/set/sadd_command.dart';
import 'package:dart_valkey/src/commands/set/scard_command.dart';
import 'package:dart_valkey/src/commands/set/sdiff_command.dart';
import 'package:dart_valkey/src/commands/set/sdiffstore_command.dart';
import 'package:dart_valkey/src/commands/set/sinter_command.dart';
import 'package:dart_valkey/src/commands/set/sinterstore_command.dart';
import 'package:dart_valkey/src/commands/set/sismember_command.dart';
import 'package:dart_valkey/src/commands/set/smembers_command.dart';
import 'package:dart_valkey/src/commands/set/smove_command.dart';
import 'package:dart_valkey/src/commands/set/spop_command.dart';
import 'package:dart_valkey/src/commands/set/spop_count_command.dart';
import 'package:dart_valkey/src/commands/set/srandmember_command.dart';
import 'package:dart_valkey/src/commands/set/srandmember_count_command.dart';
import 'package:dart_valkey/src/commands/set/srem_command.dart';
import 'package:dart_valkey/src/commands/set/sunion_command.dart';
import 'package:dart_valkey/src/commands/set/sunionstore_command.dart';
import 'package:dart_valkey/src/commands/strings/append_command.dart';
import 'package:dart_valkey/src/commands/strings/decr_command.dart';
import 'package:dart_valkey/src/commands/strings/decrby_command.dart';
import 'package:dart_valkey/src/commands/strings/expire_command.dart';
import 'package:dart_valkey/src/commands/strings/get_command.dart';
import 'package:dart_valkey/src/commands/strings/getrange_command.dart';
import 'package:dart_valkey/src/commands/strings/getset_command.dart';
import 'package:dart_valkey/src/commands/strings/incr_command.dart';
import 'package:dart_valkey/src/commands/strings/incrby_command.dart';
import 'package:dart_valkey/src/commands/strings/mget_command.dart';
import 'package:dart_valkey/src/commands/strings/mset_command.dart';
import 'package:dart_valkey/src/commands/strings/set_and_get_command.dart';
import 'package:dart_valkey/src/commands/strings/set_command.dart';
import 'package:dart_valkey/src/commands/strings/setrange_command.dart';
import 'package:dart_valkey/src/commands/strings/strlen_command.dart';
import 'package:dart_valkey/src/commands/zset/zadd_command.dart';
import 'package:dart_valkey/src/commands/zset/zcard_command.dart';
import 'package:dart_valkey/src/commands/zset/zcount_command.dart';
import 'package:dart_valkey/src/commands/zset/zincrby_command.dart';
import 'package:dart_valkey/src/commands/zset/zrange_command.dart';
import 'package:dart_valkey/src/commands/zset/zrangebyscore_command.dart';
import 'package:dart_valkey/src/commands/zset/zrangebyscore_with_scores_command.dart';
import 'package:dart_valkey/src/commands/zset/zrank_command.dart';
import 'package:dart_valkey/src/commands/zset/zrem_command.dart';
import 'package:dart_valkey/src/commands/zset/zrevrange_command.dart';
import 'package:dart_valkey/src/commands/zset/zrevrangebyscore_command.dart';
import 'package:dart_valkey/src/commands/zset/zrevrangebyscore_with_scores_command.dart';
import 'package:dart_valkey/src/commands/zset/zrevrank_command.dart';
import 'package:dart_valkey/src/commands/zset/zscore_command.dart';
import 'package:dart_valkey/src/extensions/all_commands.dart';
import 'package:test/test.dart';

// A simple mock ValkeyCommandClient for testing extension methods
class MockValkeyCommandClient extends ValkeyCommandClient {
  MockValkeyCommandClient() : super(host: 'localhost', port: 6379);

  Command? lastExecutedCommand;
  dynamic mockResponse;

  @override
  Future<T> execute<T>(ValkeyCommand<T> command) async {
    lastExecutedCommand = command;
    return command.parse(mockResponse);
  }

  @override
  Future<void> connect() async {}

  @override
  Future<void> close() async {}
}

void main() {
  group('ValkeyCommands Extension', () {
    late MockValkeyCommandClient mockClient;

    setUp(() {
      mockClient = MockValkeyCommandClient();
    });

    // Connection Commands
    test('ping calls PingCommand', () async {
      mockClient.mockResponse = 'PONG';
      await mockClient.ping();
      expect(mockClient.lastExecutedCommand, isA<PingCommand>());
    });

    test('echo calls EchoCommand', () async {
      mockClient.mockResponse = 'Hello';
      await mockClient.echo('Hello');
      expect(mockClient.lastExecutedCommand, isA<EchoCommand>());
      expect((mockClient.lastExecutedCommand! as EchoCommand).message, 'Hello');
    });

    test('clientGetname calls ClientGetnameCommand', () async {
      mockClient.mockResponse = 'myclient';
      await mockClient.clientGetname();
      expect(mockClient.lastExecutedCommand, isA<ClientGetnameCommand>());
    });

    test('clientId calls ClientIdCommand', () async {
      mockClient.mockResponse = 123;
      await mockClient.clientId();
      expect(mockClient.lastExecutedCommand, isA<ClientIdCommand>());
    });

    test('clientHelp calls ClientHelpCommand', () async {
      mockClient.mockResponse = 'Help text';
      await mockClient.clientHelp();
      expect(mockClient.lastExecutedCommand, isA<ClientHelpCommand>());
    });

    test('auth calls AuthCommand with password', () async {
      mockClient.mockResponse = 'OK';
      await mockClient.auth(password: 'pass');
      expect(mockClient.lastExecutedCommand, isA<AuthCommand>());
      expect((mockClient.lastExecutedCommand! as AuthCommand).password, 'pass');
    });

    test('auth calls AuthCommand with username and password', () async {
      mockClient.mockResponse = 'OK';
      await mockClient.auth(username: 'user', password: 'pass');
      expect(mockClient.lastExecutedCommand, isA<AuthCommand>());
      expect((mockClient.lastExecutedCommand! as AuthCommand).username, 'user');
      expect((mockClient.lastExecutedCommand! as AuthCommand).password, 'pass');
    });

    test('clientSetname calls ClientSetnameCommand', () async {
      mockClient.mockResponse = 'OK';
      await mockClient.clientSetname('newname');
      expect(mockClient.lastExecutedCommand, isA<ClientSetnameCommand>());
      expect(
        (mockClient.lastExecutedCommand! as ClientSetnameCommand).name,
        'newname',
      );
    });

    test('quit calls QuitCommand and closes client', () async {
      mockClient.mockResponse = 'OK';
      await mockClient.quit();
      expect(mockClient.lastExecutedCommand, isA<QuitCommand>());
      // Mocking close is harder without mockito, assume it's called.
    });

    test('reset calls ResetCommand', () async {
      mockClient.mockResponse = 'RESET';
      await mockClient.reset();
      expect(mockClient.lastExecutedCommand, isA<ResetCommand>());
    });

    test('clientCaching calls ClientCachingCommand', () async {
      mockClient.mockResponse = 'OK';
      await mockClient.clientCaching(enable: true);
      expect(mockClient.lastExecutedCommand, isA<ClientCachingCommand>());
      expect(
        (mockClient.lastExecutedCommand! as ClientCachingCommand).enable,
        isTrue,
      );
    });

    test('clientGetredir calls ClientGetredirCommand', () async {
      mockClient.mockResponse = 0;
      await mockClient.clientGetredir();
      expect(mockClient.lastExecutedCommand, isA<ClientGetredirCommand>());
    });

    test('clientNoEvict calls ClientNoEvictCommand', () async {
      mockClient.mockResponse = 'OK';
      await mockClient.clientNoEvict(enable: true);
      expect(mockClient.lastExecutedCommand, isA<ClientNoEvictCommand>());
      expect(
        (mockClient.lastExecutedCommand! as ClientNoEvictCommand).enable,
        isTrue,
      );
    });

    test('clientNoTouch calls ClientNoTouchCommand', () async {
      mockClient.mockResponse = 'OK';
      await mockClient.clientNoTouch(enable: true);
      expect(mockClient.lastExecutedCommand, isA<ClientNoTouchCommand>());
      expect(
        (mockClient.lastExecutedCommand! as ClientNoTouchCommand).enable,
        isTrue,
      );
    });

    test('clientUnblock calls ClientUnblockCommand', () async {
      mockClient.mockResponse = 1;
      await mockClient.clientUnblock(123);
      expect(mockClient.lastExecutedCommand, isA<ClientUnblockCommand>());
      expect(
        (mockClient.lastExecutedCommand! as ClientUnblockCommand).clientId,
        123,
      );
    });

    test('clientUnpause calls ClientUnpauseCommand', () async {
      mockClient.mockResponse = 'OK';
      await mockClient.clientUnpause();
      expect(mockClient.lastExecutedCommand, isA<ClientUnpauseCommand>());
    });

    test('hello calls HelloCommand', () async {
      mockClient.mockResponse = {'server': 'valkey'};
      await mockClient.hello(protocolVersion: 3);
      expect(mockClient.lastExecutedCommand, isA<HelloCommand>());
      expect(
        (mockClient.lastExecutedCommand! as HelloCommand).protocolVersion,
        3,
      );
    });

    // Hash Commands
    test('hset calls HSetCommand', () async {
      mockClient.mockResponse = 1;
      await mockClient.hset('key', {'field': 'value'});
      expect(mockClient.lastExecutedCommand, isA<HSetCommand>());
      expect((mockClient.lastExecutedCommand! as HSetCommand).key, 'key');
    });

    test('hget calls HGetCommand', () async {
      mockClient.mockResponse = 'value';
      await mockClient.hget('key', 'field');
      expect(mockClient.lastExecutedCommand, isA<HGetCommand>());
      expect((mockClient.lastExecutedCommand! as HGetCommand).key, 'key');
    });

    test('hgetall calls HGetAllCommand', () async {
      mockClient.mockResponse = ['field', 'value'];
      await mockClient.hgetall('key');
      expect(mockClient.lastExecutedCommand, isA<HGetAllCommand>());
      expect((mockClient.lastExecutedCommand! as HGetAllCommand).key, 'key');
    });

    test('hdel calls HDelCommand', () async {
      mockClient.mockResponse = 1;
      await mockClient.hdel('key', ['field']);
      expect(mockClient.lastExecutedCommand, isA<HDelCommand>());
      expect((mockClient.lastExecutedCommand! as HDelCommand).key, 'key');
    });

    test('hexists calls HExistsCommand', () async {
      mockClient.mockResponse = 1;
      await mockClient.hexists('key', 'field');
      expect(mockClient.lastExecutedCommand, isA<HExistsCommand>());
      expect((mockClient.lastExecutedCommand! as HExistsCommand).key, 'key');
    });

    test('hincrby calls HIncrByCommand', () async {
      mockClient.mockResponse = 1;
      await mockClient.hincrby('key', 'field', 1);
      expect(mockClient.lastExecutedCommand, isA<HIncrByCommand>());
      expect((mockClient.lastExecutedCommand! as HIncrByCommand).key, 'key');
    });

    test('hlen calls HLenCommand', () async {
      mockClient.mockResponse = 1;
      await mockClient.hlen('key');
      expect(mockClient.lastExecutedCommand, isA<HLenCommand>());
      expect((mockClient.lastExecutedCommand! as HLenCommand).key, 'key');
    });

    test('hmget calls HMGetCommand', () async {
      mockClient.mockResponse = ['value'];
      await mockClient.hmget('key', ['field']);
      expect(mockClient.lastExecutedCommand, isA<HMGetCommand>());
      expect((mockClient.lastExecutedCommand! as HMGetCommand).key, 'key');
    });

    test('hsetnx calls HSetNxCommand', () async {
      mockClient.mockResponse = 1;
      await mockClient.hsetnx('key', 'field', 'value');
      expect(mockClient.lastExecutedCommand, isA<HSetNxCommand>());
      expect((mockClient.lastExecutedCommand! as HSetNxCommand).key, 'key');
    });

    test('hkeys calls HKeysCommand', () async {
      mockClient.mockResponse = ['field'];
      await mockClient.hkeys('key');
      expect(mockClient.lastExecutedCommand, isA<HKeysCommand>());
      expect((mockClient.lastExecutedCommand! as HKeysCommand).key, 'key');
    });

    test('hvals calls HValsCommand', () async {
      mockClient.mockResponse = ['value'];
      await mockClient.hvals('key');
      expect(mockClient.lastExecutedCommand, isA<HValsCommand>());
      expect((mockClient.lastExecutedCommand! as HValsCommand).key, 'key');
    });

    test('hincrbyfloat calls HIncrByFloatCommand', () async {
      mockClient.mockResponse = '1.5';
      await mockClient.hincrbyfloat('key', 'field', 1.5);
      expect(mockClient.lastExecutedCommand, isA<HIncrByFloatCommand>());
      expect(
        (mockClient.lastExecutedCommand! as HIncrByFloatCommand).key,
        'key',
      );
    });

    test('hstrlen calls HStrLenCommand', () async {
      mockClient.mockResponse = 5;
      await mockClient.hstrlen('key', 'field');
      expect(mockClient.lastExecutedCommand, isA<HStrLenCommand>());
      expect((mockClient.lastExecutedCommand! as HStrLenCommand).key, 'key');
    });

    // Key Commands
    test('del calls DelCommand', () async {
      mockClient.mockResponse = 1;
      await mockClient.del(['key']);
      expect(mockClient.lastExecutedCommand, isA<DelCommand>());
      expect((mockClient.lastExecutedCommand! as DelCommand).keys, ['key']);
    });

    test('exists calls ExistsCommand', () async {
      mockClient.mockResponse = 1;
      await mockClient.exists(['key']);
      expect(mockClient.lastExecutedCommand, isA<ExistsCommand>());
      expect((mockClient.lastExecutedCommand! as ExistsCommand).keys, ['key']);
    });

    test('ttl calls TtlCommand', () async {
      mockClient.mockResponse = 60;
      await mockClient.ttl('key');
      expect(mockClient.lastExecutedCommand, isA<TtlCommand>());
      expect((mockClient.lastExecutedCommand! as TtlCommand).key, 'key');
    });

    test('persist calls PersistCommand', () async {
      mockClient.mockResponse = 1;
      await mockClient.persist('key');
      expect(mockClient.lastExecutedCommand, isA<PersistCommand>());
      expect((mockClient.lastExecutedCommand! as PersistCommand).key, 'key');
    });

    test('type calls TypeCommand', () async {
      mockClient.mockResponse = 'string';
      await mockClient.type('key');
      expect(mockClient.lastExecutedCommand, isA<TypeCommand>());
      expect((mockClient.lastExecutedCommand! as TypeCommand).key, 'key');
    });

    test('rename calls RenameCommand', () async {
      mockClient.mockResponse = 'OK';
      await mockClient.rename('oldkey', 'newkey');
      expect(mockClient.lastExecutedCommand, isA<RenameCommand>());
      expect((mockClient.lastExecutedCommand! as RenameCommand).key, 'oldkey');
    });

    test('renamenx calls RenameNxCommand', () async {
      mockClient.mockResponse = 1;
      await mockClient.renamenx('oldkey', 'newkey');
      expect(mockClient.lastExecutedCommand, isA<RenameNxCommand>());
      expect(
        (mockClient.lastExecutedCommand! as RenameNxCommand).key,
        'oldkey',
      );
    });

    test('expire calls ExpireCommand', () async {
      mockClient.mockResponse = 1;
      await mockClient.expire('key', 60);
      expect(mockClient.lastExecutedCommand, isA<ExpireCommand>());
      expect((mockClient.lastExecutedCommand! as ExpireCommand).key, 'key');
    });

    // List Commands
    test('lpush calls LPushCommand', () async {
      mockClient.mockResponse = 1;
      await mockClient.lpush('key', ['value']);
      expect(mockClient.lastExecutedCommand, isA<LPushCommand>());
      expect((mockClient.lastExecutedCommand! as LPushCommand).key, 'key');
    });

    test('rpush calls RPushCommand', () async {
      mockClient.mockResponse = 1;
      await mockClient.rpush('key', ['value']);
      expect(mockClient.lastExecutedCommand, isA<RPushCommand>());
      expect((mockClient.lastExecutedCommand! as RPushCommand).key, 'key');
    });

    test('lpop calls LPopCommand', () async {
      mockClient.mockResponse = ['value'];
      await mockClient.lpop('key');
      expect(mockClient.lastExecutedCommand, isA<LPopCommand>());
      expect((mockClient.lastExecutedCommand! as LPopCommand).key, 'key');
    });

    test('rpop calls RPopCommand', () async {
      mockClient.mockResponse = ['value'];
      await mockClient.rpop('key');
      expect(mockClient.lastExecutedCommand, isA<RPopCommand>());
      expect((mockClient.lastExecutedCommand! as RPopCommand).key, 'key');
    });

    test('llen calls LLenCommand', () async {
      mockClient.mockResponse = 1;
      await mockClient.llen('key');
      expect(mockClient.lastExecutedCommand, isA<LLenCommand>());
      expect((mockClient.lastExecutedCommand! as LLenCommand).key, 'key');
    });

    test('lrange calls LRangeCommand', () async {
      mockClient.mockResponse = ['value'];
      await mockClient.lrange('key', 0, -1);
      expect(mockClient.lastExecutedCommand, isA<LRangeCommand>());
      expect((mockClient.lastExecutedCommand! as LRangeCommand).key, 'key');
    });

    test('lindex calls LIndexCommand', () async {
      mockClient.mockResponse = 'value';
      await mockClient.lindex('key', 0);
      expect(mockClient.lastExecutedCommand, isA<LIndexCommand>());
      expect((mockClient.lastExecutedCommand! as LIndexCommand).key, 'key');
    });

    test('ltrim calls LTrimCommand', () async {
      mockClient.mockResponse = 'OK';
      await mockClient.ltrim('key', 0, 0);
      expect(mockClient.lastExecutedCommand, isA<LTrimCommand>());
      expect((mockClient.lastExecutedCommand! as LTrimCommand).key, 'key');
    });

    test('linsert calls LInsertCommand', () async {
      mockClient.mockResponse = 1;
      await mockClient.linsert('key', 'pivot', 'value', before: true);
      expect(mockClient.lastExecutedCommand, isA<LInsertCommand>());
      expect((mockClient.lastExecutedCommand! as LInsertCommand).key, 'key');
    });

    test('lrem calls LRemCommand', () async {
      mockClient.mockResponse = 1;
      await mockClient.lrem('key', 1, 'value');
      expect(mockClient.lastExecutedCommand, isA<LRemCommand>());
      expect((mockClient.lastExecutedCommand! as LRemCommand).key, 'key');
    });

    test('rpoplpush calls RPopLPushCommand', () async {
      mockClient.mockResponse = 'value';
      await mockClient.rpoplpush('source', 'destination');
      expect(mockClient.lastExecutedCommand, isA<RPopLPushCommand>());
      expect(
        (mockClient.lastExecutedCommand! as RPopLPushCommand).source,
        'source',
      );
    });

    // Set Commands
    test('sadd calls SAddCommand', () async {
      mockClient.mockResponse = 1;
      await mockClient.sadd('key', ['member']);
      expect(mockClient.lastExecutedCommand, isA<SAddCommand>());
      expect((mockClient.lastExecutedCommand! as SAddCommand).key, 'key');
    });

    test('srem calls SRemCommand', () async {
      mockClient.mockResponse = 1;
      await mockClient.srem('key', ['member']);
      expect(mockClient.lastExecutedCommand, isA<SRemCommand>());
      expect((mockClient.lastExecutedCommand! as SRemCommand).key, 'key');
    });

    test('sismember calls SIsMemberCommand', () async {
      mockClient.mockResponse = 1;
      await mockClient.sismember('key', 'member');
      expect(mockClient.lastExecutedCommand, isA<SIsMemberCommand>());
      expect((mockClient.lastExecutedCommand! as SIsMemberCommand).key, 'key');
    });

    test('scard calls SCardCommand', () async {
      mockClient.mockResponse = 1;
      await mockClient.scard('key');
      expect(mockClient.lastExecutedCommand, isA<SCardCommand>());
      expect((mockClient.lastExecutedCommand! as SCardCommand).key, 'key');
    });

    test('smembers calls SMembersCommand', () async {
      mockClient.mockResponse = ['member'];
      await mockClient.smembers('key');
      expect(mockClient.lastExecutedCommand, isA<SMembersCommand>());
      expect((mockClient.lastExecutedCommand! as SMembersCommand).key, 'key');
    });

    test('srandmember calls SRandMemberCommand', () async {
      mockClient.mockResponse = 'member';
      await mockClient.srandmember('key');
      expect(mockClient.lastExecutedCommand, isA<SRandMemberCommand>());
      expect(
        (mockClient.lastExecutedCommand! as SRandMemberCommand).key,
        'key',
      );
    });

    test('srandmemberCount calls SRandMemberCountCommand', () async {
      mockClient.mockResponse = ['member'];
      await mockClient.srandmemberCount('key', 1);
      expect(mockClient.lastExecutedCommand, isA<SRandMemberCountCommand>());
      expect(
        (mockClient.lastExecutedCommand! as SRandMemberCountCommand).key,
        'key',
      );
    });

    test('spop calls SPopCommand', () async {
      mockClient.mockResponse = 'member';
      await mockClient.spop('key');
      expect(mockClient.lastExecutedCommand, isA<SPopCommand>());
      expect((mockClient.lastExecutedCommand! as SPopCommand).key, 'key');
    });

    test('spopCount calls SPopCountCommand', () async {
      mockClient.mockResponse = ['member'];
      await mockClient.spopCount('key', 1);
      expect(mockClient.lastExecutedCommand, isA<SPopCountCommand>());
      expect((mockClient.lastExecutedCommand! as SPopCountCommand).key, 'key');
    });

    test('sunion calls SUnionCommand', () async {
      mockClient.mockResponse = ['member'];
      await mockClient.sunion(['key']);
      expect(mockClient.lastExecutedCommand, isA<SUnionCommand>());
      expect((mockClient.lastExecutedCommand! as SUnionCommand).keys, ['key']);
    });

    test('sinter calls SInterCommand', () async {
      mockClient.mockResponse = ['member'];
      await mockClient.sinter(['key']);
      expect(mockClient.lastExecutedCommand, isA<SInterCommand>());
      expect((mockClient.lastExecutedCommand! as SInterCommand).keys, ['key']);
    });

    test('sdiff calls SDiffCommand', () async {
      mockClient.mockResponse = ['member'];
      await mockClient.sdiff(['key']);
      expect(mockClient.lastExecutedCommand, isA<SDiffCommand>());
      expect((mockClient.lastExecutedCommand! as SDiffCommand).keys, ['key']);
    });

    test('smove calls SMoveCommand', () async {
      mockClient.mockResponse = 1;
      await mockClient.smove('source', 'destination', 'member');
      expect(mockClient.lastExecutedCommand, isA<SMoveCommand>());
      expect(
        (mockClient.lastExecutedCommand! as SMoveCommand).source,
        'source',
      );
    });

    test('sunionstore calls SUnionStoreCommand', () async {
      mockClient.mockResponse = 1;
      await mockClient.sunionstore('destination', ['key']);
      expect(mockClient.lastExecutedCommand, isA<SUnionStoreCommand>());
      expect(
        (mockClient.lastExecutedCommand! as SUnionStoreCommand).destination,
        'destination',
      );
    });

    test('sinterstore calls SInterStoreCommand', () async {
      mockClient.mockResponse = 1;
      await mockClient.sinterstore('destination', ['key']);
      expect(mockClient.lastExecutedCommand, isA<SInterStoreCommand>());
      expect(
        (mockClient.lastExecutedCommand! as SInterStoreCommand).destination,
        'destination',
      );
    });

    test('sdiffstore calls SDiffStoreCommand', () async {
      mockClient.mockResponse = 1;
      await mockClient.sdiffstore('destination', ['key']);
      expect(mockClient.lastExecutedCommand, isA<SDiffStoreCommand>());
      expect(
        (mockClient.lastExecutedCommand! as SDiffStoreCommand).destination,
        'destination',
      );
    });

    // String Commands
    test('get calls GetCommand', () async {
      mockClient.mockResponse = 'value';
      await mockClient.get('key');
      expect(mockClient.lastExecutedCommand, isA<GetCommand>());
      expect((mockClient.lastExecutedCommand! as GetCommand).key, 'key');
    });

    test('set calls SetCommand', () async {
      mockClient.mockResponse = 'OK';
      await mockClient.set('key', 'value');
      expect(mockClient.lastExecutedCommand, isA<SetCommand>());
      expect((mockClient.lastExecutedCommand! as SetCommand).key, 'key');
    });

    test('setAndGet calls SetAndGetCommand', () async {
      mockClient.mockResponse = 'oldvalue';
      await mockClient.setAndGet('key', 'value');
      expect(mockClient.lastExecutedCommand, isA<SetAndGetCommand>());
      expect((mockClient.lastExecutedCommand! as SetAndGetCommand).key, 'key');
    });

    test('incr calls IncrCommand', () async {
      mockClient.mockResponse = 1;
      await mockClient.incr('key');
      expect(mockClient.lastExecutedCommand, isA<IncrCommand>());
      expect((mockClient.lastExecutedCommand! as IncrCommand).key, 'key');
    });

    test('decr calls DecrCommand', () async {
      mockClient.mockResponse = 1;
      await mockClient.decr('key');
      expect(mockClient.lastExecutedCommand, isA<DecrCommand>());
      expect((mockClient.lastExecutedCommand! as DecrCommand).key, 'key');
    });

    test('decrby calls DecrByCommand', () async {
      mockClient.mockResponse = 1;
      await mockClient.decrby('key', 1);
      expect(mockClient.lastExecutedCommand, isA<DecrByCommand>());
      expect((mockClient.lastExecutedCommand! as DecrByCommand).key, 'key');
    });

    test('incrby calls IncrByCommand', () async {
      mockClient.mockResponse = 1;
      await mockClient.incrby('key', 1);
      expect(mockClient.lastExecutedCommand, isA<IncrByCommand>());
      expect((mockClient.lastExecutedCommand! as IncrByCommand).key, 'key');
    });

    test('mget calls MGetCommand', () async {
      mockClient.mockResponse = ['value'];
      await mockClient.mget(['key']);
      expect(mockClient.lastExecutedCommand, isA<MGetCommand>());
      expect((mockClient.lastExecutedCommand! as MGetCommand).keys, ['key']);
    });

    test('mset calls MSetCommand', () async {
      mockClient.mockResponse = 'OK';
      await mockClient.mset({'key': 'value'});
      expect(mockClient.lastExecutedCommand, isA<MSetCommand>());
      expect(
        (mockClient.lastExecutedCommand! as MSetCommand).keyValuePairs,
        {'key': 'value'},
      );
    });

    test('append calls AppendCommand', () async {
      mockClient.mockResponse = 1;
      await mockClient.append('key', 'value');
      expect(mockClient.lastExecutedCommand, isA<AppendCommand>());
      expect((mockClient.lastExecutedCommand! as AppendCommand).key, 'key');
    });

    test('getrange calls GetRangeCommand', () async {
      mockClient.mockResponse = 'value';
      await mockClient.getrange('key', 0, 1);
      expect(mockClient.lastExecutedCommand, isA<GetRangeCommand>());
      expect((mockClient.lastExecutedCommand! as GetRangeCommand).key, 'key');
    });

    test('setrange calls SetRangeCommand', () async {
      mockClient.mockResponse = 1;
      await mockClient.setrange('key', 0, 'value');
      expect(mockClient.lastExecutedCommand, isA<SetRangeCommand>());
      expect((mockClient.lastExecutedCommand! as SetRangeCommand).key, 'key');
    });

    test('getset calls GetSetCommand', () async {
      mockClient.mockResponse = 'oldvalue';
      await mockClient.getset('key', 'newvalue');
      expect(mockClient.lastExecutedCommand, isA<GetSetCommand>());
      expect((mockClient.lastExecutedCommand! as GetSetCommand).key, 'key');
    });

    test('strlen calls StrLenCommand', () async {
      mockClient.mockResponse = 5;
      await mockClient.strlen('key');
      expect(mockClient.lastExecutedCommand, isA<StrLenCommand>());
      expect((mockClient.lastExecutedCommand! as StrLenCommand).key, 'key');
    });

    // ZSet Commands
    test('zadd calls ZAddCommand', () async {
      mockClient.mockResponse = 1;
      await mockClient.zadd('key', {'member': 1.0});
      expect(mockClient.lastExecutedCommand, isA<ZAddCommand>());
      expect((mockClient.lastExecutedCommand! as ZAddCommand).key, 'key');
    });

    test('zrange calls ZRangeCommand', () async {
      mockClient.mockResponse = ['member'];
      await mockClient.zrange('key', '0', '-1');
      expect(mockClient.lastExecutedCommand, isA<ZRangeCommand>());
      expect((mockClient.lastExecutedCommand! as ZRangeCommand).key, 'key');
    });

    test('zrangeWithScores calls ZRangeCommand with withScores true', () async {
      mockClient.mockResponse = ['member', '1.0'];
      await mockClient.zrangeWithScores('key', '0', '-1');
      expect(mockClient.lastExecutedCommand, isA<ZRangeCommand>());
      expect(
        (mockClient.lastExecutedCommand! as ZRangeCommand).withScores,
        isTrue,
      );
    });

    test('zrangebyscore calls ZRangeByScoreCommand', () async {
      mockClient.mockResponse = ['member'];
      await mockClient.zrangebyscore('key', '0', '1');
      expect(mockClient.lastExecutedCommand, isA<ZRangeByScoreCommand>());
      expect(
        (mockClient.lastExecutedCommand! as ZRangeByScoreCommand).key,
        'key',
      );
    });

    test('zrangebyscoreWithScores calls ZRangeByScoreWithScoresCommand',
        () async {
      mockClient.mockResponse = ['member', '1.0'];
      await mockClient.zrangebyscoreWithScores('key', '0', '1');
      expect(
        mockClient.lastExecutedCommand,
        isA<ZRangeByScoreWithScoresCommand>(),
      );
      expect(
        (mockClient.lastExecutedCommand! as ZRangeByScoreWithScoresCommand).key,
        'key',
      );
    });

    test('zrem calls ZRemCommand', () async {
      mockClient.mockResponse = 1;
      await mockClient.zrem('key', ['member']);
      expect(mockClient.lastExecutedCommand, isA<ZRemCommand>());
      expect((mockClient.lastExecutedCommand! as ZRemCommand).key, 'key');
    });

    test('zcard calls ZCardCommand', () async {
      mockClient.mockResponse = 1;
      await mockClient.zcard('key');
      expect(mockClient.lastExecutedCommand, isA<ZCardCommand>());
      expect((mockClient.lastExecutedCommand! as ZCardCommand).key, 'key');
    });

    test('zscore calls ZScoreCommand', () async {
      mockClient.mockResponse = '1.0';
      await mockClient.zscore('key', 'member');
      expect(mockClient.lastExecutedCommand, isA<ZScoreCommand>());
      expect((mockClient.lastExecutedCommand! as ZScoreCommand).key, 'key');
    });

    test('zincrby calls ZIncrByCommand', () async {
      mockClient.mockResponse = '1.0';
      await mockClient.zincrby('key', 1, 'member');
      expect(mockClient.lastExecutedCommand, isA<ZIncrByCommand>());
      expect((mockClient.lastExecutedCommand! as ZIncrByCommand).key, 'key');
    });

    test('zcount calls ZCountCommand', () async {
      mockClient.mockResponse = 1;
      await mockClient.zcount('key', '0', '1');
      expect(mockClient.lastExecutedCommand, isA<ZCountCommand>());
      expect((mockClient.lastExecutedCommand! as ZCountCommand).key, 'key');
    });

    test('zrank calls ZRankCommand', () async {
      mockClient.mockResponse = 0;
      await mockClient.zrank('key', 'member');
      expect(mockClient.lastExecutedCommand, isA<ZRankCommand>());
      expect((mockClient.lastExecutedCommand! as ZRankCommand).key, 'key');
    });

    test('zrevrank calls ZRevRankCommand', () async {
      mockClient.mockResponse = 0;
      await mockClient.zrevrank('key', 'member');
      expect(mockClient.lastExecutedCommand, isA<ZRevRankCommand>());
      expect((mockClient.lastExecutedCommand! as ZRevRankCommand).key, 'key');
    });

    test('zrevrange calls ZRevRangeCommand', () async {
      mockClient.mockResponse = ['member'];
      await mockClient.zrevrange('key', '0', '-1');
      expect(mockClient.lastExecutedCommand, isA<ZRevRangeCommand>());
      expect((mockClient.lastExecutedCommand! as ZRevRangeCommand).key, 'key');
    });

    test('zrevrangeWithScores calls ZRevRangeCommand with withScores true',
        () async {
      mockClient.mockResponse = ['member', '1.0'];
      await mockClient.zrevrangeWithScores('key', '0', '-1');
      expect(mockClient.lastExecutedCommand, isA<ZRevRangeCommand>());
      expect(
        (mockClient.lastExecutedCommand! as ZRevRangeCommand).withScores,
        isTrue,
      );
    });

    test('zrevrangebyscore calls ZRevRangeByScoreCommand', () async {
      mockClient.mockResponse = ['member'];
      await mockClient.zrevrangebyscore('key', '0', '1');
      expect(mockClient.lastExecutedCommand, isA<ZRevRangeByScoreCommand>());
      expect(
        (mockClient.lastExecutedCommand! as ZRevRangeByScoreCommand).key,
        'key',
      );
    });

    test('zrevrangebyscoreWithScores calls ZRevRangeByScoreWithScoresCommand',
        () async {
      mockClient.mockResponse = ['member', '1.0'];
      await mockClient.zrevrangebyscoreWithScores('key', '0', '1');
      expect(
        mockClient.lastExecutedCommand,
        isA<ZRevRangeByScoreWithScoresCommand>(),
      );
      expect(
        (mockClient.lastExecutedCommand! as ZRevRangeByScoreWithScoresCommand)
            .key,
        'key',
      );
    });

    // Pub/Sub Commands
    test('publish calls PublishCommand', () async {
      mockClient.mockResponse = 1;
      await mockClient.publish('channel', 'message');
      expect(mockClient.lastExecutedCommand, isA<PublishCommand>());
      expect(
        (mockClient.lastExecutedCommand! as PublishCommand).channel,
        'channel',
      );
    });

    test('pubsubChannels calls PubsubChannelsCommand', () async {
      mockClient.mockResponse = ['channel'];
      await mockClient.pubsubChannels();
      expect(mockClient.lastExecutedCommand, isA<PubsubChannelsCommand>());
    });

    test('pubsubNumpat calls PubsubNumpatCommand', () async {
      mockClient.mockResponse = 1;
      await mockClient.pubsubNumpat();
      expect(mockClient.lastExecutedCommand, isA<PubsubNumpatCommand>());
    });

    test('pubsubNumsub calls PubsubNumsubCommand', () async {
      mockClient.mockResponse = ['channel', 1];
      await mockClient.pubsubNumsub(['channel']);
      expect(mockClient.lastExecutedCommand, isA<PubsubNumsubCommand>());
      expect(
        (mockClient.lastExecutedCommand! as PubsubNumsubCommand).channels,
        ['channel'],
      );
    });

    test('pubsubHelp calls PubsubHelpCommand', () async {
      mockClient.mockResponse = ['help'];
      await mockClient.pubsubHelp();
      expect(mockClient.lastExecutedCommand, isA<PubsubHelpCommand>());
    });

    test('spublish calls SpublishCommand', () async {
      mockClient.mockResponse = 1;
      await mockClient.spublish('channel', 'message');
      expect(mockClient.lastExecutedCommand, isA<SpublishCommand>());
      expect(
        (mockClient.lastExecutedCommand! as SpublishCommand).channel,
        'channel',
      );
    });

    test('pubsubShardChannels calls PubsubShardchannelsCommand', () async {
      mockClient.mockResponse = ['channel'];
      await mockClient.pubsubShardChannels();
      expect(mockClient.lastExecutedCommand, isA<PubsubShardchannelsCommand>());
    });

    test('pubsubShardNumsub calls PubsubShardnumsubCommand', () async {
      mockClient.mockResponse = ['channel', 1];
      await mockClient.pubsubShardNumsub(['channel']);
      expect(mockClient.lastExecutedCommand, isA<PubsubShardnumsubCommand>());
      expect(
        (mockClient.lastExecutedCommand! as PubsubShardnumsubCommand).channels,
        ['channel'],
      );
    });
  });
}
