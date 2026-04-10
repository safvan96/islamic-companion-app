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

const _faqs = [
  ('faq_q1', 'faq_a1'), ('faq_q2', 'faq_a2'), ('faq_q3', 'faq_a3'),
  ('faq_q4', 'faq_a4'), ('faq_q5', 'faq_a5'), ('faq_q6', 'faq_a6'),
  ('faq_q7', 'faq_a7'), ('faq_q8', 'faq_a8'), ('faq_q9', 'faq_a9'),
  ('faq_q10', 'faq_a10'), ('faq_q11', 'faq_a11'), ('faq_q12', 'faq_a12'),
  ('faq_q13', 'faq_a13'), ('faq_q14', 'faq_a14'), ('faq_q15', 'faq_a15'),
];

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('islamicFaq'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        itemCount: _faqs.length,
        itemBuilder: (_, i) {
          final (qKey, aKey) = _faqs[i];
          return _FaqCard(num: i + 1, qKey: qKey, aKey: aKey, p: p, l10n: l10n);
        },
      ),
    );
  }
}

class _FaqCard extends StatefulWidget {
  final int num; final String qKey, aKey; final _P p; final AppLocalizations l10n;
  const _FaqCard({required this.num, required this.qKey, required this.aKey, required this.p, required this.l10n});
  @override
  State<_FaqCard> createState() => _FaqCardState();
}

class _FaqCardState extends State<_FaqCard> {
  bool _open = false;
  @override
  Widget build(BuildContext context) {
    final p = widget.p;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: _open ? p.accent.withOpacity(0.3) : p.divider)),
      child: Column(children: [
        InkWell(
          onTap: () => setState(() => _open = !_open),
          borderRadius: BorderRadius.circular(14),
          child: Padding(padding: const EdgeInsets.all(14), child: Row(children: [
            Container(width: 28, height: 28, decoration: BoxDecoration(shape: BoxShape.circle, color: p.gold.withOpacity(0.15)),
              child: Center(child: Text('${widget.num}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: p.gold)))),
            const SizedBox(width: 10),
            Expanded(child: Text(widget.l10n.translate(widget.qKey), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: p.fg))),
            Icon(_open ? Icons.expand_less : Icons.expand_more, color: p.muted, size: 20),
          ])),
        ),
        if (_open) Padding(padding: const EdgeInsets.fromLTRB(52, 0, 14, 14), child: Text(widget.l10n.translate(widget.aKey), style: TextStyle(fontSize: 13, color: p.muted, height: 1.6))),
      ]),
    );
  }
}
