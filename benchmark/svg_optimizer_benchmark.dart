import 'dart:io';

import 'package:args/args.dart';
import 'package:collection/collection.dart';

import 'lib/benchmark.dart';
import 'lib/benchmark_result.dart';
import 'lib/project_size.dart';
import 'lib/supported_platform.dart';

Future<void> main(List<String> arguments) async {
  final File yamlFile = File('../example/pubspec.yaml');
  final String originalYaml = yamlFile.readAsStringSync();
  final ArgParser argParser = buildParser();
  final ArgResults results = argParser.parse(arguments);

  SupportedPlatform? platform = SupportedPlatform.values.firstWhereOrNull((element) => results[element.value] == true);

  if (platform == null) {
    print('Please provide platform argument');
    print(argParser.usage);
    exit(1);
  }

  final Benchmark smallProjectBenchmark = Benchmark(
    platform: platform,
    yamlFile: yamlFile,
    originalYaml: originalYaml,
    projectSize: ProjectSize.small,
  );

  final Benchmark mediumProjectBenchmark = Benchmark(
    platform: platform,
    yamlFile: yamlFile,
    originalYaml: originalYaml,
    projectSize: ProjectSize.medium,
  );

  final Benchmark bigProjectBenchmark = Benchmark(
    platform: platform,
    yamlFile: yamlFile,
    originalYaml: originalYaml,
    projectSize: ProjectSize.big,
  );

  try {
    print("*** Benchmarking small project... ***\n");
    final BenchmarkResult smallResult = await smallProjectBenchmark.execute();
    print("\nSmall project benchmark result:\n$smallResult");

    print("*** Benchmarking medium project... ***\n");
    final BenchmarkResult mediumResult = await mediumProjectBenchmark.execute();
    print("\nMedium project benchmark result:\n$mediumResult");

    print("*** Benchmarking big project... ***\n");
    final BenchmarkResult bigResult = await bigProjectBenchmark.execute();
    print("\nBig project benchmark result:\n$bigResult");
  } catch (e) {
    print(e);
    exit(1);
  } finally {
    // Restore original pubspec.yaml
    yamlFile.writeAsStringSync(originalYaml);
  }
}

/// Build argument parser with input and output options
ArgParser buildParser() => ArgParser()
  ..addFlag(SupportedPlatform.android.value, defaultsTo: false)
  ..addFlag(SupportedPlatform.ios.value, defaultsTo: false);
