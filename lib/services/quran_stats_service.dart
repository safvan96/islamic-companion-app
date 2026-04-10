import 'package:shared_preferences/shared_preferences.dart';

/// Tracks Quran reading statistics
class QuranStatsService {
  static const _readSurahsKey = 'quranReadSurahs';
  static const _totalAyahsReadKey = 'quranTotalAyahsRead';
  static const _lastReadDateKey = 'quranLastReadDate';
  static const _readingStreakKey = 'quranReadingStreak';

  static Future<void> markSurahRead(int surahNumber, int ayahCount) async {
    final prefs = await SharedPreferences.getInstance();

    // Add to read surahs set
    final readSurahs = (prefs.getStringList(_readSurahsKey) ?? []).toSet();
    readSurahs.add(surahNumber.toString());
    await prefs.setStringList(_readSurahsKey, readSurahs.toList());

    // Increment total ayahs
    final total = prefs.getInt(_totalAyahsReadKey) ?? 0;
    await prefs.setInt(_totalAyahsReadKey, total + ayahCount);

    // Update reading streak
    final today = _dateKey(DateTime.now());
    final lastRead = prefs.getString(_lastReadDateKey) ?? '';
    if (lastRead != today) {
      final yesterday = _dateKey(DateTime.now().subtract(const Duration(days: 1)));
      final streak = prefs.getInt(_readingStreakKey) ?? 0;
      if (lastRead == yesterday) {
        await prefs.setInt(_readingStreakKey, streak + 1);
      } else if (lastRead.isEmpty) {
        await prefs.setInt(_readingStreakKey, 1);
      } else {
        await prefs.setInt(_readingStreakKey, 1); // Reset
      }
      await prefs.setString(_lastReadDateKey, today);
    }
  }

  static Future<Map<String, int>> getStats() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'surahsRead': (prefs.getStringList(_readSurahsKey) ?? []).length,
      'totalAyahs': prefs.getInt(_totalAyahsReadKey) ?? 0,
      'streak': prefs.getInt(_readingStreakKey) ?? 0,
    };
  }

  static String _dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
