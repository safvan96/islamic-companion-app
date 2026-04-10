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

const _travelDua = '\u0633\u064f\u0628\u0652\u062d\u064e\u0627\u0646\u064e \u0627\u0644\u0651\u064e\u0630\u0650\u064a \u0633\u064e\u062e\u0651\u064e\u0631\u064e \u0644\u064e\u0646\u064e\u0627 \u0647\u064e\u0630\u064e\u0627 \u0648\u064e\u0645\u064e\u0627 \u0643\u064f\u0646\u0651\u064e\u0627 \u0644\u064e\u0647\u064f \u0645\u064f\u0642\u0652\u0631\u0650\u0646\u0650\u064a\u0646\u064e \u0648\u064e\u0625\u0650\u0646\u0651\u064e\u0627 \u0625\u0650\u0644\u064e\u0649 \u0631\u064e\u0628\u0651\u0650\u0646\u064e\u0627 \u0644\u064e\u0645\u064f\u0646\u0642\u064e\u0644\u0650\u0628\u064f\u0648\u0646\u064e';

class TravelGuideScreen extends StatelessWidget {
  const TravelGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;

    final rules = ['tg_r1', 'tg_r2', 'tg_r3', 'tg_r4', 'tg_r5', 'tg_r6', 'tg_r7'];

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('travelGuide'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)), centerTitle: true),
      body: ListView(padding: const EdgeInsets.fromLTRB(20, 0, 20, 32), children: [
        // Travel dua
        Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: p.gold.withOpacity(0.3))),
          child: Column(children: [
            Text(l10n.translate('travelDuaTitle').toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: p.gold, letterSpacing: 1.0)),
            const SizedBox(height: 12),
            Text(_travelDua, textDirection: TextDirection.rtl, textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: p.fg, height: 1.8)),
            const SizedBox(height: 10),
            Text(l10n.translate('travelDuaTrans'), textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: p.muted, fontStyle: FontStyle.italic, height: 1.4)),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              IconButton(onPressed: () { Clipboard.setData(ClipboardData(text: '$_travelDua\n\n${l10n.translate('travelDuaTrans')}')); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied'), duration: Duration(seconds: 1))); },
                icon: Icon(Icons.copy, size: 18, color: p.muted)),
              IconButton(onPressed: () => Share.share('$_travelDua\n\n${l10n.translate('travelDuaTrans')}\n\nIslamic Companion App'),
                icon: Icon(Icons.share_outlined, size: 18, color: p.muted)),
            ]),
          ])),
        const SizedBox(height: 20),

        // Travel rules
        Text(l10n.translate('travelRules').toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: p.muted, letterSpacing: 1.4)),
        const SizedBox(height: 10),
        ...List.generate(rules.length, (i) => Container(
          margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: p.divider)),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(width: 24, height: 24, decoration: BoxDecoration(shape: BoxShape.circle, color: p.accent.withOpacity(0.15)),
              child: Center(child: Text('${i + 1}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: p.accent)))),
            const SizedBox(width: 10),
            Expanded(child: Text(l10n.translate(rules[i]), style: TextStyle(fontSize: 13, color: p.fg, height: 1.5))),
          ]),
        )),
      ]),
    );
  }
}
