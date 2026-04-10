import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

const _letters = [
  ('\u0627', 'Alif', 'a'),    ('\u0628', 'Ba', 'b'),     ('\u062a', 'Ta', 't'),
  ('\u062b', 'Tha', 'th'),    ('\u062c', 'Jim', 'j'),    ('\u062d', 'Ha', 'h'),
  ('\u062e', 'Kha', 'kh'),    ('\u062f', 'Dal', 'd'),    ('\u0630', 'Dhal', 'dh'),
  ('\u0631', 'Ra', 'r'),      ('\u0632', 'Zay', 'z'),    ('\u0633', 'Sin', 's'),
  ('\u0634', 'Shin', 'sh'),   ('\u0635', 'Sad', 's'),    ('\u0636', 'Dad', 'd'),
  ('\u0637', 'Taa', 't'),     ('\u0638', 'Dhaa', 'dh'),  ('\u0639', 'Ayn', 'a'),
  ('\u063a', 'Ghayn', 'gh'),  ('\u0641', 'Fa', 'f'),     ('\u0642', 'Qaf', 'q'),
  ('\u0643', 'Kaf', 'k'),     ('\u0644', 'Lam', 'l'),    ('\u0645', 'Mim', 'm'),
  ('\u0646', 'Nun', 'n'),     ('\u0647', 'Ha', 'h'),     ('\u0648', 'Waw', 'w'),
  ('\u064a', 'Ya', 'y'),
];

class ArabicAlphabetScreen extends StatelessWidget {
  const ArabicAlphabetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('arabicAlphabet'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)), centerTitle: true),
      body: Column(children: [
        Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 8), child: Container(
          padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: p.gold.withOpacity(0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: p.gold.withOpacity(0.2))),
          child: Row(children: [Icon(Icons.info_outline, color: p.gold, size: 16), const SizedBox(width: 8),
            Expanded(child: Text('${_letters.length} ${l10n.translate('lettersTotal')}', style: TextStyle(fontSize: 12, color: p.muted)))]))),
        Expanded(child: GridView.builder(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 0.75),
          itemCount: _letters.length,
          itemBuilder: (_, i) {
            final (arabic, name, sound) = _letters[i];
            return GestureDetector(
              onTap: () => HapticFeedback.lightImpact(),
              child: Container(
                decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: p.divider)),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(arabic, textDirection: TextDirection.rtl, style: TextStyle(fontSize: 36, color: p.gold, height: 1.2)),
                  const SizedBox(height: 4),
                  Text(name, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: p.fg)),
                  Text('/$sound/', style: TextStyle(fontSize: 9, color: p.accent)),
                ]),
              ),
            );
          },
        )),
      ]),
    );
  }
}
