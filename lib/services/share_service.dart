import 'package:share_plus/share_plus.dart';
import '../models/hadith_model.dart';
import '../models/surah_model.dart';

class ShareService {
  static Future<void> shareHadith(HadithModel hadith, String langCode) async {
    final translation =
        hadith.translations[langCode] ?? hadith.translations['en']!;
    final text =
        '${hadith.arabic}\n\n$translation\n\n— ${hadith.source} (${hadith.narrator})\n\n📱 Islamic Companion App';
    await Share.share(text);
  }

  static Future<void> shareSurah(SurahModel surah, String langCode) async {
    final translation =
        surah.translations[langCode] ?? surah.translations['en']!;
    final text =
        '${surah.nameArabic} (${surah.transliteration})\n\n${surah.arabicText}\n\n$translation\n\n📱 Islamic Companion App';
    await Share.share(text);
  }

  static Future<void> shareDua(Map<String, dynamic> dua, String langCode) async {
    final translations = dua['translations'] as Map<String, String>;
    final translation = translations[langCode] ?? translations['en']!;
    final text =
        '${dua['arabic']}\n\n${dua['transliteration']}\n\n$translation\n\n📱 Islamic Companion App';
    await Share.share(text);
  }
}
