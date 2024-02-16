import 'package:blabla/translators/abstract_translate_api.dart';
import 'package:logger/src/logger.dart';

class Translator {
  final Logger logger;
  final AbstractTranslateApi api;

  Translator(this.logger, this.api);

  Future<Map<String, TranslationResult>> translateAll(
    String targetLanguage,
    Map<String, String> keys,
  ) async {
    logger.d("Prepare ${keys.length} translations ...");

    // Use Future.wait to wait for all translations to complete
    List<TranslationResult> results = [];

    for (final key in keys.entries) {
      final value = keys[key.key];
      final result = await translateEntry(key.key, value!, targetLanguage);
      results.add(result);
    }

    logger.d("Took ${results.length} translations to complete.  ");
    // Convert the list of results into a map
    Map<String, TranslationResult> translations = {};
    for (int i = 0; i < keys.length; i++) {
      translations[keys.entries.elementAt(i).key] = results[i];
    }

    return translations;
  }

  Future<TranslationResult> translateEntry(
      String key, String value, String targetLanguage) async {
    try {
      final translatedValue = await api.translate(value, targetLanguage);
      await Future.delayed(Duration(milliseconds: 2));
      if (translatedValue != null) {
        return TranslationResult(key, translatedValue, true);
      } else {
        return TranslationResult(key, value, false);
      }
    } catch (e) {
      logger.e("Error translating key: $key", error: e);
      return TranslationResult(key, value, false);
    }
  }
}

class TranslationResult {
  final String key;
  final String value;
  final bool success;

  TranslationResult(this.key, this.value, this.success);
}
