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

const _ideas = [
  ('sj_1', Icons.menu_book), ('sj_2', Icons.water_drop), ('sj_3', Icons.school),
  ('sj_4', Icons.park), ('sj_5', Icons.mosque), ('sj_6', Icons.local_hospital),
  ('sj_7', Icons.restaurant), ('sj_8', Icons.family_restroom), ('sj_9', Icons.share),
  ('sj_10', Icons.construction),
];

class SadaqahJariyahScreen extends StatelessWidget {
  const SadaqahJariyahScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('sadaqahJariyah'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)), centerTitle: true),
      body: ListView(padding: const EdgeInsets.fromLTRB(20, 0, 20, 32), children: [
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(gradient: LinearGradient(colors: [p.gold.withOpacity(0.1), p.accent.withOpacity(0.05)]), borderRadius: BorderRadius.circular(16), border: Border.all(color: p.gold.withOpacity(0.2))),
          child: Column(children: [
            Text('\u0625\u0650\u0630\u064e\u0627 \u0645\u064e\u0627\u062a\u064e \u0627\u0644\u0652\u0625\u0650\u0646\u0633\u064e\u0627\u0646\u064f \u0627\u0646\u0652\u0642\u064e\u0637\u064e\u0639\u064e \u0639\u064e\u0645\u064e\u0644\u064f\u0647\u064f \u0625\u0650\u0644\u0651\u064e\u0627 \u0645\u0650\u0646\u0652 \u062b\u064e\u0644\u064e\u0627\u062b\u064e\u0629\u064d: \u0635\u064e\u062f\u064e\u0642\u064e\u0629\u064d \u062c\u064e\u0627\u0631\u0650\u064a\u064e\u0629\u064d \u0623\u064e\u0648\u0652 \u0639\u0650\u0644\u0652\u0645\u064d \u064a\u064f\u0646\u0652\u062a\u064e\u0641\u064e\u0639\u064f \u0628\u0650\u0647\u0650 \u0623\u064e\u0648\u0652 \u0648\u064e\u0644\u064e\u062f\u064d \u0635\u064e\u0627\u0644\u0650\u062d\u064d \u064a\u064e\u062f\u0652\u0639\u064f\u0648 \u0644\u064e\u0647\u064f',
              textDirection: TextDirection.rtl, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: p.fg, height: 1.8)),
            const SizedBox(height: 8),
            Text(l10n.translate('sjHadith'), textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: p.muted, fontStyle: FontStyle.italic, height: 1.4)),
            Text('— Sahih Muslim', style: TextStyle(fontSize: 11, color: p.gold, fontWeight: FontWeight.w600)),
          ])),
        const SizedBox(height: 20),
        Text(l10n.translate('sjIdeas').toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: p.muted, letterSpacing: 1.4)),
        const SizedBox(height: 10),
        ...List.generate(_ideas.length, (i) {
          final (key, icon) = _ideas[i];
          return Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: p.divider)),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(width: 32, height: 32, decoration: BoxDecoration(shape: BoxShape.circle, color: p.gold.withOpacity(0.12)),
                child: Icon(icon, size: 16, color: p.gold)),
              const SizedBox(width: 12),
              Expanded(child: Text(l10n.translate(key), style: TextStyle(fontSize: 13, color: p.fg, height: 1.5))),
            ]));
        }),
      ]),
    );
  }
}
