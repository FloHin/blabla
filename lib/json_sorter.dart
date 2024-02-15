import 'dart:convert';

class JsonSorter {
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
      const JsonEncoder encoder = JsonEncoder.withIndent('  ');
      String sortedJsonString = '${encoder.convert(sortedJsonMap)}\n';

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
      print("Error loading or parsing JSON file: $e");
      return null;
    }
  }
}
