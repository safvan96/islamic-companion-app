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

class _Salawat {
  final String arabic, nameKey, descKey;
  const _Salawat(this.arabic, this.nameKey, this.descKey);
}

const _salawats = [
  _Salawat('اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ كَمَا صَلَّيْتَ عَلَى إِبْرَاهِيمَ وَعَلَى آلِ إِبْرَاهِيمَ إِنَّكَ حَمِيدٌ مَجِيدٌ اللَّهُمَّ بَارِكْ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ كَمَا بَارَكْتَ عَلَى إِبْرَاهِيمَ وَعَلَى آلِ إِبْرَاهِيمَ إِنَّكَ حَمِيدٌ مَجِيدٌ', 'salawat_ibrahimiya', 'salawat_ibrahimiya_desc'),
  _Salawat('اللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى نَبِيِّنَا مُحَمَّدٍ', 'salawat_short', 'salawat_short_desc'),
  _Salawat('صَلَّى اللّٰهُ عَلَيْهِ وَسَلَّمَ', 'salawat_saws', 'salawat_saws_desc'),
  _Salawat('اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَأَزْوَاجِهِ وَذُرِّيَّتِهِ كَمَا صَلَّيْتَ عَلَى آلِ إِبْرَاهِيمَ وَبَارِكْ عَلَى مُحَمَّدٍ وَأَزْوَاجِهِ وَذُرِّيَّتِهِ كَمَا بَارَكْتَ عَلَى آلِ إِبْرَاهِيمَ إِنَّكَ حَمِيدٌ مَجِيدٌ', 'salawat_family', 'salawat_family_desc'),
  _Salawat('اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ النَّبِيِّ الْأُمِّيِّ وَعَلَى آلِهِ وَسَلِّمْ تَسْلِيمًا', 'salawat_ummi', 'salawat_ummi_desc'),
  _Salawat('اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ عَبْدِكَ وَرَسُولِكَ كَمَا صَلَّيْتَ عَلَى إِبْرَاهِيمَ وَبَارِكْ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ كَمَا بَارَكْتَ عَلَى إِبْرَاهِيمَ وَآلِ إِبْرَاهِيمَ', 'salawat_abd', 'salawat_abd_desc'),
];

class SalawatScreen extends StatelessWidget {
  const SalawatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('salawatCollection'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          // Verse
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(gradient: LinearGradient(colors: [p.gold.withOpacity(0.1), p.accent.withOpacity(0.05)]), borderRadius: BorderRadius.circular(16), border: Border.all(color: p.gold.withOpacity(0.2))),
            child: Column(children: [
              Text('إِنَّ اللّٰهَ وَمَلَائِكَتَهُ يُصَلُّونَ عَلَى النَّبِيِّ ۚ يَا أَيُّهَا الَّذِينَ آمَنُوا صَلُّوا عَلَيْهِ وَسَلِّمُوا تَسْلِيمًا',
                textDirection: TextDirection.rtl, textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: p.fg, height: 1.8)),
              const SizedBox(height: 8),
              Text(l10n.translate('salawatVerse'), textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: p.muted, fontStyle: FontStyle.italic, height: 1.4)),
              Text('— Quran 33:56', style: TextStyle(fontSize: 11, color: p.gold, fontWeight: FontWeight.w600)),
            ]),
          ),
          const SizedBox(height: 20),
          ..._salawats.map((s) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: p.divider)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l10n.translate(s.nameKey), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: p.gold)),
              const SizedBox(height: 10),
              Text(s.arabic, textDirection: TextDirection.rtl, textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: p.fg, height: 1.8)),
              const SizedBox(height: 10),
              Text(l10n.translate(s.descKey), style: TextStyle(fontSize: 12, color: p.muted, fontStyle: FontStyle.italic, height: 1.4)),
              const SizedBox(height: 8),
              Row(children: [
                GestureDetector(onTap: () { Clipboard.setData(ClipboardData(text: s.arabic)); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.translate('copied')), duration: const Duration(seconds: 1))); },
                  child: Icon(Icons.copy, size: 16, color: p.muted)),
                const SizedBox(width: 16),
                GestureDetector(onTap: () => Share.share('${s.arabic}\n\n${l10n.translate(s.descKey)}\n\nIslamic Companion App'),
                  child: Icon(Icons.share_outlined, size: 16, color: p.muted)),
              ]),
            ]),
          )),
        ],
      ),
    );
  }
}
