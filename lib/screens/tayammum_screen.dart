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

class TayammumScreen extends StatelessWidget {
  const TayammumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;

    final when = ['tayammum_w1', 'tayammum_w2', 'tayammum_w3'];
    final steps = [
      {'icon': Icons.front_hand, 'key': 'tayammum_s1'},
      {'icon': Icons.landscape, 'key': 'tayammum_s2'},
      {'icon': Icons.face, 'key': 'tayammum_s3'},
      {'icon': Icons.back_hand, 'key': 'tayammum_s4'},
    ];

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('tayammumGuide'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          // Quran verse
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: p.accent.withOpacity(0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: p.accent.withOpacity(0.2))),
            child: Column(children: [
              Text('فَتَيَمَّمُوا صَعِيدًا طَيِّبًا فَامْسَحُوا بِوُجُوهِكُمْ وَأَيْدِيكُم مِّنْهُ',
                textDirection: TextDirection.rtl, textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: p.fg, height: 1.8)),
              const SizedBox(height: 8),
              Text(l10n.translate('tayammumVerse'), textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: p.muted, fontStyle: FontStyle.italic)),
              Text('— Quran 5:6', style: TextStyle(fontSize: 11, color: p.gold, fontWeight: FontWeight.w600)),
            ]),
          ),
          const SizedBox(height: 20),

          // When to perform
          Text(l10n.translate('whenTayammum').toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: p.muted, letterSpacing: 1.4)),
          const SizedBox(height: 10),
          ...when.map((k) => Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: p.divider)),
            child: Row(children: [
              Icon(Icons.info_outline, size: 16, color: p.gold),
              const SizedBox(width: 10),
              Expanded(child: Text(l10n.translate(k), style: TextStyle(fontSize: 13, color: p.fg, height: 1.4))),
            ]),
          )),
          const SizedBox(height: 20),

          // Steps
          Text(l10n.translate('steps').toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: p.muted, letterSpacing: 1.4)),
          const SizedBox(height: 12),
          ...List.generate(steps.length, (i) {
            final s = steps[i];
            final isLast = i == steps.length - 1;
            return IntrinsicHeight(child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(width: 36, child: Column(children: [
                Container(width: 28, height: 28, decoration: BoxDecoration(shape: BoxShape.circle, color: p.accent.withOpacity(0.15), border: Border.all(color: p.accent, width: 1.5)),
                  child: Center(child: Text('${i + 1}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: p.accent)))),
                if (!isLast) Expanded(child: Container(width: 2, margin: const EdgeInsets.symmetric(vertical: 4), color: p.divider)),
              ])),
              const SizedBox(width: 10),
              Expanded(child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: p.divider)),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Icon(s['icon'] as IconData, size: 18, color: p.accent),
                  const SizedBox(width: 10),
                  Expanded(child: Text(l10n.translate(s['key'] as String), style: TextStyle(fontSize: 13, color: p.fg, height: 1.5))),
                ]),
              )),
            ]));
          }),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: p.gold.withOpacity(0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: p.gold.withOpacity(0.2))),
            child: Row(children: [
              Icon(Icons.lightbulb_outline, size: 16, color: p.gold),
              const SizedBox(width: 10),
              Expanded(child: Text(l10n.translate('tayammumNote'), style: TextStyle(fontSize: 12, color: p.muted, height: 1.4))),
            ]),
          ),
        ],
      ),
    );
  }
}
