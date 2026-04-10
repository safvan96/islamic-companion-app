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

class _Night {
  final String nameKey, dateKey, descKey, worshipKey;
  final IconData icon;
  const _Night(this.nameKey, this.dateKey, this.descKey, this.worshipKey, this.icon);
}

const _nights = [
  _Night('hn_mawlid', 'hn_mawlid_date', 'hn_mawlid_desc', 'hn_mawlid_worship', Icons.auto_awesome),
  _Night('hn_ragaib', 'hn_ragaib_date', 'hn_ragaib_desc', 'hn_ragaib_worship', Icons.nightlight),
  _Night('hn_miraj', 'hn_miraj_date', 'hn_miraj_desc', 'hn_miraj_worship', Icons.flight_takeoff),
  _Night('hn_barat', 'hn_barat_date', 'hn_barat_desc', 'hn_barat_worship', Icons.nights_stay),
  _Night('hn_qadr', 'hn_qadr_date', 'hn_qadr_desc', 'hn_qadr_worship', Icons.star),
];

class HolyNightsScreen extends StatelessWidget {
  const HolyNightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('holyNights'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)), centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        itemCount: _nights.length,
        itemBuilder: (_, i) => _NightCard(night: _nights[i], p: p, l10n: l10n),
      ),
    );
  }
}

class _NightCard extends StatefulWidget {
  final _Night night; final _P p; final AppLocalizations l10n;
  const _NightCard({required this.night, required this.p, required this.l10n});
  @override
  State<_NightCard> createState() => _NightCardState();
}

class _NightCardState extends State<_NightCard> {
  bool _open = false;
  @override
  Widget build(BuildContext context) {
    final p = widget.p; final n = widget.night; final l10n = widget.l10n;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: _open ? p.gold.withOpacity(0.4) : p.divider)),
      child: Column(children: [
        InkWell(onTap: () => setState(() => _open = !_open), borderRadius: BorderRadius.circular(16),
          child: Padding(padding: const EdgeInsets.all(16), child: Row(children: [
            Container(width: 44, height: 44, decoration: BoxDecoration(shape: BoxShape.circle, color: p.gold.withOpacity(0.15)),
              child: Icon(n.icon, size: 22, color: p.gold)),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l10n.translate(n.nameKey), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: p.fg)),
              Text(l10n.translate(n.dateKey), style: TextStyle(fontSize: 12, color: p.accent)),
            ])),
            Icon(_open ? Icons.expand_less : Icons.expand_more, color: p.muted),
          ]))),
        if (_open) Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Divider(color: p.divider), const SizedBox(height: 8),
          Text(l10n.translate(n.descKey), style: TextStyle(fontSize: 13, color: p.muted, height: 1.6)),
          const SizedBox(height: 12),
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: p.gold.withOpacity(0.06), borderRadius: BorderRadius.circular(10), border: Border.all(color: p.gold.withOpacity(0.2))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [Icon(Icons.lightbulb, size: 14, color: p.gold), const SizedBox(width: 6),
                Text(l10n.translate('howToWorship'), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: p.gold))]),
              const SizedBox(height: 6),
              Text(l10n.translate(n.worshipKey), style: TextStyle(fontSize: 12, color: p.muted, height: 1.5)),
            ])),
        ])),
      ]),
    );
  }
}
