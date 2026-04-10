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

class _Cat {
  final String nameKey, descKey;
  final IconData icon;
  final List<String> surahs;
  final Color Function(_P) color;
  const _Cat(this.nameKey, this.descKey, this.icon, this.surahs, this.color);
}

final _categories = [
  _Cat('sc_tawheed', 'sc_tawheed_d', Icons.brightness_7, ['Al-Ikhlas (112)', 'Al-Kafirun (109)', 'Al-Anam (6)', 'Yunus (10)'], (p) => p.gold),
  _Cat('sc_stories', 'sc_stories_d', Icons.auto_stories, ['Yusuf (12)', 'Al-Kahf (18)', 'Maryam (19)', 'Al-Qasas (28)'], (p) => p.accent),
  _Cat('sc_law', 'sc_law_d', Icons.gavel, ['Al-Baqarah (2)', 'An-Nisa (4)', 'Al-Maidah (5)', 'An-Nur (24)'], (p) => Colors.orange),
  _Cat('sc_akhirah', 'sc_akhirah_d', Icons.cloud, ['Al-Waqiah (56)', 'Al-Mulk (67)', 'An-Naba (78)', 'At-Takwir (81)'], (p) => Colors.purple),
  _Cat('sc_dua', 'sc_dua_d', Icons.front_hand, ['Al-Fatiha (1)', 'Ibrahim (14)', 'Al-Furqan (25)', 'Ghafir (40)'], (p) => p.gold),
  _Cat('sc_nature', 'sc_nature_d', Icons.eco, ['Ar-Rahman (55)', 'An-Nahl (16)', 'Ya-Sin (36)', 'Al-Mulk (67)'], (p) => Colors.green),
  _Cat('sc_comfort', 'sc_comfort_d', Icons.favorite, ['Ad-Duha (93)', 'Ash-Sharh (94)', 'At-Tin (95)', 'Al-Kawthar (108)'], (p) => p.accent),
  _Cat('sc_protection', 'sc_protection_d', Icons.shield, ['Al-Falaq (113)', 'An-Nas (114)', 'Al-Baqarah 255', 'Al-Baqarah 285-286'], (p) => Colors.red),
];

class SurahCategoriesScreen extends StatelessWidget {
  const SurahCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('surahCategories'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)), centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        itemCount: _categories.length,
        itemBuilder: (_, i) => _CatCard(cat: _categories[i], p: p, l10n: l10n),
      ),
    );
  }
}

class _CatCard extends StatefulWidget {
  final _Cat cat; final _P p; final AppLocalizations l10n;
  const _CatCard({required this.cat, required this.p, required this.l10n});
  @override
  State<_CatCard> createState() => _CatCardState();
}

class _CatCardState extends State<_CatCard> {
  bool _open = false;
  @override
  Widget build(BuildContext context) {
    final p = widget.p; final c = widget.cat; final l10n = widget.l10n;
    final color = c.color(p);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: _open ? color.withOpacity(0.3) : p.divider)),
      child: Column(children: [
        InkWell(onTap: () => setState(() => _open = !_open), borderRadius: BorderRadius.circular(14),
          child: Padding(padding: const EdgeInsets.all(14), child: Row(children: [
            Container(width: 36, height: 36, decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(0.12)),
              child: Icon(c.icon, size: 18, color: color)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l10n.translate(c.nameKey), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: p.fg)),
              Text('${c.surahs.length} ${l10n.translate('surahs').toLowerCase()}', style: TextStyle(fontSize: 11, color: p.muted)),
            ])),
            Icon(_open ? Icons.expand_less : Icons.expand_more, color: p.muted, size: 20),
          ]))),
        if (_open) Padding(padding: const EdgeInsets.fromLTRB(14, 0, 14, 14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Divider(color: p.divider, height: 1), const SizedBox(height: 10),
          Text(l10n.translate(c.descKey), style: TextStyle(fontSize: 12, color: p.muted, height: 1.4)),
          const SizedBox(height: 10),
          ...c.surahs.map((s) => Padding(padding: const EdgeInsets.only(bottom: 4), child: Row(children: [
            Container(width: 6, height: 6, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
            const SizedBox(width: 8),
            Text(s, style: TextStyle(fontSize: 13, color: p.fg, fontWeight: FontWeight.w500)),
          ]))),
        ])),
      ]),
    );
  }
}
