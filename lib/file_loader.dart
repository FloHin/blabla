import 'dart:convert';
import 'dart:io';

import 'package:logger/src/logger.dart';

class FileLoader {
  final Logger logger;

  FileLoader(this.logger);

  Future<String?> read(String filePath) async {
    try {
      // Read the file
      final file = File(filePath);
      String contents = await file.readAsString(encoding: utf8);
      return contents;
    } catch (e) {
      logger.e("Error loading or parsing JSON file: $e", error: e);
      return null;
    }
  }

  Future<File?> write(String filePath, String content) async {
    try {
      // Read the file
      final file = File(filePath);
      File output =
          await file.writeAsString(content, encoding: utf8, flush: true);
      return output;
    } catch (e) {
      logger.e("Error loading or parsing JSON file: $e", error: e);
      return null;
    }
  }
}
