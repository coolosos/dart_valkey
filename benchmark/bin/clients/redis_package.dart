import 'dart:convert';
import 'dart:io';

import 'package:redis/redis.dart';

class ClientResult {
  ClientResult({
    required this.name,
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

double percentile(List<double> sorted, double p) {
  if (sorted.isEmpty) return 0;
  final index = ((sorted.length - 1) * p).round();
  return sorted[index];
}

Future<void> main(List<String> args) async {
  if (args.length < 2) {
    stderr
        .writeln('Usage: dart run clients:redis_package <iterations> <warmup>');
    exit(1);
  }

  final iterations = int.parse(args[0]);
  final warmupIterations = int.parse(args[1]);

  final memoryBefore = ProcessInfo.currentRss ~/ 1024;

  final redisConnection = RedisConnection();
  final redisCommand = await redisConnection.connect('localhost', 6379);

  // Warmup
  for (var i = 0; i < warmupIterations; i++) {
    await redisCommand.send_object(['SET', 'warmup_$i', 'value_$i']);
    await redisCommand.send_object(['GET', 'warmup_$i']);
    await redisCommand.send_object(['PING']);
  }

  // Benchmark
  final latencies = <double>[];
  final swTotal = Stopwatch()..start();

  for (var i = 0; i < iterations; i++) {
    final sw = Stopwatch()..start();
    await redisCommand.send_object(['SET', 'key_$i', 'value_$i']);
    await redisCommand.send_object(['GET', 'key_$i']);
    await redisCommand.send_object(['PING']);
    sw.stop();
    latencies.add(sw.elapsedMicroseconds / 1000.0);
  }

  swTotal.stop();

  final memoryAfter = ProcessInfo.currentRss ~/ 1024;
  await redisConnection.close();

  final sortedLatencies = List<double>.from(latencies)..sort();
  final p50 = percentile(sortedLatencies, 0.50);
  final p95 = percentile(sortedLatencies, 0.95);
  final p99 = percentile(sortedLatencies, 0.99);
  final avgLatency = latencies.reduce((a, b) => a + b) / latencies.length;
  final throughput = iterations * 3 / (swTotal.elapsedMilliseconds / 1000.0);

  final result = ClientResult(
    name: 'redis package',
    latencyP50: p50,
    latencyP95: p95,
    latencyP99: p99,
    avgLatency: avgLatency,
    throughput: throughput,
    memoryBefore: memoryBefore,
    memoryAfter: memoryAfter,
    memoryDelta: memoryAfter - memoryBefore,
  );

  print(jsonEncode(result.toJson()));
}
