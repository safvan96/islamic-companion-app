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
  ('\u0631\u064e\u0628\u0651\u064e\u0646\u064e\u0627 \u062a\u064e\u0642\u064e\u0628\u0651\u064e\u0644\u0652 \u0645\u0650\u0646\u0651\u064e\u0627 \u0625\u0650\u0646\u0651\u064e\u0643\u064e \u0623\u064e\u0646\u062a\u064e \u0627\u0644\u0633\u0651\u064e\u0645\u0650\u064a\u0639\u064f \u0627\u0644\u0652\u0639\u064e\u0644\u0650\u064a\u0645\u064f', 'rb_1', '2:127'),
  ('\u0631\u064e\u0628\u0651\u064e\u0646\u064e\u0627 \u0622\u062a\u0650\u0646\u064e\u0627 \u0641\u0650\u064a \u0627\u0644\u062f\u0651\u064f\u0646\u0652\u064a\u064e\u0627 \u062d\u064e\u0633\u064e\u0646\u064e\u0629\u064b \u0648\u064e\u0641\u0650\u064a \u0627\u0644\u0652\u0622\u062e\u0650\u0631\u064e\u0629\u0650 \u062d\u064e\u0633\u064e\u0646\u064e\u0629\u064b \u0648\u064e\u0642\u0650\u0646\u064e\u0627 \u0639\u064e\u0630\u064e\u0627\u0628\u064e \u0627\u0644\u0646\u0651\u064e\u0627\u0631\u0650', 'rb_2', '2:201'),
  ('\u0631\u064e\u0628\u0651\u064e\u0646\u064e\u0627 \u0623\u064e\u0641\u0652\u0631\u0650\u063a\u0652 \u0639\u064e\u0644\u064e\u064a\u0652\u0646\u064e\u0627 \u0635\u064e\u0628\u0652\u0631\u064b\u0627 \u0648\u064e\u062b\u064e\u0628\u0651\u0650\u062a\u0652 \u0623\u064e\u0642\u0652\u062f\u064e\u0627\u0645\u064e\u0646\u064e\u0627', 'rb_3', '2:250'),
  ('\u0631\u064e\u0628\u0651\u064e\u0646\u064e\u0627 \u0644\u064e\u0627 \u062a\u064f\u0624\u064e\u0627\u062e\u0650\u0630\u0652\u0646\u064e\u0627 \u0625\u0650\u0646 \u0646\u0651\u064e\u0633\u0650\u064a\u0646\u064e\u0627 \u0623\u064e\u0648\u0652 \u0623\u064e\u062e\u0652\u0637\u064e\u0623\u0652\u0646\u064e\u0627', 'rb_4', '2:286'),
  ('\u0631\u064e\u0628\u0651\u064e\u0646\u064e\u0627 \u0644\u064e\u0627 \u062a\u064f\u0632\u0650\u063a\u0652 \u0642\u064f\u0644\u064f\u0648\u0628\u064e\u0646\u064e\u0627 \u0628\u064e\u0639\u0652\u062f\u064e \u0625\u0650\u0630\u0652 \u0647\u064e\u062f\u064e\u064a\u0652\u062a\u064e\u0646\u064e\u0627', 'rb_5', '3:8'),
  ('\u0631\u064e\u0628\u0651\u064e\u0646\u064e\u0627 \u0638\u064e\u0644\u064e\u0645\u0652\u0646\u064e\u0627 \u0623\u064e\u0646\u0641\u064f\u0633\u064e\u0646\u064e\u0627 \u0648\u064e\u0625\u0650\u0646 \u0644\u0651\u064e\u0645\u0652 \u062a\u064e\u063a\u0652\u0641\u0650\u0631\u0652 \u0644\u064e\u0646\u064e\u0627 \u0648\u064e\u062a\u064e\u0631\u0652\u062d\u064e\u0645\u0652\u0646\u064e\u0627 \u0644\u064e\u0646\u064e\u0643\u064f\u0648\u0646\u064e\u0646\u0651\u064e \u0645\u0650\u0646\u064e \u0627\u0644\u0652\u062e\u064e\u0627\u0633\u0650\u0631\u0650\u064a\u0646\u064e', 'rb_6', '7:23'),
  ('\u0631\u064e\u0628\u0651\u064e\u0646\u064e\u0627 \u0627\u063a\u0652\u0641\u0650\u0631\u0652 \u0644\u064e\u0646\u064e\u0627 \u0630\u064f\u0646\u064f\u0648\u0628\u064e\u0646\u064e\u0627 \u0648\u064e\u0625\u0650\u0633\u0652\u0631\u064e\u0627\u0641\u064e\u0646\u064e\u0627 \u0641\u0650\u064a \u0623\u064e\u0645\u0652\u0631\u0650\u0646\u064e\u0627', 'rb_7', '3:147'),
  ('\u0631\u064e\u0628\u0651\u064e\u0646\u064e\u0627 \u0647\u064e\u0628\u0652 \u0644\u064e\u0646\u064e\u0627 \u0645\u0650\u0646\u0652 \u0623\u064e\u0632\u0652\u0648\u064e\u0627\u062c\u0650\u0646\u064e\u0627 \u0648\u064e\u0630\u064f\u0631\u0651\u0650\u064a\u0651\u064e\u0627\u062a\u0650\u0646\u064e\u0627 \u0642\u064f\u0631\u0651\u064e\u0629\u064e \u0623\u064e\u0639\u0652\u064a\u064f\u0646\u064d', 'rb_8', '25:74'),
];

class RabbanaScreen extends StatelessWidget {
  const RabbanaScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('rabbanaDuas'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)), centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        itemCount: _duas.length,
        itemBuilder: (_, i) {
          final (arabic, transKey, ref) = _duas[i];
          return Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: p.divider)),
            child: Column(children: [
              Row(children: [
                Container(width: 28, height: 28, decoration: BoxDecoration(shape: BoxShape.circle, color: p.gold.withOpacity(0.15)),
                  child: Center(child: Text('${i + 1}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: p.gold)))),
                const Spacer(),
                Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: p.accent.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                  child: Text(ref, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: p.accent))),
              ]),
              const SizedBox(height: 12),
              Text(arabic, textDirection: TextDirection.rtl, textAlign: TextAlign.center, style: TextStyle(fontSize: 20, color: p.fg, height: 1.8)),
              const SizedBox(height: 10),
              Text(l10n.translate(transKey), textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: p.muted, fontStyle: FontStyle.italic, height: 1.4)),
              const SizedBox(height: 8),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                GestureDetector(onTap: () { Clipboard.setData(ClipboardData(text: '$arabic\n\n${l10n.translate(transKey)}\n— $ref')); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied'), duration: Duration(seconds: 1))); },
                  child: Icon(Icons.copy, size: 16, color: p.muted)),
                const SizedBox(width: 16),
                GestureDetector(onTap: () => Share.share('$arabic\n\n${l10n.translate(transKey)}\n— Quran $ref\n\nIslamic Companion App'),
                  child: Icon(Icons.share_outlined, size: 16, color: p.muted)),
              ]),
            ]));
        },
      ),
    );
  }
}
