# Commands Implementation Status

This document shows the implementation status of Valkey/Redis commands in dart_valkey, based on the official [Valkey documentation](https://valkey.io/commands/).

## Summary

- **Total commands implemented**: ~100+
- **Categories**: 18

---

## Bitmap Operations

| Command | Status |
|---------|--------|
| BITCOUNT | ❌ |
| BITFIELD | ❌ |
| BITFIELD_RO | ❌ |
| BITOP | ❌ |
| BITPOS | ❌ |
| GETBIT | ❌ |
| SETBIT | ❌ |

## Bloom Filter Operations

| Command | Status |
|---------|--------|
| BF.ADD | ❌ |
| BF.CARD | ❌ |
| BF.EXISTS | ❌ |
| BF.INFO | ❌ |
| BF.INSERT | ❌ |
| BF.LOAD | ❌ |
| BF.MADD | ❌ |
| BF.MEXISTS | ❌ |
| BF.RESERVE | ❌ |

## Cluster

| Command | Status |
|---------|--------|
| ASKING | ❌ |
| CLUSTER ADDSLOTS | ❌ |
| CLUSTER ADDSLOTSRANGE | ❌ |
| CLUSTER BUMPEPOCH | ❌ |
| CLUSTER COUNT-FAILURE-REPORTS | ❌ |
| CLUSTER COUNTKEYSINSLOT | ❌ |
| CLUSTER DELSLOTS | ❌ |
| CLUSTER DELSLOTSRANGE | ❌ |
| CLUSTER FAILOVER | ❌ |
| CLUSTER FLUSHSLOTS | ❌ |
| CLUSTER FORGET | ❌ |
| CLUSTER GETKEYSINSLOT | ❌ |
| CLUSTER HELP | ❌ |
| CLUSTER INFO | ❌ |
| CLUSTER KEYSLOT | ❌ |
| CLUSTER LINKS | ❌ |
| CLUSTER MEET | ❌ |
| CLUSTER MYID | ❌ |
| CLUSTER MYSHARDID | ❌ |
| CLUSTER NODES | ❌ |
| CLUSTER REPLICAS | ❌ |
| CLUSTER REPLICATE | ❌ |
| CLUSTER RESET | ❌ |
| CLUSTER SAVECONFIG | ❌ |
| CLUSTER SET-CONFIG-EPOCH | ❌ |
| CLUSTER SETSLOT | ❌ |
| CLUSTER SHARDS | ❌ |
| CLUSTER SLAVES | ❌ |
| CLUSTER SLOT-STATS | ❌ |
| CLUSTER SLOTS | ❌ |
| READONLY | ❌ |
| READWRITE | ❌ |

## Connection

| Command | Status |
|---------|--------|
| AUTH | ✅ |
| CLIENT CACHING | ✅ |
| CLIENT CAPA | ✅ |
| CLIENT GETNAME | ✅ |
| CLIENT GETREDIR | ✅ |
| CLIENT HELP | ✅ |
| CLIENT ID | ✅ |
| CLIENT IMPORT-SOURCE | ✅ |
| CLIENT INFO | ✅ |
| CLIENT KILL | ✅ |
| CLIENT LIST | ✅ |
| CLIENT NO-EVICT | ✅ |
| CLIENT NO-TOUCH | ✅ |
| CLIENT PAUSE | ✅ |
| CLIENT REPLY | ✅ |
| CLIENT SETINFO | ✅ |
| CLIENT SETNAME | ✅ |
| CLIENT TRACKING | ✅ |
| CLIENT TRACKINGINFO | ✅ |
| CLIENT UNBLOCK | ✅ |
| CLIENT UNPAUSE | ✅ |
| ECHO | ✅ |
| HELLO | ✅ |
| PING | ✅ |
| QUIT | ✅ |
| RESET | ✅ |
| SELECT | ✅ |

## Generic (Key)

| Command | Status |
|---------|--------|
| COPY | ❌ |
| DEL | ✅ |
| DUMP | ❌ |
| EXISTS | ✅ |
| EXPIRE | ✅ |
| EXPIREAT | ❌ |
| EXPIRETIME | ❌ |
| KEYS | ❌ |
| MIGRATE | ❌ |
| MOVE | ❌ |
| OBJECT ENCODING | ❌ |
| OBJECT FREQ | ❌ |
| OBJECT HELP | ❌ |
| OBJECT IDLETIME | ❌ |
| OBJECT REFCOUNT | ❌ |
| PERSIST | ✅ |
| PEXPIRE | ❌ |
| PEXPIREAT | ❌ |
| PEXPIRETIME | ❌ |
| PTTL | ❌ |
| RANDOMKEY | ❌ |
| RENAME | ✅ |
| RENAMENX | ✅ |
| RESTORE | ❌ |
| SCAN | ❌ |
| SORT | ❌ |
| SORT_RO | ❌ |
| TOUCH | ❌ |
| TTL | ✅ |
| TYPE | ✅ |
| UNLINK | ❌ |
| WAIT | ❌ |
| WAITAOF | ❌ |

## Geospatial Indices

| Command | Status |
|---------|--------|
| GEOADD | ❌ |
| GEODIST | ❌ |
| GEOHASH | ❌ |
| GEOPOS | ❌ |
| GEORADIUS | ❌ |
| GEORADIUSBYMEMBER | ❌ |
| GEORADIUSBYMEMBER_RO | ❌ |
| GEORADIUS_RO | ❌ |
| GEOSEARCH | ❌ |
| GEOSEARCHSTORE | ❌ |

## Hash Operations

| Command | Status |
|---------|--------|
| HDEL | ✅ |
| HEXISTS | ✅ |
| HGET | ✅ |
| HGETALL | ✅ |
| HINCRBY | ✅ |
| HINCRBYFLOAT | ✅ |
| HKEYS | ✅ |
| HLEN | ✅ |
| HMGET | ✅ |
| HMSET | ✅ |
| HRANDFIELD | ❌ |
| HSCAN | ❌ |
| HSET | ✅ |
| HSETNX | ✅ |
| HSTRLEN | ✅ |
| HVALS | ✅ |

## HyperLogLog

| Command | Status |
|---------|--------|
| PFADD | ❌ |
| PFCOUNT | ❌ |
| PFDEBUG | ❌ |
| PFMERGE | ❌ |
| PFSELFTEST | ❌ |

## JSON Operations

| Command | Status |
|---------|--------|
| JSON.ARRAPPEND | ❌ |
| JSON.ARRINDEX | ❌ |
| JSON.ARRINSERT | ❌ |
| JSON.ARRLEN | ❌ |
| JSON.ARRPOP | ❌ |
| JSON.ARRTRIM | ❌ |
| JSON.CLEAR | ❌ |
| JSON.DEBUG | ❌ |
| JSON.DEL | ❌ |
| JSON.FORGET | ❌ |
| JSON.GET | ❌ |
| JSON.MGET | ❌ |
| JSON.MSET | ❌ |
| JSON.NUMINCRBY | ❌ |
| JSON.NUMMULTBY | ❌ |
| JSON.OBJKEYS | ❌ |
| JSON.OBJLEN | ❌ |
| JSON.RESP | ❌ |
| JSON.SET | ❌ |
| JSON.STRAPPEND | ❌ |
| JSON.STRLEN | ❌ |
| JSON.TOGGLE | ❌ |
| JSON.TYPE | ❌ |

## List Operations

| Command | Status |
|---------|--------|
| BLMOVE | ❌ |
| BLMPOP | ❌ |
| BLPOP | ❌ |
| BRPOP | ❌ |
| BRPOPLPUSH | ❌ |
| LINDEX | ✅ |
| LINSERT | ✅ |
| LLEN | ✅ |
| LMOVE | ❌ |
| LMPOP | ❌ |
| LPOP | ✅ |
| LPOS | ❌ |
| LPUSH | ✅ |
| LPUSHX | ❌ |
| LRANGE | ✅ |
| LREM | ✅ |
| LSET | ❌ |
| LTRIM | ✅ |
| RPOP | ✅ |
| RPOPLPUSH | ✅ |
| RPUSH | ✅ |
| RPUSHX | ❌ |

## Pub/Sub

| Command | Status |
|---------|--------|
| PSUBSCRIBE | ✅ |
| PUBLISH | ✅ |
| PUNSUBSCRIBE | ✅ |
| PUBSUB CHANNELS | ✅ |
| PUBSUB HELP | ✅ |
| PUBSUB NUMPAT | ✅ |
| PUBSUB NUMSUB | ✅ |
| PUBSUB SHARDCHANNELS | ✅ |
| PUBSUB SHARDNUMSUB | ✅ |
| SPUBLISH | ✅ |
| SSUBSCRIBE | ✅ |
| SUBSCRIBE | ✅ |
| SUNSUBSCRIBE | ✅ |
| UNSUBSCRIBE | ✅ |

## Scripting and Functions

| Command | Status |
|---------|--------|
| EVAL | ❌ |
| EVALSHA | ❌ |
| EVALSHA_RO | ❌ |
| EVAL_RO | ❌ |
| FCALL | ❌ |
| FCALL_RO | ❌ |
| FUNCTION DELETE | ❌ |
| FUNCTION DUMP | ❌ |
| FUNCTION FLUSH | ❌ |
| FUNCTION HELP | ❌ |
| FUNCTION KILL | ❌ |
| FUNCTION LIST | ❌ |
| FUNCTION LOAD | ❌ |
| FUNCTION RESTORE | ❌ |
| FUNCTION STATS | ❌ |
| SCRIPT DEBUG | ❌ |
| SCRIPT EXISTS | ❌ |
| SCRIPT FLUSH | ❌ |
| SCRIPT HELP | ❌ |
| SCRIPT KILL | ❌ |
| SCRIPT LOAD | ❌ |
| SCRIPT SHOW | ❌ |

## Search

| Command | Status |
|---------|--------|
| FT.CREATE | ❌ |
| FT.DROPINDEX | ❌ |
| FT.INFO | ❌ |
| FT.SEARCH | ❌ |
| FT._LIST | ❌ |

## Server

| Command | Status |
|---------|--------|
| ACL CAT | ❌ |
| ACL DELUSER | ❌ |
| ACL DRYRUN | ❌ |
| ACL GENPASS | ❌ |
| ACL GETUSER | ❌ |
| ACL HELP | ❌ |
| ACL LIST | ❌ |
| ACL LOAD | ❌ |
| ACL LOG | ❌ |
| ACL SAVE | ❌ |
| ACL SETUSER | ❌ |
| ACL USERS | ❌ |
| ACL WHOAMI | ❌ |
| BGREWRITEAOF | ❌ |
| BGSAVE | ❌ |
| COMMAND COUNT | ❌ |
| COMMAND DOCS | ❌ |
| COMMAND GETKEYS | ❌ |
| COMMAND GETKEYSANDFLAGS | ❌ |
| COMMAND HELP | ❌ |
| COMMAND INFO | ❌ |
| COMMAND LIST | ❌ |
| COMMANDLOG GET | ❌ |
| COMMANDLOG HELP | ❌ |
| COMMANDLOG LEN | ❌ |
| COMMANDLOG RESET | ❌ |
| CONFIG GET | ❌ |
| CONFIG HELP | ❌ |
| CONFIG RESETSTAT | ❌ |
| CONFIG REWRITE | ❌ |
| CONFIG SET | ❌ |
| DBSIZE | ❌ |
| DEBUG | ❌ |
| FAILOVER | ❌ |
| FLUSHALL | ❌ |
| FLUSHDB | ❌ |
| INFO | ❌ |
| LASTSAVE | ❌ |
| LATENCY DOCTOR | ❌ |
| LATENCY GRAPH | ❌ |
| LATENCY HELP | ❌ |
| LATENCY HISTOGRAM | ❌ |
| LATENCY HISTORY | ❌ |
| LATENCY LATEST | ❌ |
| LATENCY RESET | ❌ |
| LOLWUT | ❌ |
| MEMORY DOCTOR | ❌ |
| MEMORY HELP | ❌ |
| MEMORY MALLOC-STATS | ❌ |
| MEMORY PURGE | ❌ |
| MEMORY STATS | ❌ |
| MEMORY USAGE | ❌ |
| MODULE HELP | ❌ |
| MODULE LIST | ❌ |
| MODULE LOAD | ❌ |
| MODULE LOADEX | ❌ |
| MODULE UNLOAD | ❌ |
| MONITOR | ❌ |
| PSYNC | ❌ |
| REPLCONF | ❌ |
| REPLICAOF | ❌ |
| RESTORE-ASKING | ❌ |
| ROLE | ❌ |
| SAVE | ❌ |
| SHUTDOWN | ❌ |
| SLAVEOF | ❌ |
| SLOWLOG GET | ❌ |
| SLOWLOG HELP | ❌ |
| SLOWLOG LEN | ❌ |
| SLOWLOG RESET | ❌ |
| SWAPDB | ❌ |
| SYNC | ❌ |
| TIME | ❌ |

## Set Operations

| Command | Status |
|---------|--------|
| SADD | ✅ |
| SCARD | ✅ |
| SDIFF | ✅ |
| SDIFFSTORE | ✅ |
| SINTER | ✅ |
| SINTERCARD | ❌ |
| SINTERSTORE | ✅ |
| SISMEMBER | ✅ |
| SMEMBERS | ✅ |
| SMISMEMBER | ❌ |
| SMOVE | ✅ |
| SPOP | ✅ |
| SRANDMEMBER | ✅ |
| SREM | ✅ |
| SSCAN | ❌ |
| SUNION | ✅ |
| SUNIONSTORE | ✅ |

## Sorted Set Operations

| Command | Status |
|---------|--------|
| ZADD | ✅ |
| BZMPOP | ❌ |
| BZPOPMAX | ❌ |
| BZPOPMIN | ❌ |
| ZCARD | ✅ |
| ZCOUNT | ✅ |
| ZDIFF | ❌ |
| ZDIFFSTORE | ❌ |
| ZINCRBY | ✅ |
| ZINTER | ❌ |
| ZINTERCARD | ❌ |
| ZINTERSTORE | ❌ |
| ZLEXCOUNT | ❌ |
| ZMPOP | ❌ |
| ZMSCORE | ❌ |
| ZPOPMAX | ❌ |
| ZPOPMIN | ❌ |
| ZRANDMEMBER | ❌ |
| ZRANGE | ✅ |
| ZRANGEBYLEX | ❌ |
| ZRANGEBYSCORE | ✅ |
| ZRANGESTORE | ❌ |
| ZRANK | ✅ |
| ZREM | ✅ |
| ZREMRANGEBYLEX | ❌ |
| ZREMRANGEBYRANK | ❌ |
| ZREMRANGEBYSCORE | ❌ |
| ZREVRANGE | ✅ |
| ZREVRANGEBYLEX | ❌ |
| ZREVRANGEBYSCORE | ✅ |
| ZREVRANK | ✅ |
| ZSCAN | ❌ |
| ZSCORE | ✅ |
| ZUNION | ❌ |
| ZUNIONSTORE | ❌ |

## Stream Operations

| Command | Status |
|---------|--------|
| XACK | ❌ |
| XADD | ❌ |
| XAUTOCLAIM | ❌ |
| XCLAIM | ❌ |
| XDEL | ❌ |
| XGROUP CREATE | ❌ |
| XGROUP CREATECONSUMER | ❌ |
| XGROUP DELCONSUMER | ❌ |
| XGROUP DESTROY | ❌ |
| XGROUP HELP | ❌ |
| XGROUP SETID | ❌ |
| XINFO CONSUMERS | ❌ |
| XINFO GROUPS | ❌ |
| XINFO HELP | ❌ |
| XINFO STREAM | ❌ |
| XLEN | ❌ |
| XPENDING | ❌ |
| XRANGE | ❌ |
| XREAD | ❌ |
| XREADGROUP | ❌ |
| XREVRANGE | ❌ |
| XSETID | ❌ |
| XTRIM | ❌ |

## String Operations

| Command | Status |
|---------|--------|
| APPEND | ✅ |
| BITCOUNT | ❌ |
| BITFIELD | ❌ |
| DECR | ✅ |
| DECRBY | ✅ |
| DELIFEQ | ❌ |
| GET | ✅ |
| GETBIT | ❌ |
| GETDEL | ❌ |
| GETEX | ❌ |
| GETRANGE | ✅ |
| GETSET | ✅ |
| INCR | ✅ |
| INCRBY | ✅ |
| INCRBYFLOAT | ❌ |
| LCS | ❌ |
| MGET | ✅ |
| MSET | ✅ |
| MSETNX | ❌ |
| PSETEX | ❌ |
| SET | ✅ |
| SETBIT | ❌ |
| SETEX | ❌ |
| SETNX | ❌ |
| SETRANGE | ✅ |
| STRLEN | ✅ |
| SUBSTR | ❌ |

## Transactions

| Command | Status |
|---------|--------|
| DISCARD | ❌ |
| EXEC | ❌ |
| MULTI | ❌ |
| UNWATCH | ❌ |
| WATCH | ❌ |

---

## Contributing

Want to contribute? Check out the main README for contribution guidelines.
