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

const _reminders = [
  ('\u0643\u064f\u0644\u0651\u064f \u0646\u064e\u0641\u0652\u0633\u064d \u0630\u064e\u0627\u0626\u0650\u0642\u064e\u0629\u064f \u0627\u0644\u0652\u0645\u064e\u0648\u0652\u062a\u0650', 'dr_1', '3:185'),
  ('\u0623\u064e\u064a\u0652\u0646\u064e\u0645\u064e\u0627 \u062a\u064e\u0643\u064f\u0648\u0646\u064f\u0648\u0627 \u064a\u064f\u062f\u0652\u0631\u0650\u0643\u0643\u0651\u064f\u0645\u064f \u0627\u0644\u0652\u0645\u064e\u0648\u0652\u062a\u064f', 'dr_2', '4:78'),
  ('\u0648\u064e\u0645\u064e\u0627 \u062a\u064e\u062f\u0652\u0631\u0650\u064a \u0646\u064e\u0641\u0652\u0633\u064c \u0645\u0651\u064e\u0627\u0630\u064e\u0627 \u062a\u064e\u0643\u0652\u0633\u0650\u0628\u064f \u063a\u064e\u062f\u064b\u0627 \u0648\u064e\u0645\u064e\u0627 \u062a\u064e\u062f\u0652\u0631\u0650\u064a \u0646\u064e\u0641\u0652\u0633\u064c \u0628\u0650\u0623\u064e\u064a\u0651\u0650 \u0623\u064e\u0631\u0652\u0636\u064d \u062a\u064e\u0645\u064f\u0648\u062a\u064f', 'dr_3', '31:34'),
  ('\u0623\u064e\u0643\u0652\u062b\u0650\u0631\u064f\u0648\u0627 \u0630\u0650\u0643\u0652\u0631\u064e \u0647\u064e\u0627\u0630\u0650\u0645\u0650 \u0627\u0644\u0644\u0651\u064e\u0630\u0651\u064e\u0627\u062a\u0650', 'dr_4', 'Hadith'),
  ('\u0627\u0644\u0652\u0643\u064e\u064a\u0651\u0650\u0633\u064f \u0645\u064e\u0646\u0652 \u062f\u064e\u0627\u0646\u064e \u0646\u064e\u0641\u0652\u0633\u064e\u0647\u064f \u0648\u064e\u0639\u064e\u0645\u0650\u0644\u064e \u0644\u0650\u0645\u064e\u0627 \u0628\u064e\u0639\u0652\u062f\u064e \u0627\u0644\u0652\u0645\u064e\u0648\u0652\u062a\u0650', 'dr_5', 'Hadith'),
];

class DeathReminderScreen extends StatelessWidget {
  const DeathReminderScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('deathReminder'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)), centerTitle: true),
      body: ListView(padding: const EdgeInsets.fromLTRB(20, 0, 20, 32), children: [
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: p.muted.withOpacity(0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: p.muted.withOpacity(0.2))),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.hourglass_bottom, color: p.muted, size: 18), const SizedBox(width: 10),
            Expanded(child: Text(l10n.translate('drInfo'), style: TextStyle(fontSize: 12, color: p.muted, height: 1.5)))])),
        const SizedBox(height: 20),
        ..._reminders.map((r) {
          final (arabic, transKey, ref) = r;
          return Container(margin: const EdgeInsets.only(bottom: 14), padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: p.divider)),
            child: Column(children: [
              Text(arabic, textDirection: TextDirection.rtl, textAlign: TextAlign.center, style: TextStyle(fontSize: 20, color: p.fg, height: 1.8)),
              const SizedBox(height: 12),
              Container(width: 30, height: 2, color: p.muted.withOpacity(0.3)),
              const SizedBox(height: 12),
              Text(l10n.translate(transKey), textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: p.muted, fontStyle: FontStyle.italic, height: 1.5)),
              const SizedBox(height: 6),
              Text('— $ref', style: TextStyle(fontSize: 11, color: p.gold, fontWeight: FontWeight.w600)),
            ]));
        }),
      ]),
    );
  }
}
