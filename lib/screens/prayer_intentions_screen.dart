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

const _intentions = [
  ('pi_fajr', 'pi_fajr_ar', Icons.wb_twilight, 2),
  ('pi_dhuhr', 'pi_dhuhr_ar', Icons.wb_sunny, 4),
  ('pi_asr', 'pi_asr_ar', Icons.sunny_snowing, 4),
  ('pi_maghrib', 'pi_maghrib_ar', Icons.nights_stay_outlined, 3),
  ('pi_isha', 'pi_isha_ar', Icons.dark_mode_outlined, 4),
  ('pi_witr', 'pi_witr_ar', Icons.auto_awesome, 3),
  ('pi_tarawih', 'pi_tarawih_ar', Icons.nightlight, 2),
  ('pi_jumuah', 'pi_jumuah_ar', Icons.mosque, 2),
];

class PrayerIntentionsScreen extends StatelessWidget {
  const PrayerIntentionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('prayerIntentions'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)), centerTitle: true),
      body: ListView(padding: const EdgeInsets.fromLTRB(20, 0, 20, 32), children: [
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: p.accent.withOpacity(0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: p.accent.withOpacity(0.2))),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.info_outline, color: p.accent, size: 18), const SizedBox(width: 10),
            Expanded(child: Text(l10n.translate('piInfo'), style: TextStyle(fontSize: 12, color: p.muted, height: 1.5)))])),
        const SizedBox(height: 16),
        ..._intentions.map((i) {
          final (nameKey, arabicKey, icon, rakat) = i;
          return Container(
            margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: p.divider)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(width: 36, height: 36, decoration: BoxDecoration(shape: BoxShape.circle, color: p.gold.withOpacity(0.12)),
                  child: Icon(icon, size: 18, color: p.gold)),
                const SizedBox(width: 12),
                Expanded(child: Text(l10n.translate(nameKey), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: p.fg))),
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: p.accent.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                  child: Text('$rakat ${l10n.translate('rakatGuide').split(' ').first}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: p.accent))),
              ]),
              const SizedBox(height: 10),
              Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: p.bg, borderRadius: BorderRadius.circular(10)),
                child: Text(l10n.translate(arabicKey), textDirection: TextDirection.rtl, textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: p.fg, height: 1.6))),
            ]),
          );
        }),
      ]),
    );
  }
}
