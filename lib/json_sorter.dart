import 'dart:convert';

import 'package:logger/src/logger.dart';

class JsonHandler {
  final Logger logger;

  JsonHandler(this.logger);

  Future<String?> sort(String content) async {
    try {
      final result = json.decode(content);
      if (result == null) {
        return null;
      }
      Map<String, dynamic> jsonMap = result as Map<String, dynamic>;
      Map<String, String> strudelMap = {};
      Map<String, dynamic> fixedMap = {};
      for (final key in result.keys) {
        final value = jsonMap[key];
        if (key.startsWith('@')) {
          final fixedKey = key.substring(1);
          final finalKey = "${fixedKey}_$key";
          strudelMap[finalKey] = key;
          fixedMap[finalKey] = value;
        } else {
          fixedMap[key] = value;
        }
      }

      Map<String, dynamic> sortedJsonMap = Map.fromEntries(
          fixedMap.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
      String sortedJsonString = encodeMap(sortedJsonMap);

      for (final key in strudelMap.keys) {
        final value =
            sortedJsonString.replaceAll('"$key"', '"${strudelMap[key]}"');
        sortedJsonString = value;
      }
      // if (Platform.isWindows) {
      //   sortedJsonString = sortedJsonString.replaceAll('\n', '\r\n');
      // }

      return sortedJsonString;
    } catch (e) {
      logger.e("Error loading or parsing JSON file: $e", error: e);
      return null;
    }
  }

  String encodeMap(Map<String, dynamic> sortedJsonMap) {
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    String sortedJsonString = '${encoder.convert(sortedJsonMap)}\n';
    return sortedJsonString;
  }

  Future<Map<String, String>?> getMap(String content) async {
    try {
      final result = json.decode(content);
      if (result == null) {
        return null;
      }
      Map<String, dynamic> jsonMap = result as Map<String, dynamic>;
      Map<String, String> fixedMap = {};
      for (final key in result.keys) {
        final value = jsonMap[key];
        if (key.startsWith('@')) {
          // just skip
        } else {
          if (value is String) {
            fixedMap[key] = value;
          }
        }
      }
      return fixedMap;
    } catch (e) {
      logger.w("Error loading or parsing JSON file: $e", error: e);
      return null;
    }
  }
}
