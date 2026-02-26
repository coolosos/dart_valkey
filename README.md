
#### dart valkey/redis

[![Pub Version](https://badgen.net/pub/v/dart_valkey)](https://pub.dev/packages/dart_valkey/)
[![Pub Likes](https://badgen.net/pub/likes/dart_valkey)](https://pub.dev/packages/dart_valkey/score)
[![Pub Points](https://badgen.net/pub/points/dart_valkey)](https://pub.dev/packages/dart_valkey/score)
[![Pub Downloads](https://badgen.net/pub/dm/dart_valkey)](https://pub.dev/packages/dart_valkey)
[![Dart SDK Version](https://badgen.net/pub/sdk-version/dart_valkey)](https://pub.dev/packages/dart_valkey/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/coolosos/dart_valkey/blob/main/LICENSE)
[![](https://img.shields.io/badge/linted%20by-coolint-0553B1)](https://pub.dev/packages/coolint)
[![codecov](https://codecov.io/gh/coolosos/dart_valkey/graph/badge.svg)](https://codecov.io/gh/coolosos/dart_valkey)

![Codecov icicle graph](https://codecov.io/github/coolosos/dart_valkey/graphs/sunburst.svg?token=UCBDRQIM3S)

This project is a robust, type-safe Dart client for Redis (and Valkey) that manages both command and Pub/Sub interactions. It provides built‐in connection management, automatic reconnection, and pluggable authentication. Thanks to its modular design, the user can easily extend commands as Dart extensions and choose between a secure (TLS) and insecure connection.

---

### Features

- **Connection Management**  
  Uses the Template Method pattern in `BaseConnection` to handle the socket connection, reconnection logic, and error management automatically.
  
- **Authentication and Command Execution**  
  Implements authentication commands (e.g. `HelloCommand` and `AuthCommand`) to ensure secure and correct data exchange with the Redis/Valkey server.

- **Pub/Sub Support**  
  Supports Pub/Sub operations with the `ValkeySubscriptionClient` which handles subscriptions to channels and patterns and delivers messages via a unified stream.

- **Extensible & Modular**  
  Commands are organized into modules so that new commands can be added as extensions. The core libraries (`ValkeyCommandClient` and `ValkeyClient`) provide a foundation for building more specialized client implementations.

---

### Installation

1. Add the dependency in your pubspec.yaml:

    ````dart
    // filepath: pubspec.yaml
    dependencies:
      dart_valkey: any
    ````

2. Install the dependency by running:

    ```sh
    pub get
    ```

---

### Usage

#### Connecting and Sending Commands

To connect and execute commands, first import the client library:

```dart
import 'package:dart_valkey/dart_valkey.dart';

Future<void> main() async {
  // Create a command client (or use a specific implementation)
  final client = ValkeyCommandClient(
    host: 'localhost',
    port: 6379,
    username: 'your-username',  // optional
    password: 'your-password',  // optional
  );
  
  // Connect to the server
  await client.connect();

  // Execute a command (for example, a PING command if implemented)
  final response = await client.execute(PingCommand());
  print('Server response: $response');

  // Close the client when done
  await client.close();
}
```

#### Pub/Sub Example

Subscribing to channels and listening for messages is simple with the `ValkeySubscriptionClient`:

```dart
import 'package:dart_valkey/dart_valkey.dart';
import 'dart:async';

Future<void> main() async {
  final subClient = ValkeySubscriptionClient(
    host: 'localhost',
    port: 6379,
  );

  // Connect to the server
  await subClient.connect();

  // Subscribe to a channel
  subClient.subscribe(['channel1']);

  // Listen to Pub/Sub messages
  final subscription = subClient.messages.listen((PubSubMessage msg) {
    print('Received message: ${msg.message} on channel: ${msg.channel}');
  });

  // Run for a while and cancel subscription when done.
  await Future.delayed(const Duration(seconds: 30));
  await subClient.close();
  await subscription.cancel();
}
```

### Running Tests

To run the tests, you need a Valkey or Redis server running on `localhost:6379`.

```bash
# Start Valkey server (if not running)
valkey-server --daemonize yes

# Run all tests (requires server)
dart test

# Run only unit tests (without integration tests)
dart test -x integration
```

---

## Commands Implementation Status

The implementation status of the Valkey commands is shown below, as indicated in the official documentation. Commands marked with `[x]` are implemented, while those marked with `[ ]` are not yet implemented.

### Bitmap Operations
- [ ] [BITCOUNT](https://valkey.io/commands/BITCOUNT)
- [ ] [BITFIELD](https://valkey.io/commands/BITFIELD)
- [ ] [BITFIELD_RO](https://valkey.io/commands/BITFIELD_RO)
- [ ] [BITOP](https://valkey.io/commands/BITOP)
- [ ] [BITPOS](https://valkey.io/commands/BITPOS)
- [ ] [GETBIT](https://valkey.io/commands/GETBIT)
- [ ] [SETBIT](https://valkey.io/commands/SETBIT)

### Bloom filter Operations
- [ ] [BF.ADD](https://valkey.io/commands/BF.ADD)
- [ ] [BF.CARD](https://valkey.io/commands/BF.CARD)
- [ ] [BF.EXISTS](https://valkey.io/commands/BF.EXISTS)
- [ ] [BF.INFO](https://valkey.io/commands/BF.INFO)
- [ ] [BF.INSERT](https://valkey.io/commands/BF.INSERT)
- [ ] [BF.LOAD](https://valkey.io/commands/BF.LOAD)
- [ ] [BF.MADD](https://valkey.io/commands/BF.MADD)
- [ ] [BF.MEXISTS](https://valkey.io/commands/BF.MEXISTS)
- [ ] [BF.RESERVE](https://valkey.io/commands/BF.RESERVE)

### Cluster
- [ ] [ASKING](https://valkey.io/commands/ASKING)
- [ ] [CLUSTER ADDSLOTS](https://valkey.io/commands/CLUSTER-ADDSLOTS)
- [ ] [CLUSTER ADDSLOTSRANGE](https://valkey.io/commands/CLUSTER-ADDSLOTSRANGE)
- [ ] [CLUSTER BUMPEPOCH](https://valkey.io/commands/CLUSTER-BUMPEPOCH)
- [ ] [CLUSTER COUNT-FAILURE-REPORTS](https://valkey.io/commands/CLUSTER-COUNT-FAILURE-REPORTS)
- [ ] [CLUSTER COUNTKEYSINSLOT](https://valkey.io/commands/CLUSTER-COUNTKEYSINSLOT)
- [ ] [CLUSTER DELSLOTS](https://valkey.io/commands/CLUSTER-DELSLOTS)
- [ ] [CLUSTER DELSLOTSRANGE](https://valkey.io/commands/CLUSTER-DELSLOTSRANGE)
- [ ] [CLUSTER FAILOVER](https://valkey.io/commands/CLUSTER-FAILOVER)
- [ ] [CLUSTER FLUSHSLOTS](https://valkey.io/commands/CLUSTER-FLUSHSLOTS)
- [ ] [CLUSTER FORGET](https://valkey.io/commands/CLUSTER-FORGET)
- [ ] [CLUSTER GETKEYSINSLOT](https://valkey.io/commands/CLUSTER-GETKEYSINSLOT)
- [ ] [CLUSTER HELP](https://valkey.io/commands/CLUSTER-HELP)
- [ ] [CLUSTER INFO](https://valkey.io/commands/CLUSTER-INFO)
- [ ] [CLUSTER KEYSLOT](https://valkey.io/commands/CLUSTER-KEYSLOT)
- [ ] [CLUSTER LINKS](https://valkey.io/commands/CLUSTER-LINKS)
- [ ] [CLUSTER MEET](https://valkey.io/commands/CLUSTER-MEET)
- [ ] [CLUSTER MYID](https://valkey.io/commands/CLUSTER-MYID)
- [ ] [CLUSTER MYSHARDID](https://valkey.io/commands/CLUSTER-MYSHARDID)
- [ ] [CLUSTER NODES](https://valkey.io/commands/CLUSTER-NODES)
- [ ] [CLUSTER REPLICAS](https://valkey.io/commands/CLUSTER-REPLICAS)
- [ ] [CLUSTER REPLICATE](https://valkey.io/commands/CLUSTER-REPLICATE)
- [ ] [CLUSTER RESET](https://valkey.io/commands/CLUSTER-RESET)
- [ ] [CLUSTER SAVECONFIG](https://valkey.io/commands/CLUSTER-SAVECONFIG)
- [ ] [CLUSTER SET-CONFIG-EPOCH](https://valkey.io/commands/CLUSTER-SET-CONFIG-EPOCH)
- [ ] [CLUSTER SETSLOT](https://valkey.io/commands/CLUSTER-SETSLOT)
- [ ] [CLUSTER SHARDS](https://valkey.io/commands/CLUSTER-SHARDS)
- [ ] [CLUSTER SLAVES](https://valkey.io/commands/CLUSTER-SLAVES)
- [ ] [CLUSTER SLOT-STATS](https://valkey.io/commands/CLUSTER-SLOT-STATS)
- [ ] [CLUSTER SLOTS](https://valkey.io/commands/CLUSTER-SLOTS)
- [ ] [READONLY](https://valkey.io/commands/READONLY)
- [ ] [READWRITE](https://valkey.io/commands/READWRITE)

### Connection
- [x] [AUTH](https://valkey.io/commands/AUTH)
- [x] [CLIENT CACHING](https://valkey.io/commands/CLIENT-CACHING)
- [x] [CLIENT CAPA](https://valkey.io/commands/CLIENT-CAPA)
- [x] [CLIENT GETNAME](https://valkey.io/commands/CLIENT-GETNAME)
- [x] [CLIENT GETREDIR](https://valkey.io/commands/CLIENT-GETREDIR)
- [x] [CLIENT HELP](https://valkey.io/commands/CLIENT-HELP)
- [x] [CLIENT ID](https://valkey.io/commands/CLIENT-ID)
- [x] [CLIENT IMPORT-SOURCE](https://valkey.io/commands/CLIENT-IMPORT-SOURCE)
- [x] [CLIENT INFO](https://valkey.io/commands/CLIENT-INFO)
- [x] [CLIENT KILL](https://valkey.io/commands/CLIENT-KILL)
- [x] [CLIENT LIST](https://valkey.io/commands/CLIENT-LIST)
- [x] [CLIENT NO-EVICT](https://valkey.io/commands/CLIENT-NO-EVICT)
- [x] [CLIENT NO-TOUCH](https://valkey.io/commands/CLIENT-NO-TOUCH)
- [x] [CLIENT PAUSE](https://valkey.io/commands/CLIENT-PAUSE)
- [x] [CLIENT REPLY](https://valkey.io/commands/CLIENT-REPLY)
- [x] [CLIENT SETINFO](https://valkey.io/commands/CLIENT-SETINFO)
- [x] [CLIENT SETNAME](https://valkey.io/commands/CLIENT-SETNAME)
- [x] [CLIENT TRACKING](https://valkey.io/commands/CLIENT-TRACKING)
- [x] [CLIENT TRACKINGINFO](https://valkey.io/commands/CLIENT-TRACKINGINFO)
- [x] [CLIENT UNBLOCK](https://valkey.io/commands/CLIENT-UNBLOCK)
- [x] [CLIENT UNPAUSE](https://valkey.io/commands/CLIENT-UNPAUSE)
- [x] [ECHO](https://valkey.io/commands/ECHO)
- [x] [HELLO](https://valkey.io/commands/HELLO)
- [x] [PING](https://valkey.io/commands/PING)
- [x] [QUIT](https://valkey.io/commands/QUIT)
- [x] [RESET](https://valkey.io/commands/RESET)
- [x] [SELECT](https://valkey.io/commands/SELECT)

### Generic
- [ ] [COPY](https://valkey.io/commands/COPY)
- [x] [DEL](https://valkey.io/commands/DEL)
- [ ] [DUMP](https://valkey.io/commands/DUMP)
- [x] [EXISTS](https://valkey.io/commands/EXISTS)
- [x] [EXPIRE](https://valkey.io/commands/EXPIRE)
- [ ] [EXPIREAT](https://valkey.io/commands/EXPIREAT)
- [ ] [EXPIRETIME](https://valkey.io/commands/EXPIRETIME)
- [ ] [KEYS](https://valkey.io/commands/KEYS)
- [ ] [MIGRATE](https://valkey.io/commands/MIGRATE)
- [ ] [MOVE](https://valkey.io/commands/MOVE)
- [ ] [OBJECT ENCODING](https://valkey.io/commands/OBJECT-ENCODING)
- [ ] [OBJECT FREQ](https://valkey.io/commands/OBJECT-FREQ)
- [ ] [OBJECT HELP](https://valkey.io/commands/OBJECT-HELP)
- [ ] [OBJECT IDLETIME](https://valkey.io/commands/OBJECT-IDLETIME)
- [ ] [OBJECT REFCOUNT](https://valkey.io/commands/OBJECT-REFCOUNT)
- [x] [PERSIST](https://valkey.io/commands/PERSIST)
- [ ] [PEXPIRE](https://valkey.io/commands/PEXPIRE)
- [ ] [PEXPIREAT](https://valkey.io/commands/PEXPIREAT)
- [ ] [PEXPIRETIME](https://valkey.io/commands/PEXPIRETIME)
- [ ] [PTTL](https://valkey.io/commands/PTTL)
- [ ] [RANDOMKEY](https://valkey.io/commands/RANDOMKEY)
- [x] [RENAME](https://valkey.io/commands/RENAME)
- [x] [RENAMENX](https://valkey.io/commands/RENAMENX)
- [ ] [RESTORE](https://valkey.io/commands/RESTORE)
- [ ] [SCAN](https://valkey.io/commands/SCAN)
- [ ] [SORT](https://valkey.io/commands/SORT)
- [ ] [SORT_RO](https://valkey.io/commands/SORT_RO)
- [ ] [TOUCH](https://valkey.io/commands/TOUCH)
- [x] [TTL](https://valkey.io/commands/TTL)
- [x] [TYPE](https://valkey.io/commands/TYPE)
- [ ] [UNLINK](https://valkey.io/commands/UNLINK)
- [ ] [WAIT](https://valkey.io/commands/WAIT)
- [ ] [WAITAOF](https://valkey.io/commands/WAITAOF)

### Geospatial indices
- [ ] [GEOADD](https://valkey.io/commands/GEOADD)
- [ ] [GEODIST](https://valkey.io/commands/GEODIST)
- [ ] [GEOHASH](https://valkey.io/commands/GEOHASH)
- [ ] [GEOPOS](https://valkey.io/commands/GEOPOS)
- [ ] [GEORADIUS](https://valkey.io/commands/GEORADIUS)
- [ ] [GEORADIUSBYMEMBER](https://valkey.io/commands/GEORADIUSBYMEMBER)
- [ ] [GEORADIUSBYMEMBER_RO](https://valkey.io/commands/GEORADIUSBYMEMBER_RO)
- [ ] [GEORADIUS_RO](https://valkey.io/commands/GEORADIUS_RO)
- [ ] [GEOSEARCH](https://valkey.io/commands/GEOSEARCH)
- [ ] [GEOSEARCHSTORE](https://valkey.io/commands/GEOSEARCHSTORE)

### Hash Operations
- [x] [HDEL](https://valkey.io/commands/HDEL)
- [x] [HEXISTS](https://valkey.io/commands/HEXISTS)
- [x] [HGET](https://valkey.io/commands/HGET)
- [x] [HGETALL](https://valkey.io/commands/HGETALL)
- [x] [HINCRBY](https://valkey.io/commands/HINCRBY)
- [x] [HINCRBYFLOAT](https://valkey.io/commands/HINCRBYFLOAT)
- [x] [HKEYS](https://valkey.io/commands/HKEYS)
- [x] [HLEN](https://valkey.io/commands/HLEN)
- [x] [HMGET](https://valkey.io/commands/HMGET)
- [x] [HMSET](https://valkey.io/commands/HMSET)
- [ ] [HRANDFIELD](https://valkey.io/commands/HRANDFIELD)
- [ ] [HSCAN](https://valkey.io/commands/HSCAN)
- [x] [HSET](https://valkey.io/commands/HSET)
- [x] [HSETNX](https://valkey.io/commands/HSETNX)
- [x] [HSTRLEN](https://valkey.io/commands/HSTRLEN)
- [x] [HVALS](https://valkey.io/commands/HVALS)

### HyperLogLog
- [ ] [PFADD](https://valkey.io/commands/PFADD)
- [ ] [PFCOUNT](https://valkey.io/commands/PFCOUNT)
- [ ] [PFDEBUG](https://valkey.io/commands/PFDEBUG)
- [ ] [PFMERGE](https://valkey.io/commands/PFMERGE)
- [ ] [PFSELFTEST](https://valkey.io/commands/PFSELFTEST)

### JSON Operations
- [ ] [JSON.ARRAPPEND](https://valkey.io/commands/JSON.ARRAPPEND)
- [ ] [JSON.ARRINDEX](https://valkey.io/commands/JSON.ARRINDEX)
- [ ] [JSON.ARRINSERT](https://valkey.io/commands/JSON.ARRINSERT)
- [ ] [JSON.ARRLEN](https://valkey.io/commands/JSON.ARRLEN)
- [ ] [JSON.ARRPOP](https://valkey.io/commands/JSON.ARRPOP)
- [ ] [JSON.ARRTRIM](https://valkey.io/commands/JSON.ARRTRIM)
- [ ] [JSON.CLEAR](https://valkey.io/commands/JSON.CLEAR)
- [ ] [JSON.DEBUG](https://valkey.io/commands/JSON.DEBUG)
- [ ] [JSON.DEL](https://valkey.io/commands/JSON.DEL)
- [ ] [JSON.FORGET](https://valkey.io/commands/JSON.FORGET)
- [ ] [JSON.GET](https://valkey.io/commands/JSON.GET)
- [ ] [JSON.MGET](https://valkey.io/commands/JSON.MGET)
- [ ] [JSON.MSET](https://valkey.io/commands/JSON.MSET)
- [ ] [JSON.NUMINCRBY](https://valkey.io/commands/JSON.NUMINCRBY)
- [ ] [JSON.NUMMULTBY](https://valkey.io/commands/JSON.NUMMULTBY)
- [ ] [JSON.OBJKEYS](https://valkey.io/commands/JSON.OBJKEYS)
- [ ] [JSON.OBJLEN](https://valkey.io/commands/JSON.OBJLEN)
- [ ] [JSON.RESP](https://valkey.io/commands/JSON.RESP)
- [ ] [JSON.SET](https://valkey.io/commands/JSON.SET)
- [ ] [JSON.STRAPPEND](https://valkey.io/commands/JSON.STRAPPEND)
- [ ] [JSON.STRLEN](https://valkey.io/commands/JSON.STRLEN)
- [ ] [JSON.TOGGLE](https://valkey.io/commands/JSON.TOGGLE)
- [ ] [JSON.TYPE](https://valkey.io/commands/JSON.TYPE)

### List Operations
- [ ] [BLMOVE](https://valkey.io/commands/BLMOVE)
- [ ] [BLMPOP](https://valkey.io/commands/BLMPOP)
- [ ] [BLPOP](https://valkey.io/commands/BLPOP)
- [ ] [BRPOP](https://valkey.io/commands/BRPOP)
- [ ] [BRPOPLPUSH](https://valkey.io/commands/BRPOPLPUSH)
- [x] [LINDEX](https://valkey.io/commands/LINDEX)
- [x] [LINSERT](https://valkey.io/commands/LINSERT)
- [x] [LLEN](https://valkey.io/commands/LLEN)
- [ ] [LMOVE](https://valkey.io/commands/LMOVE)
- [ ] [LMPOP](https://valkey.io/commands/LMPOP)
- [x] [LPOP](https://valkey.io/commands/LPOP)
- [ ] [LPOS](https://valkey.io/commands/LPOS)
- [x] [LPUSH](https://valkey.io/commands/LPUSH)
- [ ] [LPUSHX](https://valkey.io/commands/LPUSHX)
- [x] [LRANGE](https://valkey.io/commands/LRANGE)
- [x] [LREM](https://valkey.io/commands/LREM)
- [ ] [LSET](https://valkey.io/commands/LSET)
- [x] [LTRIM](https://valkey.io/commands/LTRIM)
- [x] [RPOP](https://valkey.io/commands/RPOP)
- [x] [RPOPLPUSH](https://valkey.io/commands/RPOPLPUSH)
- [x] [RPUSH](https://valkey.io/commands/RPUSH)
- [ ] [RPUSHX](https://valkey.io/commands/RPUSHX)

### Pub/Sub
- [x] [PSUBSCRIBE](https://valkey.io/commands/PSUBSCRIBE)
- [x] [PUBLISH](https://valkey.io/commands/PUBLISH)
- [x] [PUNSUBSCRIBE](https://valkey.io/commands/PUNSUBSCRIBE)
- [x] [PUBSUB CHANNELS](https://valkey.io/commands/PUBSUB-CHANNELS)
- [x] [PUBSUB HELP](https://valkey.io/commands/PUBSUB-HELP)
- [x] [PUBSUB NUMPAT](https://valkey.io/commands/PUBSUB-NUMPAT)
- [x] [PUBSUB NUMSUB](https://valkey.io/commands/PUBSUB-NUMSUB)
- [x] [PUBSUB SHARDCHANNELS](https://valkey.io/commands/PUBSUB-SHARDCHANNELS)
- [x] [PUBSUB SHARDNUMSUB](https://valkey.io/commands/PUBSUB-SHARDNUMSUB)
- [x] [SPUBLISH](https://valkey.io/commands/SPUBLISH)
- [x] [SSUBSCRIBE](https://valkey.io/commands/SSUBSCRIBE)
- [x] [SUBSCRIBE](https://valkey.io/commands/SUBSCRIBE)
- [x] [SUNSUBSCRIBE](https://valkey.io/commands/SUNSUBSCRIBE)
- [x] [UNSUBSCRIBE](https://valkey.io/commands/UNSUBSCRIBE)

### Scripting and Functions
- [ ] [EVAL](https://valkey.io/commands/EVAL)
- [ ] [EVALSHA](https://valkey.io/commands/EVALSHA)
- [ ] [EVALSHA_RO](https://valkey.io/commands/EVALSHA_RO)
- [ ] [EVAL_RO](https://valkey.io/commands/EVAL_RO)
- [ ] [FCALL](https://valkey.io/commands/FCALL)
- [ ] [FCALL_RO](https://valkey.io/commands/FCALL_RO)
- [ ] [FUNCTION DELETE](https://valkey.io/commands/FUNCTION-DELETE)
- [ ] [FUNCTION DUMP](https://valkey.io/commands/FUNCTION-DUMP)
- [ ] [FUNCTION FLUSH](https://valkey.io/commands/FUNCTION-FLUSH)
- [ ] [FUNCTION HELP](https://valkey.io/commands/FUNCTION-HELP)
- [ ] [FUNCTION KILL](https://valkey.io/commands/FUNCTION-KILL)
- [ ] [FUNCTION LIST](https://valkey.io/commands/FUNCTION-LIST)
- [ ] [FUNCTION LOAD](https://valkey.io/commands/FUNCTION-LOAD)
- [ ] [FUNCTION RESTORE](https://valkey.io/commands/FUNCTION-RESTORE)
- [ ] [FUNCTION STATS](https://valkey.io/commands/FUNCTION-STATS)
- [ ] [SCRIPT DEBUG](https://valkey.io/commands/SCRIPT-DEBUG)
- [ ] [SCRIPT EXISTS](https://valkey.io/commands/SCRIPT-EXISTS)
- [ ] [SCRIPT FLUSH](https://valkey.io/commands/SCRIPT-FLUSH)
- [ ] [SCRIPT HELP](https://valkey.io/commands/SCRIPT-HELP)
- [ ] [SCRIPT KILL](https://valkey.io/commands/SCRIPT-KILL)
- [ ] [SCRIPT LOAD](https://valkey.io/commands/SCRIPT-LOAD)
- [ ] [SCRIPT SHOW](https://valkey.io/commands/SCRIPT-SHOW)

### Search
- [ ] [FT.CREATE](https://valkey.io/commands/FT.CREATE)
- [ ] [FT.DROPINDEX](https://valkey.io/commands/FT.DROPINDEX)
- [ ] [FT.INFO](https://valkey.io/commands/FT.INFO)
- [ ] [FT.SEARCH](https://valkey.io/commands/FT.SEARCH)
- [ ] [FT._LIST](https://valkey.io/commands/FT._LIST)

### Server
- [ ] [ACL CAT](https://valkey.io/commands/ACL-CAT)
- [ ] [ACL DELUSER](https://valkey.io/commands/ACL-DELUSER)
- [ ] [ACL DRYRUN](https://valkey.io/commands/ACL-DRYRUN)
- [ ] [ACL GENPASS](https://valkey.io/commands/ACL-GENPASS)
- [ ] [ACL GETUSER](https://valkey.io/commands/ACL-GETUSER)
- [ ] [ACL HELP](https://valkey.io/commands/ACL-HELP)
- [ ] [ACL LIST](https://valkey.io/commands/ACL-LIST)
- [ ] [ACL LOAD](https://valkey.io/commands/ACL-LOAD)
- [ ] [ACL LOG](https://valkey.io/commands/ACL-LOG)
- [ ] [ACL SAVE](https://valkey.io/commands/ACL-SAVE)
- [ ] [ACL SETUSER](https://valkey.io/commands/ACL-SETUSER)
- [ ] [ACL USERS](https://valkey.io/commands/ACL-USERS)
- [ ] [ACL WHOAMI](https://valkey.io/commands/ACL-WHOAMI)
- [ ] [BGREWRITEAOF](https://valkey.io/commands/BGREWRITEAOF)
- [ ] [BGSAVE](https://valkey.io/commands/BGSAVE)
- [ ] [COMMAND COUNT](https://valkey.io/commands/COMMAND-COUNT)
- [ ] [COMMAND DOCS](https://valkey.io/commands/COMMAND-DOCS)
- [ ] [COMMAND GETKEYS](https://valkey.io/commands/COMMAND-GETKEYS)
- [ ] [COMMAND GETKEYSANDFLAGS](https://valkey.io/commands/COMMAND-GETKEYSANDFLAGS)
- [ ] [COMMAND HELP](https://valkey.io/commands/COMMAND-HELP)
- [ ] [COMMAND INFO](https://valkey.io/commands/COMMAND-INFO)
- [ ] [COMMAND LIST](https://valkey.io/commands/COMMAND-LIST)
- [ ] [COMMANDLOG GET](https://valkey.io/commands/COMMANDLOG-GET)
- [ ] [COMMANDLOG HELP](https://valkey.io/commands/COMMANDLOG-HELP)
- [ ] [COMMANDLOG LEN](https://valkey.io/commands/COMMANDLOG-LEN)
- [ ] [COMMANDLOG RESET](https://valkey.io/commands/COMMANDLOG-RESET)
- [ ] [CONFIG GET](https://valkey.io/commands/CONFIG-GET)
- [ ] [CONFIG HELP](https://valkey.io/commands/CONFIG-HELP)
- [ ] [CONFIG RESETSTAT](https://valkey.io/commands/CONFIG-RESETSTAT)
- [ ] [CONFIG REWRITE](https://valkey.io/commands/CONFIG-REWRITE)
- [ ] [CONFIG SET](https://valkey.io/commands/CONFIG-SET)
- [ ] [DBSIZE](https://valkey.io/commands/DBSIZE)
- [ ] [DEBUG](https://valkey.io/commands/DEBUG)
- [ ] [FAILOVER](https://valkey.io/commands/FAILOVER)
- [ ] [FLUSHALL](https://valkey.io/commands/FLUSHALL)
- [ ] [FLUSHDB](https://valkey.io/commands/FLUSHDB)
- [ ] [INFO](https://valkey.io/commands/INFO)
- [ ] [LASTSAVE](https://valkey.io/commands/LASTSAVE)
- [ ] [LATENCY DOCTOR](https://valkey.io/commands/LATENCY-DOCTOR)
- [ ] [LATENCY GRAPH](https://valkey.io/commands/LATENCY-GRAPH)
- [ ] [LATENCY HELP](https://valkey.io/commands/LATENCY-HELP)
- [ ] [LATENCY HISTOGRAM](https://valkey.io/commands/LATENCY-HISTOGRAM)
- [ ] [LATENCY HISTORY](https://valkey.io/commands/LATENCY-HISTORY)
- [ ] [LATENCY LATEST](https://valkey.io/commands/LATENCY-LATEST)
- [ ] [LATENCY RESET](https://valkey.io/commands/LATENCY-RESET)
- [ ] [LOLWUT](https://valkey.io/commands/LOLWUT)
- [ ] [MEMORY DOCTOR](https://valkey.io/commands/MEMORY-DOCTOR)
- [ ] [MEMORY HELP](https://valkey.io/commands/MEMORY-HELP)
- [ ] [MEMORY MALLOC-STATS](https://valkey.io/commands/MEMORY-MALLOC-STATS)
- [ ] [MEMORY PURGE](https://valkey.io/commands/MEMORY-PURGE)
- [ ] [MEMORY STATS](https://valkey.io/commands/MEMORY-STATS)
- [ ] [MEMORY USAGE](https://valkey.io/commands/MEMORY-USAGE)
- [ ] [MODULE HELP](https://valkey.io/commands/MODULE-HELP)
- [ ] [MODULE LIST](https://valkey.io/commands/MODULE-LIST)
- [ ] [MODULE LOAD](https://valkey.io/commands/MODULE-LOAD)
- [ ] [MODULE LOADEX](https://valkey.io/commands/MODULE-LOADEX)
- [ ] [MODULE UNLOAD](https://valkey.io/commands/MODULE-UNLOAD)
- [ ] [MONITOR](https://valkey.io/commands/MONITOR)
- [ ] [PSYNC](https://valkey.io/commands/PSYNC)
- [ ] [REPLCONF](https://valkey.io/commands/REPLCONF)
- [ ] [REPLICAOF](https://valkey.io/commands/REPLICAOF)
- [ ] [RESTORE-ASKING](https://valkey.io/commands/RESTORE-ASKING)
- [ ] [ROLE](https://valkey.io/commands/ROLE)
- [ ] [SAVE](https://valkey.io/commands/SAVE)
- [ ] [SHUTDOWN](https://valkey.io/commands/SHUTDOWN)
- [ ] [SLAVEOF](https://valkey.io/commands/SLAVEOF)
- [ ] [SLOWLOG GET](https://valkey.io/commands/SLOWLOG-GET)
- [ ] [SLOWLOG HELP](https://valkey.io/commands/SLOWLOG-HELP)
- [ ] [SLOWLOG LEN](https://valkey.io/commands/SLOWLOG-LEN)
- [ ] [SLOWLOG RESET](https://valkey.io/commands/SLOWLOG-RESET)
- [ ] [SWAPDB](https://valkey.io/commands/SWAPDB)
- [ ] [SYNC](https://valkey.io/commands/SYNC)
- [ ] [TIME](https://valkey.io/commands/TIME)

### Set Operations
- [x] [SADD](https://valkey.io/commands/SADD)
- [x] [SCARD](https://valkey.io/commands/SCARD)
- [x] [SDIFF](https://valkey.io/commands/SDIFF)
- [x] [SDIFFSTORE](https://valkey.io/commands/SDIFFSTORE)
- [x] [SINTER](https://valkey.io/commands/SINTER)
- [ ] [SINTERCARD](https://valkey.io/commands/SINTERCARD)
- [x] [SINTERSTORE](https://valkey.io/commands/SINTERSTORE)
- [x] [SISMEMBER](https://valkey.io/commands/SISMEMBER)
- [x] [SMEMBERS](https://valkey.io/commands/SMEMBERS)
- [ ] [SMISMEMBER](https://valkey.io/commands/SMISMEMBER)
- [x] [SMOVE](https://valkey.io/commands/SMOVE)
- [x] [SPOP](https://valkey.io/commands/SPOP)
- [x] [SRANDMEMBER](https://valkey.io/commands/SRANDMEMBER)
- [x] [SREM](https://valkey.io/commands/SREM)
- [ ] [SSCAN](https://valkey.io/commands/SSCAN)
- [x] [SUNION](https://valkey.io/commands/SUNION)
- [x] [SUNIONSTORE](https://valkey.io/commands/SUNIONSTORE)

### Sorted Set Operations
- [x] [ZADD](https://valkey.io/commands/ZADD)
- [ ] [BZMPOP](https://valkey.io/commands/BZMPOP)
- [ ] [BZPOPMAX](https://valkey.io/commands/BZPOPMAX)
- [ ] [BZPOPMIN](https://valkey.io/commands/BZPOPMIN)
- [x] [ZCARD](https://valkey.io/commands/ZCARD)
- [x] [ZCOUNT](https://valkey.io/commands/ZCOUNT)
- [ ] [ZDIFF](https://valkey.io/commands/ZDIFF)
- [ ] [ZDIFFSTORE](https://valkey.io/commands/ZDIFFSTORE)
- [x] [ZINCRBY](https://valkey.io/commands/ZINCRBY)
- [ ] [ZINTER](https://valkey.io/commands/ZINTER)
- [ ] [ZINTERCARD](https://valkey.io/commands/ZINTERCARD)
- [ ] [ZINTERSTORE](https://valkey.io/commands/ZINTERSTORE)
- [ ] [ZLEXCOUNT](https://valkey.io/commands/ZLEXCOUNT)
- [ ] [ZMPOP](https://valkey.io/commands/ZMPOP)
- [ ] [ZMSCORE](https://valkey.io/commands/ZMSCORE)
- [ ] [ZPOPMAX](https://valkey.io/commands/ZPOPMAX)
- [ ] [ZPOPMIN](https://valkey.io/commands/ZPOPMIN)
- [ ] [ZRANDMEMBER](https://valkey.io/commands/ZRANDMEMBER)
- [x] [ZRANGE](https://valkey.io/commands/ZRANGE)
- [ ] [ZRANGEBYLEX](https://valkey.io/commands/ZRANGEBYLEX)
- [x] [ZRANGEBYSCORE](https://valkey.io/commands/ZRANGEBYSCORE)
- [ ] [ZRANGESTORE](https://valkey.io/commands/ZRANGESTORE)
- [x] [ZRANK](https://valkey.io/commands/ZRANK)
- [x] [ZREM](https://valkey.io/commands/ZREM)
- [ ] [ZREMRANGEBYLEX](https://valkey.io/commands/ZREMRANGEBYLEX)
- [ ] [ZREMRANGEBYRANK](https://valkey.io/commands/ZREMRANGEBYRANK)
- [ ] [ZREMRANGEBYSCORE](https://valkey.io/commands/ZREMRANGEBYSCORE)
- [x] [ZREVRANGE](https://valkey.io/commands/ZREVRANGE)
- [ ] [ZREVRANGEBYLEX](https://valkey.io/commands/ZREVRANGEBYLEX)
- [x] [ZREVRANGEBYSCORE](https://valkey.io/commands/ZREVRANGEBYSCORE)
- [x] [ZREVRANK](https://valkey.io/commands/ZREVRANK)
- [ ] [ZSCAN](https://valkey.io/commands/ZSCAN)
- [x] [ZSCORE](https://valkey.io/commands/ZSCORE)
- [ ] [ZUNION](https://valkey.io/commands/ZUNION)
- [ ] [ZUNIONSTORE](https://valkey.io/commands/ZUNIONSTORE)

### Stream Operations
- [ ] [XACK](https://valkey.io/commands/XACK)
- [ ] [XADD](https://valkey.io/commands/XADD)
- [ ] [XAUTOCLAIM](https://valkey.io/commands/XAUTOCLAIM)
- [ ] [XCLAIM](https://valkey.io/commands/XCLAIM)
- [ ] [XDEL](https://valkey.io/commands/XDEL)
- [ ] [XGROUP CREATE](https://valkey.io/commands/XGROUP-CREATE)
- [ ] [XGROUP CREATECONSUMER](https://valkey.io/commands/XGROUP-CREATECONSUMER)
- [ ] [XGROUP DELCONSUMER](https://valkey.io/commands/XGROUP-DELCONSUMER)
- [ ] [XGROUP DESTROY](https://valkey.io/commands/XGROUP-DESTROY)
- [ ] [XGROUP HELP](https://valkey.io/commands/XGROUP-HELP)
- [ ] [XGROUP SETID](https://valkey.io/commands/XGROUP-SETID)
- [ ] [XINFO CONSUMERS](https://valkey.io/commands/XINFO-CONSUMERS)
- [ ] [XINFO GROUPS](https://valkey.io/commands/XINFO-GROUPS)
- [ ] [XINFO HELP](https://valkey.io/commands/XINFO-HELP)
- [ ] [XINFO STREAM](https://valkey.io/commands/XINFO-STREAM)
- [ ] [XLEN](https://valkey.io/commands/XLEN)
- [ ] [XPENDING](https://valkey.io/commands/XPENDING)
- [ ] [XRANGE](https://valkey.io/commands/XRANGE)
- [ ] [XREAD](https://valkey.io/commands/XREAD)
- [ ] [XREADGROUP](https://valkey.io/commands/XREADGROUP)
- [ ] [XREVRANGE](https://valkey.io/commands/XREVRANGE)
- [ ] [XSETID](https://valkey.io/commands/XSETID)
- [ ] [XTRIM](https://valkey.io/commands/XTRIM)

### String Operations
- [x] [APPEND](https://valkey.io/commands/APPEND)
- [ ] [BITCOUNT](https://valkey.io/commands/BITCOUNT)
- [ ] [BITFIELD](https://valkey.io/commands/BITFIELD)
- [x] [DECR](https://valkey.io/commands/DECR)
- [x] [DECRBY](https://valkey.io/commands/DECRBY)
- [ ] [DELIFEQ](https://valkey.io/commands/DELIFEQ)
- [x] [GET](https://valkey.io/commands/GET)
- [ ] [GETBIT](https://valkey.io/commands/GETBIT)
- [ ] [GETDEL](https://valkey.io/commands/GETDEL)
- [ ] [GETEX](https://valkey.io/commands/GETEX)
- [x] [GETRANGE](https://valkey.io/commands/GETRANGE)
- [x] [GETSET](https://valkey.io/commands/GETSET)
- [x] [INCR](https://valkey.io/commands/INCR)
- [x] [INCRBY](https://valkey.io/commands/INCRBY)
- [ ] [INCRBYFLOAT](https://valkey.io/commands/INCRBYFLOAT)
- [ ] [LCS](https://valkey.io/commands/LCS)
- [x] [MGET](https://valkey.io/commands/MGET)
- [x] [MSET](https://valkey.io/commands/MSET)
- [ ] [MSETNX](https://valkey.io/commands/MSETNX)
- [ ] [PSETEX](https://valkey.io/commands/PSETEX)
- [x] [SET](https://valkey.io/commands/SET)
- [ ] [SETBIT](https://valkey.io/commands/SETBIT)
- [ ] [SETEX](https://valkey.io/commands/SETEX)
- [ ] [SETNX](https://valkey.io/commands/SETNX)
- [x] [SETRANGE](https://valkey.io/commands/SETRANGE)
- [x] [STRLEN](https://valkey.io/commands/STRLEN)
- [ ] [SUBSTR](https://valkey.io/commands/SUBSTR)

### Transactions
- [ ] [DISCARD](https://valkey.io/commands/DISCARD)
- [ ] [EXEC](https://valkey.io/commands/EXEC)
- [ ] [MULTI](https://valkey.io/commands/MULTI)
- [ ] [UNWATCH](https://valkey.io/commands/UNWATCH)
- [ ] [WATCH](https://valkey.io/commands/WATCH)
 

### Contributing

Contributions are welcome!  
Feel free to open issues or submit pull requests on our repository.  



