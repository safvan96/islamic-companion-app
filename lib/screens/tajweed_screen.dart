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

class _Rule {
  final String titleKey, descKey, exampleArabic;
  final Color Function(_P) color;
  const _Rule(this.titleKey, this.descKey, this.exampleArabic, this.color);
}

final _rules = [
  _Rule('tajweed_noon_sakin', 'tajweed_noon_sakin_desc', 'مِنْ بَعْدِ ۝ أَنْعَمْتَ', (p) => const Color(0xFF4CAF50)),
  _Rule('tajweed_ikhfa', 'tajweed_ikhfa_desc', 'مِنْ ثَمَرَةٍ ۝ أَنْتُمْ', (p) => const Color(0xFFFF9800)),
  _Rule('tajweed_iqlab', 'tajweed_iqlab_desc', 'مِنْ بَعْدِ ۝ أَنْبِئْهُمْ', (p) => const Color(0xFF2196F3)),
  _Rule('tajweed_idgham', 'tajweed_idgham_desc', 'مِنْ يَوْمٍ ۝ مِنْ وَلِيٍّ', (p) => const Color(0xFF9C27B0)),
  _Rule('tajweed_izhar', 'tajweed_izhar_desc', 'مِنْ عِلْمٍ ۝ مَنْ آمَنَ', (p) => p.accent),
  _Rule('tajweed_ghunna', 'tajweed_ghunna_desc', 'إِنَّ ۝ ثُمَّ', (p) => p.gold),
  _Rule('tajweed_madd', 'tajweed_madd_desc', 'قَالَ ۝ قِيلَ ۝ يَقُولُ', (p) => const Color(0xFFE91E63)),
  _Rule('tajweed_qalqala', 'tajweed_qalqala_desc', 'يَخْلُقْ ۝ أَحَدٌ ۝ لَهَبٍ', (p) => const Color(0xFF00BCD4)),
  _Rule('tajweed_lam_shamsiya', 'tajweed_lam_shamsiya_desc', 'الشَّمْسُ ۝ النَّاسِ', (p) => const Color(0xFFFF5722)),
  _Rule('tajweed_lam_qamariya', 'tajweed_lam_qamariya_desc', 'الْقَمَرُ ۝ الْكِتَابِ', (p) => const Color(0xFF607D8B)),
  _Rule('tajweed_waqf', 'tajweed_waqf_desc', '۝ ۞ ◌ۖ ◌ۗ ◌ۘ ◌ۙ', (p) => p.muted),
];

class TajweedScreen extends StatelessWidget {
  const TajweedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('tajweedGuide'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          // Info
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: p.accent.withOpacity(0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: p.accent.withOpacity(0.2))),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.info_outline, color: p.accent, size: 18),
              const SizedBox(width: 10),
              Expanded(child: Text(l10n.translate('tajweedInfo'), style: TextStyle(fontSize: 12, color: p.muted, height: 1.5))),
            ]),
          ),
          const SizedBox(height: 20),
          ..._rules.map((rule) {
            final color = rule.color(p);
            return _RuleCard(rule: rule, color: color, p: p, l10n: l10n);
          }),
        ],
      ),
    );
  }
}

class _RuleCard extends StatefulWidget {
  final _Rule rule; final Color color; final _P p; final AppLocalizations l10n;
  const _RuleCard({required this.rule, required this.color, required this.p, required this.l10n});
  @override
  State<_RuleCard> createState() => _RuleCardState();
}

class _RuleCardState extends State<_RuleCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.p;
    final l10n = widget.l10n;
    final rule = widget.rule;
    final color = widget.color;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _expanded ? color.withOpacity(0.4) : p.divider),
      ),
      child: Column(children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(children: [
              Container(width: 12, height: 12, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
              const SizedBox(width: 12),
              Expanded(child: Text(l10n.translate(rule.titleKey), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: p.fg))),
              Icon(_expanded ? Icons.expand_less : Icons.expand_more, color: p.muted, size: 20),
            ]),
          ),
        ),
        if (_expanded) Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Divider(color: p.divider, height: 1),
            const SizedBox(height: 12),
            Text(l10n.translate(rule.descKey), style: TextStyle(fontSize: 13, color: p.muted, height: 1.5)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
              child: Text(rule.exampleArabic, textDirection: TextDirection.rtl, textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, color: p.fg, height: 1.6)),
            ),
          ]),
        ),
      ]),
    );
  }
}
