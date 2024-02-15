import 'package:blabla/file_loader.dart';
import 'package:blabla/json_sorter.dart';

Future<void> main(List<String> arguments) async {
  if (arguments.length < 2) {
    printHelp();
    return;
  }
  final command = arguments[0];
  if (command == 'sort') {
    runSort(arguments[1]);
  } else {
    printHelp();
  }
}

Future<void> runSort(String filePath) async {
  final fileLoader = FileLoader();
  final sorter = JsonSorter();
  final fileContent = await fileLoader.read(filePath);
  final String? output = await sorter.sort(fileContent!);

  if (output != null) {
    print(output);
  } else {
    print("Failed to load or parse JSON file.");
  }
}

Future<void> printHelp() async {
  print("usage: blabla <command> [<args>]");
  print("commands: ");
  print("\t sort <filename> \t Sorts the JSON file");
}
