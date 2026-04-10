import 'package:flutter_test/flutter_test.dart';
import 'package:islamic_companion/models/hadith_model.dart';
import 'package:islamic_companion/models/surah_model.dart';
import 'package:islamic_companion/models/asma_al_husna_model.dart';
import 'package:islamic_companion/providers/dhikr_provider.dart';
import 'package:islamic_companion/providers/prayer_provider.dart';
import 'package:islamic_companion/services/hijri_calendar.dart';
import 'package:islamic_companion/utils/constants.dart';

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

  group('Hijri Calendar', () {
    test('HijriCalendar.now() returns valid date', () {
      final hijri = HijriCalendar.now();
      expect(hijri.year, greaterThan(1440));
      expect(hijri.month, inInclusiveRange(1, 12));
      expect(hijri.day, inInclusiveRange(1, 30));
    });

    test('Hijri month names have 12 entries', () {
      expect(HijriCalendar.monthNamesArabic.length, 12);
      expect(HijriCalendar.monthNamesEnglish.length, 12);
      expect(HijriCalendar.monthNamesTurkish.length, 12);
    });

    test('format returns non-empty string', () {
      final hijri = HijriCalendar.now();
      expect(hijri.format('en').isNotEmpty, true);
      expect(hijri.format('tr').isNotEmpty, true);
      expect(hijri.format('ar').isNotEmpty, true);
    });

    test('Eid al-Fitr is a special day', () {
      final eid = HijriCalendar(year: 1447, month: 10, day: 1);
      expect(eid.getSpecialDay('en'), 'Eid al-Fitr');
      expect(eid.getSpecialDay('tr'), 'Ramazan Bayramı');
    });

    test('Ramadan month is detected', () {
      final ramadan = HijriCalendar(year: 1447, month: 9, day: 15);
      expect(ramadan.isRamadan, true);
    });
  });

  group('Constants', () {
    test('Kaaba coordinates are valid', () {
      expect(AppConstants.kaabaLatitude, closeTo(21.42, 0.1));
      expect(AppConstants.kaabaLongitude, closeTo(39.82, 0.1));
    });

    test('13 languages defined', () {
      expect(AppConstants.languageNames.length, 13);
      expect(AppConstants.languageFlags.length, 13);
    });

    test('All languages have flags', () {
      for (final lang in AppConstants.languageNames.keys) {
        expect(AppConstants.languageFlags.containsKey(lang), true,
            reason: '$lang missing flag');
      }
    });
  });

  group('Surah content', () {
    test('Al-Fatiha is in the list', () {
      final fatiha = SurahModel.shortSurahs
          .where((s) => s.number == 1)
          .toList();
      expect(fatiha.length, 1);
      expect(fatiha.first.transliteration, 'Al-Fatiha');
    });

    test('All surahs have verse count > 0', () {
      for (final s in SurahModel.shortSurahs) {
        expect(s.versesCount, greaterThan(0),
            reason: '${s.transliteration} has 0 verses');
      }
    });
  });
}
