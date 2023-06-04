import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

class Dictionary {
  Map<String, String> slangTranslations = {};

  Future<void> loadTranslations() async {
    final csvString = await rootBundle.loadString('assets/dataset.csv');
    final csvParsed = CsvToListConverter().convert(csvString);

    slangTranslations = Map<String, String>.fromIterables(
      csvParsed.map((row) => row[0].toString()),
      csvParsed.map((row) => row[1].toString()),
    );
  }
}

final dictionary = Dictionary();
