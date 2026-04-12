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

class _Word {
  final String arabic, translit, meaning;
  final int freq;
  const _Word(this.arabic, this.translit, this.meaning, this.freq);
}

const _words = [
  _Word('\u0627\u0644\u0644\u0647', 'Allah', 'God', 2699),
  _Word('\u0631\u0628', 'Rabb', 'Lord', 970),
  _Word('\u0642\u0627\u0644', 'Qala', 'He said', 529),
  _Word('\u0643\u0627\u0646', 'Kana', 'He was', 358),
  _Word('\u0639\u0644\u0645', 'Ilm', 'Knowledge', 382),
  _Word('\u0623\u0631\u0636', 'Ard', 'Earth', 461),
  _Word('\u0633\u0645\u0627\u0621', 'Sama', 'Sky/Heaven', 310),
  _Word('\u0646\u0627\u0633', 'Nas', 'People', 241),
  _Word('\u064a\u0648\u0645', 'Yawm', 'Day', 405),
  _Word('\u0642\u0644\u0628', 'Qalb', 'Heart', 132),
  _Word('\u0646\u0648\u0631', 'Nur', 'Light', 43),
  _Word('\u062d\u0642', 'Haqq', 'Truth/Right', 227),
  _Word('\u0633\u0628\u064a\u0644', 'Sabil', 'Path/Way', 176),
  _Word('\u0631\u062d\u0645\u0629', 'Rahma', 'Mercy', 114),
  _Word('\u0635\u0644\u0627\u0629', 'Salah', 'Prayer', 67),
  _Word('\u062a\u0642\u0648\u0649', 'Taqwa', 'God-consciousness', 17),
  _Word('\u0635\u0628\u0631', 'Sabr', 'Patience', 43),
  _Word('\u0634\u0643\u0631', 'Shukr', 'Gratitude', 35),
  _Word('\u062a\u0648\u0628\u0629', 'Tawba', 'Repentance', 32),
  _Word('\u062c\u0646\u0629', 'Jannah', 'Paradise', 66),
  _Word('\u0646\u0627\u0631', 'Nar', 'Fire (Hell)', 125),
  _Word('\u0645\u0644\u0643', 'Malik', 'King/Owner', 48),
  _Word('\u0639\u0628\u062f', 'Abd', 'Servant', 152),
  _Word('\u062f\u0639\u0627', 'Dua', 'Supplication', 15),
  _Word('\u0630\u0643\u0631', 'Dhikr', 'Remembrance', 76),
  _Word('\u0622\u064a\u0629', 'Ayah', 'Sign/Verse', 382),
  _Word('\u0643\u062a\u0627\u0628', 'Kitab', 'Book', 230),
  _Word('\u0631\u0633\u0648\u0644', 'Rasul', 'Messenger', 236),
  _Word('\u0645\u0624\u0645\u0646', 'Mumin', 'Believer', 175),
  _Word('\u0643\u0627\u0641\u0631', 'Kafir', 'Disbeliever', 134),
  _Word('\u0638\u0644\u0645', 'Zulm', 'Injustice', 110),
  _Word('\u0639\u062f\u0644', 'Adl', 'Justice', 14),
  _Word('\u062d\u064a\u0627\u0629', 'Hayat', 'Life', 76),
  _Word('\u0645\u0648\u062a', 'Mawt', 'Death', 55),
  _Word('\u0631\u0632\u0642', 'Rizq', 'Provision', 42),
  _Word('\u0641\u0636\u0644', 'Fadl', 'Grace/Bounty', 64),
  _Word('\u0628\u0631\u0643\u0629', 'Baraka', 'Blessing', 32),
  _Word('\u0647\u062f\u0649', 'Huda', 'Guidance', 79),
  _Word('\u0636\u0644\u0627\u0644', 'Dalal', 'Misguidance', 26),
  _Word('\u0623\u062c\u0631', 'Ajr', 'Reward', 78),
];

class QuranWordsScreen extends StatefulWidget {
  const QuranWordsScreen({super.key});
  @override
  State<QuranWordsScreen> createState() => _QuranWordsScreenState();
}

class _QuranWordsScreenState extends State<QuranWordsScreen> {
  String _search = '';
  bool _sortByFreq = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;

    var list = _words.toList();
    if (_search.isNotEmpty) {
      final q = _search.toLowerCase();
      list = list.where((w) => w.translit.toLowerCase().contains(q) || w.meaning.toLowerCase().contains(q) || w.arabic.contains(q)).toList();
    }
    if (_sortByFreq) list.sort((a, b) => b.freq.compareTo(a.freq));

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('quranWords'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(_sortByFreq ? Icons.sort : Icons.sort_by_alpha, color: p.muted, size: 20),
            onPressed: () => setState(() => _sortByFreq = !_sortByFreq)),
        ],
      ),
      body: Column(children: [
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Container(
          decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: p.divider)),
          child: TextField(onChanged: (v) => setState(() => _search = v), style: TextStyle(color: p.fg, fontSize: 14),
            decoration: InputDecoration(hintText: l10n.translate('searchWords'), hintStyle: TextStyle(color: p.muted),
              prefixIcon: Icon(Icons.search, color: p.muted, size: 20), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(vertical: 12))),
        )),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: Text('${list.length} ${l10n.translate('words')}', style: TextStyle(fontSize: 11, color: p.muted))),
        Expanded(child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
          itemCount: list.length,
          itemBuilder: (_, i) {
            final w = list[i];
            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: p.divider)),
              child: Row(children: [
                Text(w.arabic, textDirection: TextDirection.rtl, style: TextStyle(fontSize: 22, color: p.gold)),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(w.translit, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: p.fg)),
                  Text(w.meaning, style: TextStyle(fontSize: 11, color: p.muted)),
                ])),
                Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: p.accent.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                  child: Text('${w.freq}x', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: p.accent))),
              ]),
            );
          },
        )),
      ]),
    );
  }
}
