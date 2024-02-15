import 'dart:io';

import 'package:blabla/file_loader.dart';
import 'package:test/test.dart';

void main() {
  test('FileLoader should read file', () {
    final subject = FileLoader();
    final result = subject.read('test_data/app_de.arb');
    expect(result, isNotNull);
  });

  test('FileLoader should read json', () async {
    final subject = FileLoader();

    // create file name with timestamp:

    // get timestamp:
    final DateTime now = DateTime.now();
    final int timestamp = now.millisecondsSinceEpoch;
    final path = "test_$timestamp";

    final result = await subject.write(path, "content");
    expect(result, isNotNull);

    // delete File
    final file = File(path);
    await file.delete(recursive: false);
  });
}
