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

class _Verse {
  final String arabic, ref, descKey;
  final int repeat;
  const _Verse(this.arabic, this.ref, this.descKey, {this.repeat = 1});
}

const _verses = [
  _Verse('بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيمِ ۝ الْحَمْدُ لِلّٰهِ رَبِّ الْعَالَمِينَ ۝ الرَّحْمٰنِ الرَّحِيمِ ۝ مَالِكِ يَوْمِ الدِّينِ ۝ إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ ۝ اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ ۝ صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ', '1:1-7', 'ruqyah_fatiha', repeat: 7),
  _Verse('اللّٰهُ لَا إِلٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ ۚ لَّهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ', '2:255', 'ruqyah_kursi'),
  _Verse('آمَنَ الرَّسُولُ بِمَا أُنزِلَ إِلَيْهِ مِن رَّبِّهِ وَالْمُؤْمِنُونَ', '2:285-286', 'ruqyah_baqarah_end'),
  _Verse('قُلْ هُوَ اللّٰهُ أَحَدٌ ۝ اللّٰهُ الصَّمَدُ ۝ لَمْ يَلِدْ وَلَمْ يُولَدْ ۝ وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ', '112:1-4', 'ruqyah_ikhlas', repeat: 3),
  _Verse('قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ ۝ مِن شَرِّ مَا خَلَقَ ۝ وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ ۝ وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ ۝ وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ', '113:1-5', 'ruqyah_falaq', repeat: 3),
  _Verse('قُلْ أَعُوذُ بِرَبِّ النَّاسِ ۝ مَلِكِ النَّاسِ ۝ إِلٰهِ النَّاسِ ۝ مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ ۝ الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ ۝ مِنَ الْجِنَّةِ وَالنَّاسِ', '114:1-6', 'ruqyah_nas', repeat: 3),
  _Verse('وَنُنَزِّلُ مِنَ الْقُرْآنِ مَا هُوَ شِفَاءٌ وَرَحْمَةٌ لِّلْمُؤْمِنِينَ', '17:82', 'ruqyah_shifa'),
  _Verse('وَإِذَا مَرِضْتُ فَهُوَ يَشْفِينِ', '26:80', 'ruqyah_heal'),
  _Verse('بِسْمِ اللّٰهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ', 'Hadith', 'ruqyah_bismillah', repeat: 3),
  _Verse('أَعُوذُ بِكَلِمَاتِ اللّٰهِ التَّامَّاتِ مِن شَرِّ مَا خَلَقَ', 'Hadith', 'ruqyah_kalimat', repeat: 3),
];

class RuqyahScreen extends StatelessWidget {
  const RuqyahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('ruqyahGuide'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: p.accent.withOpacity(0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: p.accent.withOpacity(0.2))),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.healing, color: p.accent, size: 18),
              const SizedBox(width: 10),
              Expanded(child: Text(l10n.translate('ruqyahInfo'), style: TextStyle(fontSize: 12, color: p.muted, height: 1.5))),
            ]),
          ),
          const SizedBox(height: 20),
          ...List.generate(_verses.length, (i) {
            final v = _verses[i];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: p.divider)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: p.gold.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                    child: Text(v.ref, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: p.gold))),
                  if (v.repeat > 1) ...[
                    const SizedBox(width: 8),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3), decoration: BoxDecoration(color: p.accent.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                      child: Text('x${v.repeat}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: p.accent))),
                  ],
                  const Spacer(),
                  GestureDetector(onTap: () => Share.share('${v.arabic}\n\n${l10n.translate(v.descKey)}\n\n— ${v.ref}\n\nIslamic Companion App'),
                    child: Icon(Icons.share_outlined, size: 16, color: p.muted)),
                ]),
                const SizedBox(height: 12),
                Text(v.arabic, textDirection: TextDirection.rtl, textAlign: TextAlign.center, style: TextStyle(fontSize: 20, color: p.fg, height: 1.8)),
                const SizedBox(height: 10),
                Text(l10n.translate(v.descKey), style: TextStyle(fontSize: 12, color: p.muted, fontStyle: FontStyle.italic, height: 1.4)),
              ]),
            );
          }),
        ],
      ),
    );
  }
}
