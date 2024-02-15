import 'dart:io';

class FileLoader {
  Future<String?> read(String filePath) async {
    try {
      // Read the file
      final file = File(filePath);
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      print("Error loading or parsing JSON file: $e");
      return null;
    }
  }

  Future<File?> write(String filePath, String content) async {
    try {
      // Read the file
      final file = File(filePath);
      File output = await file.writeAsString(content);
      return output;
    } catch (e) {
      print("Error loading or parsing JSON file: $e");
      return null;
    }
  }
}
