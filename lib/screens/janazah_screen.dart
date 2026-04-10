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

class JanazahScreen extends StatelessWidget {
  const JanazahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;

    final steps = [
      {'icon': Icons.water_drop, 'title': 'janazah_s1_title', 'desc': 'janazah_s1_desc'},
      {'icon': Icons.checkroom, 'title': 'janazah_s2_title', 'desc': 'janazah_s2_desc'},
      {'icon': Icons.groups, 'title': 'janazah_s3_title', 'desc': 'janazah_s3_desc'},
      {'icon': Icons.mosque, 'title': 'janazah_s4_title', 'desc': 'janazah_s4_desc'},
    ];

    final takbirs = [
      {'num': '1', 'title': 'janazah_t1_title', 'desc': 'janazah_t1_desc', 'arabic': 'اللّٰهُ أَكْبَرُ'},
      {'num': '2', 'title': 'janazah_t2_title', 'desc': 'janazah_t2_desc', 'arabic': 'اللّٰهُ أَكْبَرُ'},
      {'num': '3', 'title': 'janazah_t3_title', 'desc': 'janazah_t3_desc', 'arabic': 'اللّٰهُ أَكْبَرُ'},
      {'num': '4', 'title': 'janazah_t4_title', 'desc': 'janazah_t4_desc', 'arabic': 'اللّٰهُ أَكْبَرُ'},
    ];

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('janazahGuide'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          // Preparation steps
          Text(l10n.translate('preparation').toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: p.muted, letterSpacing: 1.4)),
          const SizedBox(height: 12),
          ...List.generate(steps.length, (i) {
            final s = steps[i];
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: p.divider)),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(width: 32, height: 32, decoration: BoxDecoration(shape: BoxShape.circle, color: p.accent.withOpacity(0.12)),
                  child: Icon(s['icon'] as IconData, size: 16, color: p.accent)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(l10n.translate(s['title'] as String), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: p.fg)),
                  const SizedBox(height: 4),
                  Text(l10n.translate(s['desc'] as String), style: TextStyle(fontSize: 12, color: p.muted, height: 1.5)),
                ])),
              ]),
            );
          }),
          const SizedBox(height: 24),

          // Prayer (4 Takbirs)
          Text(l10n.translate('janazahPrayer').toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: p.muted, letterSpacing: 1.4)),
          const SizedBox(height: 12),
          ...List.generate(takbirs.length, (i) {
            final t = takbirs[i];
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: p.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: p.gold.withOpacity(0.3)),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(
                    width: 28, height: 28,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: p.gold.withOpacity(0.15), border: Border.all(color: p.gold, width: 1.5)),
                    child: Center(child: Text(t['num']!, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: p.gold))),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(l10n.translate(t['title']!), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: p.fg))),
                  Text(t['arabic']!, textDirection: TextDirection.rtl, style: TextStyle(fontSize: 16, color: p.gold)),
                ]),
                const SizedBox(height: 10),
                Text(l10n.translate(t['desc']!), style: TextStyle(fontSize: 12, color: p.muted, height: 1.5)),
              ]),
            );
          }),
          const SizedBox(height: 12),
          // Salam
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: p.accent.withOpacity(0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: p.accent.withOpacity(0.2))),
            child: Row(children: [
              Icon(Icons.check_circle, color: p.accent, size: 18),
              const SizedBox(width: 10),
              Expanded(child: Text(l10n.translate('janazahSalam'), style: TextStyle(fontSize: 13, color: p.fg, height: 1.4))),
            ]),
          ),
        ],
      ),
    );
  }
}
