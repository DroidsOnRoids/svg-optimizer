import 'dart:convert';
import 'dart:io';

import 'package:yaml_edit/yaml_edit.dart';

import 'benchmark_result.dart';
import 'project_size.dart';
import 'supported_platform.dart';

class Benchmark {
  final SupportedPlatform platform;
  final File yamlFile;
  final String originalYaml;
  final ProjectSize projectSize;

  const Benchmark({
    required this.platform,
    required this.yamlFile,
    required this.originalYaml,
    required this.projectSize,
  });

  Future<BenchmarkResult> execute() async {
    final YamlEditor editor = YamlEditor(originalYaml.toString());
    // Reset pubspec.yaml to original form before making changes
    yamlFile.writeAsStringSync(originalYaml.toString());

    final List<dynamic> currentAssets = jsonDecode(jsonEncode(editor.parseAt(['flutter', 'assets']).value));

    late final int nonOptimizedBuildSize;
    late final int optimizedBuildSize;

    // Append assets to pubspec.yaml without transformer
    projectSize.getAssetRecords(false).forEach((element) => editor.appendToList(['flutter', 'assets'], element));
    yamlFile.writeAsStringSync(editor.toString());

    // Make a benchmark with non optimized SVG files
    Directory.current = Directory('../example');
    print('Building without svg_optimizer...');
    final ProcessResult nonOptimizedResult = await Process.run('flutter', platform.buildArguments);
    if (nonOptimizedResult.exitCode != 0) {
      print(nonOptimizedResult.stderr);
      throw Exception('Failed to build non optimized project');
    }

    Directory.current = Directory('../benchmark');
    nonOptimizedBuildSize = File(platform.buildPath).lengthSync();

    // Reset previous changes to assets in pubspec.yaml
    editor.update(['flutter', 'assets'], currentAssets);
    // Append assets to pubspec.yaml with transformer
    projectSize.getAssetRecords(true).forEach((element) => editor.appendToList(['flutter', 'assets'], element));
    yamlFile.writeAsStringSync(editor.toString());

    // Make a benchmark with optimized SVG files
    print('Building with svg_optimizer...');
    Directory.current = Directory('../example');
    final ProcessResult optimizedResult = await Process.run('flutter', platform.buildArguments);
    if (optimizedResult.exitCode != 0) {
      print(optimizedResult.stderr);
      throw Exception('Failed to build optimized project');
    }

    Directory.current = Directory('../benchmark');
    optimizedBuildSize = File(platform.buildPath).lengthSync();

    return BenchmarkResult(
      nonOptimizedBuildSize: nonOptimizedBuildSize,
      optimizedBuildSize: optimizedBuildSize,
    );
  }
}
