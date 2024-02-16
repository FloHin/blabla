import 'dart:io';

import 'package:blabla/blabla.dart';
import 'package:blabla/file_loader.dart';
import 'package:blabla/json_sorter.dart';
import 'package:blabla/translators/deepl_api.dart';
import 'package:blabla/translators/translator.dart';
import 'package:logger/logger.dart';

var globalAllowPrint = false;

Future<void> main(List<String> arguments) async {
  if (arguments.length < 2) {
    _printHelp();
    return;
  }
  final command = arguments[0];
  final inputFile = arguments[1];

  if (arguments.length > 1 && command == 'sort') {
    if (arguments.length > 2 && arguments[2] == "-o") {
      final overwrite = arguments.length > 4 && arguments[4] == "--overwrite";
      Blabla app = createAppWithLogger(true);
      app.runSortSave(inputFile, arguments[3], overwrite);
    } else {
      Blabla app = createAppWithLogger(false);
      app.runSortSave(inputFile, null, false);
    }
  } else if (arguments.length > 1 && command == 'translate') {
    if (arguments.length < 3) {
      _printHelp();
      return;
    }
    final targetLanguage = arguments[2];

    if (arguments.length > 4 && arguments[3] == "-o") {
      final overwrite = arguments.length > 5 && arguments[5] == "--overwrite";
      Blabla app = createAppWithLogger(true);
      app.runDeeplSave(inputFile, targetLanguage, arguments[4], overwrite);
    } else {
      Blabla app = createAppWithLogger(false);
      app.runDeeplSave(inputFile, targetLanguage, null, false);
    }
  } else {
    _printHelp();
  }
}

Future<void> _printHelp() async {
  print("usage: blabla <command> [<args>]");
  print("commands: ");
  print(
      "\t sort <input_file>                                       Sorts the JSON <input_file> and prints the result.");
  print(
      "\t sort <input_file> -o <output_file> [--overwrite]        Sorts the JSON <input_file> and saves the result in <output_file>.");
  print(
      "\t translate <input_file> <lang_code>                      Translates the <input_file> via deepl and prints the result.");
  print(
      "\t translate <input_file> <lang_code> -o <output_file> [--overwrite]   Translates the <input_file> via deepl and saves the result in <output_file>.");
}

Blabla createAppWithLogger(bool allowPrint) {
  globalAllowPrint = allowPrint;
  final logger = createLogger(allowPrint);
  final fileLoader = FileLoader(logger);
  final sorter = JsonHandler(logger);

  final apiKey = Platform.environment['BLABLA_DEEPL_API_KEY'];
  if (apiKey == null) {
    print(
        "No API key found. Please set the environment variable BLABLA_DEEPL_API_KEY");
    exit(1);
  }
  var deeplApi = DeeplApi(logger, apiKey);
  deeplApi.setup();
  final translator = Translator(logger, deeplApi);
  final app = Blabla(logger, fileLoader, sorter, translator);
  return app;
}

Logger createLogger(bool allowPrint) {
  LogOutput? output;
  if (allowPrint) {
    output = ConsoleOutput();
  } else {
    output = FileOutput(file: File("error.log"));
  }
  return Logger(
    filter: null, // Use the default LogFilter (-> only log in debug mode)
    printer: SimplePrinter(), // Use the PrettyPrinter to format and print log
    output: output, // Use the default LogOutput (-> send everything to console)
  );
}
