import 'package:flutter_test/flutter_test.dart';
import 'package:islamic_companion/models/hadith_model.dart';
import 'package:islamic_companion/models/surah_model.dart';
import 'package:islamic_companion/models/asma_al_husna_model.dart';
import 'package:islamic_companion/providers/dhikr_provider.dart';
import 'package:islamic_companion/providers/prayer_provider.dart';

void main() {
  group('Models', () {
    test('Hadith model has 20 hadiths', () {
      expect(HadithModel.hadiths.length, 20);
    });

    test('All hadiths have 11 translations', () {
      for (final hadith in HadithModel.hadiths) {
        expect(hadith.translations.length, 11,
            reason: '${hadith.source} missing translations');
      }
    });

    test('All hadiths have Arabic text', () {
      for (final hadith in HadithModel.hadiths) {
        expect(hadith.arabic.isNotEmpty, true);
      }
    });

    test('All hadiths have source and narrator', () {
      for (final hadith in HadithModel.hadiths) {
        expect(hadith.source.isNotEmpty, true);
        expect(hadith.narrator.isNotEmpty, true);
      }
    });

    test('Surah model has short surahs', () {
      expect(SurahModel.shortSurahs.isNotEmpty, true);
      expect(SurahModel.shortSurahs.length, greaterThanOrEqualTo(10));
    });

    test('All surahs have unique numbers', () {
      final numbers = SurahModel.shortSurahs.map((s) => s.number).toSet();
      expect(numbers.length, SurahModel.shortSurahs.length);
    });

    test('All surahs have Arabic text and translations', () {
      for (final surah in SurahModel.shortSurahs) {
        expect(surah.arabicText.isNotEmpty, true,
            reason: '${surah.transliteration} missing Arabic');
        expect(surah.translations.isNotEmpty, true,
            reason: '${surah.transliteration} missing translations');
      }
    });

    test('Asma Al Husna has 99 names', () {
      expect(AsmaAlHusnaModel.names.length, 99);
    });

    test('All 99 names have Arabic and transliteration', () {
      for (final name in AsmaAlHusnaModel.names) {
        expect(name.arabic.isNotEmpty, true);
        expect(name.transliteration.isNotEmpty, true);
      }
    });
  });

  group('Providers', () {
    test('Dhikr list has 8 entries', () {
      expect(DhikrProvider.dhikrList.length, 8);
    });

    test('All dhikr have arabic, transliteration, meaning', () {
      for (final d in DhikrProvider.dhikrList) {
        expect(d['arabic']?.isNotEmpty, true);
        expect(d['transliteration']?.isNotEmpty, true);
        expect(d['meaning']?.isNotEmpty, true);
      }
    });

    test('Prayer provider has 26+ cities', () {
      expect(PrayerProvider.cities.length, greaterThanOrEqualTo(26));
    });

    test('All cities have valid coordinates', () {
      for (final entry in PrayerProvider.cities.entries) {
        final coords = entry.value;
        expect(coords.length, 2, reason: '${entry.key} invalid coords');
        expect(coords[0], inInclusiveRange(-90, 90),
            reason: '${entry.key} latitude out of range');
        expect(coords[1], inInclusiveRange(-180, 180),
            reason: '${entry.key} longitude out of range');
      }
    });

    test('Istanbul is in cities list', () {
      expect(PrayerProvider.cities.containsKey('Istanbul'), true);
    });

    test('Mecca is in cities list', () {
      expect(PrayerProvider.cities.containsKey('Mecca'), true);
    });
  });

  group('Localization keys', () {
    test('All hadiths have Turkish translation', () {
      for (final hadith in HadithModel.hadiths) {
        expect(hadith.translations.containsKey('tr'), true,
            reason: '${hadith.source} missing Turkish');
      }
    });

    test('All hadiths have English translation', () {
      for (final hadith in HadithModel.hadiths) {
        expect(hadith.translations.containsKey('en'), true,
            reason: '${hadith.source} missing English');
      }
    });

    test('All hadiths have Arabic translation', () {
      for (final hadith in HadithModel.hadiths) {
        expect(hadith.translations.containsKey('ar'), true,
            reason: '${hadith.source} missing Arabic');
      }
    });
  });
}
