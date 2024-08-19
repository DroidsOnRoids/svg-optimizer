import '../utils/file_size_formatter.dart';

class BenchmarkResult {
  final int nonOptimizedBuildSize;
  final int optimizedBuildSize;

  const BenchmarkResult({
    required this.nonOptimizedBuildSize,
    required this.optimizedBuildSize,
  });

  @override
  String toString() =>
      'Build size without svg_optimizer: ${FileSizeFormatter.format(nonOptimizedBuildSize)}\n'
      'Build size with svg_optimizer: ${FileSizeFormatter.format(optimizedBuildSize)}\n'
      'Optimized build size is ${FileSizeFormatter.format(nonOptimizedBuildSize - optimizedBuildSize)} smaller '
      '(${((nonOptimizedBuildSize - optimizedBuildSize) / nonOptimizedBuildSize * 100).toStringAsFixed(2)}%)\n';
}
