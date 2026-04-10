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

class _Rec {
  final String prayerKey, descKey;
  final List<String> surahs;
  final IconData icon;
  const _Rec(this.prayerKey, this.descKey, this.surahs, this.icon);
}

const _recommendations = [
  _Rec('fajr', 'ps_fajr_desc', ['Al-Waqiah (56)', 'At-Tur (52)', 'Qaf (50)', 'Al-Insan (76)'], Icons.wb_twilight),
  _Rec('dhuhr', 'ps_dhuhr_desc', ['Al-Buruj (85)', 'At-Tariq (86)', 'Al-Ala (87)', 'Al-Ghashiyah (88)'], Icons.wb_sunny),
  _Rec('asr', 'ps_asr_desc', ['Ad-Duha (93)', 'Ash-Sharh (94)', 'At-Tin (95)', 'Al-Alaq (96)'], Icons.sunny_snowing),
  _Rec('maghrib', 'ps_maghrib_desc', ['Al-Kafirun (109)', 'Al-Ikhlas (112)', 'At-Tin (95)', 'Al-Qadr (97)'], Icons.nights_stay_outlined),
  _Rec('isha', 'ps_isha_desc', ['Al-Mulk (67)', 'As-Sajdah (32)', 'Al-Inshiqaq (84)', 'Al-Mutaffifin (83)'], Icons.dark_mode_outlined),
  _Rec('jumuah', 'ps_jumuah_desc', ['Al-Jumuah (62)', 'Al-Munafiqun (63)', 'Al-Ala (87)', 'Al-Ghashiyah (88)'], Icons.mosque),
  _Rec('tahajjud', 'ps_tahajjud_desc', ['Al-Muzzammil (73)', 'Ya-Sin (36)', 'Ad-Dukhan (44)', 'Ar-Rahman (55)'], Icons.dark_mode),
  _Rec('witrPrayer', 'ps_witr_desc', ['Al-Ala (87)', 'Al-Kafirun (109)', 'Al-Ikhlas (112)'], Icons.auto_awesome),
];

class PrayerSurahsScreen extends StatelessWidget {
  const PrayerSurahsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('prayerSurahs'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)), centerTitle: true),
      body: ListView(padding: const EdgeInsets.fromLTRB(20, 0, 20, 32), children: [
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: p.accent.withOpacity(0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: p.accent.withOpacity(0.2))),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.info_outline, color: p.accent, size: 18), const SizedBox(width: 10),
            Expanded(child: Text(l10n.translate('prayerSurahsInfo'), style: TextStyle(fontSize: 12, color: p.muted, height: 1.5)))])),
        const SizedBox(height: 16),
        ..._recommendations.map((r) => _RecCard(rec: r, p: p, l10n: l10n)),
      ]),
    );
  }
}

class _RecCard extends StatefulWidget {
  final _Rec rec; final _P p; final AppLocalizations l10n;
  const _RecCard({required this.rec, required this.p, required this.l10n});
  @override
  State<_RecCard> createState() => _RecCardState();
}

class _RecCardState extends State<_RecCard> {
  bool _open = false;
  @override
  Widget build(BuildContext context) {
    final p = widget.p; final r = widget.rec; final l10n = widget.l10n;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: _open ? p.gold.withOpacity(0.3) : p.divider)),
      child: Column(children: [
        InkWell(onTap: () => setState(() => _open = !_open), borderRadius: BorderRadius.circular(14),
          child: Padding(padding: const EdgeInsets.all(14), child: Row(children: [
            Container(width: 36, height: 36, decoration: BoxDecoration(shape: BoxShape.circle, color: p.gold.withOpacity(0.12)),
              child: Icon(r.icon, size: 18, color: p.gold)),
            const SizedBox(width: 12),
            Expanded(child: Text(l10n.translate(r.prayerKey), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: p.fg))),
            Icon(_open ? Icons.expand_less : Icons.expand_more, color: p.muted, size: 20),
          ]))),
        if (_open) Padding(padding: const EdgeInsets.fromLTRB(14, 0, 14, 14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Divider(color: p.divider, height: 1), const SizedBox(height: 10),
          Text(l10n.translate(r.descKey), style: TextStyle(fontSize: 12, color: p.muted, height: 1.4)),
          const SizedBox(height: 10),
          ...r.surahs.map((s) => Padding(padding: const EdgeInsets.only(bottom: 4),
            child: Row(children: [
              Container(width: 6, height: 6, decoration: BoxDecoration(shape: BoxShape.circle, color: p.gold)),
              const SizedBox(width: 8),
              Text(s, style: TextStyle(fontSize: 13, color: p.fg, fontWeight: FontWeight.w500)),
            ]))),
        ])),
      ]),
    );
  }
}
