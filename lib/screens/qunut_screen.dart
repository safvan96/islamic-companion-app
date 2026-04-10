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

const _qunutDua1 = '\u0627\u0644\u0644\u0651\u064e\u0647\u064f\u0645\u0651\u064e \u0627\u0647\u0652\u062f\u0650\u0646\u064e\u0627 \u0641\u0650\u064a\u0645\u064e\u0646\u0652 \u0647\u064e\u062f\u064e\u064a\u0652\u062a\u064e \u0648\u064e\u0639\u064e\u0627\u0641\u0650\u0646\u064e\u0627 \u0641\u0650\u064a\u0645\u064e\u0646\u0652 \u0639\u064e\u0627\u0641\u064e\u064a\u0652\u062a\u064e \u0648\u064e\u062a\u064e\u0648\u064e\u0644\u0651\u064e\u0646\u064e\u0627 \u0641\u0650\u064a\u0645\u064e\u0646\u0652 \u062a\u064e\u0648\u064e\u0644\u0651\u064e\u064a\u0652\u062a\u064e \u0648\u064e\u0628\u064e\u0627\u0631\u0650\u0643\u0652 \u0644\u064e\u0646\u064e\u0627 \u0641\u0650\u064a\u0645\u064e\u0627 \u0623\u064e\u0639\u0652\u0637\u064e\u064a\u0652\u062a\u064e \u0648\u064e\u0642\u0650\u0646\u064e\u0627 \u0634\u064e\u0631\u0651\u064e \u0645\u064e\u0627 \u0642\u064e\u0636\u064e\u064a\u0652\u062a\u064e \u0641\u064e\u0625\u0650\u0646\u0651\u064e\u0643\u064e \u062a\u064e\u0642\u0652\u0636\u0650\u064a \u0648\u064e\u0644\u064e\u0627 \u064a\u064f\u0642\u0652\u0636\u064e\u0649 \u0639\u064e\u0644\u064e\u064a\u0652\u0643\u064e \u0625\u0650\u0646\u0651\u064e\u0647\u064f \u0644\u064e\u0627 \u064a\u064e\u0630\u0650\u0644\u0651\u064f \u0645\u064e\u0646\u0652 \u0648\u064e\u0627\u0644\u064e\u064a\u0652\u062a\u064e \u0648\u064e\u0644\u064e\u0627 \u064a\u064e\u0639\u0650\u0632\u0651\u064f \u0645\u064e\u0646\u0652 \u0639\u064e\u0627\u062f\u064e\u064a\u0652\u062a\u064e \u062a\u064e\u0628\u064e\u0627\u0631\u064e\u0643\u0652\u062a\u064e \u0631\u064e\u0628\u0651\u064e\u0646\u064e\u0627 \u0648\u064e\u062a\u064e\u0639\u064e\u0627\u0644\u064e\u064a\u0652\u062a\u064e';

const _qunutDua2 = '\u0627\u0644\u0644\u0651\u064e\u0647\u064f\u0645\u0651\u064e \u0625\u0650\u0646\u0651\u064e\u0627 \u0646\u064e\u0633\u0652\u062a\u064e\u0639\u0650\u064a\u0646\u064f\u0643\u064e \u0648\u064e\u0646\u064e\u0633\u0652\u062a\u064e\u063a\u0652\u0641\u0650\u0631\u064f\u0643\u064e \u0648\u064e\u0646\u064f\u0624\u0652\u0645\u0650\u0646\u064f \u0628\u0650\u0643\u064e \u0648\u064e\u0646\u064e\u062a\u064e\u0648\u064e\u0643\u0651\u064e\u0644\u064f \u0639\u064e\u0644\u064e\u064a\u0652\u0643\u064e \u0648\u064e\u0646\u064f\u062b\u0652\u0646\u0650\u064a \u0639\u064e\u0644\u064e\u064a\u0652\u0643\u064e \u0627\u0644\u0652\u062e\u064e\u064a\u0652\u0631\u064e \u0643\u064f\u0644\u0651\u064e\u0647\u064f \u0648\u064e\u0646\u064e\u0634\u0652\u0643\u064f\u0631\u064f\u0643\u064e \u0648\u064e\u0644\u064e\u0627 \u0646\u064e\u0643\u0652\u0641\u064f\u0631\u064f\u0643\u064e \u0648\u064e\u0646\u064e\u062e\u0652\u0644\u064e\u0639\u064f \u0648\u064e\u0646\u064e\u062a\u0652\u0631\u064f\u0643\u064f \u0645\u064e\u0646\u0652 \u064a\u064e\u0641\u0652\u062c\u064f\u0631\u064f\u0643\u064e';

class QunutScreen extends StatelessWidget {
  const QunutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('qunutDuas'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)), centerTitle: true),
      body: ListView(padding: const EdgeInsets.fromLTRB(20, 0, 20, 32), children: [
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: p.accent.withOpacity(0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: p.accent.withOpacity(0.2))),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.info_outline, color: p.accent, size: 18), const SizedBox(width: 10),
            Expanded(child: Text(l10n.translate('qunutInfo'), style: TextStyle(fontSize: 12, color: p.muted, height: 1.5)))])),
        const SizedBox(height: 20),
        _duaCard(p, l10n, l10n.translate('qunutDua1Title'), _qunutDua1, 'qunutDua1Trans'),
        const SizedBox(height: 16),
        _duaCard(p, l10n, l10n.translate('qunutDua2Title'), _qunutDua2, 'qunutDua2Trans'),
      ]),
    );
  }

  Widget _duaCard(_P p, AppLocalizations l10n, String title, String arabic, String transKey) => Container(
    padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: p.gold.withOpacity(0.3))),
    child: Column(children: [
      Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: p.gold)),
      const SizedBox(height: 14),
      Text(arabic, textDirection: TextDirection.rtl, textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: p.fg, height: 1.9)),
      const SizedBox(height: 14),
      Divider(color: p.divider),
      const SizedBox(height: 10),
      Text(l10n.translate(transKey), textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: p.muted, fontStyle: FontStyle.italic, height: 1.5)),
      const SizedBox(height: 10),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        IconButton(onPressed: () { Clipboard.setData(ClipboardData(text: '$arabic\n\n${l10n.translate(transKey)}')); }, icon: Icon(Icons.copy, size: 18, color: p.muted)),
        IconButton(onPressed: () => Share.share('$arabic\n\n${l10n.translate(transKey)}\n\nIslamic Companion App'), icon: Icon(Icons.share_outlined, size: 18, color: p.muted)),
      ]),
    ]),
  );
}
