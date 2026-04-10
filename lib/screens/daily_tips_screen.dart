import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';

class _P {
  final Color bg, surface, accent, gold, fg, muted, divider;
  const _P({required this.bg, required this.surface, required this.accent, required this.gold, required this.fg, required this.muted, required this.divider});
  static _P of(bool d) => d
      ? const _P(bg: Color(0xFF0E1A19), surface: Color(0xFF182624), accent: Color(0xFF4FBFA8), gold: Color(0xFFE3C77B), fg: Color(0xFFF5F1E8), muted: Color(0xFF8B968F), divider: Color(0xFF243532))
      : const _P(bg: Color(0xFFF8F5EE), surface: Color(0xFFFFFFFF), accent: Color(0xFF2C7A6B), gold: Color(0xFFB8902B), fg: Color(0xFF1F2937), muted: Color(0xFF6B6359), divider: Color(0xFFE8DDD0));
}

class _Tip {
  final String titleKey, descKey;
  final IconData icon;
  final Color Function(_P) color;
  const _Tip(this.titleKey, this.descKey, this.icon, this.color);
}

final _tips = [
  _Tip('tip_1_title', 'tip_1_desc', Icons.wb_sunny, (p) => p.gold),
  _Tip('tip_2_title', 'tip_2_desc', Icons.water_drop, (p) => p.accent),
  _Tip('tip_3_title', 'tip_3_desc', Icons.menu_book, (p) => p.gold),
  _Tip('tip_4_title', 'tip_4_desc', Icons.favorite, (p) => Colors.pink),
  _Tip('tip_5_title', 'tip_5_desc', Icons.groups, (p) => p.accent),
  _Tip('tip_6_title', 'tip_6_desc', Icons.nightlight, (p) => p.gold),
  _Tip('tip_7_title', 'tip_7_desc', Icons.volunteer_activism, (p) => Colors.orange),
  _Tip('tip_8_title', 'tip_8_desc', Icons.self_improvement, (p) => p.accent),
  _Tip('tip_9_title', 'tip_9_desc', Icons.restaurant, (p) => p.gold),
  _Tip('tip_10_title', 'tip_10_desc', Icons.access_time, (p) => p.accent),
  _Tip('tip_11_title', 'tip_11_desc', Icons.psychology, (p) => p.gold),
  _Tip('tip_12_title', 'tip_12_desc', Icons.eco, (p) => Colors.green),
];

class DailyTipsScreen extends StatelessWidget {
  const DailyTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;
    // Show daily tip based on day of year
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
    final todayIndex = dayOfYear % _tips.length;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('dailyTips'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          // Today's tip highlight
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [p.gold.withOpacity(0.12), p.accent.withOpacity(0.06)]),
              borderRadius: BorderRadius.circular(20), border: Border.all(color: p.gold.withOpacity(0.3)),
            ),
            child: Column(children: [
              Row(children: [
                Icon(Icons.lightbulb, color: p.gold, size: 20),
                const SizedBox(width: 8),
                Text(l10n.translate('todaysTip').toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: p.gold, letterSpacing: 1.2)),
              ]),
              const SizedBox(height: 12),
              Text(l10n.translate(_tips[todayIndex].titleKey), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: p.fg)),
              const SizedBox(height: 8),
              Text(l10n.translate(_tips[todayIndex].descKey), style: TextStyle(fontSize: 13, color: p.muted, height: 1.5)),
            ]),
          ),
          const SizedBox(height: 20),
          Text(l10n.translate('allTips').toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: p.muted, letterSpacing: 1.4)),
          const SizedBox(height: 10),
          ...List.generate(_tips.length, (i) {
            final tip = _tips[i];
            final color = tip.color(p);
            final isToday = i == todayIndex;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isToday ? color.withOpacity(0.06) : p.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isToday ? color.withOpacity(0.3) : p.divider),
              ),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(width: 36, height: 36, decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(0.12)),
                  child: Icon(tip.icon, size: 18, color: color)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(child: Text(l10n.translate(tip.titleKey), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: p.fg))),
                    if (isToday) Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
                      child: Text(l10n.translate('today'), style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: color))),
                  ]),
                  const SizedBox(height: 4),
                  Text(l10n.translate(tip.descKey), style: TextStyle(fontSize: 12, color: p.muted, height: 1.4)),
                ])),
              ]),
            );
          }),
        ],
      ),
    );
  }
}
