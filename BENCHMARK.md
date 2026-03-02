# Benchmark Results

**Test Environment**
- **OS:** macos
- **Dart Version:** 3.10.4
- **Server:** Valkey on `localhost:6379`
- **Workload:** SET + GET + PING per iteration
- **Iterations:** 10000 per run
- **Warmup:** 10000 iterations

---

## Latency (ms)

| Library | p50 | p95 | p99 | Avg |
|---------|-----|-----|-----|-----|
| dart_valkey | 0.119 | 0.184 | 0.237 | 0.128 |
| redis package | 0.125 | 0.205 | 0.296 | 0.137 |
| shorebird_redis_client | 0.148 | 0.241 | 0.322 | 0.163 |

## Throughput

| Library | ops/sec |
|---------|---------|
| dart_valkey | 23419.73 |
| redis package | 22121.36 |
| shorebird_redis_client | 18555.64 |

## Memory Usage

| Library | Before (KB) | After (KB) | Delta (KB) |
|---------|-------------|------------|------------|
| dart_valkey | 136246 | 133960 | -2286 |
| redis package | 134037 | 129754 | -4283 |
| shorebird_redis_client | 129778 | 122282 | -7496 |

---

*Generated automatically*
