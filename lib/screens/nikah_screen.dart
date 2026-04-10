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

class NikahScreen extends StatelessWidget {
  const NikahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;

    final conditions = [
      {'icon': Icons.check_circle_outline, 'key': 'nikah_c1'},
      {'icon': Icons.check_circle_outline, 'key': 'nikah_c2'},
      {'icon': Icons.check_circle_outline, 'key': 'nikah_c3'},
      {'icon': Icons.check_circle_outline, 'key': 'nikah_c4'},
      {'icon': Icons.check_circle_outline, 'key': 'nikah_c5'},
    ];

    final steps = [
      {'icon': Icons.search, 'key': 'nikah_s1'},
      {'icon': Icons.handshake, 'key': 'nikah_s2'},
      {'icon': Icons.diamond, 'key': 'nikah_s3'},
      {'icon': Icons.groups, 'key': 'nikah_s4'},
      {'icon': Icons.record_voice_over, 'key': 'nikah_s5'},
      {'icon': Icons.celebration, 'key': 'nikah_s6'},
    ];

    final rights = [
      {'icon': Icons.favorite, 'key': 'nikah_r1'},
      {'icon': Icons.balance, 'key': 'nikah_r2'},
      {'icon': Icons.home, 'key': 'nikah_r3'},
      {'icon': Icons.psychology, 'key': 'nikah_r4'},
    ];

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('nikahGuide'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          // Quran verse about marriage
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [p.gold.withOpacity(0.1), p.accent.withOpacity(0.05)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(16), border: Border.all(color: p.gold.withOpacity(0.2)),
            ),
            child: Column(children: [
              Text('وَمِنْ آيَاتِهِ أَنْ خَلَقَ لَكُم مِّنْ أَنفُسِكُمْ أَزْوَاجًا لِّتَسْكُنُوا إِلَيْهَا وَجَعَلَ بَيْنَكُم مَّوَدَّةً وَرَحْمَةً',
                textDirection: TextDirection.rtl, textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: p.fg, height: 1.8)),
              const SizedBox(height: 8),
              Text(l10n.translate('nikahVerse'), textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: p.muted, fontStyle: FontStyle.italic, height: 1.4)),
              const SizedBox(height: 4),
              Text('— Quran 30:21', style: TextStyle(fontSize: 11, color: p.gold, fontWeight: FontWeight.w600)),
            ]),
          ),
          const SizedBox(height: 24),

          // Conditions
          _section(l10n.translate('nikahConditions'), p),
          const SizedBox(height: 10),
          ...conditions.map((c) => _item(c['icon'] as IconData, l10n.translate(c['key'] as String), p, p.accent)),
          const SizedBox(height: 20),

          // Steps
          _section(l10n.translate('nikahSteps'), p),
          const SizedBox(height: 10),
          ...List.generate(steps.length, (i) {
            final s = steps[i];
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: p.divider)),
              child: Row(children: [
                Container(width: 28, height: 28, decoration: BoxDecoration(shape: BoxShape.circle, color: p.gold.withOpacity(0.15)),
                  child: Center(child: Text('${i + 1}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: p.gold)))),
                const SizedBox(width: 10),
                Icon(s['icon'] as IconData, size: 16, color: p.gold),
                const SizedBox(width: 8),
                Expanded(child: Text(l10n.translate(s['key'] as String), style: TextStyle(fontSize: 13, color: p.fg, height: 1.4))),
              ]),
            );
          }),
          const SizedBox(height: 20),

          // Rights & Responsibilities
          _section(l10n.translate('nikahRights'), p),
          const SizedBox(height: 10),
          ...rights.map((r) => _item(r['icon'] as IconData, l10n.translate(r['key'] as String), p, p.gold)),
          const SizedBox(height: 16),

          // Dua
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: p.gold.withOpacity(0.3))),
            child: Column(children: [
              Text(l10n.translate('nikahDuaTitle'), style: TextStyle(fontSize: 11, color: p.gold, fontWeight: FontWeight.w600, letterSpacing: 1.0)),
              const SizedBox(height: 8),
              Text('بَارَكَ اللّٰهُ لَكَ وَبَارَكَ عَلَيْكَ وَجَمَعَ بَيْنَكُمَا فِي خَيْرٍ',
                textDirection: TextDirection.rtl, textAlign: TextAlign.center, style: TextStyle(fontSize: 20, color: p.fg, height: 1.8)),
              const SizedBox(height: 8),
              Text(l10n.translate('nikahDua'), textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: p.muted, fontStyle: FontStyle.italic)),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _section(String text, _P p) => Text(text.toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: p.muted, letterSpacing: 1.4));

  Widget _item(IconData icon, String text, _P p, Color color) => Container(
    margin: const EdgeInsets.only(bottom: 6),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: p.divider)),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, size: 16, color: color),
      const SizedBox(width: 10),
      Expanded(child: Text(text, style: TextStyle(fontSize: 13, color: p.fg, height: 1.4))),
    ]),
  );
}
