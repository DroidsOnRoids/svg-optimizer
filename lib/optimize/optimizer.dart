import 'dart:io';

import 'package:args/args.dart';

const String _inputOptionName = 'input';
const String _outputOptionName = 'output';
const String _configOptionName = 'config';

void optimizeSvg(List<String> arguments) {
  final ArgParser argParser = buildParser();
  try {
    final ArgResults results = argParser.parse(arguments);

    if (!results[_inputOptionName].endsWith('.svg')) {
      File(results[_inputOptionName]).copySync(results[_outputOptionName]);
      exit(0);
    }

    final String? configPath = results[_configOptionName];

    final ProcessResult result = Process.runSync(
      'svgo',
      [
        '-i',
        results[_inputOptionName],
        '-o',
        results[_outputOptionName],
        if (configPath != null) ...['--config', configPath],
      ],
    );

    if (result.exitCode != 0) {
      print(result.stderr);
      exit(result.exitCode);
    } else {
      print(result.stdout);
      exit(0);
    }
  } on FormatException catch (e) {
    print(e.message);
    print(argParser.usage);
    exit(1);
  } on ProcessException catch (_) {
    print('It looks like svgo is not configured properly. To install it, refer to README file.');
    exit(1);
  } catch (e) {
    print(e.toString());
    exit(1);
  }
}

/// Build argument parser with input and output options
ArgParser buildParser() => ArgParser()
  ..addOption(_inputOptionName, mandatory: true, abbr: 'i')
  ..addOption(_outputOptionName, mandatory: true, abbr: 'o')
  ..addOption(_configOptionName, mandatory: false);
