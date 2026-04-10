import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';

class _P {
  final Color bg, surface, accent, gold, fg, muted, divider;
  const _P({required this.bg, required this.surface, required this.accent, required this.gold, required this.fg, required this.muted, required this.divider});
  static _P of(bool d) => d
      ? const _P(bg: Color(0xFF0E1A19), surface: Color(0xFF182624), accent: Color(0xFF4FBFA8), gold: Color(0xFFE3C77B), fg: Color(0xFFF5F1E8), muted: Color(0xFF8B968F), divider: Color(0xFF243532))
      : const _P(bg: Color(0xFFF8F5EE), surface: Color(0xFFFFFFFF), accent: Color(0xFF2C7A6B), gold: Color(0xFFB8902B), fg: Color(0xFF1F2937), muted: Color(0xFF6B6359), divider: Color(0xFFE8DDD0));
}

const _duas = [
  ('\u0631\u064e\u0628\u0651\u064e\u0646\u064e\u0627 \u0647\u064e\u0628\u0652 \u0644\u064e\u0646\u064e\u0627 \u0645\u0650\u0646\u0652 \u0623\u064e\u0632\u0652\u0648\u064e\u0627\u062c\u0650\u0646\u064e\u0627 \u0648\u064e\u0630\u064f\u0631\u0651\u0650\u064a\u0651\u064e\u0627\u062a\u0650\u0646\u064e\u0627 \u0642\u064f\u0631\u0651\u064e\u0629\u064e \u0623\u064e\u0639\u0652\u064a\u064f\u0646\u064d', 'sd_1', '25:74'),
  ('\u0628\u064e\u0627\u0631\u064e\u0643\u064e \u0627\u0644\u0644\u0651\u064e\u0647\u064f \u0644\u064e\u0643\u064e \u0648\u064e\u0628\u064e\u0627\u0631\u064e\u0643\u064e \u0639\u064e\u0644\u064e\u064a\u0652\u0643\u064e \u0648\u064e\u062c\u064e\u0645\u064e\u0639\u064e \u0628\u064e\u064a\u0652\u0646\u064e\u0643\u064f\u0645\u064e\u0627 \u0641\u0650\u064a \u062e\u064e\u064a\u0652\u0631\u064d', 'sd_2', 'Hadith'),
  ('\u0631\u064e\u0628\u0651\u0650 \u0627\u062c\u0652\u0639\u064e\u0644\u0652\u0646\u0650\u064a \u0645\u064f\u0642\u0650\u064a\u0645\u064e \u0627\u0644\u0635\u0651\u064e\u0644\u064e\u0627\u0629\u0650 \u0648\u064e\u0645\u0650\u0646 \u0630\u064f\u0631\u0651\u0650\u064a\u0651\u064e\u062a\u0650\u064a \u0631\u064e\u0628\u0651\u064e\u0646\u064e\u0627 \u0648\u064e\u062a\u064e\u0642\u064e\u0628\u0651\u064e\u0644\u0652 \u062f\u064f\u0639\u064e\u0627\u0621\u0650', 'sd_3', '14:40'),
  ('\u0631\u064e\u0628\u0651\u064e\u0646\u064e\u0627 \u0622\u062a\u0650\u0646\u064e\u0627 \u0641\u0650\u064a \u0627\u0644\u062f\u0651\u064f\u0646\u0652\u064a\u064e\u0627 \u062d\u064e\u0633\u064e\u0646\u064e\u0629\u064b \u0648\u064e\u0641\u0650\u064a \u0627\u0644\u0652\u0622\u062e\u0650\u0631\u064e\u0629\u0650 \u062d\u064e\u0633\u064e\u0646\u064e\u0629\u064b', 'sd_4', '2:201'),
];

class SpouseDuasScreen extends StatelessWidget {
  const SpouseDuasScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('spouseDuas'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)), centerTitle: true),
      body: ListView(padding: const EdgeInsets.fromLTRB(20, 0, 20, 32), children: [
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(gradient: LinearGradient(colors: [p.gold.withOpacity(0.1), Colors.pink.withOpacity(0.05)]), borderRadius: BorderRadius.circular(16), border: Border.all(color: p.gold.withOpacity(0.2))),
          child: Column(children: [
            Icon(Icons.favorite, color: Colors.pink.withOpacity(0.6), size: 28),
            const SizedBox(height: 8),
            Text(l10n.translate('spouseDuasInfo'), textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: p.muted, height: 1.5)),
          ])),
        const SizedBox(height: 16),
        ..._duas.map((d) {
          final (arabic, transKey, ref) = d;
          return Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: p.divider)),
            child: Column(children: [
              Text(arabic, textDirection: TextDirection.rtl, textAlign: TextAlign.center, style: TextStyle(fontSize: 20, color: p.fg, height: 1.8)),
              const SizedBox(height: 10),
              Text(l10n.translate(transKey), textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: p.muted, fontStyle: FontStyle.italic, height: 1.4)),
              const SizedBox(height: 6),
              Text('— $ref', style: TextStyle(fontSize: 11, color: p.gold, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                GestureDetector(onTap: () { Clipboard.setData(ClipboardData(text: '$arabic\n\n${l10n.translate(transKey)}')); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied'), duration: Duration(seconds: 1))); },
                  child: Icon(Icons.copy, size: 16, color: p.muted)),
                const SizedBox(width: 16),
                GestureDetector(onTap: () => Share.share('$arabic\n\n${l10n.translate(transKey)}\n— $ref\n\nIslamic Companion App'),
                  child: Icon(Icons.share_outlined, size: 16, color: p.muted)),
              ]),
            ]));
        }),
      ]),
    );
  }
}
