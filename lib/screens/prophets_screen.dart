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

class _Prophet {
  final String name, arabic, titleKey, descKey;
  final bool isUlulAzm;
  const _Prophet(this.name, this.arabic, this.titleKey, this.descKey, {this.isUlulAzm = false});
}

const _prophets = [
  _Prophet('Adam', '\u0622\u062f\u064e\u0645', 'prophet_adam_title', 'prophet_adam_desc'),
  _Prophet('Idris', '\u0625\u0650\u062f\u0631\u064a\u0633', 'prophet_idris_title', 'prophet_idris_desc'),
  _Prophet('Nuh', '\u0646\u064f\u0648\u062d', 'prophet_nuh_title', 'prophet_nuh_desc', isUlulAzm: true),
  _Prophet('Hud', '\u0647\u064f\u0648\u062f', 'prophet_hud_title', 'prophet_hud_desc'),
  _Prophet('Salih', '\u0635\u064e\u0627\u0644\u0650\u062d', 'prophet_salih_title', 'prophet_salih_desc'),
  _Prophet('Ibrahim', '\u0625\u0650\u0628\u0631\u064e\u0627\u0647\u0650\u064a\u0645', 'prophet_ibrahim_title', 'prophet_ibrahim_desc', isUlulAzm: true),
  _Prophet('Lut', '\u0644\u064f\u0648\u0637', 'prophet_lut_title', 'prophet_lut_desc'),
  _Prophet('Ismail', '\u0625\u0650\u0633\u0645\u064e\u0627\u0639\u0650\u064a\u0644', 'prophet_ismail_title', 'prophet_ismail_desc'),
  _Prophet('Ishaq', '\u0625\u0650\u0633\u062d\u064e\u0627\u0642', 'prophet_ishaq_title', 'prophet_ishaq_desc'),
  _Prophet('Yaqub', '\u064a\u064e\u0639\u0642\u064f\u0648\u0628', 'prophet_yaqub_title', 'prophet_yaqub_desc'),
  _Prophet('Yusuf', '\u064a\u064f\u0648\u0633\u064f\u0641', 'prophet_yusuf_title', 'prophet_yusuf_desc'),
  _Prophet('Ayyub', '\u0623\u064e\u064a\u0651\u064f\u0648\u0628', 'prophet_ayyub_title', 'prophet_ayyub_desc'),
  _Prophet('Shuayb', '\u0634\u064f\u0639\u064e\u064a\u0628', 'prophet_shuayb_title', 'prophet_shuayb_desc'),
  _Prophet('Musa', '\u0645\u064f\u0648\u0633\u0649', 'prophet_musa_title', 'prophet_musa_desc', isUlulAzm: true),
  _Prophet('Harun', '\u0647\u064e\u0627\u0631\u064f\u0648\u0646', 'prophet_harun_title', 'prophet_harun_desc'),
  _Prophet('Dhul-Kifl', '\u0630\u064f\u0648 \u0627\u0644\u0643\u0650\u0641\u0644', 'prophet_dhulkifl_title', 'prophet_dhulkifl_desc'),
  _Prophet('Dawud', '\u062f\u064e\u0627\u0648\u064f\u062f', 'prophet_dawud_title', 'prophet_dawud_desc'),
  _Prophet('Sulaiman', '\u0633\u064f\u0644\u064e\u064a\u0645\u064e\u0627\u0646', 'prophet_sulaiman_title', 'prophet_sulaiman_desc'),
  _Prophet('Ilyas', '\u0625\u0650\u0644\u064a\u064e\u0627\u0633', 'prophet_ilyas_title', 'prophet_ilyas_desc'),
  _Prophet('Al-Yasa', '\u0627\u0644\u064a\u064e\u0633\u064e\u0639', 'prophet_alyasa_title', 'prophet_alyasa_desc'),
  _Prophet('Yunus', '\u064a\u064f\u0648\u0646\u064f\u0633', 'prophet_yunus_title', 'prophet_yunus_desc'),
  _Prophet('Zakariya', '\u0632\u064e\u0643\u064e\u0631\u0650\u064a\u0651\u064e\u0627', 'prophet_zakariya_title', 'prophet_zakariya_desc'),
  _Prophet('Yahya', '\u064a\u064e\u062d\u064a\u0649', 'prophet_yahya_title', 'prophet_yahya_desc'),
  _Prophet('Isa', '\u0639\u0650\u064a\u0633\u0649', 'prophet_isa_title', 'prophet_isa_desc', isUlulAzm: true),
  _Prophet('Muhammad', '\u0645\u064f\u062d\u064e\u0645\u0651\u064e\u062f', 'prophet_muhammad_title', 'prophet_muhammad_desc', isUlulAzm: true),
];

class ProphetsScreen extends StatelessWidget {
  const ProphetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('prophetsOfIslam'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        itemCount: _prophets.length,
        itemBuilder: (_, i) {
          final pr = _prophets[i];
          return _ProphetCard(prophet: pr, index: i, p: p, l10n: l10n);
        },
      ),
    );
  }
}

class _ProphetCard extends StatefulWidget {
  final _Prophet prophet; final int index; final _P p; final AppLocalizations l10n;
  const _ProphetCard({required this.prophet, required this.index, required this.p, required this.l10n});
  @override
  State<_ProphetCard> createState() => _ProphetCardState();
}

class _ProphetCardState extends State<_ProphetCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.p;
    final l10n = widget.l10n;
    final pr = widget.prophet;
    final color = pr.isUlulAzm ? p.gold : p.accent;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: p.surface, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _expanded ? color.withOpacity(0.3) : p.divider),
      ),
      child: Column(children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(children: [
              Container(width: 36, height: 36,
                decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(0.12)),
                child: Center(child: Text('${widget.index + 1}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color)))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Text(pr.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: p.fg)),
                  const SizedBox(width: 8),
                  Text(pr.arabic, textDirection: TextDirection.rtl, style: TextStyle(fontSize: 14, color: p.gold)),
                ]),
                Text(l10n.translate(pr.titleKey), style: TextStyle(fontSize: 11, color: p.muted)),
              ])),
              if (pr.isUlulAzm)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: p.gold.withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
                  child: Text('Ulul Azm', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: p.gold)),
                ),
              const SizedBox(width: 4),
              Icon(_expanded ? Icons.expand_less : Icons.expand_more, color: p.muted, size: 20),
            ]),
          ),
        ),
        if (_expanded)
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Divider(color: p.divider, height: 1),
              const SizedBox(height: 10),
              Text(l10n.translate(pr.descKey), style: TextStyle(fontSize: 13, color: p.muted, height: 1.6)),
            ]),
          ),
      ]),
    );
  }
}
