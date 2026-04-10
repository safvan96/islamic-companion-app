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
import 'surah_screen.dart';
import 'dua_screen.dart';
import 'daily_duas_screen.dart';
import 'patience_duas_screen.dart';
import 'asma_al_husna_screen.dart';
import 'sadaqah_screen.dart';
import 'favorites_screen.dart';
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
  _Feature('prayerTimes', 'searchPrayer', Icons.access_time_filled, const PrayerTimesScreen(), ['namaz', 'prayer', 'salah', 'ezan', 'adhan', 'vakit']),
  _Feature('qibla', 'searchQibla', Icons.explore, const QiblaScreen(), ['kible', 'qibla', 'compass', 'direction', 'kaaba']),
  _Feature('dhikr', 'searchDhikr', Icons.touch_app, const DhikrScreen(), ['zikir', 'dhikr', 'counter', 'tesbih', 'tasbih']),
  _Feature('tasbihSet', 'searchTasbih', Icons.repeat_rounded, const TasbihSetScreen(), ['tesbih', 'tasbih', '33', 'namaz sonrasi']),
  _Feature('visualTasbih', 'searchBeads', Icons.radio_button_checked, const VisualTasbihScreen(), ['boncuk', 'beads', 'tesbih']),
  _Feature('adhkar', 'searchAdhkar', Icons.wb_twilight_rounded, const AdhkarScreen(), ['sabah', 'aksam', 'morning', 'evening', 'zikir']),
  _Feature('postPrayer', 'searchPostPrayer', Icons.playlist_add_check, const PostPrayerScreen(), ['namaz sonrasi', 'after prayer', 'tesbihat']),
  // Quran
  _Feature('quranReader', 'searchQuran', Icons.chrome_reader_mode, const QuranReaderScreen(), ['kuran', 'quran', 'read', 'oku', 'sure', 'ayet']),
  _Feature('hifzTracker', 'searchHifz', Icons.auto_stories_outlined, const HifzScreen(), ['hafiz', 'hifz', 'ezber', 'memorize']),
  _Feature('khatmPlanner', 'searchKhatm', Icons.import_contacts, const KhatmPlannerScreen(), ['hatim', 'khatm', 'plan', 'reading']),
  _Feature('quranWords', 'searchWords', Icons.translate, const QuranWordsScreen(), ['kelime', 'word', 'arabic', 'arapca']),
  _Feature('surahVirtues', 'searchVirtues', Icons.auto_stories, const SurahVirtuesScreen(), ['fazilet', 'virtue', 'sure']),
  _Feature('sajdahTilawah', 'searchSajdah', Icons.airline_seat_flat, const SajdahScreen(), ['secde', 'sajdah', 'prostration']),
  _Feature('tajweedGuide', 'searchTajweed', Icons.record_voice_over, const TajweedScreen(), ['tecvid', 'tajweed', 'okuma', 'recitation']),
  // Dua & Dhikr
  _Feature('duas', 'searchDuas', Icons.front_hand, const DuaScreen(), ['dua', 'supplication', 'prayer']),
  _Feature('duaForOccasions', 'searchOccasions', Icons.menu_book_outlined, const DailyDuasScreen(), ['gunluk', 'daily', 'yemek', 'uyku', 'yolculuk']),
  _Feature('patienceDuas', 'searchPatience', Icons.healing_outlined, const PatienceDuasScreen(), ['sabir', 'patience', 'difficulty', 'sikinti']),
  _Feature('salawatCollection', 'searchSalawat', Icons.mosque_outlined, const SalawatScreen(), ['salavat', 'salawat', 'peygamber', 'prophet']),
  _Feature('adhanDua', 'searchAdhan', Icons.notifications_active, const AdhanDuaScreen(), ['ezan', 'adhan', 'dua']),
  _Feature('ruqyahGuide', 'searchRuqyah', Icons.healing, const RuqyahScreen(), ['rukyah', 'ruqyah', 'sifa', 'healing', 'korunma']),
  // Education
  _Feature('hadiths', 'searchHadith', Icons.auto_stories, const HadithScreen(), ['hadis', 'hadith', 'peygamber']),
  _Feature('prophetsOfIslam', 'searchProphets', Icons.groups_outlined, const ProphetsScreen(), ['peygamber', 'prophet', 'nabi']),
  _Feature('names99', 'searchNames99', Icons.star_outline, const AsmaAlHusnaScreen(), ['esma', '99', 'names', 'allah']),
  _Feature('islamicNames', 'searchBabyNames', Icons.child_care, const NamesScreen(), ['isim', 'name', 'bebek', 'baby']),
  _Feature('islamicGlossary', 'searchGlossary', Icons.library_books_outlined, const GlossaryScreen(), ['sozluk', 'glossary', 'terim', 'term']),
  _Feature('islamicFaq', 'searchFaq', Icons.question_answer, const FaqScreen(), ['soru', 'faq', 'question', 'sss']),
  _Feature('wisdomQuotes', 'searchWisdom', Icons.auto_awesome, const WisdomScreen(), ['hikmet', 'wisdom', 'ayet', 'sozu']),
  // Guides
  _Feature('prayerGuide', 'searchPrayerGuide', Icons.school, const PrayerGuideScreen(), ['namaz', 'kilinisi', 'how to pray']),
  _Feature('wuduGuide', 'searchWudu', Icons.water_drop_outlined, const WuduScreen(), ['abdest', 'wudu', 'ablution']),
  _Feature('ghuslGuide', 'searchGhusl', Icons.shower, const GhuslScreen(), ['gusul', 'ghusl', 'boy abdesti']),
  _Feature('tayammumGuide', 'searchTayammum', Icons.landscape, const TayammumScreen(), ['teyemmum', 'tayammum']),
  _Feature('hajjUmrah', 'searchHajj', Icons.location_city, const HajjGuideScreen(), ['hac', 'umre', 'hajj', 'umrah']),
  _Feature('janazahGuide', 'searchJanazah', Icons.people_outline, const JanazahScreen(), ['cenaze', 'janazah', 'funeral']),
  _Feature('istikharaGuide', 'searchIstikhara', Icons.help_outline, const IstikharaScreen(), ['istihare', 'istikhara']),
  _Feature('nikahGuide', 'searchNikah', Icons.favorite_border, const NikahScreen(), ['nikah', 'evlilik', 'marriage']),
  _Feature('tawbahGuide', 'searchTawbah', Icons.self_improvement, const TawbahScreen(), ['tovbe', 'tawbah', 'repentance']),
  _Feature('islamicAdab', 'searchAdab', Icons.auto_fix_high, const AdabScreen(), ['adab', 'edep', 'etiquette']),
  // Trackers
  _Feature('zakatCalculator', 'searchZakat', Icons.calculate_outlined, const ZakatScreen(), ['zekat', 'zakat', 'hesap']),
  _Feature('fidyahCalc', 'searchFidyah', Icons.paid_outlined, const FidyahScreen(), ['fidye', 'kefaret', 'fidyah']),
  _Feature('fastingTracker', 'searchFasting', Icons.restaurant_outlined, const FastingScreen(), ['oruc', 'fasting', 'ramazan']),
  _Feature('qazaTracker', 'searchQaza', Icons.history_rounded, const QazaScreen(), ['kaza', 'qaza', 'missed']),
  _Feature('goodDeeds', 'searchDeeds', Icons.checklist_rounded, const GoodDeedsScreen(), ['iyilik', 'good deeds', 'amel']),
  _Feature('charityTracker', 'searchCharity', Icons.volunteer_activism, const CharityScreen(), ['bagis', 'charity', 'sadaka']),
  _Feature('duaJournal', 'searchJournal', Icons.edit_note, const DuaJournalScreen(), ['dua defteri', 'journal', 'gunluk']),
  _Feature('muhasaba', 'searchMuhasaba', Icons.nightlight_round, const MuhasabaScreen(), ['muhasebe', 'muhasaba', 'nefis']),
  _Feature('statsDashboard', 'searchStats', Icons.bar_chart_rounded, const StatsDashboardScreen(), ['istatistik', 'stats']),
  // Calendar & History
  _Feature('islamicCalendar', 'searchCalendar', Icons.calendar_month, const IslamicCalendarScreen(), ['takvim', 'calendar', 'hicri']),
  _Feature('hijriMonthsGuide', 'searchHijriMonths', Icons.date_range, const HijriMonthsScreen(), ['hicri', 'ay', 'month']),
  _Feature('islamicTimeline', 'searchTimeline', Icons.timeline, const TimelineScreen(), ['tarih', 'timeline', 'history']),
  // Other
  _Feature('islamicQuiz', 'searchQuiz', Icons.quiz_outlined, const QuizScreen(), ['quiz', 'yarisma', 'bilgi']),
  _Feature('dailyTips', 'searchTips', Icons.tips_and_updates, const DailyTipsScreen(), ['ipucu', 'tip', 'tavsiye']),
  _Feature('motivation', 'searchMotivation', Icons.format_paint, const MotivationScreen(), ['motivasyon', 'motivation']),
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
