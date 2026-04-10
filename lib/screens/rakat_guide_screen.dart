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

class _Prayer { final String nameKey; final int sunnahBefore, fard, sunnahAfter, witr; final IconData icon;
  const _Prayer(this.nameKey, this.icon, {this.sunnahBefore = 0, required this.fard, this.sunnahAfter = 0, this.witr = 0}); }

const _prayers = [
  _Prayer('fajr', Icons.wb_twilight, sunnahBefore: 2, fard: 2),
  _Prayer('dhuhr', Icons.wb_sunny, sunnahBefore: 4, fard: 4, sunnahAfter: 2),
  _Prayer('asr', Icons.sunny_snowing, sunnahBefore: 4, fard: 4),
  _Prayer('maghrib', Icons.nights_stay_outlined, fard: 3, sunnahAfter: 2),
  _Prayer('isha', Icons.dark_mode_outlined, sunnahBefore: 4, fard: 4, sunnahAfter: 2, witr: 3),
  _Prayer('jumuah', Icons.mosque, sunnahBefore: 4, fard: 2, sunnahAfter: 4),
  _Prayer('tarawih', Icons.nightlight, fard: 20),
  _Prayer('eidPrayer', Icons.celebration, fard: 2),
  _Prayer('janazahPrayer', Icons.people, fard: 0), // standing only, no rakat
  _Prayer('duha', Icons.wb_sunny_outlined, fard: 2),
  _Prayer('tahajjud', Icons.dark_mode, fard: 2),
];

class RakatGuideScreen extends StatelessWidget {
  const RakatGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('rakatGuide'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)), centerTitle: true),
      body: ListView(padding: const EdgeInsets.fromLTRB(20, 0, 20, 32), children: [
        // Legend
        Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: p.divider)),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _legend(l10n.translate('sunnahLabel'), p.gold, p),
            _legend(l10n.translate('fardLabel'), p.accent, p),
            _legend(l10n.translate('witrLabel'), Colors.purple, p),
          ])),
        const SizedBox(height: 16),
        // Daily total
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: p.gold.withOpacity(0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: p.gold.withOpacity(0.2))),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.star, color: p.gold, size: 18), const SizedBox(width: 8),
            Text('${l10n.translate('dailyTotal')}: 17 ${l10n.translate('fardLabel')} + 12 ${l10n.translate('sunnahLabel')} + 3 ${l10n.translate('witrLabel')} = 32',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: p.gold)),
          ])),
        const SizedBox(height: 16),
        ..._prayers.map((pr) {
          final total = pr.sunnahBefore + pr.fard + pr.sunnahAfter + pr.witr;
          return Container(
            margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: p.divider)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(width: 36, height: 36, decoration: BoxDecoration(shape: BoxShape.circle, color: p.accent.withOpacity(0.12)),
                  child: Icon(pr.icon, size: 18, color: p.accent)),
                const SizedBox(width: 12),
                Expanded(child: Text(l10n.translate(pr.nameKey), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: p.fg))),
                Text('$total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: p.fg)),
              ]),
              if (pr.fard > 0 || pr.sunnahBefore > 0) ...[
                const SizedBox(height: 10),
                Row(children: [
                  if (pr.sunnahBefore > 0) _badge('${pr.sunnahBefore} ${l10n.translate('sunnahLabel')}', p.gold, p),
                  if (pr.sunnahBefore > 0) const SizedBox(width: 6),
                  if (pr.fard > 0) _badge('${pr.fard} ${l10n.translate('fardLabel')}', p.accent, p),
                  if (pr.sunnahAfter > 0) const SizedBox(width: 6),
                  if (pr.sunnahAfter > 0) _badge('${pr.sunnahAfter} ${l10n.translate('sunnahLabel')}', p.gold, p),
                  if (pr.witr > 0) const SizedBox(width: 6),
                  if (pr.witr > 0) _badge('${pr.witr} ${l10n.translate('witrLabel')}', Colors.purple, p),
                ]),
              ],
              if (pr.nameKey == 'janazahPrayer') Padding(padding: const EdgeInsets.only(top: 8),
                child: Text(l10n.translate('janazahNote'), style: TextStyle(fontSize: 11, color: p.muted, fontStyle: FontStyle.italic))),
            ]),
          );
        }),
      ]),
    );
  }

  Widget _legend(String label, Color color, _P p) => Row(children: [
    Container(width: 10, height: 10, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
    const SizedBox(width: 4),
    Text(label, style: TextStyle(fontSize: 11, color: p.muted, fontWeight: FontWeight.w500)),
  ]);

  Widget _badge(String text, Color color, _P p) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
    child: Text(text, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
  );
}
