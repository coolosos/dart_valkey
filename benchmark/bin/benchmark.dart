import 'dart:convert';
import 'dart:io';

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
  });

  factory BenchmarkResult.fromJson(Map<String, dynamic> json) {
    return BenchmarkResult(
      name: json['name'] as String,
      iterations: 0,
      warmupIterations: 0,
      latencyP50: (json['latencyP50'] as num).toDouble(),
      latencyP95: (json['latencyP95'] as num).toDouble(),
      latencyP99: (json['latencyP99'] as num).toDouble(),
      avgLatency: (json['avgLatency'] as num).toDouble(),
      throughput: (json['throughput'] as num).toDouble(),
    );
  }
  final String name;
  final int iterations;
  final int warmupIterations;
  final double latencyP50;
  final double latencyP95;
  final double latencyP99;
  final double avgLatency;
  final double throughput;

  Map<String, dynamic> toJson() => {
        'name': name,
        'iterations': iterations,
        'warmupIterations': warmupIterations,
        'latencyP50': latencyP50,
        'latencyP95': latencyP95,
        'latencyP99': latencyP99,
        'avgLatency': avgLatency,
        'throughput': throughput,
      };
}

Future<BenchmarkResult> runClientScript(
  String scriptPath,
  int iterations,
  int warmup,
) async {
  print('--- Running: $scriptPath ---');

  final process = await Process.start(
    'dart',
    ['run', scriptPath, '$iterations', '$warmup'],
    workingDirectory: Directory.current.path,
  );

  final stdout = await process.stdout.transform(utf8.decoder).join();
  final stderr = await process.stderr.transform(utf8.decoder).join();
  final exitCode = await process.exitCode;

  if (exitCode != 0) {
    print('Error running $scriptPath:');
    print(stderr);
    throw Exception('Failed to run $scriptPath');
  }

  final json = jsonDecode(stdout.trim()) as Map<String, dynamic>;
  return BenchmarkResult.fromJson(json);
}

String generateMarkdown(List<BenchmarkResult> results) {
  final dartVersion = Platform.version.split(' ').first;

  final buffer = StringBuffer();

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
      '| ${r.name} | ${r.latencyP50.toStringAsFixed(3)} | ${r.latencyP95.toStringAsFixed(3)} | ${r.latencyP99.toStringAsFixed(3)} | ${r.avgLatency.toStringAsFixed(3)} |',
    );
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

  buffer.writeln('---');
  buffer.writeln();

  return buffer.toString();
}

Future<void> main() async {
  const rounds = 10;
  const iterations = 10000;
  const warmupIterations = 10000;

  print('===========================================');
  print('       Redis/Dart Client Benchmark       ');
  print('===========================================');
  print('');
  print('Configuration:');
  print('  Rounds: $rounds');
  print('  Iterations per round: $iterations');
  print('  Warmup iterations: $warmupIterations');
  print('');
  print('Note: Each client runs in a separate process');
  print('');

  final clientScripts = [
    'bin/clients/dart_valkey.dart',
    'bin/clients/dart_valkey_commands.dart',
    'bin/clients/dart_valkey_reuse.dart',
    'bin/clients/redis_package.dart',
    'bin/clients/shorebird.dart',
    'bin/clients/keyscope_client.dart',
  ];

  final allResults = <List<BenchmarkResult>>[];

  for (var round = 1; round <= rounds; round++) {
    print('=== Round $round / $rounds ===');
    print('');

    final roundResults = <BenchmarkResult>[];

    for (final script in clientScripts) {
      final result =
          await runClientScript(script, iterations, warmupIterations);
      roundResults.add(result);

      print('  ${result.name}:');
      print('    p50: ${result.latencyP50.toStringAsFixed(3)} ms');
      print('    p95: ${result.latencyP95.toStringAsFixed(3)} ms');
      print('    p99: ${result.latencyP99.toStringAsFixed(3)} ms');
      print('    Throughput: ${result.throughput.toStringAsFixed(2)} ops/sec');
      print('');

      // Delay between clients
      await Future.delayed(const Duration(seconds: 1));
    }

    allResults.add(roundResults);

    // Delay between rounds
    if (round < rounds) {
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
    'dart_valkey (commands)',
    'dart_valkey (reuse)',
    'redis package',
    'shorebird_redis_client',
    'keyscope_client',
  ];
  final averagedResults = <BenchmarkResult>[];

  for (var i = 0; i < 6; i++) {
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

    averagedResults.add(
      BenchmarkResult(
        name: clientNames[i],
        iterations: iterations,
        warmupIterations: warmupIterations,
        latencyP50: avgP50,
        latencyP95: avgP95,
        latencyP99: avgP99,
        avgLatency: avgLatency,
        throughput: avgThroughput,
      ),
    );
  }

  // Print summary
  for (final r in averagedResults) {
    print('${r.name}:');
    print('  Latency p50: ${r.latencyP50.toStringAsFixed(3)} ms');
    print('  Latency p95: ${r.latencyP95.toStringAsFixed(3)} ms');
    print('  Latency p99: ${r.latencyP99.toStringAsFixed(3)} ms');
    print('  Avg Latency: ${r.avgLatency.toStringAsFixed(3)} ms');
    print('  Throughput: ${r.throughput.toStringAsFixed(2)} ops/sec');
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
