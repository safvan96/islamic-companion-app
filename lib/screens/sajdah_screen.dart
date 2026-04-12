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

class _Sajdah {
  final int surah, ayah, juz;
  final String surahName;
  const _Sajdah(this.surah, this.ayah, this.surahName, this.juz);
}

const _sajdahs = [
  _Sajdah(7, 206, 'Al-Araf', 9),
  _Sajdah(13, 15, 'Ar-Rad', 13),
  _Sajdah(16, 50, 'An-Nahl', 14),
  _Sajdah(17, 109, 'Al-Isra', 15),
  _Sajdah(19, 58, 'Maryam', 16),
  _Sajdah(22, 18, 'Al-Hajj', 17),
  _Sajdah(22, 77, 'Al-Hajj', 17),
  _Sajdah(25, 60, 'Al-Furqan', 19),
  _Sajdah(27, 26, 'An-Naml', 19),
  _Sajdah(32, 15, 'As-Sajdah', 21),
  _Sajdah(38, 24, 'Sad', 23),
  _Sajdah(41, 38, 'Fussilat', 24),
  _Sajdah(53, 62, 'An-Najm', 27),
  _Sajdah(84, 21, 'Al-Inshiqaq', 30),
  _Sajdah(96, 19, 'Al-Alaq', 30),
];

class SajdahScreen extends StatelessWidget {
  const SajdahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('sajdahTilawah'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)), centerTitle: true),
      body: ListView(padding: const EdgeInsets.fromLTRB(20, 0, 20, 32), children: [
        // Info
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: p.accent.withOpacity(0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: p.accent.withOpacity(0.2))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Icon(Icons.info_outline, color: p.accent, size: 18), const SizedBox(width: 10),
              Expanded(child: Text(l10n.translate('sajdahInfo'), style: TextStyle(fontSize: 12, color: p.muted, height: 1.5)))]),
            const SizedBox(height: 10),
            Text(l10n.translate('sajdahHow'), style: TextStyle(fontSize: 12, color: p.fg, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(l10n.translate('sajdahHowDesc'), style: TextStyle(fontSize: 12, color: p.muted, height: 1.4)),
          ])),
        const SizedBox(height: 16),

        // Dua
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: p.gold.withOpacity(0.3))),
          child: Column(children: [
            Text(l10n.translate('sajdahDuaLabel').toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: p.gold, letterSpacing: 1.0)),
            const SizedBox(height: 8),
            Text('سَجَدَ وَجْهِيَ لِلَّذ��ي خَلَقَهُ وَشَقَّ سَمْعَهُ وَبَصَرَهُ بِحَوْلِهِ وَقُوَّتِهِ', textDirection: TextDirection.rtl, textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: p.fg, height: 1.8)),
            const SizedBox(height: 8),
            Text(l10n.translate('sajdahDuaTranslation'), textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: p.muted, fontStyle: FontStyle.italic, height: 1.4)),
          ])),
        const SizedBox(height: 20),

        // List
        Text('${_sajdahs.length} ${l10n.translate('sajdahPlaces')}'.toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: p.muted, letterSpacing: 1.4)),
        const SizedBox(height: 10),
        ...List.generate(_sajdahs.length, (i) {
          final s = _sajdahs[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: p.divider)),
            child: Row(children: [
              Container(width: 28, height: 28, decoration: BoxDecoration(shape: BoxShape.circle, color: p.gold.withOpacity(0.15)),
                child: Center(child: Text('${i + 1}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: p.gold)))),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(s.surahName, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: p.fg)),
                Text('${l10n.translate('surahNum')} ${s.surah}, ${l10n.translate('ayahNum')} ${s.ayah}', style: TextStyle(fontSize: 11, color: p.muted)),
              ])),
              Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: p.accent.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                child: Text('${l10n.translate('juz')} ${s.juz}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: p.accent))),
            ]),
          );
        }),
      ]),
    );
  }
}
