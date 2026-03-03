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
| dart_valkey | 0.120 | 0.189 | 0.253 | 0.130 |
| dart_valkey (commands) | 0.121 | 0.189 | 0.251 | 0.131 |
| dart_valkey (reuse) | 0.121 | 0.187 | 0.240 | 0.129 |
| redis package | 0.121 | 0.186 | 0.252 | 0.130 |
| shorebird_redis_client | 0.148 | 0.223 | 0.283 | 0.159 |
| keyscope_client | 0.148 | 0.219 | 0.296 | 0.158 |

## Throughput

| Library | ops/sec |
|---------|---------|
| dart_valkey | 23029.13 |
| dart_valkey (commands) | 22910.96 |
| dart_valkey (reuse) | 23296.62 |
| redis package | 22981.75 |
| shorebird_redis_client | 18888.20 |
| keyscope_client | 18938.28 |

---

