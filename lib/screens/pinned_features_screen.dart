import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';

class _P {
  final Color bg, surface, accent, gold, fg, muted, divider;
  const _P({required this.bg, required this.surface, required this.accent, required this.gold, required this.fg, required this.muted, required this.divider});
  static _P of(bool d) => d
      ? const _P(bg: Color(0xFF0E1A19), surface: Color(0xFF182624), accent: Color(0xFF4FBFA8), gold: Color(0xFFE3C77B), fg: Color(0xFFF5F1E8), muted: Color(0xFF8B968F), divider: Color(0xFF243532))
      : const _P(bg: Color(0xFFF8F5EE), surface: Color(0xFFFFFFFF), accent: Color(0xFF2C7A6B), gold: Color(0xFFB8902B), fg: Color(0xFF1F2937), muted: Color(0xFF6B6359), divider: Color(0xFFE8DDD0));
}

/// Manages pinned/favorite features that appear at the top of home screen
class PinnedFeaturesManager {
  static const _key = 'pinnedFeatures';

  static Future<List<String>> getPinned() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key);
    return raw ?? [];
  }

  static Future<void> togglePin(String featureKey) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    if (list.contains(featureKey)) {
      list.remove(featureKey);
    } else {
      if (list.length >= 8) return; // max 8 pinned
      list.add(featureKey);
    }
    await prefs.setStringList(_key, list);
  }

  static Future<bool> isPinned(String featureKey) async {
    final list = await getPinned();
    return list.contains(featureKey);
  }
}

/// Screen to manage pinned features
class PinnedFeaturesScreen extends StatefulWidget {
  const PinnedFeaturesScreen({super.key});
  @override
  State<PinnedFeaturesScreen> createState() => _PinnedFeaturesScreenState();
}

class _PinnedFeaturesScreenState extends State<PinnedFeaturesScreen> {
  List<String> _pinned = [];

  static const _allFeatures = [
    ('prayerTimes', Icons.access_time_filled),
    ('qibla', Icons.explore),
    ('dhikr', Icons.touch_app),
    ('adhkar', Icons.wb_twilight_rounded),
    ('postPrayer', Icons.playlist_add_check),
    ('quranReader', Icons.chrome_reader_mode),
    ('hifzTracker', Icons.auto_stories_outlined),
    ('khatmPlanner', Icons.import_contacts),
    ('tasbihSet', Icons.repeat_rounded),
    ('visualTasbih', Icons.radio_button_checked),
    ('duaForOccasions', Icons.menu_book_outlined),
    ('patienceDuas', Icons.healing_outlined),
    ('salawatCollection', Icons.mosque_outlined),
    ('adhanDua', Icons.notifications_active),
    ('zakatCalculator', Icons.calculate_outlined),
    ('fastingTracker', Icons.restaurant_outlined),
    ('qazaTracker', Icons.history_rounded),
    ('goodDeeds', Icons.checklist_rounded),
    ('muhasaba', Icons.nightlight_round),
    ('charityTracker', Icons.volunteer_activism),
    ('islamicQuiz', Icons.quiz_outlined),
    ('wisdomQuotes', Icons.auto_awesome),
    ('dailyTips', Icons.tips_and_updates),
    ('statsDashboard', Icons.bar_chart_rounded),
    ('duaJournal', Icons.edit_note),
    ('hajjUmrah', Icons.location_city),
    ('islamicCalendar', Icons.calendar_month),
    ('prophetsOfIslam', Icons.groups_outlined),
    ('islamicGlossary', Icons.library_books_outlined),
    ('tajweedGuide', Icons.record_voice_over),
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    _pinned = await PinnedFeaturesManager.getPinned();
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _toggle(String key) async {
    HapticFeedback.lightImpact();
    await PinnedFeaturesManager.togglePin(key);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('pinnedFeatures'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)), centerTitle: true),
      body: ListView(padding: const EdgeInsets.fromLTRB(20, 0, 20, 32), children: [
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: p.gold.withOpacity(0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: p.gold.withOpacity(0.2))),
          child: Row(children: [Icon(Icons.push_pin, color: p.gold, size: 18), const SizedBox(width: 10),
            Expanded(child: Text(l10n.translate('pinnedInfo'), style: TextStyle(fontSize: 12, color: p.muted, height: 1.4)))])),
        const SizedBox(height: 16),
        Text('${_pinned.length}/8 ${l10n.translate('pinned')}', style: TextStyle(fontSize: 11, color: p.muted, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        ..._allFeatures.map((f) {
          final (key, icon) = f;
          final isPinned = _pinned.contains(key);
          return Container(
            margin: const EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(color: isPinned ? p.gold.withOpacity(0.06) : p.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: isPinned ? p.gold.withOpacity(0.3) : p.divider)),
            child: ListTile(
              onTap: () => _toggle(key),
              dense: true,
              leading: Container(width: 32, height: 32, decoration: BoxDecoration(shape: BoxShape.circle, color: (isPinned ? p.gold : p.accent).withOpacity(0.12)),
                child: Icon(icon, size: 16, color: isPinned ? p.gold : p.accent)),
              title: Text(l10n.translate(key), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: p.fg)),
              trailing: Icon(isPinned ? Icons.push_pin : Icons.push_pin_outlined, size: 18, color: isPinned ? p.gold : p.muted),
            ),
          );
        }),
      ]),
    );
  }
}
