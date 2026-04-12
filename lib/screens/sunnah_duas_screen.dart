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

class _SunnahDua {
  final String arabic, contextKey, translationKey;
  const _SunnahDua(this.arabic, this.contextKey, this.translationKey);
}

const _duas = [
  _SunnahDua('\u0628\u0650\u0633\u0652\u0645\u0650 \u0627\u0644\u0644\u0651\u064e\u0647\u0650 \u0627\u0644\u0631\u0651\u064e\u062d\u0652\u0645\u064e\u0646\u0650 \u0627\u0644\u0631\u0651\u064e\u062d\u0650\u064a\u0645\u0650', 'sunnah_c1', 'sunnah_d1'),
  _SunnahDua('\u0627\u0644\u0644\u0651\u064e\u0647\u064f\u0645\u0651\u064e \u0628\u064e\u0627\u0631\u0650\u0643\u0652 \u0644\u064e\u0646\u064e\u0627 \u0641\u0650\u064a\u0645\u064e\u0627 \u0631\u064e\u0632\u064e\u0642\u0652\u062a\u064e\u0646\u064e\u0627 \u0648\u064e\u0642\u0650\u0646\u064e\u0627 \u0639\u064e\u0630\u064e\u0627\u0628\u064e \u0627\u0644\u0646\u0651\u064e\u0627\u0631\u0650', 'sunnah_c2', 'sunnah_d2'),
  _SunnahDua('\u0627\u0644\u0644\u0651\u064e\u0647\u064f\u0645\u0651\u064e \u0625\u0650\u0646\u0651\u0650\u064a \u0623\u064e\u0633\u0652\u0623\u064e\u0644\u064f\u0643\u064e \u0639\u0650\u0644\u0652\u0645\u064b\u0627 \u0646\u064e\u0627\u0641\u0650\u0639\u064b\u0627 \u0648\u064e\u0631\u0650\u0632\u0652\u0642\u064b\u0627 \u0637\u064e\u064a\u0651\u0650\u0628\u064b\u0627 \u0648\u064e\u0639\u064e\u0645\u064e\u0644\u064b\u0627 \u0645\u064f\u062a\u064e\u0642\u064e\u0628\u0651\u064e\u0644\u064b\u0627', 'sunnah_c3', 'sunnah_d3'),
  _SunnahDua('\u0628\u0650\u0633\u0652\u0645\u0650 \u0627\u0644\u0644\u0651\u064e\u0647\u0650 \u062a\u064e\u0648\u064e\u0643\u0651\u064e\u0644\u0652\u062a\u064f \u0639\u064e\u0644\u064e\u0649 \u0627\u0644\u0644\u0651\u064e\u0647\u0650 \u0648\u064e\u0644\u064e\u0627 \u062d\u064e\u0648\u0652\u0644\u064e \u0648\u064e\u0644\u064e\u0627 \u0642\u064f\u0648\u0651\u064e\u0629\u064e \u0625\u0650\u0644\u0651\u064e\u0627 \u0628\u0650\u0627\u0644\u0644\u0651\u064e\u0647\u0650', 'sunnah_c4', 'sunnah_d4'),
  _SunnahDua('\u0627\u0644\u0644\u0651\u064e\u0647\u064f\u0645\u0651\u064e \u0625\u0650\u0646\u0651\u0650\u064a \u0623\u064e\u0639\u064f\u0648\u0630\u064f \u0628\u0650\u0643\u064e \u0645\u0650\u0646\u064e \u0627\u0644\u0652\u0643\u064e\u0633\u064e\u0644\u0650 \u0648\u064e\u0627\u0644\u0652\u0647\u064e\u0631\u064e\u0645\u0650', 'sunnah_c5', 'sunnah_d5'),
  _SunnahDua('\u0627\u0644\u0644\u0651\u064e\u0647\u064f\u0645\u0651\u064e \u0627\u062c\u0652\u0639\u064e\u0644\u0652 \u0641\u0650\u064a \u0642\u064e\u0644\u0652\u0628\u0650\u064a \u0646\u064f\u0648\u0631\u064b\u0627', 'sunnah_c6', 'sunnah_d6'),
  _SunnahDua('\u0631\u064e\u0628\u0651\u064e\u0646\u064e\u0627 \u0647\u064e\u0628\u0652 \u0644\u064e\u0646\u064e\u0627 \u0645\u0650\u0646\u0652 \u0623\u064e\u0632\u0652\u0648\u064e\u0627\u062c\u0650\u0646\u064e\u0627 \u0648\u064e\u0630\u064f\u0631\u0651\u0650\u064a\u0651\u064e\u0627\u062a\u0650\u0646\u064e\u0627 \u0642\u064f\u0631\u0651\u064e\u0629\u064e \u0623\u064e\u0639\u0652\u064a\u064f\u0646\u064d', 'sunnah_c7', 'sunnah_d7'),
  _SunnahDua('\u0627\u0644\u0644\u0651\u064e\u0647\u064f\u0645\u0651\u064e \u0623\u064e\u0639\u0650\u0646\u0651\u0650\u064a \u0639\u064e\u0644\u064e\u0649 \u0630\u0650\u0643\u0652\u0631\u0650\u0643\u064e \u0648\u064e\u0634\u064f\u0643\u0652\u0631\u0650\u0643\u064e \u0648\u064e\u062d\u064f\u0633\u0652\u0646\u0650 \u0639\u0650\u0628\u064e\u0627\u062f\u064e\u062a\u0650\u0643\u064e', 'sunnah_c8', 'sunnah_d8'),
  _SunnahDua('\u0627\u0644\u0644\u0651\u064e\u0647\u064f\u0645\u0651\u064e \u0625\u0650\u0646\u0651\u0650\u064a \u0623\u064e\u0633\u0652\u0623\u064e\u0644\u064f\u0643\u064e \u0627\u0644\u0652\u0639\u064e\u0641\u0652\u0648\u064e \u0648\u064e\u0627\u0644\u0652\u0639\u064e\u0627\u0641\u0650\u064a\u064e\u0629\u064e', 'sunnah_c9', 'sunnah_d9'),
  _SunnahDua('\u0627\u0644\u0644\u0651\u064e\u0647\u064f\u0645\u0651\u064e \u0627\u062c\u0652\u0639\u064e\u0644\u0652\u0646\u0650\u064a \u0645\u0650\u0646\u064e \u0627\u0644\u062a\u0651\u064e\u0648\u0651\u064e\u0627\u0628\u0650\u064a\u0646\u064e \u0648\u064e\u0627\u062c\u0652\u0639\u064e\u0644\u0652\u0646\u0650\u064a \u0645\u0650\u0646\u064e \u0627\u0644\u0652\u0645\u064f\u062a\u064e\u0637\u064e\u0647\u0651\u0650\u0631\u0650\u064a\u0646\u064e', 'sunnah_c10', 'sunnah_d10'),
];

class SunnahDuasScreen extends StatelessWidget {
  const SunnahDuasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('sunnahDuas'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)), centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        itemCount: _duas.length,
        itemBuilder: (_, i) {
          final d = _duas[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: p.divider)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: p.gold.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                child: Text(l10n.translate(d.contextKey), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: p.gold))),
              const SizedBox(height: 12),
              Text(d.arabic, textDirection: TextDirection.rtl, textAlign: TextAlign.center, style: TextStyle(fontSize: 20, color: p.fg, height: 1.8)),
              const SizedBox(height: 10),
              Text(l10n.translate(d.translationKey), style: TextStyle(fontSize: 12, color: p.muted, fontStyle: FontStyle.italic, height: 1.4)),
              const SizedBox(height: 8),
              Row(children: [
                GestureDetector(onTap: () { Clipboard.setData(ClipboardData(text: '${d.arabic}\n\n${l10n.translate(d.translationKey)}')); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.translate('copied')), duration: const Duration(seconds: 1))); },
                  child: Icon(Icons.copy, size: 16, color: p.muted)),
                const SizedBox(width: 16),
                GestureDetector(onTap: () => Share.share('${d.arabic}\n\n${l10n.translate(d.translationKey)}\n\nIslamic Companion App'),
                  child: Icon(Icons.share_outlined, size: 16, color: p.muted)),
              ]),
            ]),
          );
        },
      ),
    );
  }
}
