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

class _Event {
  final String year, titleKey, descKey;
  final IconData icon;
  final bool major;
  const _Event(this.year, this.titleKey, this.descKey, this.icon, {this.major = false});
}

const _events = [
  _Event('570 CE', 'tl_birth', 'tl_birth_desc', Icons.child_care, major: true),
  _Event('610 CE', 'tl_revelation', 'tl_revelation_desc', Icons.menu_book, major: true),
  _Event('613 CE', 'tl_public', 'tl_public_desc', Icons.campaign),
  _Event('615 CE', 'tl_abyssinia', 'tl_abyssinia_desc', Icons.flight),
  _Event('619 CE', 'tl_sorrow', 'tl_sorrow_desc', Icons.sentiment_dissatisfied),
  _Event('620 CE', 'tl_isra', 'tl_isra_desc', Icons.nightlight_round, major: true),
  _Event('622 CE', 'tl_hijra', 'tl_hijra_desc', Icons.directions_walk, major: true),
  _Event('624 CE', 'tl_badr', 'tl_badr_desc', Icons.shield, major: true),
  _Event('625 CE', 'tl_uhud', 'tl_uhud_desc', Icons.terrain),
  _Event('627 CE', 'tl_khandaq', 'tl_khandaq_desc', Icons.construction),
  _Event('628 CE', 'tl_hudaybiya', 'tl_hudaybiya_desc', Icons.handshake),
  _Event('630 CE', 'tl_mecca', 'tl_mecca_desc', Icons.location_city, major: true),
  _Event('632 CE', 'tl_farewell', 'tl_farewell_desc', Icons.groups, major: true),
  _Event('632 CE', 'tl_passing', 'tl_passing_desc', Icons.star, major: true),
  _Event('632-661', 'tl_rashidun', 'tl_rashidun_desc', Icons.account_balance),
  _Event('661-750', 'tl_umayyad', 'tl_umayyad_desc', Icons.mosque),
  _Event('750-1258', 'tl_abbasid', 'tl_abbasid_desc', Icons.auto_stories),
  _Event('1453', 'tl_ottoman', 'tl_ottoman_desc', Icons.flag),
];

class TimelineScreen extends StatelessWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('islamicTimeline'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        itemCount: _events.length,
        itemBuilder: (_, i) {
          final e = _events[i];
          final isLast = i == _events.length - 1;
          final color = e.major ? p.gold : p.accent;
          return _EventCard(event: e, isLast: isLast, color: color, p: p, l10n: l10n);
        },
      ),
    );
  }
}

class _EventCard extends StatefulWidget {
  final _Event event; final bool isLast; final Color color; final _P p; final AppLocalizations l10n;
  const _EventCard({required this.event, required this.isLast, required this.color, required this.p, required this.l10n});
  @override
  State<_EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<_EventCard> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    final p = widget.p; final l10n = widget.l10n; final e = widget.event; final color = widget.color;
    return IntrinsicHeight(child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(width: 44, child: Column(children: [
        Container(width: e.major ? 16 : 10, height: e.major ? 16 : 10,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color, boxShadow: e.major ? [BoxShadow(color: color.withOpacity(0.4), blurRadius: 6)] : null)),
        if (!widget.isLast) Expanded(child: Container(width: 2, color: p.divider)),
      ])),
      Expanded(child: GestureDetector(
        onTap: () => setState(() => _expanded = !_expanded),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _expanded ? color.withOpacity(0.06) : p.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _expanded ? color.withOpacity(0.3) : p.divider),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
                child: Text(e.year, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color))),
              const SizedBox(width: 8),
              Icon(e.icon, size: 16, color: color),
              const SizedBox(width: 6),
              Expanded(child: Text(l10n.translate(e.titleKey), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: p.fg))),
              Icon(_expanded ? Icons.expand_less : Icons.expand_more, color: p.muted, size: 16),
            ]),
            if (_expanded) ...[
              const SizedBox(height: 8),
              Text(l10n.translate(e.descKey), style: TextStyle(fontSize: 12, color: p.muted, height: 1.5)),
            ],
          ]),
        ),
      )),
    ]));
  }
}
