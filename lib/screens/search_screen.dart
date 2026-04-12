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
];

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _query = '';

  List<_Feature> get _filtered {
    if (_query.isEmpty) return _features;
    final q = _query.toLowerCase();
    return _features.where((f) {
      final name = f.nameKey.toLowerCase();
      return name.contains(q) || f.tags.any((t) => t.contains(q));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;
    final results = _filtered;

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
