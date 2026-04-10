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

class _ProphetDua {
  final String prophet, arabic, translationKey, ref;
  const _ProphetDua(this.prophet, this.arabic, this.translationKey, this.ref);
}

const _duas = [
  _ProphetDua('Adam (AS)', '\u0631\u064e\u0628\u0651\u064e\u0646\u064e\u0627 \u0638\u064e\u0644\u064e\u0645\u0652\u0646\u064e\u0627 \u0623\u064e\u0646\u0641\u064f\u0633\u064e\u0646\u064e\u0627 \u0648\u064e\u0625\u0650\u0646 \u0644\u0651\u064e\u0645\u0652 \u062a\u064e\u063a\u0652\u0641\u0650\u0631\u0652 \u0644\u064e\u0646\u064e\u0627 \u0648\u064e\u062a\u064e\u0631\u0652\u062d\u064e\u0645\u0652\u0646\u064e\u0627 \u0644\u064e\u0646\u064e\u0643\u064f\u0648\u0646\u064e\u0646\u0651\u064e \u0645\u0650\u0646\u064e \u0627\u0644\u0652\u062e\u064e\u0627\u0633\u0650\u0631\u0650\u064a\u0646\u064e', 'pd_adam', '7:23'),
  _ProphetDua('Nuh (AS)', '\u0631\u064e\u0628\u0651\u0650 \u0627\u063a\u0652\u0641\u0650\u0631\u0652 \u0644\u0650\u064a \u0648\u064e\u0644\u0650\u0648\u064e\u0627\u0644\u0650\u062f\u064e\u064a\u0651\u064e \u0648\u064e\u0644\u0650\u0645\u064e\u0646 \u062f\u064e\u062e\u064e\u0644\u064e \u0628\u064e\u064a\u0652\u062a\u0650\u064a\u064e \u0645\u064f\u0624\u0652\u0645\u0650\u0646\u064b\u0627', 'pd_nuh', '71:28'),
  _ProphetDua('Ibrahim (AS)', '\u0631\u064e\u0628\u0651\u0650 \u0627\u062c\u0652\u0639\u064e\u0644\u0652\u0646\u0650\u064a \u0645\u064f\u0642\u0650\u064a\u0645\u064e \u0627\u0644\u0635\u0651\u064e\u0644\u064e\u0627\u0629\u0650 \u0648\u064e\u0645\u0650\u0646 \u0630\u064f\u0631\u0651\u0650\u064a\u0651\u064e\u062a\u0650\u064a', 'pd_ibrahim', '14:40'),
  _ProphetDua('Musa (AS)', '\u0631\u064e\u0628\u0651\u0650 \u0627\u0634\u0652\u0631\u064e\u062d\u0652 \u0644\u0650\u064a \u0635\u064e\u062f\u0652\u0631\u0650\u064a \u0648\u064e\u064a\u064e\u0633\u0651\u0650\u0631\u0652 \u0644\u0650\u064a \u0623\u064e\u0645\u0652\u0631\u0650\u064a', 'pd_musa', '20:25-26'),
  _ProphetDua('Yunus (AS)', '\u0644\u064e\u0627 \u0625\u0650\u0644\u064e\u0647\u064e \u0625\u0650\u0644\u0651\u064e\u0627 \u0623\u064e\u0646\u062a\u064e \u0633\u064f\u0628\u0652\u062d\u064e\u0627\u0646\u064e\u0643\u064e \u0625\u0650\u0646\u0651\u0650\u064a \u0643\u064f\u0646\u062a\u064f \u0645\u0650\u0646\u064e \u0627\u0644\u0638\u0651\u064e\u0627\u0644\u0650\u0645\u0650\u064a\u0646\u064e', 'pd_yunus', '21:87'),
  _ProphetDua('Ayyub (AS)', '\u0631\u064e\u0628\u0651\u0650 \u0625\u0650\u0646\u0651\u0650\u064a \u0645\u064e\u0633\u0651\u064e\u0646\u0650\u064a\u064e \u0627\u0644\u0636\u0651\u064f\u0631\u0651\u064f \u0648\u064e\u0623\u064e\u0646\u062a\u064e \u0623\u064e\u0631\u0652\u062d\u064e\u0645\u064f \u0627\u0644\u0631\u0651\u064e\u0627\u062d\u0650\u0645\u0650\u064a\u0646\u064e', 'pd_ayyub', '21:83'),
  _ProphetDua('Sulaiman (AS)', '\u0631\u064e\u0628\u0651\u0650 \u0623\u064e\u0648\u0652\u0632\u0650\u0639\u0652\u0646\u0650\u064a \u0623\u064e\u0646\u0652 \u0623\u064e\u0634\u0652\u0643\u064f\u0631\u064e \u0646\u0650\u0639\u0652\u0645\u064e\u062a\u064e\u0643\u064e', 'pd_sulaiman', '27:19'),
  _ProphetDua('Zakariya (AS)', '\u0631\u064e\u0628\u0651\u0650 \u0644\u064e\u0627 \u062a\u064e\u0630\u064e\u0631\u0652\u0646\u0650\u064a \u0641\u064e\u0631\u0652\u062f\u064b\u0627 \u0648\u064e\u0623\u064e\u0646\u062a\u064e \u062e\u064e\u064a\u0652\u0631\u064f \u0627\u0644\u0652\u0648\u064e\u0627\u0631\u0650\u062b\u0650\u064a\u0646\u064e', 'pd_zakariya', '21:89'),
  _ProphetDua('Muhammad (SAW)', '\u0631\u064e\u0628\u0651\u064e\u0646\u064e\u0627 \u0622\u062a\u0650\u0646\u064e\u0627 \u0641\u0650\u064a \u0627\u0644\u062f\u0651\u064f\u0646\u0652\u064a\u064e\u0627 \u062d\u064e\u0633\u064e\u0646\u064e\u0629\u064b \u0648\u064e\u0641\u0650\u064a \u0627\u0644\u0652\u0622\u062e\u0650\u0631\u064e\u0629\u0650 \u062d\u064e\u0633\u064e\u0646\u064e\u0629\u064b \u0648\u064e\u0642\u0650\u0646\u064e\u0627 \u0639\u064e\u0630\u064e\u0627\u0628\u064e \u0627\u0644\u0646\u0651\u064e\u0627\u0631\u0650', 'pd_muhammad', '2:201'),
];

class ProphetDuasScreen extends StatelessWidget {
  const ProphetDuasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('prophetDuas'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)), centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        itemCount: _duas.length,
        itemBuilder: (_, i) {
          final d = _duas[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: p.divider)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(width: 32, height: 32, decoration: BoxDecoration(shape: BoxShape.circle, color: p.gold.withOpacity(0.15)),
                  child: Center(child: Text('${i + 1}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: p.gold)))),
                const SizedBox(width: 10),
                Text(d.prophet, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: p.fg)),
                const Spacer(),
                Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: p.accent.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                  child: Text(d.ref, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: p.accent))),
              ]),
              const SizedBox(height: 12),
              Text(d.arabic, textDirection: TextDirection.rtl, textAlign: TextAlign.center, style: TextStyle(fontSize: 20, color: p.fg, height: 1.8)),
              const SizedBox(height: 10),
              Text(l10n.translate(d.translationKey), style: TextStyle(fontSize: 12, color: p.muted, fontStyle: FontStyle.italic, height: 1.4)),
              const SizedBox(height: 8),
              Row(children: [
                GestureDetector(onTap: () { Clipboard.setData(ClipboardData(text: '${d.arabic}\n\n${l10n.translate(d.translationKey)}\n— Quran ${d.ref}')); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied'), duration: Duration(seconds: 1))); },
                  child: Icon(Icons.copy, size: 16, color: p.muted)),
                const SizedBox(width: 16),
                GestureDetector(onTap: () => Share.share('${d.arabic}\n\n${l10n.translate(d.translationKey)}\n— Quran ${d.ref}\n\nIslamic Companion App'),
                  child: Icon(Icons.share_outlined, size: 16, color: p.muted)),
              ]),
            ]),
          );
        },
      ),
    );
  }
}
