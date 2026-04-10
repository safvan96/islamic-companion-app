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

class _Virtue {
  final String surahName, arabic, virtueKey;
  final int surahNum;
  const _Virtue(this.surahNum, this.surahName, this.arabic, this.virtueKey);
}

const _virtues = [
  _Virtue(1, 'Al-Fatiha', '\u0627\u0644\u0641\u0627\u062a\u062d\u0629', 'virtue_fatiha'),
  _Virtue(2, 'Al-Baqarah', '\u0627\u0644\u0628\u0642\u0631\u0629', 'virtue_baqarah'),
  _Virtue(3, 'Ali Imran', '\u0622\u0644 \u0639\u0645\u0631\u0627\u0646', 'virtue_imran'),
  _Virtue(18, 'Al-Kahf', '\u0627\u0644\u0643\u0647\u0641', 'virtue_kahf'),
  _Virtue(32, 'As-Sajdah', '\u0627\u0644\u0633\u062c\u062f\u0629', 'virtue_sajdah'),
  _Virtue(36, 'Ya-Sin', '\u064a\u0633', 'virtue_yasin'),
  _Virtue(44, 'Ad-Dukhan', '\u0627\u0644\u062f\u062e\u0627\u0646', 'virtue_dukhan'),
  _Virtue(55, 'Ar-Rahman', '\u0627\u0644\u0631\u062d\u0645\u0646', 'virtue_rahman'),
  _Virtue(56, 'Al-Waqiah', '\u0627\u0644\u0648\u0627\u0642\u0639\u0629', 'virtue_waqiah'),
  _Virtue(67, 'Al-Mulk', '\u0627\u0644\u0645\u0644\u0643', 'virtue_mulk'),
  _Virtue(112, 'Al-Ikhlas', '\u0627\u0644\u0625\u062e\u0644\u0627\u0635', 'virtue_ikhlas'),
  _Virtue(113, 'Al-Falaq', '\u0627\u0644\u0641\u0644\u0642', 'virtue_falaq'),
  _Virtue(114, 'An-Nas', '\u0627\u0644\u0646\u0627\u0633', 'virtue_nas'),
];

class SurahVirtuesScreen extends StatelessWidget {
  const SurahVirtuesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('surahVirtues'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)), centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        itemCount: _virtues.length,
        itemBuilder: (_, i) {
          final v = _virtues[i];
          return _VirtueCard(virtue: v, p: p, l10n: l10n);
        },
      ),
    );
  }
}

class _VirtueCard extends StatefulWidget {
  final _Virtue virtue; final _P p; final AppLocalizations l10n;
  const _VirtueCard({required this.virtue, required this.p, required this.l10n});
  @override
  State<_VirtueCard> createState() => _VirtueCardState();
}

class _VirtueCardState extends State<_VirtueCard> {
  bool _open = false;
  @override
  Widget build(BuildContext context) {
    final p = widget.p; final v = widget.virtue; final l10n = widget.l10n;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: _open ? p.gold.withOpacity(0.3) : p.divider)),
      child: Column(children: [
        InkWell(onTap: () => setState(() => _open = !_open), borderRadius: BorderRadius.circular(14),
          child: Padding(padding: const EdgeInsets.all(14), child: Row(children: [
            Container(width: 36, height: 36, decoration: BoxDecoration(shape: BoxShape.circle, color: p.gold.withOpacity(0.12)),
              child: Center(child: Text('${v.surahNum}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: p.gold)))),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(v.surahName, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: p.fg)),
              Text(v.arabic, textDirection: TextDirection.rtl, style: TextStyle(fontSize: 13, color: p.gold)),
            ])),
            Icon(_open ? Icons.expand_less : Icons.expand_more, color: p.muted, size: 20),
          ]))),
        if (_open) Padding(padding: const EdgeInsets.fromLTRB(14, 0, 14, 14), child: Column(children: [
          Divider(color: p.divider, height: 1), const SizedBox(height: 10),
          Text(l10n.translate(v.virtueKey), style: TextStyle(fontSize: 13, color: p.muted, height: 1.6)),
        ])),
      ]),
    );
  }
}
