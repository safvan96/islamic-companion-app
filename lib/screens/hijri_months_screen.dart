import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';
import '../services/hijri_calendar.dart';

class _P {
  final Color bg, surface, accent, gold, fg, muted, divider;
  const _P({required this.bg, required this.surface, required this.accent, required this.gold, required this.fg, required this.muted, required this.divider});
  static _P of(bool d) => d
      ? const _P(bg: Color(0xFF0E1A19), surface: Color(0xFF182624), accent: Color(0xFF4FBFA8), gold: Color(0xFFE3C77B), fg: Color(0xFFF5F1E8), muted: Color(0xFF8B968F), divider: Color(0xFF243532))
      : const _P(bg: Color(0xFFF8F5EE), surface: Color(0xFFFFFFFF), accent: Color(0xFF2C7A6B), gold: Color(0xFFB8902B), fg: Color(0xFF1F2937), muted: Color(0xFF6B6359), divider: Color(0xFFE8DDD0));
}

class _Month {
  final int num;
  final String name, arabic, descKey;
  final IconData icon;
  final bool sacred;
  const _Month(this.num, this.name, this.arabic, this.descKey, this.icon, {this.sacred = false});
}

const _months = [
  _Month(1, 'Muharram', '\u0645\u064f\u062d\u064e\u0631\u0651\u064e\u0645', 'hijri_m1', Icons.star, sacred: true),
  _Month(2, 'Safar', '\u0635\u064e\u0641\u064e\u0631', 'hijri_m2', Icons.directions_walk),
  _Month(3, "Rabi al-Awwal", '\u0631\u064e\u0628\u0650\u064a\u0639 \u0627\u0644\u0623\u064e\u0648\u0651\u064e\u0644', 'hijri_m3', Icons.auto_awesome),
  _Month(4, "Rabi al-Thani", '\u0631\u064e\u0628\u0650\u064a\u0639 \u0627\u0644\u062b\u0651\u064e\u0627\u0646\u0650\u064a', 'hijri_m4', Icons.eco),
  _Month(5, "Jumada al-Ula", '\u062c\u064f\u0645\u064e\u0627\u062f\u064e\u0649 \u0627\u0644\u0623\u064f\u0648\u0644\u064e\u0649', 'hijri_m5', Icons.ac_unit),
  _Month(6, "Jumada al-Thani", '\u062c\u064f\u0645\u064e\u0627\u062f\u064e\u0649 \u0627\u0644\u062b\u0651\u064e\u0627\u0646\u0650\u064a\u0629', 'hijri_m6', Icons.ac_unit),
  _Month(7, 'Rajab', '\u0631\u064e\u062c\u064e\u0628', 'hijri_m7', Icons.nightlight_round, sacred: true),
  _Month(8, "Sha'ban", '\u0634\u064e\u0639\u0628\u064e\u0627\u0646', 'hijri_m8', Icons.nights_stay),
  _Month(9, 'Ramadan', '\u0631\u064e\u0645\u064e\u0636\u064e\u0627\u0646', 'hijri_m9', Icons.mosque),
  _Month(10, 'Shawwal', '\u0634\u064e\u0648\u0651\u064e\u0627\u0644', 'hijri_m10', Icons.celebration),
  _Month(11, "Dhul Qa'dah", '\u0630\u064f\u0648 \u0627\u0644\u0642\u064e\u0639\u062f\u064e\u0629', 'hijri_m11', Icons.timer, sacred: true),
  _Month(12, 'Dhul Hijjah', '\u0630\u064f\u0648 \u0627\u0644\u062d\u0650\u062c\u0651\u064e\u0629', 'hijri_m12', Icons.location_city, sacred: true),
];

class HijriMonthsScreen extends StatelessWidget {
  const HijriMonthsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;
    final currentMonth = HijriCalendar.now().month;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('hijriMonthsGuide'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        itemCount: _months.length,
        itemBuilder: (_, i) {
          final m = _months[i];
          final isCurrent = m.num == currentMonth;
          final color = m.sacred ? p.gold : p.accent;
          return _MonthCard(month: m, isCurrent: isCurrent, color: color, p: p, l10n: l10n);
        },
      ),
    );
  }
}

class _MonthCard extends StatefulWidget {
  final _Month month; final bool isCurrent; final Color color; final _P p; final AppLocalizations l10n;
  const _MonthCard({required this.month, required this.isCurrent, required this.color, required this.p, required this.l10n});
  @override
  State<_MonthCard> createState() => _MonthCardState();
}

class _MonthCardState extends State<_MonthCard> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    final p = widget.p; final l10n = widget.l10n; final m = widget.month;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: widget.isCurrent ? widget.color.withOpacity(0.06) : p.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: widget.isCurrent ? widget.color.withOpacity(0.4) : _expanded ? widget.color.withOpacity(0.3) : p.divider),
      ),
      child: Column(children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          borderRadius: BorderRadius.circular(14),
          child: Padding(padding: const EdgeInsets.all(14), child: Row(children: [
            Container(width: 36, height: 36, decoration: BoxDecoration(shape: BoxShape.circle, color: widget.color.withOpacity(0.12)),
              child: Icon(m.icon, size: 18, color: widget.color)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(m.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: p.fg)),
                if (m.sacred) ...[
                  const SizedBox(width: 6),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1), decoration: BoxDecoration(color: p.gold.withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
                    child: Text(l10n.translate('sacred'), style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: p.gold))),
                ],
                if (widget.isCurrent) ...[
                  const SizedBox(width: 6),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1), decoration: BoxDecoration(color: p.accent.withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
                    child: Text(l10n.translate('current'), style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: p.accent))),
                ],
              ]),
              Text(m.arabic, textDirection: TextDirection.rtl, style: TextStyle(fontSize: 12, color: p.gold)),
            ])),
            Text('${m.num}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: p.muted)),
            const SizedBox(width: 4),
            Icon(_expanded ? Icons.expand_less : Icons.expand_more, color: p.muted, size: 18),
          ])),
        ),
        if (_expanded)
          Padding(padding: const EdgeInsets.fromLTRB(14, 0, 14, 14), child: Column(children: [
            Divider(color: p.divider, height: 1),
            const SizedBox(height: 10),
            Text(l10n.translate(m.descKey), style: TextStyle(fontSize: 13, color: p.muted, height: 1.6)),
          ])),
      ]),
    );
  }
}
