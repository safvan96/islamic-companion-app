import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';
import '../services/quran_stats_service.dart';

class _P {
  final Color bg, surface, accent, gold, fg, muted, divider;
  const _P({required this.bg, required this.surface, required this.accent, required this.gold, required this.fg, required this.muted, required this.divider});
  static _P of(bool d) => d
      ? const _P(bg: Color(0xFF0E1A19), surface: Color(0xFF182624), accent: Color(0xFF4FBFA8), gold: Color(0xFFE3C77B), fg: Color(0xFFF5F1E8), muted: Color(0xFF8B968F), divider: Color(0xFF243532))
      : const _P(bg: Color(0xFFF8F5EE), surface: Color(0xFFFFFFFF), accent: Color(0xFF2C7A6B), gold: Color(0xFFB8902B), fg: Color(0xFF1F2937), muted: Color(0xFF6B6359), divider: Color(0xFFE8DDD0));
}

class QuranStatsScreen extends StatefulWidget {
  const QuranStatsScreen({super.key});
  @override
  State<QuranStatsScreen> createState() => _QuranStatsScreenState();
}

class _QuranStatsScreenState extends State<QuranStatsScreen> {
  int _surahsRead = 0, _totalAyahs = 0, _streak = 0;
  Set<String> _readSurahs = {};

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final stats = await QuranStatsService.getStats();
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('quranReadSurahs') ?? [];
    if (!mounted) return;
    setState(() {
      _surahsRead = stats['surahsRead'] ?? 0;
      _totalAyahs = stats['totalAyahs'] ?? 0;
      _streak = stats['streak'] ?? 0;
      _readSurahs = list.toSet();
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = _P.of(Provider.of<AppProvider>(context).isDarkMode);
    final l10n = AppLocalizations.of(context)!;
    final pct = _surahsRead == 0 ? 0.0 : _surahsRead / 114.0;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('quranStats'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted)), centerTitle: true),
      body: ListView(padding: const EdgeInsets.fromLTRB(20, 0, 20, 32), children: [
        // Progress circle
        Center(child: SizedBox(width: 160, height: 160, child: Stack(alignment: Alignment.center, children: [
          SizedBox(width: 160, height: 160, child: CircularProgressIndicator(value: pct, strokeWidth: 8, backgroundColor: p.divider, valueColor: AlwaysStoppedAnimation(p.gold))),
          Column(mainAxisSize: MainAxisSize.min, children: [
            Text('${(pct * 100).toStringAsFixed(0)}%', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w200, color: p.fg)),
            Text('$_surahsRead / 114', style: TextStyle(fontSize: 13, color: p.muted)),
          ]),
        ]))),
        const SizedBox(height: 24),
        // Stats row
        Row(children: [
          _card(p, '$_totalAyahs', l10n.translate('ayahsRead'), Icons.format_list_numbered),
          const SizedBox(width: 12),
          _card(p, '$_streak', l10n.translate('dayStreak'), Icons.local_fire_department),
          const SizedBox(width: 12),
          _card(p, '${114 - _surahsRead}', l10n.translate('remaining'), Icons.hourglass_bottom),
        ]),
        const SizedBox(height: 24),
        // Surah grid (114 mini tiles)
        Text(l10n.translate('surahMap'), style: TextStyle(fontSize: 11, color: p.muted, fontWeight: FontWeight.w600, letterSpacing: 1)),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 12, mainAxisSpacing: 3, crossAxisSpacing: 3),
          itemCount: 114,
          itemBuilder: (_, i) {
            final read = _readSurahs.contains('${i + 1}');
            return Container(
              decoration: BoxDecoration(
                color: read ? p.gold : p.surface,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: read ? p.gold : p.divider, width: 0.5),
              ),
              child: Center(child: Text('${i + 1}', style: TextStyle(fontSize: 7, color: read ? Colors.white : p.muted))),
            );
          },
        ),
        const SizedBox(height: 8),
        Row(children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: p.gold, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 6),
          Text(l10n.translate('read'), style: TextStyle(fontSize: 10, color: p.muted)),
          const SizedBox(width: 16),
          Container(width: 12, height: 12, decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(2), border: Border.all(color: p.divider))),
          const SizedBox(width: 6),
          Text(l10n.translate('notStarted'), style: TextStyle(fontSize: 10, color: p.muted)),
        ]),
      ]),
    );
  }

  Widget _card(_P p, String value, String label, IconData icon) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: p.divider)),
      child: Column(children: [
        Icon(icon, size: 20, color: p.gold),
        const SizedBox(height: 6),
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: p.fg)),
        Text(label, style: TextStyle(fontSize: 10, color: p.muted)),
      ]),
    ),
  );
}
