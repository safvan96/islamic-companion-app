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

const _steps = [
  ('sg_1', Icons.clean_hands),
  ('sg_2', Icons.bed),
  ('sg_3', Icons.menu_book),
  ('sg_4', Icons.air),
  ('sg_5', Icons.nightlight),
  ('sg_6', Icons.self_improvement),
  ('sg_7', Icons.alarm),
];

const _sleepDua = '\u0628\u0650\u0627\u0633\u0652\u0645\u0650\u0643\u064e \u0627\u0644\u0644\u0651\u064e\u0647\u064f\u0645\u0651\u064e \u0623\u064e\u0645\u064f\u0648\u062a\u064f \u0648\u064e\u0623\u064e\u062d\u0652\u064a\u064e\u0627';
const _wakeDua = '\u0627\u0644\u0652\u062d\u064e\u0645\u0652\u062f\u064f \u0644\u0650\u0644\u0651\u064e\u0647\u0650 \u0627\u0644\u0651\u064e\u0630\u0650\u064a \u0623\u064e\u062d\u0652\u064a\u064e\u0627\u0646\u064e\u0627 \u0628\u064e\u0639\u0652\u062f\u064e \u0645\u064e\u0627 \u0623\u064e\u0645\u064e\u0627\u062a\u064e\u0646\u064e\u0627 \u0648\u064e\u0625\u0650\u0644\u064e\u064a\u0652\u0647\u0650 \u0627\u0644\u0646\u0651\u064f\u0634\u064f\u0648\u0631\u064f';

class SleepGuideScreen extends StatelessWidget {
  const SleepGuideScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('sleepGuide'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)), centerTitle: true),
      body: ListView(padding: const EdgeInsets.fromLTRB(20, 0, 20, 32), children: [
        // Sleep dua
        _duaCard(p, l10n, l10n.translate('sleepDuaTitle'), _sleepDua, 'sleepDuaTrans'),
        const SizedBox(height: 16),
        // Sunnah steps
        Text(l10n.translate('sleepSunnah').toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: p.muted, letterSpacing: 1.4)),
        const SizedBox(height: 10),
        ...List.generate(_steps.length, (i) {
          final (key, icon) = _steps[i];
          return Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: p.divider)),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(width: 28, height: 28, decoration: BoxDecoration(shape: BoxShape.circle, color: p.accent.withOpacity(0.15)),
                child: Center(child: Text('${i + 1}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: p.accent)))),
              const SizedBox(width: 10),
              Icon(icon, size: 16, color: p.accent),
              const SizedBox(width: 8),
              Expanded(child: Text(l10n.translate(key), style: TextStyle(fontSize: 13, color: p.fg, height: 1.5))),
            ]));
        }),
        const SizedBox(height: 16),
        // Wake up dua
        _duaCard(p, l10n, l10n.translate('wakeDuaTitle'), _wakeDua, 'wakeDuaTrans'),
      ]),
    );
  }

  Widget _duaCard(_P p, AppLocalizations l10n, String title, String arabic, String transKey) => Container(
    padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: p.gold.withOpacity(0.3))),
    child: Column(children: [
      Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: p.gold, letterSpacing: 1.0)),
      const SizedBox(height: 10),
      Text(arabic, textDirection: TextDirection.rtl, textAlign: TextAlign.center, style: TextStyle(fontSize: 20, color: p.fg, height: 1.6)),
      const SizedBox(height: 8),
      Text(l10n.translate(transKey), textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: p.muted, fontStyle: FontStyle.italic)),
    ]));
}
