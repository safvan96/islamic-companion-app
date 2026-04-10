import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';
import '../providers/dhikr_provider.dart';
import '../providers/qaza_provider.dart';
import '../providers/fasting_provider.dart';

class _P {
  final Color bg, surface, accent, gold, fg, muted, divider;
  const _P({required this.bg, required this.surface, required this.accent, required this.gold, required this.fg, required this.muted, required this.divider});
  static _P of(bool d) => d
      ? const _P(bg: Color(0xFF0E1A19), surface: Color(0xFF182624), accent: Color(0xFF4FBFA8), gold: Color(0xFFE3C77B), fg: Color(0xFFF5F1E8), muted: Color(0xFF8B968F), divider: Color(0xFF243532))
      : const _P(bg: Color(0xFFF8F5EE), surface: Color(0xFFFFFFFF), accent: Color(0xFF2C7A6B), gold: Color(0xFFB8902B), fg: Color(0xFF1F2937), muted: Color(0xFF6B6359), divider: Color(0xFFE8DDD0));
}

class WeeklyReportScreen extends StatelessWidget {
  const WeeklyReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;
    final dhikr = Provider.of<DhikrProvider>(context);
    final qaza = Provider.of<QazaProvider>(context);
    final fasting = Provider.of<FastingProvider>(context);
    final data = dhikr.last7Days;
    final weekTotal = data.fold<int>(0, (s, e) => s + e.value);
    final dayAvg = weekTotal ~/ 7;
    final bestDay = data.fold<int>(0, (s, e) => e.value > s ? e.value : s);
    final activeDays = data.where((e) => e.value > 0).length;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('weeklyReport'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)), centerTitle: true),
      body: ListView(padding: const EdgeInsets.fromLTRB(20, 0, 20, 32), children: [
        // Header
        Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(
          gradient: LinearGradient(colors: [p.gold.withOpacity(0.12), p.accent.withOpacity(0.06)]),
          borderRadius: BorderRadius.circular(20), border: Border.all(color: p.gold.withOpacity(0.2))),
          child: Column(children: [
            Icon(Icons.insights, size: 32, color: p.gold),
            const SizedBox(height: 8),
            Text(l10n.translate('thisWeekSummary'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: p.fg)),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _stat(l10n.translate('totalDhikr'), '$weekTotal', p.gold, p),
              _stat(l10n.translate('dayAvg'), '$dayAvg', p.accent, p),
              _stat(l10n.translate('bestDayLabel'), '$bestDay', Colors.orange, p),
              _stat(l10n.translate('activeDays'), '$activeDays/7', p.accent, p),
            ]),
          ])),
        const SizedBox(height: 16),

        // Weekly chart
        Text(l10n.translate('dhikrChart').toUpperCase(), style: TextStyle(fontSize: 10, color: p.muted, letterSpacing: 1.2, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: p.divider)),
          child: SizedBox(height: 100, child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: List.generate(7, (i) {
            final val = data[i].value;
            final maxVal = bestDay == 0 ? 1 : bestDay;
            final ratio = val / maxVal;
            final isToday = i == 6;
            const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
            final now = DateTime.now();
            final d = now.subtract(Duration(days: 6 - i));
            final wd = (d.weekday - 1) % 7;
            return Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              Text('$val', style: TextStyle(fontSize: 10, color: p.muted, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Container(margin: const EdgeInsets.symmetric(horizontal: 4), height: (ratio * 60).clamp(4.0, 60.0),
                decoration: BoxDecoration(color: isToday ? p.gold : p.gold.withOpacity(0.35), borderRadius: BorderRadius.circular(4))),
              const SizedBox(height: 6),
              Text(labels[wd], style: TextStyle(fontSize: 10, color: isToday ? p.gold : p.muted, fontWeight: isToday ? FontWeight.w700 : FontWeight.w400)),
            ]));
          })))),
        const SizedBox(height: 20),

        // Other stats
        Text(l10n.translate('otherStats').toUpperCase(), style: TextStyle(fontSize: 10, color: p.muted, letterSpacing: 1.2, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        _row(Icons.local_fire_department, l10n.translate('streak'), '${dhikr.streak} ${l10n.translate('days')}', Colors.orange, p),
        _row(Icons.history, l10n.translate('qazaTracker'), '${qaza.totalRemaining} ${l10n.translate('remaining').toLowerCase()}', p.accent, p),
        _row(Icons.restaurant, l10n.translate('totalFasts'), '${fasting.totalFasts}', p.gold, p),
        _row(Icons.check_circle, l10n.translate('qazaMadeUp'), '${qaza.totalCompleted}', p.accent, p),
      ]),
    );
  }

  Widget _stat(String label, String value, Color color, _P p) => Column(children: [
    Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: color)),
    Text(label, style: TextStyle(fontSize: 8, color: p.muted, fontWeight: FontWeight.w600)),
  ]);

  Widget _row(IconData icon, String label, String value, Color color, _P p) => Container(
    margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: p.divider)),
    child: Row(children: [
      Container(width: 32, height: 32, decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(0.12)),
        child: Icon(icon, size: 16, color: color)),
      const SizedBox(width: 12),
      Expanded(child: Text(label, style: TextStyle(fontSize: 13, color: p.fg, fontWeight: FontWeight.w500))),
      Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: color)),
    ]),
  );
}
