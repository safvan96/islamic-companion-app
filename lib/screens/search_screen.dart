import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';

// Import all screens for navigation
import 'prayer_times_screen.dart';
import 'qibla_screen.dart';
import 'dhikr_screen.dart';
import 'tasbih_set_screen.dart';
import 'visual_tasbih_screen.dart';
import 'adhkar_screen.dart';
import 'quran_reader_screen.dart';
import 'hadith_screen.dart';
import 'dua_screen.dart';
import 'daily_duas_screen.dart';
import 'patience_duas_screen.dart';
import 'asma_al_husna_screen.dart';
import 'prayer_guide_screen.dart';
import 'post_prayer_screen.dart';
import 'qaza_screen.dart';
import 'zakat_screen.dart';
import 'fidyah_screen.dart';
import 'fasting_screen.dart';
import 'good_deeds_screen.dart';
import 'hifz_screen.dart';
import 'khatm_planner_screen.dart';
import 'quiz_screen.dart';
import 'hajj_guide_screen.dart';
import 'wudu_screen.dart';
import 'ghusl_screen.dart';
import 'tayammum_screen.dart';
import 'tajweed_screen.dart';
import 'janazah_screen.dart';
import 'istikhara_screen.dart';
import 'nikah_screen.dart';
import 'tawbah_screen.dart';
import 'ruqyah_screen.dart';
import 'prophets_screen.dart';
import 'names_screen.dart';
import 'glossary_screen.dart';
import 'islamic_calendar_screen.dart';
import 'hijri_months_screen.dart';
import 'timeline_screen.dart';
import 'wisdom_screen.dart';
import 'motivation_screen.dart';
import 'adab_screen.dart';
import 'faq_screen.dart';
import 'charity_screen.dart';
import 'dua_journal_screen.dart';
import 'muhasaba_screen.dart';
import 'stats_dashboard_screen.dart';
import 'salawat_screen.dart';
import 'daily_tips_screen.dart';
import 'quran_words_screen.dart';
import 'adhan_dua_screen.dart';
import 'sajdah_screen.dart';
import 'surah_virtues_screen.dart';
import 'share_card_screen.dart';
import 'quran_stories_screen.dart';
import 'dua_timer_screen.dart';
import 'sunnah_duas_screen.dart';
import 'mukabele_screen.dart';
import 'rakat_guide_screen.dart';
import 'date_converter_screen.dart';
import 'prayer_surahs_screen.dart';
import 'word_match_screen.dart';
import 'quran_etiquette_screen.dart';
import 'prophet_duas_screen.dart';
import 'arabic_alphabet_screen.dart';
import 'daily_checkin_screen.dart';
import 'prayer_intentions_screen.dart';
import 'surah_categories_screen.dart';
import 'qunut_screen.dart';
import 'prayer_counter_screen.dart';
import 'tafakkur_screen.dart';
import 'weekly_report_screen.dart';
import 'holy_nights_screen.dart';
import 'reading_log_screen.dart';
import 'spouse_duas_screen.dart';
import 'travel_guide_screen.dart';
import 'sadaqah_jariyah_screen.dart';
import 'death_reminder_screen.dart';
import 'rabbana_screen.dart';
import 'sleep_guide_screen.dart';
import 'friday_guide_screen.dart';
import 'tasbihat_counter_screen.dart';
import 'hifz_test_screen.dart';
import 'fact_cards_screen.dart';
import 'eid_guide_screen.dart';
import 'bayram_countdown_screen.dart';
import 'ashura_guide_screen.dart';
import 'daily_sadaqah_screen.dart';
import 'khatm_dua_screen.dart';
import 'iftar_dua_screen.dart';
import 'suhoor_guide_screen.dart';
import 'prayer_times_table_screen.dart';
import 'allah_attributes_screen.dart';
import 'islamic_months_virtues_screen.dart';
import 'morning_routine_screen.dart';
import 'night_routine_screen.dart';
import 'islamic_finance_screen.dart';
import 'health_sunnah_screen.dart';
import 'umrah_checklist_screen.dart';
import 'hajj_checklist_screen.dart';
import 'islamic_dream_screen.dart';
import 'charity_ideas_screen.dart';
import 'convert_guide_screen.dart';
import 'masjid_etiquette_screen.dart';
import 'islamic_greetings_screen.dart';
import 'forgiveness_duas_screen.dart';
import 'exam_duas_screen.dart';
import 'gratitude_journal_screen.dart';
import 'taraweeh_tracker_screen.dart';
import 'dua_by_mood_screen.dart';
import 'ayah_of_day_screen.dart';
import 'surah_info_screen.dart';

class _P {
  final Color bg, surface, accent, gold, fg, muted, divider;
  const _P({required this.bg, required this.surface, required this.accent, required this.gold, required this.fg, required this.muted, required this.divider});
  static _P of(bool d) => d
      ? const _P(bg: Color(0xFF0E1A19), surface: Color(0xFF182624), accent: Color(0xFF4FBFA8), gold: Color(0xFFE3C77B), fg: Color(0xFFF5F1E8), muted: Color(0xFF8B968F), divider: Color(0xFF243532))
      : const _P(bg: Color(0xFFF8F5EE), surface: Color(0xFFFFFFFF), accent: Color(0xFF2C7A6B), gold: Color(0xFFB8902B), fg: Color(0xFF1F2937), muted: Color(0xFF6B6359), divider: Color(0xFFE8DDD0));
}

class _Feature {
  final String nameKey, descKey;
  final IconData icon;
  final Widget screen;
  final List<String> tags;
  const _Feature(this.nameKey, this.descKey, this.icon, this.screen, this.tags);
}

final _features = [
  const _Feature('prayerTimes', 'searchPrayer', Icons.access_time_filled, PrayerTimesScreen(), ['namaz', 'prayer', 'salah', 'ezan', 'adhan', 'vakit']),
  const _Feature('qibla', 'searchQibla', Icons.explore, QiblaScreen(), ['kible', 'qibla', 'compass', 'direction', 'kaaba']),
  const _Feature('dhikr', 'searchDhikr', Icons.touch_app, DhikrScreen(), ['zikir', 'dhikr', 'counter', 'tesbih', 'tasbih']),
  const _Feature('tasbihSet', 'searchTasbih', Icons.repeat_rounded, TasbihSetScreen(), ['tesbih', 'tasbih', '33', 'namaz sonrasi']),
  const _Feature('visualTasbih', 'searchBeads', Icons.radio_button_checked, VisualTasbihScreen(), ['boncuk', 'beads', 'tesbih']),
  const _Feature('adhkar', 'searchAdhkar', Icons.wb_twilight_rounded, AdhkarScreen(), ['sabah', 'aksam', 'morning', 'evening', 'zikir']),
  const _Feature('postPrayer', 'searchPostPrayer', Icons.playlist_add_check, PostPrayerScreen(), ['namaz sonrasi', 'after prayer', 'tesbihat']),
  // Quran
  const _Feature('quranReader', 'searchQuran', Icons.chrome_reader_mode, QuranReaderScreen(), ['kuran', 'quran', 'read', 'oku', 'sure', 'ayet']),
  const _Feature('hifzTracker', 'searchHifz', Icons.auto_stories_outlined, HifzScreen(), ['hafiz', 'hifz', 'ezber', 'memorize']),
  const _Feature('khatmPlanner', 'searchKhatm', Icons.import_contacts, KhatmPlannerScreen(), ['hatim', 'khatm', 'plan', 'reading']),
  const _Feature('quranWords', 'searchWords', Icons.translate, QuranWordsScreen(), ['kelime', 'word', 'arabic', 'arapca']),
  const _Feature('surahVirtues', 'searchVirtues', Icons.auto_stories, SurahVirtuesScreen(), ['fazilet', 'virtue', 'sure']),
  const _Feature('sajdahTilawah', 'searchSajdah', Icons.airline_seat_flat, SajdahScreen(), ['secde', 'sajdah', 'prostration']),
  const _Feature('tajweedGuide', 'searchTajweed', Icons.record_voice_over, TajweedScreen(), ['tecvid', 'tajweed', 'okuma', 'recitation']),
  // Dua & Dhikr
  const _Feature('duas', 'searchDuas', Icons.front_hand, DuaScreen(), ['dua', 'supplication', 'prayer']),
  const _Feature('duaForOccasions', 'searchOccasions', Icons.menu_book_outlined, DailyDuasScreen(), ['gunluk', 'daily', 'yemek', 'uyku', 'yolculuk']),
  const _Feature('patienceDuas', 'searchPatience', Icons.healing_outlined, PatienceDuasScreen(), ['sabir', 'patience', 'difficulty', 'sikinti']),
  const _Feature('salawatCollection', 'searchSalawat', Icons.mosque_outlined, SalawatScreen(), ['salavat', 'salawat', 'peygamber', 'prophet']),
  const _Feature('adhanDua', 'searchAdhan', Icons.notifications_active, AdhanDuaScreen(), ['ezan', 'adhan', 'dua']),
  const _Feature('ruqyahGuide', 'searchRuqyah', Icons.healing, RuqyahScreen(), ['rukyah', 'ruqyah', 'sifa', 'healing', 'korunma']),
  // Education
  const _Feature('hadiths', 'searchHadith', Icons.auto_stories, HadithScreen(), ['hadis', 'hadith', 'peygamber']),
  const _Feature('prophetsOfIslam', 'searchProphets', Icons.groups_outlined, ProphetsScreen(), ['peygamber', 'prophet', 'nabi']),
  const _Feature('names99', 'searchNames99', Icons.star_outline, AsmaAlHusnaScreen(), ['esma', '99', 'names', 'allah']),
  const _Feature('islamicNames', 'searchBabyNames', Icons.child_care, NamesScreen(), ['isim', 'name', 'bebek', 'baby']),
  const _Feature('islamicGlossary', 'searchGlossary', Icons.library_books_outlined, GlossaryScreen(), ['sozluk', 'glossary', 'terim', 'term']),
  const _Feature('islamicFaq', 'searchFaq', Icons.question_answer, FaqScreen(), ['soru', 'faq', 'question', 'sss']),
  const _Feature('wisdomQuotes', 'searchWisdom', Icons.auto_awesome, WisdomScreen(), ['hikmet', 'wisdom', 'ayet', 'sozu']),
  // Guides
  const _Feature('prayerGuide', 'searchPrayerGuide', Icons.school, PrayerGuideScreen(), ['namaz', 'kilinisi', 'how to pray']),
  const _Feature('wuduGuide', 'searchWudu', Icons.water_drop_outlined, WuduScreen(), ['abdest', 'wudu', 'ablution']),
  const _Feature('ghuslGuide', 'searchGhusl', Icons.shower, GhuslScreen(), ['gusul', 'ghusl', 'boy abdesti']),
  const _Feature('tayammumGuide', 'searchTayammum', Icons.landscape, TayammumScreen(), ['teyemmum', 'tayammum']),
  const _Feature('hajjUmrah', 'searchHajj', Icons.location_city, HajjGuideScreen(), ['hac', 'umre', 'hajj', 'umrah']),
  const _Feature('janazahGuide', 'searchJanazah', Icons.people_outline, JanazahScreen(), ['cenaze', 'janazah', 'funeral']),
  const _Feature('istikharaGuide', 'searchIstikhara', Icons.help_outline, IstikharaScreen(), ['istihare', 'istikhara']),
  const _Feature('nikahGuide', 'searchNikah', Icons.favorite_border, NikahScreen(), ['nikah', 'evlilik', 'marriage']),
  const _Feature('tawbahGuide', 'searchTawbah', Icons.self_improvement, TawbahScreen(), ['tovbe', 'tawbah', 'repentance']),
  const _Feature('islamicAdab', 'searchAdab', Icons.auto_fix_high, AdabScreen(), ['adab', 'edep', 'etiquette']),
  // Trackers
  const _Feature('zakatCalculator', 'searchZakat', Icons.calculate_outlined, ZakatScreen(), ['zekat', 'zakat', 'hesap']),
  const _Feature('fidyahCalc', 'searchFidyah', Icons.paid_outlined, FidyahScreen(), ['fidye', 'kefaret', 'fidyah']),
  const _Feature('fastingTracker', 'searchFasting', Icons.restaurant_outlined, FastingScreen(), ['oruc', 'fasting', 'ramazan']),
  const _Feature('qazaTracker', 'searchQaza', Icons.history_rounded, QazaScreen(), ['kaza', 'qaza', 'missed']),
  const _Feature('goodDeeds', 'searchDeeds', Icons.checklist_rounded, GoodDeedsScreen(), ['iyilik', 'good deeds', 'amel']),
  const _Feature('charityTracker', 'searchCharity', Icons.volunteer_activism, CharityScreen(), ['bagis', 'charity', 'sadaka']),
  const _Feature('duaJournal', 'searchJournal', Icons.edit_note, DuaJournalScreen(), ['dua defteri', 'journal', 'gunluk']),
  const _Feature('muhasaba', 'searchMuhasaba', Icons.nightlight_round, MuhasabaScreen(), ['muhasebe', 'muhasaba', 'nefis']),
  const _Feature('statsDashboard', 'searchStats', Icons.bar_chart_rounded, StatsDashboardScreen(), ['istatistik', 'stats']),
  // Calendar & History
  const _Feature('islamicCalendar', 'searchCalendar', Icons.calendar_month, IslamicCalendarScreen(), ['takvim', 'calendar', 'hicri']),
  const _Feature('hijriMonthsGuide', 'searchHijriMonths', Icons.date_range, HijriMonthsScreen(), ['hicri', 'ay', 'month']),
  const _Feature('islamicTimeline', 'searchTimeline', Icons.timeline, TimelineScreen(), ['tarih', 'timeline', 'history']),
  // Other
  const _Feature('islamicQuiz', 'searchQuiz', Icons.quiz_outlined, QuizScreen(), ['quiz', 'yarisma', 'bilgi']),
  const _Feature('dailyTips', 'searchTips', Icons.tips_and_updates, DailyTipsScreen(), ['ipucu', 'tip', 'tavsiye']),
  const _Feature('motivation', 'searchMotivation', Icons.format_paint, MotivationScreen(), ['motivasyon', 'motivation']),
  // Additional screens
  const _Feature('shareCard', 'searchShare', Icons.share, ShareCardScreen(), ['paylas', 'share', 'card']),
  const _Feature('quranStories', 'searchStories', Icons.auto_stories_outlined, QuranStoriesScreen(), ['kissa', 'stories', 'quran']),
  const _Feature('duaTimer', 'searchTimer', Icons.timer, DuaTimerScreen(), ['zamanlayici', 'timer', 'dua']),
  const _Feature('sunnahDuas', 'searchSunnah', Icons.auto_awesome, SunnahDuasScreen(), ['sunnet', 'sunnah', 'dua']),
  const _Feature('mukabele', 'searchMukabele', Icons.groups, MukabeleScreen(), ['mukabele', 'hatim', 'cuz']),
  const _Feature('rakatGuide', 'searchRakat', Icons.format_list_numbered, RakatGuideScreen(), ['rekat', 'rakat', 'namaz']),
  const _Feature('dateConverter', 'searchDate', Icons.date_range, DateConverterScreen(), ['tarih', 'hicri', 'miladi', 'date', 'converter']),
  const _Feature('prayerSurahs', 'searchPrayerSurahs', Icons.menu_book, PrayerSurahsScreen(), ['namaz suresi', 'prayer surah']),
  const _Feature('wordMatch', 'searchWordMatch', Icons.extension, WordMatchScreen(), ['kelime', 'eslestir', 'word', 'match', 'game']),
  const _Feature('quranEtiquette', 'searchEtiquette', Icons.auto_fix_high, QuranEtiquetteScreen(), ['kuran adabi', 'quran etiquette']),
  const _Feature('prophetDuas', 'searchProphetDuas', Icons.person_outline, ProphetDuasScreen(), ['peygamber dua', 'prophet dua']),
  const _Feature('arabicAlphabet', 'searchArabic', Icons.abc, ArabicAlphabetScreen(), ['arapca', 'harf', 'arabic', 'alphabet']),
  const _Feature('dailyCheckin', 'searchCheckin', Icons.check_box, DailyCheckinScreen(), ['check-in', 'gunluk', 'daily']),
  const _Feature('prayerIntentions', 'searchIntentions', Icons.psychology, PrayerIntentionsScreen(), ['niyet', 'intention', 'namaz']),
  const _Feature('surahCategories', 'searchCategories', Icons.category, SurahCategoriesScreen(), ['kategori', 'category', 'sure']),
  const _Feature('qunut', 'searchQunut', Icons.front_hand_outlined, QunutScreen(), ['kunut', 'qunut', 'dua', 'vitir']),
  const _Feature('prayerCounter', 'searchCounter', Icons.pin, PrayerCounterScreen(), ['sayac', 'counter', 'namaz']),
  const _Feature('tafakkur', 'searchTafakkur', Icons.spa, TafakkurScreen(), ['tefekkur', 'tafakkur', 'meditation', 'dusunce']),
  const _Feature('weeklyReport', 'searchReport', Icons.assessment, WeeklyReportScreen(), ['rapor', 'report', 'haftalik']),
  const _Feature('holyNights', 'searchHolyNights', Icons.nightlight, HolyNightsScreen(), ['mubarek', 'gece', 'kadir', 'holy', 'night']),
  const _Feature('readingLog', 'searchReadingLog', Icons.bookmark_added, ReadingLogScreen(), ['okuma', 'reading', 'log', 'kitap']),
  const _Feature('spouseDuas', 'searchSpouse', Icons.favorite, SpouseDuasScreen(), ['es', 'spouse', 'evlilik', 'dua']),
  const _Feature('travelGuide', 'searchTravel', Icons.flight, TravelGuideScreen(), ['seyahat', 'travel', 'yolculuk']),
  const _Feature('sadaqahJariyah', 'searchJariyah', Icons.volunteer_activism_outlined, SadaqahJariyahScreen(), ['sadaka', 'jariye', 'jariyah']),
  const _Feature('deathReminder', 'searchDeath', Icons.hourglass_bottom, DeathReminderScreen(), ['olum', 'death', 'ahiret', 'hereafter']),
  const _Feature('rabbana', 'searchRabbana', Icons.menu_book_outlined, RabbanaScreen(), ['rabbena', 'rabbana', 'kuran', 'dua']),
  const _Feature('sleepGuide', 'searchSleep', Icons.bedtime, SleepGuideScreen(), ['uyku', 'sleep', 'adab']),
  const _Feature('fridayGuide', 'searchFriday', Icons.mosque, FridayGuideScreen(), ['cuma', 'friday', 'juma']),
  const _Feature('tasbihatCounter', 'searchTasbihat', Icons.repeat_one, TasbihatCounterScreen(), ['tesbihat', 'tasbih', 'namaz sonrasi']),
  const _Feature('hifzTest', 'searchHifzTest', Icons.quiz, HifzTestScreen(), ['test', 'hafizlik', 'sinav', 'hifz']),
  const _Feature('factCards', 'searchFacts', Icons.lightbulb_outline, FactCardsScreen(), ['bilgi', 'fact', 'ilginc']),
  const _Feature('eidGuide', 'searchEid', Icons.celebration, EidGuideScreen(), ['bayram', 'eid', 'fitr', 'adha']),
  const _Feature('bayramCountdown', 'searchCountdown', Icons.timer_outlined, BayramCountdownScreen(), ['bayram', 'geri sayim', 'countdown']),
  const _Feature('ashuraGuide', 'searchAshura', Icons.event_note, AshuraGuideScreen(), ['asure', 'ashura', 'muharrem']),
  const _Feature('dailySadaqah', 'searchDailySadaqah', Icons.monetization_on_outlined, DailySadaqahScreen(), ['sadaka', 'gunluk', 'daily']),
  const _Feature('khatmDua', 'searchKhatmDua', Icons.auto_stories, KhatmDuaScreen(), ['hatim', 'dua', 'khatm']),
  const _Feature('iftarDuaTitle', 'searchIftar', Icons.restaurant, IftarDuaScreen(), ['iftar', 'dua', 'oruc']),
  const _Feature('suhoorGuide', 'searchSuhoor', Icons.free_breakfast, SuhoorGuideScreen(), ['sahur', 'suhoor', 'ramazan']),
  const _Feature('prayerTimesTable', 'searchTable', Icons.table_chart, PrayerTimesTableScreen(), ['tablo', 'table', 'vakit']),
  const _Feature('allahAttributes', 'searchAttributes', Icons.brightness_high, AllahAttributesScreen(), ['sifat', 'attribute', 'allah']),
  const _Feature('islamicMonthsVirtues', 'searchMonthVirtues', Icons.calendar_today, IslamicMonthsVirtuesScreen(), ['ay', 'fazilet', 'month', 'virtue']),
  const _Feature('morningRoutine', 'searchMorning', Icons.wb_sunny, MorningRoutineScreen(), ['sabah', 'morning', 'rutin']),
  const _Feature('nightRoutine', 'searchNight', Icons.nights_stay, NightRoutineScreen(), ['gece', 'night', 'aksam', 'rutin']),
  const _Feature('islamicFinance', 'searchFinance', Icons.account_balance, IslamicFinanceScreen(), ['finans', 'finance', 'faiz', 'riba']),
  const _Feature('healthSunnah', 'searchHealth', Icons.health_and_safety, HealthSunnahScreen(), ['saglik', 'health', 'sunnet']),
  const _Feature('umrahChecklist', 'searchUmrah', Icons.checklist, UmrahChecklistScreen(), ['umre', 'umrah', 'liste']),
  const _Feature('hajjChecklist', 'searchHajjList', Icons.checklist_rtl, HajjChecklistScreen(), ['hac', 'hajj', 'liste']),
  const _Feature('islamicDream', 'searchDream', Icons.cloud, IslamicDreamScreen(), ['ruya', 'dream', 'tabir']),
  const _Feature('charityIdeas', 'searchCharityIdeas', Icons.lightbulb, CharityIdeasScreen(), ['hayir', 'charity', 'fikir']),
  const _Feature('convertGuide', 'searchConvert', Icons.person_add, ConvertGuideScreen(), ['muhtedi', 'convert', 'yeni musluman']),
  const _Feature('masjidEtiquette', 'searchMasjid', Icons.mosque_outlined, MasjidEtiquetteScreen(), ['cami', 'masjid', 'mosque', 'adab']),
  const _Feature('islamicGreetings', 'searchGreetings', Icons.waving_hand, IslamicGreetingsScreen(), ['selam', 'greeting', 'merhaba']),
  const _Feature('forgivenessDuas', 'searchForgiveness', Icons.spa_outlined, ForgivenessDuasScreen(), ['af', 'magfiret', 'forgiveness']),
  const _Feature('examDuas', 'searchExam', Icons.school_outlined, ExamDuasScreen(), ['sinav', 'exam', 'dua']),
  const _Feature('gratitudeJournal', 'searchGratitude', Icons.sentiment_satisfied, GratitudeJournalScreen(), ['sukur', 'gratitude', 'tesekkur']),
  const _Feature('ayahOfDay', 'searchAyah', Icons.format_quote, AyahOfDayScreen(), ['ayet', 'ayah', 'gunun', 'daily']),
  const _Feature('surahGuide', 'searchSurahInfo', Icons.info_outline, SurahInfoScreen(), ['sure', 'surah', 'bilgi', 'info']),
  const _Feature('taraweehTracker', 'searchTaraweeh', Icons.nightlight_round, TaraweehTrackerScreen(), ['teravih', 'taraweeh', 'ramazan', 'ramadan', 'gece']),
  const _Feature('duaByMood', 'searchMood', Icons.mood, DuaByMoodScreen(), ['ruh hali', 'mood', 'duygu', 'feeling', 'anxious', 'sad', 'angry', 'sick']),
];

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _query = '';

  List<_Feature> _getFiltered(AppLocalizations l10n) {
    if (_query.isEmpty) return _features;
    final q = _query.toLowerCase();
    return _features.where((f) {
      final name = f.nameKey.toLowerCase();
      final translated = l10n.translate(f.nameKey).toLowerCase();
      return name.contains(q) || translated.contains(q) || f.tags.any((t) => t.contains(q));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;
    final results = _getFiltered(l10n);

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Container(
          decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: p.divider)),
          child: TextField(
            autofocus: true,
            onChanged: (v) => setState(() => _query = v),
            style: TextStyle(color: p.fg, fontSize: 15),
            decoration: InputDecoration(
              hintText: l10n.translate('searchFeatures'),
              hintStyle: TextStyle(color: p.muted),
              prefixIcon: Icon(Icons.search, color: p.muted, size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        itemCount: results.length,
        itemBuilder: (_, i) {
          final f = results[i];
          return InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => f.screen)),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: p.divider)),
              child: Row(children: [
                Container(width: 36, height: 36, decoration: BoxDecoration(shape: BoxShape.circle, color: p.accent.withOpacity(0.1)),
                  child: Icon(f.icon, size: 18, color: p.accent)),
                const SizedBox(width: 12),
                Expanded(child: Text(l10n.translate(f.nameKey), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: p.fg))),
                Icon(Icons.chevron_right, size: 18, color: p.muted),
              ]),
            ),
          );
        },
      ),
    );
  }
}
