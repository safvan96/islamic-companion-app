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

class _AdabCategory {
  final String titleKey;
  final IconData icon;
  final List<String> itemKeys;
  const _AdabCategory(this.titleKey, this.icon, this.itemKeys);
}

const _categories = [
  _AdabCategory('adab_eating', Icons.restaurant, ['adab_eat1', 'adab_eat2', 'adab_eat3', 'adab_eat4', 'adab_eat5']),
  _AdabCategory('adab_greeting', Icons.waving_hand, ['adab_greet1', 'adab_greet2', 'adab_greet3']),
  _AdabCategory('adab_mosque', Icons.mosque, ['adab_mosque1', 'adab_mosque2', 'adab_mosque3', 'adab_mosque4']),
  _AdabCategory('adab_sleeping', Icons.bedtime, ['adab_sleep1', 'adab_sleep2', 'adab_sleep3']),
  _AdabCategory('adab_parents', Icons.family_restroom, ['adab_parent1', 'adab_parent2', 'adab_parent3']),
  _AdabCategory('adab_neighbor', Icons.people, ['adab_neighbor1', 'adab_neighbor2', 'adab_neighbor3']),
  _AdabCategory('adab_speech', Icons.record_voice_over, ['adab_speech1', 'adab_speech2', 'adab_speech3']),
  _AdabCategory('adab_travel', Icons.flight, ['adab_travel1', 'adab_travel2', 'adab_travel3']),
];

class AdabScreen extends StatelessWidget {
  const AdabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('islamicAdab'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        itemCount: _categories.length,
        itemBuilder: (_, i) => _CatCard(cat: _categories[i], p: p, l10n: l10n),
      ),
    );
  }
}

class _CatCard extends StatefulWidget {
  final _AdabCategory cat; final _P p; final AppLocalizations l10n;
  const _CatCard({required this.cat, required this.p, required this.l10n});
  @override
  State<_CatCard> createState() => _CatCardState();
}

class _CatCardState extends State<_CatCard> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    final p = widget.p; final l10n = widget.l10n; final cat = widget.cat;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: _expanded ? p.accent.withOpacity(0.3) : p.divider)),
      child: Column(children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          borderRadius: BorderRadius.circular(14),
          child: Padding(padding: const EdgeInsets.all(14), child: Row(children: [
            Container(width: 36, height: 36, decoration: BoxDecoration(shape: BoxShape.circle, color: p.accent.withOpacity(0.1)),
              child: Icon(cat.icon, size: 18, color: p.accent)),
            const SizedBox(width: 12),
            Expanded(child: Text(l10n.translate(cat.titleKey), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: p.fg))),
            Text('${cat.itemKeys.length}', style: TextStyle(fontSize: 12, color: p.muted)),
            const SizedBox(width: 4),
            Icon(_expanded ? Icons.expand_less : Icons.expand_more, color: p.muted, size: 20),
          ])),
        ),
        if (_expanded)
          Padding(padding: const EdgeInsets.fromLTRB(14, 0, 14, 14), child: Column(children: [
            Divider(color: p.divider, height: 1),
            const SizedBox(height: 10),
            ...cat.itemKeys.map((key) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(width: 6, height: 6, margin: const EdgeInsets.only(top: 6),
                  decoration: BoxDecoration(shape: BoxShape.circle, color: p.gold)),
                const SizedBox(width: 10),
                Expanded(child: Text(l10n.translate(key), style: TextStyle(fontSize: 13, color: p.muted, height: 1.5))),
              ]),
            )),
          ])),
      ]),
    );
  }
}
