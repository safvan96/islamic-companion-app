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

const _rules = [
  ('qe_1', Icons.clean_hands),
  ('qe_2', Icons.self_improvement),
  ('qe_3', Icons.volume_down),
  ('qe_4', Icons.south),
  ('qe_5', Icons.menu_book),
  ('qe_6', Icons.psychology),
  ('qe_7', Icons.pause),
  ('qe_8', Icons.water_drop),
  ('qe_9', Icons.place),
  ('qe_10', Icons.repeat),
];

class QuranEtiquetteScreen extends StatelessWidget {
  const QuranEtiquetteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('quranEtiquette'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)), centerTitle: true),
      body: ListView(padding: const EdgeInsets.fromLTRB(20, 0, 20, 32), children: [
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(
          gradient: LinearGradient(colors: [p.gold.withOpacity(0.1), p.accent.withOpacity(0.05)]),
          borderRadius: BorderRadius.circular(16), border: Border.all(color: p.gold.withOpacity(0.2))),
          child: Column(children: [
            Text('\u0648\u064e\u0631\u064e\u062a\u0651\u0650\u0644\u0650 \u0627\u0644\u0652\u0642\u064f\u0631\u0652\u0622\u0646\u064e \u062a\u064e\u0631\u0652\u062a\u0650\u064a\u0644\u064b\u0627', textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 22, color: p.fg, height: 1.6)),
            const SizedBox(height: 8),
            Text(l10n.translate('qeVerse'), textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: p.muted, fontStyle: FontStyle.italic)),
            Text('— Quran 73:4', style: TextStyle(fontSize: 11, color: p.gold, fontWeight: FontWeight.w600)),
          ])),
        const SizedBox(height: 20),
        ...List.generate(_rules.length, (i) {
          final (key, icon) = _rules[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: p.divider)),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(width: 28, height: 28, decoration: BoxDecoration(shape: BoxShape.circle, color: p.gold.withOpacity(0.15)),
                child: Center(child: Text('${i + 1}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: p.gold)))),
              const SizedBox(width: 10),
              Icon(icon, size: 18, color: p.accent),
              const SizedBox(width: 10),
              Expanded(child: Text(l10n.translate(key), style: TextStyle(fontSize: 13, color: p.fg, height: 1.5))),
            ]),
          );
        }),
      ]),
    );
  }
}
