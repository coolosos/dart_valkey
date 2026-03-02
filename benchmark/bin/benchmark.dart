import 'dart:async';
import 'dart:io';

import 'package:dart_valkey/dart_valkey.dart';
import 'package:redis/redis.dart';
import 'package:shorebird_redis_client/shorebird_redis_client.dart';

class BenchmarkResult {
  BenchmarkResult({
    required this.name,
    required this.iterations,
    required this.warmupIterations,
    required this.latencyP50,
    required this.latencyP95,
    required this.latencyP99,
    required this.avgLatency,
    required this.throughput,
    required this.memoryBefore,
    required this.memoryAfter,
    required this.memoryDelta,
  });

  final String name;
  final int iterations;
  final int warmupIterations;
  final double latencyP50;
  final double latencyP95;
  final double latencyP99;
  final double avgLatency;
  final double throughput;
  final int memoryBefore;
  final int memoryAfter;
  final int memoryDelta;

  Map<String, dynamic> toJson() => {
        'name': name,
        'iterations': iterations,
        'warmupIterations': warmupIterations,
        'latencyP50': latencyP50,
        'latencyP95': latencyP95,
        'latencyP99': latencyP99,
        'avgLatency': avgLatency,
        'throughput': throughput,
        'memoryBefore': memoryBefore,
        'memoryAfter': memoryAfter,
        'memoryDelta': memoryDelta,
      };
}

int getMemoryKB() {
  return ProcessInfo.currentRss ~/ 1024;
}

double percentile(List<double> sorted, double p) {
  if (sorted.isEmpty) return 0;
  final index = ((sorted.length - 1) * p).round();
  return sorted[index];
}

Future<BenchmarkResult> benchmarkDartValkey({
  int iterations = 10000,
  int warmupIterations = 10000,
}) async {
  print('--- Benchmark: dart_valkey ---');

  final memBefore = getMemoryKB();
  final client = ValkeyCommandClient(host: 'localhost', port: 6379);
  await client.connect();
  print('  Connected');

  // Warmup - allow JIT to optimize
  print('  Warmup: $warmupIterations iterations...');
  for (int i = 0; i < warmupIterations; i++) {
    await client.set('warmup_$i', 'value_$i');
    await client.get('warmup_$i');
    await client.ping();
  }

  // Actual benchmark
  print('  Running: $iterations iterations...');
  final latencies = <double>[];
  final swTotal = Stopwatch()..start();

  for (int i = 0; i < iterations; i++) {
    final sw = Stopwatch()..start();
    await client.set('key_$i', 'value_$i');
    await client.get('key_$i');
    await client.ping();
    sw.stop();
    latencies.add(sw.elapsedMicroseconds / 1000.0);
  }

  swTotal.stop();

  final memAfter = getMemoryKB();
  await client.close();
  print('  Closed');

  // Calculate statistics
  final sortedLatencies = List<double>.from(latencies)..sort();
  final p50 = percentile(sortedLatencies, 0.50);
  final p95 = percentile(sortedLatencies, 0.95);
  final p99 = percentile(sortedLatencies, 0.99);
  final avgLatency = latencies.reduce((a, b) => a + b) / latencies.length;
  final throughput = iterations * 3 / (swTotal.elapsedMilliseconds / 1000.0);

  print('  Results:');
  print('    Latency p50: ${p50.toStringAsFixed(3)} ms');
  print('    Latency p95: ${p95.toStringAsFixed(3)} ms');
  print('    Latency p99: ${p99.toStringAsFixed(3)} ms');
  print('    Avg Latency: ${avgLatency.toStringAsFixed(3)} ms');
  print('    Throughput: ${throughput.toStringAsFixed(2)} ops/sec');
  print(
      '    Memory: $memBefore KB -> $memAfter KB (delta: ${memAfter - memBefore} KB)');
  print('');

  return BenchmarkResult(
    name: 'dart_valkey',
    iterations: iterations,
    warmupIterations: warmupIterations,
    latencyP50: p50,
    latencyP95: p95,
    latencyP99: p99,
    avgLatency: avgLatency,
    throughput: throughput,
    memoryBefore: memBefore,
    memoryAfter: memAfter,
    memoryDelta: memAfter - memBefore,
  );
}

Future<BenchmarkResult> benchmarkRedisPackage({
  int iterations = 10000,
  int warmupIterations = 10000,
}) async {
  print('--- Benchmark: redis package ---');

  final memBefore = getMemoryKB();
  final redisConnection = RedisConnection();
  final redisCommand = await redisConnection.connect('localhost', 6379);
  print('  Connected');

  // Warmup
  print('  Warmup: $warmupIterations iterations...');
  for (int i = 0; i < warmupIterations; i++) {
    await redisCommand.send_object(['SET', 'warmup_$i', 'value_$i']);
    await redisCommand.send_object(['GET', 'warmup_$i']);
    await redisCommand.send_object(['PING']);
  }

  // Actual benchmark
  print('  Running: $iterations iterations...');
  final latencies = <double>[];
  final swTotal = Stopwatch()..start();

  for (int i = 0; i < iterations; i++) {
    final sw = Stopwatch()..start();
    await redisCommand.send_object(['SET', 'key_$i', 'value_$i']);
    await redisCommand.send_object(['GET', 'key_$i']);
    await redisCommand.send_object(['PING']);
    sw.stop();
    latencies.add(sw.elapsedMicroseconds / 1000.0);
  }

  swTotal.stop();

  final memAfter = getMemoryKB();
  await redisConnection.close();
  print('  Closed');

  final sortedLatencies = List<double>.from(latencies)..sort();
  final p50 = percentile(sortedLatencies, 0.50);
  final p95 = percentile(sortedLatencies, 0.95);
  final p99 = percentile(sortedLatencies, 0.99);
  final avgLatency = latencies.reduce((a, b) => a + b) / latencies.length;
  final throughput = iterations * 3 / (swTotal.elapsedMilliseconds / 1000.0);

  print('  Results:');
  print('    Latency p50: ${p50.toStringAsFixed(3)} ms');
  print('    Latency p95: ${p95.toStringAsFixed(3)} ms');
  print('    Latency p99: ${p99.toStringAsFixed(3)} ms');
  print('    Avg Latency: ${avgLatency.toStringAsFixed(3)} ms');
  print('    Throughput: ${throughput.toStringAsFixed(2)} ops/sec');
  print(
      '    Memory: $memBefore KB -> $memAfter KB (delta: ${memAfter - memBefore} KB)');
  print('');

  return BenchmarkResult(
    name: 'redis package',
    iterations: iterations,
    warmupIterations: warmupIterations,
    latencyP50: p50,
    latencyP95: p95,
    latencyP99: p99,
    avgLatency: avgLatency,
    throughput: throughput,
    memoryBefore: memBefore,
    memoryAfter: memAfter,
    memoryDelta: memAfter - memBefore,
  );
}

Future<BenchmarkResult> benchmarkShorebirdRedisClient({
  int iterations = 10000,
  int warmupIterations = 10000,
}) async {
  print('--- Benchmark: shorebird_redis_client ---');

  final memBefore = getMemoryKB();
  final client = RedisClient();
  await client.connect();
  print('  Connected');

  // Warmup
  print('  Warmup: $warmupIterations iterations...');
  for (int i = 0; i < warmupIterations; i++) {
    await client.execute(['SET', 'warmup_$i', 'value_$i']);
    await client.execute(['GET', 'warmup_$i']);
    await client.execute(['PING']);
  }

  // Actual benchmark
  print('  Running: $iterations iterations...');
  final latencies = <double>[];
  final swTotal = Stopwatch()..start();

  for (int i = 0; i < iterations; i++) {
    final sw = Stopwatch()..start();
    await client.execute(['SET', 'key_$i', 'value_$i']);
    await client.execute(['GET', 'key_$i']);
    await client.execute(['PING']);
    sw.stop();
    latencies.add(sw.elapsedMicroseconds / 1000.0);
  }

  swTotal.stop();

  final memAfter = getMemoryKB();
  await client.close();
  print('  Closed');

  final sortedLatencies = List<double>.from(latencies)..sort();
  final p50 = percentile(sortedLatencies, 0.50);
  final p95 = percentile(sortedLatencies, 0.95);
  final p99 = percentile(sortedLatencies, 0.99);
  final avgLatency = latencies.reduce((a, b) => a + b) / latencies.length;
  final throughput = iterations * 3 / (swTotal.elapsedMilliseconds / 1000.0);

  print('  Results:');
  print('    Latency p50: ${p50.toStringAsFixed(3)} ms');
  print('    Latency p95: ${p95.toStringAsFixed(3)} ms');
  print('    Latency p99: ${p99.toStringAsFixed(3)} ms');
  print('    Avg Latency: ${avgLatency.toStringAsFixed(3)} ms');
  print('    Throughput: ${throughput.toStringAsFixed(2)} ops/sec');
  print(
      '    Memory: $memBefore KB -> $memAfter KB (delta: ${memAfter - memBefore} KB)');
  print('');

  return BenchmarkResult(
    name: 'shorebird_redis_client',
    iterations: iterations,
    warmupIterations: warmupIterations,
    latencyP50: p50,
    latencyP95: p95,
    latencyP99: p99,
    avgLatency: avgLatency,
    throughput: throughput,
    memoryBefore: memBefore,
    memoryAfter: memAfter,
    memoryDelta: memAfter - memBefore,
  );
}

String generateMarkdown(List<BenchmarkResult> results) {
  final buffer = StringBuffer();

  // Environment info
  final dartVersion = Platform.version.split(' ').first;

  buffer.writeln('# Benchmark Results');
  buffer.writeln();
  buffer.writeln('**Test Environment**');
  buffer.writeln('- **OS:** ${Platform.operatingSystem}');
  buffer.writeln('- **Dart Version:** $dartVersion');
  buffer.writeln('- **Server:** Valkey on `localhost:6379`');
  buffer.writeln('- **Workload:** SET + GET + PING per iteration');
  buffer.writeln('- **Iterations:** ${results.first.iterations} per run');
  buffer.writeln('- **Warmup:** ${results.first.warmupIterations} iterations');
  buffer.writeln();
  buffer.writeln('---');
  buffer.writeln();

  // Latency table
  buffer.writeln('## Latency (ms)');
  buffer.writeln();
  buffer.writeln('| Library | p50 | p95 | p99 | Avg |');
  buffer.writeln('|---------|-----|-----|-----|-----|');

  for (final r in results) {
    buffer.writeln(
        '| ${r.name} | ${r.latencyP50.toStringAsFixed(3)} | ${r.latencyP95.toStringAsFixed(3)} | ${r.latencyP99.toStringAsFixed(3)} | ${r.avgLatency.toStringAsFixed(3)} |');
  }
  buffer.writeln();

  // Throughput table
  buffer.writeln('## Throughput');
  buffer.writeln();
  buffer.writeln('| Library | ops/sec |');
  buffer.writeln('|---------|---------|');

  for (final r in results) {
    buffer.writeln('| ${r.name} | ${r.throughput.toStringAsFixed(2)} |');
  }
  buffer.writeln();

  // Memory table
  buffer.writeln('## Memory Usage');
  buffer.writeln();
  buffer.writeln('| Library | Before (KB) | After (KB) | Delta (KB) |');
  buffer.writeln('|---------|-------------|------------|------------|');

  for (final r in results) {
    buffer.writeln(
        '| ${r.name} | ${r.memoryBefore} | ${r.memoryAfter} | ${r.memoryDelta} |');
  }
  buffer.writeln();

  // Summary
  buffer.writeln('---');
  buffer.writeln();
  buffer.writeln('*Generated automatically*');

  return buffer.toString();
}

Future<void> main() async {
  const int rounds = 10;
  const int iterations = 10000;
  const int warmupIterations = 10000;

  print('===========================================');
  print('       Redis/Dart Client Benchmark       ');
  print('===========================================');
  print('');
  print('Configuration:');
  print('  Rounds: $rounds');
  print('  Iterations per round: $iterations');
  print('  Warmup iterations: $warmupIterations');
  print('');

  // Collect results per round
  final allResults = <List<BenchmarkResult>>[];

  for (int round = 1; round <= rounds; round++) {
    print('=== Round $round / $rounds ===');
    print('');

    allResults.add([
      await benchmarkDartValkey(
          iterations: iterations, warmupIterations: warmupIterations),
      await benchmarkRedisPackage(
          iterations: iterations, warmupIterations: warmupIterations),
      await benchmarkShorebirdRedisClient(
          iterations: iterations, warmupIterations: warmupIterations),
    ]);

    // Delay between rounds
    if (round < rounds) {
      print('Waiting 2 seconds before next round...');
      await Future.delayed(const Duration(seconds: 2));
    }
    print('');
  }

  // Calculate averages
  print('===========================================');
  print('          Final Results (Averaged)         ');
  print('===========================================');
  print('');

  final clientNames = [
    'dart_valkey',
    'redis package',
    'shorebird_redis_client'
  ];
  final averagedResults = <BenchmarkResult>[];

  for (int i = 0; i < 3; i++) {
    final roundResults = allResults.map((r) => r[i]).toList();

    final avgP50 =
        roundResults.map((r) => r.latencyP50).reduce((a, b) => a + b) / rounds;
    final avgP95 =
        roundResults.map((r) => r.latencyP95).reduce((a, b) => a + b) / rounds;
    final avgP99 =
        roundResults.map((r) => r.latencyP99).reduce((a, b) => a + b) / rounds;
    final avgLatency =
        roundResults.map((r) => r.avgLatency).reduce((a, b) => a + b) / rounds;
    final avgThroughput =
        roundResults.map((r) => r.throughput).reduce((a, b) => a + b) / rounds;
    final avgMemDelta =
        roundResults.map((r) => r.memoryDelta).reduce((a, b) => a + b) / rounds;
    final avgMemBefore =
        roundResults.map((r) => r.memoryBefore).reduce((a, b) => a + b) /
            rounds;
    final avgMemAfter =
        roundResults.map((r) => r.memoryAfter).reduce((a, b) => a + b) / rounds;

    averagedResults.add(BenchmarkResult(
      name: clientNames[i],
      iterations: iterations,
      warmupIterations: warmupIterations,
      latencyP50: avgP50,
      latencyP95: avgP95,
      latencyP99: avgP99,
      avgLatency: avgLatency,
      throughput: avgThroughput,
      memoryBefore: avgMemBefore.round(),
      memoryAfter: avgMemAfter.round(),
      memoryDelta: avgMemDelta.round(),
    ));
  }

  // Print summary
  for (final r in averagedResults) {
    print('${r.name}:');
    print('  Latency p50: ${r.latencyP50.toStringAsFixed(3)} ms');
    print('  Latency p95: ${r.latencyP95.toStringAsFixed(3)} ms');
    print('  Latency p99: ${r.latencyP99.toStringAsFixed(3)} ms');
    print('  Avg Latency: ${r.avgLatency.toStringAsFixed(3)} ms');
    print('  Throughput: ${r.throughput.toStringAsFixed(2)} ops/sec');
    print('  Memory Delta: ${r.memoryDelta} KB');
    print('');
  }

  // Generate and save markdown
  final markdown = generateMarkdown(averagedResults);
  final benchmarkFile = File('../BENCHMARK.md');
  await benchmarkFile.writeAsString(markdown);

  print('===========================================');
  print('Results saved to BENCHMARK.md');
  print('===========================================');
}
