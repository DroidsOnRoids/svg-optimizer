import 'dart:math';

abstract class FileSizeFormatter {
  static String format(int size) {
    const suffixes = ["B", "KB", "MB", "GB"];
    var i = (log(size) / log(1024)).floor();
    return '${(size / pow(1024, i)).toStringAsFixed(2)} ${suffixes[i]}';
  }
}
