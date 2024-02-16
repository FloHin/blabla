abstract class AbstractTranslateApi {
  void setup();

  Future<String?> translate(String text, String targetLanguage);
}
