import 'dart:io';

import 'package:args/args.dart';
import 'package:posix/posix.dart';

const String _inputOptionName = 'input';
const String _outputOptionName = 'output';
const String _configOptionName = 'config';

Future<void> optimizeSvg(List<String> arguments) async {
  final ArgParser argParser = buildParser();
  try {
    final ArgResults results = argParser.parse(arguments);

    bool canProceed = false;
    while (!canProceed) {
      final lastFd = dup(0);
      if (lastFd >= 0) {
        close(lastFd);
        int totalFd = getdtablesize();
        int possibleOpenFiles = totalFd - lastFd;
        if (possibleOpenFiles >= 16) {
          canProceed = true;
        } else {
          await Future.delayed(const Duration(seconds: 1));
        }
      } else {
        canProceed = true;
      }
    }

    final String inputName = results[_inputOptionName];
    final String outputName = results[_outputOptionName];

    if (!inputName.toLowerCase().endsWith('.svg')) {
      File(inputName).copySync(outputName);
      exit(0);
    }

    final String? configPath = results[_configOptionName];

    final ProcessResult result = Process.runSync(
      'svgo',
      [
        '-i',
        inputName,
        '-o',
        outputName,
        if (configPath != null) ...['--config', configPath],
      ],
    );

    if (result.exitCode != 0) {
      print(result.stderr);
      stderr.write(result.stderr);
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
    print(
        'It looks like svgo is not configured properly. To install it, refer to README file.');
    exit(1);
  } catch (e) {
    print(e.toString());
    exit(1);
  }
}

/// Build argument parser with input and output options
ArgParser buildParser() =>
    ArgParser()
      ..addOption(_inputOptionName, mandatory: true, abbr: 'i')..addOption(
        _outputOptionName, mandatory: true, abbr: 'o')..addOption(_configOptionName, mandatory: false);
