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

class _Term {
  final String term, arabic, defKey;
  const _Term(this.term, this.arabic, this.defKey);
}

const _terms = [
  _Term('Allah', '\u0627\u0644\u0644\u0647', 'gloss_allah'),
  _Term('Islam', '\u0625\u0633\u0644\u0627\u0645', 'gloss_islam'),
  _Term('Iman', '\u0625\u064a\u0645\u0627\u0646', 'gloss_iman'),
  _Term('Ihsan', '\u0625\u062d\u0633\u0627\u0646', 'gloss_ihsan'),
  _Term('Salah', '\u0635\u0644\u0627\u0629', 'gloss_salah'),
  _Term('Zakat', '\u0632\u0643\u0627\u0629', 'gloss_zakat'),
  _Term('Sawm', '\u0635\u0648\u0645', 'gloss_sawm'),
  _Term('Hajj', '\u062d\u062c', 'gloss_hajj'),
  _Term('Shahada', '\u0634\u0647\u0627\u062f\u0629', 'gloss_shahada'),
  _Term('Quran', '\u0642\u0631\u0622\u0646', 'gloss_quran'),
  _Term('Sunnah', '\u0633\u0646\u0629', 'gloss_sunnah'),
  _Term('Hadith', '\u062d\u062f\u064a\u062b', 'gloss_hadith'),
  _Term('Dua', '\u062f\u0639\u0627\u0621', 'gloss_dua'),
  _Term('Dhikr', '\u0630\u0643\u0631', 'gloss_dhikr'),
  _Term('Tawbah', '\u062a\u0648\u0628\u0629', 'gloss_tawbah'),
  _Term('Taqwa', '\u062a\u0642\u0648\u0649', 'gloss_taqwa'),
  _Term('Sadaqah', '\u0635\u062f\u0642\u0629', 'gloss_sadaqah'),
  _Term('Wudu', '\u0648\u0636\u0648\u0621', 'gloss_wudu'),
  _Term('Hijab', '\u062d\u062c\u0627\u0628', 'gloss_hijab'),
  _Term('Halal', '\u062d\u0644\u0627\u0644', 'gloss_halal'),
  _Term('Haram', '\u062d\u0631\u0627\u0645', 'gloss_haram'),
  _Term('Fitrah', '\u0641\u0637\u0631\u0629', 'gloss_fitrah'),
  _Term('Ummah', '\u0623\u0645\u0629', 'gloss_ummah'),
  _Term('Shura', '\u0634\u0648\u0631\u0649', 'gloss_shura'),
  _Term('Barakah', '\u0628\u0631\u0643\u0629', 'gloss_barakah'),
];

class GlossaryScreen extends StatefulWidget {
  const GlossaryScreen({super.key});
  @override
  State<GlossaryScreen> createState() => _GlossaryScreenState();
}

class _GlossaryScreenState extends State<GlossaryScreen> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;
    final filtered = _search.isEmpty ? _terms : _terms.where((t) =>
      t.term.toLowerCase().contains(_search.toLowerCase()) ||
      t.arabic.contains(_search)
    ).toList();

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('islamicGlossary'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)),
        centerTitle: true,
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: p.divider)),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              style: TextStyle(color: p.fg, fontSize: 14),
              decoration: InputDecoration(
                hintText: l10n.translate('searchTerms'), hintStyle: TextStyle(color: p.muted),
                prefixIcon: Icon(Icons.search, color: p.muted, size: 20),
                border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text('${filtered.length} ${l10n.translate('terms')}', style: TextStyle(fontSize: 11, color: p.muted)),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            itemCount: filtered.length,
            itemBuilder: (_, i) => _TermCard(term: filtered[i], p: p, l10n: l10n),
          ),
        ),
      ]),
    );
  }
}

class _TermCard extends StatefulWidget {
  final _Term term; final _P p; final AppLocalizations l10n;
  const _TermCard({required this.term, required this.p, required this.l10n});
  @override
  State<_TermCard> createState() => _TermCardState();
}

class _TermCardState extends State<_TermCard> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    final p = widget.p; final l10n = widget.l10n; final t = widget.term;
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: _expanded ? p.accent.withOpacity(0.3) : p.divider)),
      child: Column(children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          borderRadius: BorderRadius.circular(12),
          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10), child: Row(children: [
            Text(t.arabic, textDirection: TextDirection.rtl, style: TextStyle(fontSize: 16, color: p.gold)),
            const SizedBox(width: 10),
            Expanded(child: Text(t.term, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: p.fg))),
            Icon(_expanded ? Icons.expand_less : Icons.expand_more, color: p.muted, size: 18),
          ])),
        ),
        if (_expanded)
          Padding(padding: const EdgeInsets.fromLTRB(14, 0, 14, 12), child: Column(children: [
            Divider(color: p.divider, height: 1),
            const SizedBox(height: 8),
            Text(l10n.translate(t.defKey), style: TextStyle(fontSize: 13, color: p.muted, height: 1.5)),
          ])),
      ]),
    );
  }
}
