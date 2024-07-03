import 'dart:io';

import 'package:args/args.dart';

const String inputOptionName = 'input';
const String outputOptionName = 'output';

void main(List<String> arguments) {
  final ArgParser argParser = buildParser();
  try {
    final ArgResults results = argParser.parse(arguments);

    Process.runSync(
      'svgo',
      ['-i', results[inputOptionName], '-o', results[outputOptionName]],
    );
  } on FormatException catch (e) {
    print(e.message);
    print(argParser.usage);
    exit(1);
  } catch (e) {
    print(e.toString());
    exit(1);
  }
}

ArgParser buildParser() => ArgParser()
  ..addOption(inputOptionName, mandatory: true, abbr: 'i')
  ..addOption(outputOptionName, mandatory: true, abbr: 'o');
