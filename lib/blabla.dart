import 'dart:io';

import 'package:blabla/file_loader.dart';
import 'package:blabla/json_sorter.dart';
import 'package:blabla/translators/translator.dart';
import 'package:logger/logger.dart';

class Blabla {
  final Logger logger;
  final FileLoader fileLoader;
  final JsonHandler handler;
  final Translator translator;

  Blabla(this.logger, this.fileLoader, this.handler, this.translator);

  Future<void> runSortSave(
      String filePath, String? outputPath, bool overwrite) async {
    _checkOutputOverwrite(outputPath, overwrite);

    final fileContent = await fileLoader.read(filePath);
    final String? output = await handler.sort(fileContent!);

    if (output != null) {
      if (outputPath != null) {
        await fileLoader.write(outputPath, output);
        logger.i("Saved into file: $outputPath");
      } else {
        print(output);
      }
    } else {
      logger.e("Failed to load or parse JSON file.");
    }
  }

  Future<void> runDeeplSave(
    String filePath,
    String targetLanguage,
    String? outputPath,
    bool overwrite,
  ) async {
    _checkOutputOverwrite(outputPath, overwrite);

    final fileContent = await fileLoader.read(filePath);
    final keyLangMap = await handler.getMap(fileContent!);
    if (keyLangMap == null) {
      logger.e("Failed to load or parse JSON file.");
      return;
    }
    if (targetLanguage == "" || targetLanguage.length != 2) {
      logger.e("targetLanguage should be a valid 2-letter language code! Is: $targetLanguage");
      return;
    }

    final Map<String, TranslationResult> results =
        await translator.translateAll(
      targetLanguage,
      keyLangMap,
    );

    final succeeded = results.entries
        .where((element) => element.value.success == true)
        .toList();

    final failed = results.entries
        .where((element) => element.value.success == false)
        .toList();
    Map<String, String> textResults = Map.fromEntries(
        results.entries.map((e) => MapEntry(e.key, e.value.value)));
    final output = handler.encodeMap(textResults);

    if (outputPath != null) {
      await fileLoader.write(outputPath, output);
      logger.i("Saved into file: $outputPath");
      logger.i("Yeah!!!! succeeded many translations: ${succeeded.length}");
      if (failed.isNotEmpty) {
        logger.w("Warning: missed many translations: ${failed.length}");
        for (var element in failed) {
          logger.w("Missing: ${element.key}");
        }
      }
    } else {
      print(output);
    }
  }

  void _checkOutputOverwrite(String? outputPath, bool overwrite) {
    if (outputPath != null) {
      final file = File(outputPath);
      if (file.existsSync() && !overwrite) {
        logger.e(
            "This tool is really untested and will NOT overwrite the file: $outputPath");
        exit(1);
      }
    }
  }
}
