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

// Quick overview of all 114 surahs: number, name, ayahs, type, brief theme
class _SurahMeta {
  final int num, ayahs;
  final String name, arabic;
  final bool meccan;
  final String themeKey;
  const _SurahMeta(this.num, this.name, this.arabic, this.ayahs, this.meccan, this.themeKey);
}

// Just 20 most important surahs with themes (the rest show basic info)
const _surahsWithThemes = {
  1: 'si_1', 2: 'si_2', 3: 'si_3', 4: 'si_4', 5: 'si_5',
  12: 'si_12', 18: 'si_18', 19: 'si_19', 36: 'si_36', 55: 'si_55',
  56: 'si_56', 67: 'si_67', 78: 'si_78', 93: 'si_93', 94: 'si_94',
  112: 'si_112', 113: 'si_113', 114: 'si_114',
};

const _allSurahs = [
  _SurahMeta(1,'Al-Fatiha','\u0627\u0644\u0641\u0627\u062a\u062d\u0629',7,true,'si_1'),
  _SurahMeta(2,'Al-Baqarah','\u0627\u0644\u0628\u0642\u0631\u0629',286,false,'si_2'),
  _SurahMeta(3,'Ali Imran','\u0622\u0644 \u0639\u0645\u0631\u0627\u0646',200,false,'si_3'),
  _SurahMeta(4,'An-Nisa','\u0627\u0644\u0646\u0633\u0627\u0621',176,false,'si_4'),
  _SurahMeta(5,'Al-Maidah','\u0627\u0644\u0645\u0627\u0626\u062f\u0629',120,false,'si_5'),
  _SurahMeta(12,'Yusuf','\u064a\u0648\u0633\u0641',111,true,'si_12'),
  _SurahMeta(18,'Al-Kahf','\u0627\u0644\u0643\u0647\u0641',110,true,'si_18'),
  _SurahMeta(19,'Maryam','\u0645\u0631\u064a\u0645',98,true,'si_19'),
  _SurahMeta(36,'Ya-Sin','\u064a\u0633',83,true,'si_36'),
  _SurahMeta(55,'Ar-Rahman','\u0627\u0644\u0631\u062d\u0645\u0646',78,false,'si_55'),
  _SurahMeta(56,'Al-Waqiah','\u0627\u0644\u0648\u0627\u0642\u0639\u0629',96,true,'si_56'),
  _SurahMeta(67,'Al-Mulk','\u0627\u0644\u0645\u0644\u0643',30,true,'si_67'),
  _SurahMeta(78,'An-Naba','\u0627\u0644\u0646\u0628\u0623',40,true,'si_78'),
  _SurahMeta(93,'Ad-Duha','\u0627\u0644\u0636\u062d\u0649',11,true,'si_93'),
  _SurahMeta(94,'Ash-Sharh','\u0627\u0644\u0634\u0631\u062d',8,true,'si_94'),
  _SurahMeta(112,'Al-Ikhlas','\u0627\u0644\u0625\u062e\u0644\u0627\u0635',4,true,'si_112'),
  _SurahMeta(113,'Al-Falaq','\u0627\u0644\u0641\u0644\u0642',5,true,'si_113'),
  _SurahMeta(114,'An-Nas','\u0627\u0644\u0646\u0627\u0633',6,true,'si_114'),
];

class SurahInfoScreen extends StatefulWidget {
  const SurahInfoScreen({super.key});
  @override
  State<SurahInfoScreen> createState() => _SurahInfoScreenState();
}

class _SurahInfoScreenState extends State<SurahInfoScreen> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;
    var list = _allSurahs.toList();
    if (_search.isNotEmpty) {
      final q = _search.toLowerCase();
      list = list.where((s) => s.name.toLowerCase().contains(q) || s.arabic.contains(q) || s.num.toString() == q).toList();
    }

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('surahInfo'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)), centerTitle: true),
      body: Column(children: [
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Container(
          decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: p.divider)),
          child: TextField(onChanged: (v) => setState(() => _search = v), style: TextStyle(color: p.fg, fontSize: 14),
            decoration: InputDecoration(hintText: l10n.translate('searchSurah'), hintStyle: TextStyle(color: p.muted),
              prefixIcon: Icon(Icons.search, color: p.muted, size: 20), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(vertical: 12))))),
        const SizedBox(height: 8),
        Expanded(child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
          itemCount: list.length,
          itemBuilder: (_, i) {
            final s = list[i];
            return _SurahCard(surah: s, p: p, l10n: l10n);
          },
        )),
      ]),
    );
  }
}

class _SurahCard extends StatefulWidget {
  final _SurahMeta surah; final _P p; final AppLocalizations l10n;
  const _SurahCard({required this.surah, required this.p, required this.l10n});
  @override
  State<_SurahCard> createState() => _SurahCardState();
}

class _SurahCardState extends State<_SurahCard> {
  bool _open = false;
  @override
  Widget build(BuildContext context) {
    final p = widget.p; final s = widget.surah; final l10n = widget.l10n;
    final color = s.meccan ? p.gold : p.accent;
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: _open ? color.withOpacity(0.3) : p.divider)),
      child: Column(children: [
        InkWell(onTap: () => setState(() => _open = !_open), borderRadius: BorderRadius.circular(12),
          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), child: Row(children: [
            Container(width: 32, height: 32, decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(0.12)),
              child: Center(child: Text('${s.num}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color)))),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(s.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: p.fg)),
              Row(children: [
                Text(s.arabic, textDirection: TextDirection.rtl, style: TextStyle(fontSize: 12, color: p.gold)),
                const SizedBox(width: 8),
                Text('${s.ayahs} ${l10n.translate('ayahs')}', style: TextStyle(fontSize: 10, color: p.muted)),
              ]),
            ])),
            Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
              child: Text(s.meccan ? l10n.translate('meccan') : l10n.translate('medinan'), style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: color))),
            const SizedBox(width: 4),
            Icon(_open ? Icons.expand_less : Icons.expand_more, color: p.muted, size: 18),
          ]))),
        if (_open) Padding(padding: const EdgeInsets.fromLTRB(54, 0, 12, 12),
          child: Text(l10n.translate(s.themeKey), style: TextStyle(fontSize: 12, color: p.muted, height: 1.5))),
      ]),
    );
  }
}
