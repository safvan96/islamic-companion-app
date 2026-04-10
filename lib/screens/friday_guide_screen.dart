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

class _Step {
  final String key;
  final IconData icon;
  const _Step(this.key, this.icon);
}

const _steps = [
  _Step('fg_1', Icons.shower),           // Ghusl
  _Step('fg_2', Icons.access_time),      // Early arrival
  _Step('fg_3', Icons.favorite),         // Salawat
  _Step('fg_4', Icons.menu_book),        // Surah Al-Kahf
  _Step('fg_5', Icons.front_hand),       // Dua between Asr-Maghrib
  _Step('fg_6', Icons.mosque),           // Jumu'ah prayer
];

class FridayGuideScreen extends StatelessWidget {
  const FridayGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('fridayGuide'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        itemCount: _steps.length,
        itemBuilder: (_, i) {
          final step = _steps[i];
          final isLast = i == _steps.length - 1;
          return IntrinsicHeight(
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Column(children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: p.gold.withOpacity(0.15), border: Border.all(color: p.gold.withOpacity(0.4))),
                  child: Center(child: Icon(step.icon, size: 18, color: p.gold)),
                ),
                if (!isLast) Expanded(child: Container(width: 2, color: p.divider)),
              ]),
              const SizedBox(width: 14),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: p.divider)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: p.accent.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                      child: Text('${i + 1}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: p.accent)),
                    ),
                    const SizedBox(height: 8),
                    Text(l10n.translate(step.key), style: TextStyle(fontSize: 13, color: p.fg, height: 1.5)),
                  ]),
                ),
              ),
            ]),
          );
        },
      ),
    );
  }
}
