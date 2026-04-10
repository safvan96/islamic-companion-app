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

class _WuduStep {
  final IconData icon;
  final String titleKey, descKey;
  final int times;
  const _WuduStep(this.icon, this.titleKey, this.descKey, this.times);
}

const _steps = [
  _WuduStep(Icons.front_hand, 'wudu_s1_title', 'wudu_s1_desc', 0),
  _WuduStep(Icons.water_drop, 'wudu_s2_title', 'wudu_s2_desc', 3),
  _WuduStep(Icons.water, 'wudu_s3_title', 'wudu_s3_desc', 3),
  _WuduStep(Icons.face, 'wudu_s4_title', 'wudu_s4_desc', 3),
  _WuduStep(Icons.back_hand, 'wudu_s5_title', 'wudu_s5_desc', 3),
  _WuduStep(Icons.person, 'wudu_s6_title', 'wudu_s6_desc', 1),
  _WuduStep(Icons.hearing, 'wudu_s7_title', 'wudu_s7_desc', 1),
  _WuduStep(Icons.do_not_step, 'wudu_s8_title', 'wudu_s8_desc', 3),
  _WuduStep(Icons.check_circle, 'wudu_s9_title', 'wudu_s9_desc', 0),
];

class WuduScreen extends StatelessWidget {
  const WuduScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('wuduGuide'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          // Dua before wudu
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: p.accent.withOpacity(0.08), borderRadius: BorderRadius.circular(14),
              border: Border.all(color: p.accent.withOpacity(0.2)),
            ),
            child: Column(children: [
              Text(l10n.translate('wuduDuaBefore'), style: TextStyle(fontSize: 11, color: p.accent, fontWeight: FontWeight.w600, letterSpacing: 1.0)),
              const SizedBox(height: 8),
              Text('بِسْمِ اللّٰهِ', textDirection: TextDirection.rtl, style: TextStyle(fontSize: 24, color: p.fg)),
              const SizedBox(height: 4),
              Text('Bismillah', style: TextStyle(fontSize: 12, color: p.muted, fontStyle: FontStyle.italic)),
            ]),
          ),
          const SizedBox(height: 20),
          // Steps
          ...List.generate(_steps.length, (i) {
            final s = _steps[i];
            final isLast = i == _steps.length - 1;
            return IntrinsicHeight(child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(width: 40, child: Column(children: [
                Container(width: 32, height: 32,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: p.accent.withOpacity(0.15), border: Border.all(color: p.accent, width: 1.5)),
                  child: Center(child: Text('${i + 1}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: p.accent)))),
                if (!isLast) Expanded(child: Container(width: 2, margin: const EdgeInsets.symmetric(vertical: 4), color: p.divider)),
              ])),
              const SizedBox(width: 10),
              Expanded(child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: p.divider)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Icon(s.icon, size: 18, color: p.accent),
                    const SizedBox(width: 8),
                    Expanded(child: Text(l10n.translate(s.titleKey), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: p.fg))),
                    if (s.times > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: p.gold.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                        child: Text('x${s.times}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: p.gold)),
                      ),
                  ]),
                  const SizedBox(height: 6),
                  Text(l10n.translate(s.descKey), style: TextStyle(fontSize: 12, color: p.muted, height: 1.5)),
                ]),
              )),
            ]));
          }),
          const SizedBox(height: 12),
          // Dua after wudu
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: p.gold.withOpacity(0.08), borderRadius: BorderRadius.circular(14),
              border: Border.all(color: p.gold.withOpacity(0.2)),
            ),
            child: Column(children: [
              Text(l10n.translate('wuduDuaAfter'), style: TextStyle(fontSize: 11, color: p.gold, fontWeight: FontWeight.w600, letterSpacing: 1.0)),
              const SizedBox(height: 8),
              Text('أَشْهَدُ أَنْ لَا إِلٰهَ إِلَّا اللّٰهُ وَحْدَهُ لَا شَرِيكَ لَهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ',
                textDirection: TextDirection.rtl, textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: p.fg, height: 1.8)),
              const SizedBox(height: 8),
              Text(l10n.translate('wuduDuaAfterTranslation'), textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: p.muted, fontStyle: FontStyle.italic, height: 1.4)),
            ]),
          ),
        ],
      ),
    );
  }
}
