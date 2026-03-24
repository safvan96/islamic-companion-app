import 'package:flutter_test/flutter_test.dart';
import 'package:islamic_companion/models/hadith_model.dart';
import 'package:islamic_companion/models/surah_model.dart';
import 'package:islamic_companion/models/asma_al_husna_model.dart';
import 'package:islamic_companion/providers/dhikr_provider.dart';

void main() {
  test('Hadith model has 10 hadiths', () {
    expect(HadithModel.hadiths.length, 10);
  });

  test('Surah model has short surahs', () {
    expect(SurahModel.shortSurahs.isNotEmpty, true);
  });

  test('Asma Al Husna has 99 names', () {
    expect(AsmaAlHusnaModel.names.length, 99);
  });

  test('Dhikr list has entries', () {
    expect(DhikrProvider.dhikrList.isNotEmpty, true);
  });

  test('All hadiths have 11 translations (including Turkish)', () {
    for (final hadith in HadithModel.hadiths) {
      expect(hadith.translations.length, 11);
    }
  });
}
