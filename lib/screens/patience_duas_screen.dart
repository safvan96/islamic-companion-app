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

class _Dua {
  final String arabic, translationKey, contextKey;
  const _Dua(this.arabic, this.translationKey, this.contextKey);
}

const _duas = [
  _Dua('إِنَّا لِلّٰهِ وَإِنَّا إِلَيْهِ رَاجِعُونَ ۝ اللَّهُمَّ أْجُرْنِي فِي مُصِيبَتِي وَأَخْلِفْ لِي خَيْرًا مِنْهَا', 'patience_d1', 'patience_c1'),
  _Dua('اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحُزْنِ', 'patience_d2', 'patience_c2'),
  _Dua('حَسْبُنَا اللّٰهُ وَنِعْمَ الْوَكِيلُ', 'patience_d3', 'patience_c3'),
  _Dua('لَا إِلٰهَ إِلَّا أَنتَ سُبْحَانَكَ إِنِّي كُنتُ مِنَ الظَّالِمِينَ', 'patience_d4', 'patience_c4'),
  _Dua('رَبَّنَا أَفْرِغْ عَلَيْنَا صَبْرًا وَثَبِّتْ أَقْدَامَنَا وَانصُرْنَا عَلَى الْقَوْمِ الْكَافِرِينَ', 'patience_d5', 'patience_c5'),
  _Dua('اللَّهُمَّ لَا سَهْلَ إِلَّا مَا جَعَلْتَهُ سَهْلًا وَأَنْتَ تَجْعَلُ الْحَزْنَ إِذَا شِئْتَ سَهْلًا', 'patience_d6', 'patience_c6'),
  _Dua('رَبِّ إِنِّي مَسَّنِيَ الضُّرُّ وَأَنتَ أَرْحَمُ الرَّاحِمِينَ', 'patience_d7', 'patience_c7'),
  _Dua('يَا حَيُّ يَا قَيُّومُ بِرَحْمَتِكَ أَسْتَغِيثُ', 'patience_d8', 'patience_c8'),
];

class PatienceDuasScreen extends StatelessWidget {
  const PatienceDuasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('patienceDuas'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: p.accent.withOpacity(0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: p.accent.withOpacity(0.2))),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.favorite, color: p.accent, size: 18),
              const SizedBox(width: 10),
              Expanded(child: Text(l10n.translate('patienceInfo'), style: TextStyle(fontSize: 12, color: p.muted, height: 1.5))),
            ]),
          ),
          const SizedBox(height: 16),
          ..._duas.map((d) => Container(
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
          )),
        ],
      ),
    );
  }
}
