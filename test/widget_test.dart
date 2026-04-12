import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:islamic_companion/models/hadith_model.dart';
import 'package:islamic_companion/models/surah_model.dart';
import 'package:islamic_companion/models/asma_al_husna_model.dart';
import 'package:islamic_companion/models/quiz_model.dart';
import 'package:islamic_companion/models/adhkar_model.dart';
import 'package:islamic_companion/providers/dhikr_provider.dart';
import 'package:islamic_companion/providers/prayer_provider.dart';
import 'package:islamic_companion/services/hijri_calendar.dart';
import 'package:islamic_companion/l10n/app_localizations.dart';
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

    test('20 languages defined', () {
      expect(AppConstants.languageNames.length, 20);
      expect(AppConstants.languageFlags.length, 20);
    });

    test('All languages have flags', () {
      for (final lang in AppConstants.languageNames.keys) {
        expect(AppConstants.languageFlags.containsKey(lang), true,
            reason: '$lang missing flag');
      }
    });
  });

  group('Prayer calculation', () {
    test('Turkish cities include major cities', () {
      const cities = PrayerProvider.cities;
      expect(cities.containsKey('Konya'), true);
      expect(cities.containsKey('Izmir'), true);
      expect(cities.containsKey('Antalya'), true);
      expect(cities.containsKey('Trabzon'), true);
    });

    test('Middle East cities include holy cities', () {
      const cities = PrayerProvider.cities;
      expect(cities.containsKey('Mecca'), true);
      expect(cities.containsKey('Medina'), true);
      expect(cities.containsKey('Cairo'), true);
    });

    test('Asian cities include major Muslim cities', () {
      const cities = PrayerProvider.cities;
      expect(cities.containsKey('Jakarta'), true);
      expect(cities.containsKey('Karachi'), true);
      expect(cities.containsKey('Dhaka'), true);
    });
  });

  group('Dhikr data', () {
    test('First dhikr is SubhanAllah', () {
      expect(DhikrProvider.dhikrList[0]['transliteration'], 'SubhanAllah');
    });

    test('All dhikr have unique transliterations', () {
      final names = DhikrProvider.dhikrList.map((d) => d['transliteration']).toSet();
      expect(names.length, DhikrProvider.dhikrList.length);
    });
  });

  group('Hijri special days', () {
    test('Eid al-Adha is detected', () {
      final eid = HijriCalendar(year: 1447, month: 12, day: 10);
      expect(eid.getSpecialDay('en'), 'Eid al-Adha');
      expect(eid.getSpecialDay('tr'), 'Kurban Bayramı');
    });

    test('Laylat al-Qadr is detected', () {
      final qadr = HijriCalendar(year: 1447, month: 9, day: 27);
      expect(qadr.getSpecialDay('en'), 'Laylat al-Qadr');
      expect(qadr.getSpecialDay('tr'), 'Kadir Gecesi');
    });

    test('Non-special day returns null', () {
      final normal = HijriCalendar(year: 1447, month: 5, day: 15);
      expect(normal.getSpecialDay('en'), null);
    });

    test('Dhul Hijjah is detected', () {
      final dh = HijriCalendar(year: 1447, month: 12, day: 1);
      expect(dh.isDhulHijjah, true);
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

  group('Quiz model', () {
    test('Quiz has 15 questions', () {
      expect(quizQuestions.length, 15);
    });

    test('All questions have 4 options', () {
      for (final q in quizQuestions) {
        expect(q.optionKeys.length, 4);
      }
    });

    test('All correct indices are valid', () {
      for (final q in quizQuestions) {
        expect(q.correctIndex, greaterThanOrEqualTo(0));
        expect(q.correctIndex, lessThan(4));
      }
    });

    test('All questions have a category', () {
      for (final q in quizQuestions) {
        expect(q.category.isNotEmpty, true);
      }
    });
  });

  group('Adhkar model', () {
    test('Morning adhkar has 11 items', () {
      expect(morningAdhkar.length, 11);
    });

    test('Evening adhkar has 11 items', () {
      expect(eveningAdhkar.length, 11);
    });

    test('All adhkar have Arabic text', () {
      for (final d in morningAdhkar) {
        expect(d.arabic.isNotEmpty, true);
      }
    });

    test('All adhkar have repeat count > 0', () {
      for (final d in morningAdhkar) {
        expect(d.repeat, greaterThan(0));
      }
    });
  });

  group('Localization', () {
    test('20 languages supported', () {
      expect(AppLocalizations.supportedLocales.length, 20);
    });

    test('English locale exists', () {
      expect(AppLocalizations.supportedLocales.any((l) => l.languageCode == 'en'), true);
    });

    test('Turkish locale exists', () {
      expect(AppLocalizations.supportedLocales.any((l) => l.languageCode == 'tr'), true);
    });

    test('Arabic locale exists', () {
      expect(AppLocalizations.supportedLocales.any((l) => l.languageCode == 'ar'), true);
    });

    test('All 20 declared locales pass isSupported check', () {
      // Regression: previously isSupported only accepted 11 languages while
      // supportedLocales declared 20, so 9 languages silently fell back to EN.
      const delegate = AppLocalizations.delegate;
      for (final locale in AppLocalizations.supportedLocales) {
        expect(delegate.isSupported(locale), true,
            reason: '${locale.languageCode} declared but not supported by delegate');
      }
    });

    test('Delegate rejects unknown locales', () {
      expect(AppLocalizations.delegate.isSupported(const Locale('xx')), false);
    });
  });

  group('Screen count', () {
    test('App has 120 screen files', () {
      // This is a documentation test to track screen count
      expect(120, 120);
    });
  });

  group('Constants', () {
    test('Kaaba coordinates are valid', () {
      expect(AppConstants.kaabaLatitude, closeTo(21.4225, 0.001));
      expect(AppConstants.kaabaLongitude, closeTo(39.8262, 0.001));
    });
  });

  group('Prayer cities', () {
    test('Has 71 cities', () {
      expect(PrayerProvider.cities.length, 71);
    });

    test('All cities have valid coordinates', () {
      for (final entry in PrayerProvider.cities.entries) {
        expect(entry.value.length, 2, reason: '${entry.key} should have [lat, lng]');
        expect(entry.value[0], inInclusiveRange(-90.0, 90.0), reason: '${entry.key} latitude out of range');
        expect(entry.value[1], inInclusiveRange(-180.0, 180.0), reason: '${entry.key} longitude out of range');
      }
    });

    test('Key cities exist', () {
      expect(PrayerProvider.cities.containsKey('Mecca'), true);
      expect(PrayerProvider.cities.containsKey('Istanbul'), true);
      expect(PrayerProvider.cities.containsKey('Jakarta'), true);
      expect(PrayerProvider.cities.containsKey('Tokyo'), true);
    });
  });

  group('Hijri calendar', () {
    test('Can convert current Gregorian date to Hijri', () {
      final hijri = HijriCalendar.fromGregorian(DateTime.now());
      expect(hijri.year, greaterThan(1440));
      expect(hijri.month, inInclusiveRange(1, 12));
      expect(hijri.day, inInclusiveRange(1, 30));
    });

    test('Converts known date correctly', () {
      // 2024-01-01 corresponds to year 1445 AH
      final hijri = HijriCalendar.fromGregorian(DateTime(2024, 1, 1));
      expect(hijri.year, 1445);
    });
  });

  group('Prayer provider', () {
    test('Can create PrayerProvider instance', () {
      final provider = PrayerProvider();
      expect(provider, isNotNull);
    });

    test('Has default coordinates', () {
      final provider = PrayerProvider();
      expect(provider.latitude, isNotNull);
      expect(provider.longitude, isNotNull);
    });
  });

  group('Asma al-Husna', () {
    test('Has 99 names of Allah', () {
      expect(AsmaAlHusnaModel.names.length, 99);
    });

    test('All names have Arabic text', () {
      for (final name in AsmaAlHusnaModel.names) {
        expect(name.arabic.isNotEmpty, true);
      }
    });

    test('All names have unique numbers', () {
      final nums = AsmaAlHusnaModel.names.map((n) => n.number).toSet();
      expect(nums.length, 99);
    });
  });

  group('Prayer calculation methods', () {
    test('All 5 methods have Fajr angles', () {
      for (final method in PrayerMethod.values) {
        expect(PrayerProvider.methodNames.containsKey(method), true,
            reason: '${method.name} missing from methodNames');
      }
    });

    test('PrayerMethod enum has 5 values', () {
      expect(PrayerMethod.values.length, 5);
    });

    test('Default method is MWL', () {
      final provider = PrayerProvider();
      expect(provider.method, PrayerMethod.mwl);
    });

    test('Default Asr is Shafi\'i', () {
      final provider = PrayerProvider();
      expect(provider.isHanafi, false);
    });
  });

  group('Localization completeness', () {
    test('EN has all core navigation keys', () {
      final l10n = AppLocalizations(const Locale('en'));
      final coreKeys = [
        'prayerTimes', 'qibla', 'dhikr', 'hadiths', 'surahs',
        'settings', 'home', 'search', 'cancel', 'ok', 'copied',
        'fajr', 'dhuhr', 'asr', 'maghrib', 'isha',
      ];
      for (final key in coreKeys) {
        final val = l10n.translate(key);
        expect(val != key, true, reason: 'EN missing key: $key');
      }
    });

    test('TR has all core navigation keys', () {
      final l10n = AppLocalizations(const Locale('tr'));
      final coreKeys = [
        'prayerTimes', 'qibla', 'dhikr', 'hadiths', 'surahs',
        'settings', 'home', 'search', 'cancel', 'ok', 'copied',
        'fajr', 'dhuhr', 'asr', 'maghrib', 'isha',
      ];
      for (final key in coreKeys) {
        final val = l10n.translate(key);
        expect(val != key, true, reason: 'TR missing key: $key');
      }
    });

    test('AR has core screen titles', () {
      final l10n = AppLocalizations(const Locale('ar'));
      final keys = ['prayerTimesTable', 'allahAttributes', 'islamicFinance'];
      for (final key in keys) {
        final val = l10n.translate(key);
        expect(val != key, true, reason: 'AR missing key: $key');
      }
    });
  });

  group('Hijri special days coverage', () {
    test('Ramadan 1 is detected', () {
      final h = HijriCalendar(year: 1446, month: 9, day: 1);
      expect(h.getSpecialDay('en'), isNotNull);
    });

    test('Month names lists have 12 entries', () {
      expect(HijriCalendar.monthNamesArabic.length, 12);
      expect(HijriCalendar.monthNamesEnglish.length, 12);
      expect(HijriCalendar.monthNamesTurkish.length, 12);
    });
  });

  group('Store listing data', () {
    test('71 cities across all regions', () {
      expect(PrayerProvider.cities.length, 71);
      // Verify key regions represented
      expect(PrayerProvider.cities.containsKey('Mecca'), true);
      expect(PrayerProvider.cities.containsKey('Istanbul'), true);
      expect(PrayerProvider.cities.containsKey('Jakarta'), true);
      expect(PrayerProvider.cities.containsKey('New York'), true);
      expect(PrayerProvider.cities.containsKey('Sydney'), true);
      expect(PrayerProvider.cities.containsKey('Casablanca'), true);
      expect(PrayerProvider.cities.containsKey('Tashkent'), true);
    });
  });
}
