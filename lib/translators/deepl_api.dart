import 'package:blabla/translators/abstract_translate_api.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class DeeplApi extends AbstractTranslateApi {
  final String apiKey;
  final Logger logger;

  DeeplApi(this.logger, this.apiKey);

  late Dio _dio;
  late Options _options;

  @override
  void setup() {
    _dio = Dio();
    // _dio.interceptors.add(LogInterceptor(responseBody: true));
    _options = Options(
      headers: {
        'Authorization': 'DeepL-Auth-Key $apiKey',
        'Content-Type': 'application/json',
      },
      sendTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    );
  }

  @override
  Future<String?> translate(String text, String targetLanguage) async {
    try {
      var response = await _dio.post(
        'https://api-free.deepl.com/v2/translate',
        data: {
          'text': [text],
          'target_lang': targetLanguage,
        },
        options: _options,
      );
      if (response.statusCode != 200) {
        logger.w(
            'Requesting DEEPL: $text & $targetLanguage -> ${response.statusCode} ${response.statusMessage}');
        return null;
      } else {
        final body = response.data as Map<String, dynamic>;
        final result = body['translations'][0]['text'] as String;
        logger.d('Requesting DEEPL: ($targetLanguage) $text -> $result');
        return result;
      }
    } catch (e) {
      logger.w('Requesting DEEPL: $text & $targetLanguage -> ${e.toString()}');
      return null;
    }
  }
}
