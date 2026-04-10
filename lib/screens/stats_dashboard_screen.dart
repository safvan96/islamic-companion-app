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

class StatsDashboardScreen extends StatelessWidget {
  const StatsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;
    final dhikr = Provider.of<DhikrProvider>(context);
    final qaza = Provider.of<QazaProvider>(context);
    final fasting = Provider.of<FastingProvider>(context);

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('statsDashboard'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          // Overview
          _SectionLabel(l10n.translate('overview'), p),
          const SizedBox(height: 10),
          Row(children: [
            _BigStat(p: p, value: _fmt(dhikr.totalCount), label: l10n.translate('totalDhikr'), icon: Icons.touch_app, color: p.accent),
            const SizedBox(width: 10),
            _BigStat(p: p, value: '${dhikr.streak}', label: l10n.translate('dayStreak'), icon: Icons.local_fire_department, color: Colors.orange),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            _BigStat(p: p, value: '${fasting.totalFasts}', label: l10n.translate('totalFasts'), icon: Icons.restaurant, color: p.gold),
            const SizedBox(width: 10),
            _BigStat(p: p, value: '${qaza.totalCompleted}', label: l10n.translate('qazaMadeUp'), icon: Icons.check_circle_outline, color: p.accent),
          ]),
          const SizedBox(height: 24),

          // Dhikr section
          _SectionLabel(l10n.translate('dhikr'), p),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: p.divider)),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                _MiniStat(l10n.translate('today'), '${dhikr.todayCount}', p),
                _MiniStat(l10n.translate('total'), _fmt(dhikr.totalCount), p),
                _MiniStat(l10n.translate('streak'), '${dhikr.streak}d', p),
              ]),
              const SizedBox(height: 16),
              // Weekly chart
              SizedBox(
                height: 60,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(7, (i) {
                    final data = dhikr.last7Days;
                    final val = i < data.length ? data[i].value : 0;
                    final maxVal = data.map((e) => e.value).fold<int>(0, (a, b) => b > a ? b : a);
                    final ratio = maxVal == 0 ? 0.0 : val / maxVal;
                    final isToday = i == 6;
                    return Expanded(child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      height: (ratio * 50).clamp(3.0, 50.0),
                      decoration: BoxDecoration(
                        color: isToday ? p.accent : p.accent.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ));
                  }),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 24),

          // Qaza section
          _SectionLabel(l10n.translate('qazaTracker'), p),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: p.divider)),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                _MiniStat(l10n.translate('remaining'), '${qaza.totalRemaining}', p),
                _MiniStat(l10n.translate('madeUp'), '${qaza.totalCompleted}', p),
              ]),
              if (qaza.totalRemaining + qaza.totalCompleted > 0) ...[
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: qaza.totalCompleted / (qaza.totalRemaining + qaza.totalCompleted),
                    minHeight: 6, backgroundColor: p.divider, valueColor: AlwaysStoppedAnimation(p.accent),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              // Per-prayer breakdown
              ...QazaProvider.prayerKeys.where((k) => (qaza.counts[k] ?? 0) > 0).map((k) {
                final count = qaza.counts[k] ?? 0;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(l10n.translate(k), style: TextStyle(fontSize: 12, color: p.muted)),
                    Text('$count', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: p.fg)),
                  ]),
                );
              }),
            ]),
          ),
          const SizedBox(height: 24),

          // Fasting section
          _SectionLabel(l10n.translate('fastingTracker'), p),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: p.divider)),
            child: Row(children: [
              _ColorDot(p.gold, l10n.translate('ramadanShort'), '${fasting.ramadanFasts}', p),
              const SizedBox(width: 16),
              _ColorDot(p.accent, l10n.translate('voluntaryShort'), '${fasting.voluntaryFasts}', p),
              const SizedBox(width: 16),
              _ColorDot(Colors.orange, l10n.translate('makeupFast'), '${fasting.makeupFasts}', p),
            ]),
          ),
          const SizedBox(height: 24),

          // Per-dhikr stats
          _SectionLabel(l10n.translate('perDhikrStats'), p),
          const SizedBox(height: 10),
          ...List.generate(dhikr.allDhikrList.length, (i) {
            final d = dhikr.allDhikrList[i];
            final count = dhikr.perDhikrCounts[i];
            if (count == 0) return const SizedBox.shrink();
            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: p.divider)),
              child: Row(children: [
                Expanded(child: Text(d['transliteration'] ?? '', style: TextStyle(fontSize: 13, color: p.fg, fontWeight: FontWeight.w500))),
                Text(_fmt(count), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: p.gold)),
              ]),
            );
          }),
        ],
      ),
    );
  }

  static String _fmt(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return n.toString();
  }
}

class _SectionLabel extends StatelessWidget {
  final String text; final _P p;
  const _SectionLabel(this.text, this.p);
  @override
  Widget build(BuildContext context) => Text(text.toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: p.muted, letterSpacing: 1.4));
}

class _BigStat extends StatelessWidget {
  final _P p; final String value, label; final IconData icon; final Color color;
  const _BigStat({required this.p, required this.value, required this.label, required this.icon, required this.color});
  @override
  Widget build(BuildContext context) => Expanded(child: Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: p.divider)),
    child: Row(children: [
      Container(width: 40, height: 40, decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(0.12)),
        child: Icon(icon, size: 20, color: color)),
      const SizedBox(width: 12),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: p.fg)),
        Text(label, style: TextStyle(fontSize: 9, color: p.muted, fontWeight: FontWeight.w600)),
      ]),
    ]),
  ));
}

class _MiniStat extends StatelessWidget {
  final String label, value; final _P p;
  const _MiniStat(this.label, this.value, this.p);
  @override
  Widget build(BuildContext context) => Column(children: [
    Text(label.toUpperCase(), style: TextStyle(fontSize: 8, color: p.muted, letterSpacing: 1.0, fontWeight: FontWeight.w600)),
    const SizedBox(height: 4),
    Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: p.fg)),
  ]);
}

class _ColorDot extends StatelessWidget {
  final Color color; final String label, value; final _P p;
  const _ColorDot(this.color, this.label, this.value, this.p);
  @override
  Widget build(BuildContext context) => Expanded(child: Row(children: [
    Container(width: 10, height: 10, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
    const SizedBox(width: 8),
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: p.fg)),
      Text(label, style: TextStyle(fontSize: 9, color: p.muted)),
    ]),
  ]));
}
