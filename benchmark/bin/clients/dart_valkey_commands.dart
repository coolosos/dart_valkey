import 'dart:convert';
import 'dart:io';

import 'package:dart_valkey/dart_valkey.dart';

class ClientResult {
  ClientResult({
    required this.name,
    required this.latencyP50,
    required this.latencyP95,
    required this.latencyP99,
    required this.avgLatency,
    required this.throughput,
  });
  final String name;
  final double latencyP50;
  final double latencyP95;
  final double latencyP99;
  final double avgLatency;
  final double throughput;

  Map<String, dynamic> toJson() => {
        'name': name,
        'latencyP50': latencyP50,
        'latencyP95': latencyP95,
        'latencyP99': latencyP99,
        'avgLatency': avgLatency,
        'throughput': throughput,
      };
}

double percentile(List<double> sorted, double p) {
  if (sorted.isEmpty) return 0;
  final index = ((sorted.length - 1) * p).round();
  return sorted[index];
}

Future<void> main(List<String> args) async {
  if (args.length < 2) {
    stderr.writeln(
      'Usage: dart run clients:dart_valkey_commands <iterations> <warmup>',
    );
    exit(1);
  }

  final iterations = int.parse(args[0]);
  final warmupIterations = int.parse(args[1]);

  final client = ValkeyCommandClient(host: 'localhost', port: 6379);
  await client.connect();

  // Warmup using execute with commands (not extensions)
  for (var i = 0; i < warmupIterations; i++) {
    await client.execute(SetCommand('warmup_$i', 'value_$i'));
    await client.execute(GetCommand('warmup_$i'));
    await client.execute(PingCommand());
  }

  // Benchmark using execute with commands (not extensions)
  final latencies = <double>[];
  final swTotal = Stopwatch()..start();

  for (var i = 0; i < iterations; i++) {
    final sw = Stopwatch()..start();
    await client.execute(SetCommand('key_$i', 'value_$i'));
    await client.execute(GetCommand('key_$i'));
    await client.execute(PingCommand());
    sw.stop();
    latencies.add(sw.elapsedMicroseconds / 1000.0);
  }

  swTotal.stop();

  await client.close();

  final sortedLatencies = List<double>.from(latencies)..sort();
  final p50 = percentile(sortedLatencies, 0.50);
  final p95 = percentile(sortedLatencies, 0.95);
  final p99 = percentile(sortedLatencies, 0.99);
  final avgLatency = latencies.reduce((a, b) => a + b) / latencies.length;
  final throughput = iterations * 3 / (swTotal.elapsedMilliseconds / 1000.0);

  final result = ClientResult(
    name: 'dart_valkey (commands)',
    latencyP50: p50,
    latencyP95: p95,
    latencyP99: p99,
    avgLatency: avgLatency,
    throughput: throughput,
  );

  print(jsonEncode(result.toJson()));
}
