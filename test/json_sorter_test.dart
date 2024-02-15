import 'package:blabla/json_sorter.dart';
import 'package:test/test.dart';

final easy_unsorted = '''
{
  "cancel": "Abbrechen",
  "common_cancel": "Abbrechen",
  "name": "John",
  "call_request_dashboard_text_date": "{name} wünscht sich einen Anruf von dir um {time}.",
  "age": 30
}
''';

final easy_sorted = '''
{
  "age": 30,
  "call_request_dashboard_text_date": "{name} wünscht sich einen Anruf von dir um {time}.",
  "cancel": "Abbrechen",
  "common_cancel": "Abbrechen",
  "name": "John"
}
''';

final complex_unsorted = '''
{
  "@call_request_dashboard_text_date": {
    "placeholders": {
      "name": {
        "type": "String",
        "example": "Gerti"
      },
      "time": {
        "type": "String",
        "example": "11:23"
      }
    }
  },
  "cancel": "Abbrechen",
  "common_cancel": "Abbrechen",
  "name": "John",
  "call_request_dashboard_text_date": "{name} wünscht sich einen Anruf von dir um {time}.",
  "age": 30
}
''';

final complex_sorted = '''
{
  "age": 30,
  "call_request_dashboard_text_date": "{name} wünscht sich einen Anruf von dir um {time}.",
  "@call_request_dashboard_text_date": {
    "placeholders": {
      "name": {
        "type": "String",
        "example": "Gerti"
      },
      "time": {
        "type": "String",
        "example": "11:23"
      }
    }
  },
  "cancel": "Abbrechen",
  "common_cancel": "Abbrechen",
  "name": "John"
}
''';

void main() {
  test('JsonFileLoader should parse easy json', () async {
    final subject = JsonSorter();
    final result = await subject.sort(easy_unsorted);
    expect(result, easy_sorted);
  });

  test('JsonFileLoader should parse complex json', () async {
    final subject = JsonSorter();
    final result = await subject.sort(complex_unsorted);
    expect(result, complex_sorted);
  });
}
