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

// Key Islamic events (Hijri month, day, nameKey)
class _Event {
  final int month, day;
  final String nameKey;
  final IconData icon;
  final Color Function(_P) color;
  const _Event(this.month, this.day, this.nameKey, this.icon, this.color);
}

final _events = [
  _Event(1, 1, 'event_hijriNewYear', Icons.celebration, (p) => p.gold),
  _Event(1, 10, 'event_ashura', Icons.star, (p) => p.accent),
  _Event(3, 12, 'event_mawlid', Icons.auto_awesome, (p) => p.gold),
  _Event(7, 27, 'event_isra', Icons.nightlight_round, (p) => p.accent),
  _Event(8, 15, 'event_baraah', Icons.nights_stay, (p) => p.gold),
  _Event(9, 1, 'event_ramadanStart', Icons.mosque, (p) => p.accent),
  _Event(9, 27, 'event_laylatul', Icons.auto_awesome, (p) => p.gold),
  _Event(10, 1, 'event_eidFitr', Icons.celebration, (p) => p.gold),
  _Event(12, 8, 'event_hajjStart', Icons.location_city, (p) => p.accent),
  _Event(12, 9, 'event_arafah', Icons.terrain, (p) => p.gold),
  _Event(12, 10, 'event_eidAdha', Icons.celebration, (p) => p.gold),
];

final _hijriMonthNames = [
  '', 'Muharram', 'Safar', 'Rabi al-Awwal', 'Rabi al-Thani',
  'Jumada al-Ula', 'Jumada al-Thani', 'Rajab', 'Shaban',
  'Ramadan', 'Shawwal', 'Dhul Qadah', 'Dhul Hijjah',
];

class IslamicCalendarScreen extends StatelessWidget {
  const IslamicCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;
    final hijri = HijriCalendar.now();
    final today = DateTime.now();

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('islamicCalendar'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          // Today card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [p.accent.withOpacity(0.15), p.gold.withOpacity(0.1)],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: p.accent.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                Text(l10n.translate('today'), style: TextStyle(fontSize: 11, color: p.muted, letterSpacing: 1.2, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Text(
                  hijri.format(Localizations.localeOf(context).languageCode),
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: p.fg),
                ),
                const SizedBox(height: 4),
                Text(
                  '${today.day}/${today.month}/${today.year}',
                  style: TextStyle(fontSize: 13, color: p.muted),
                ),
                const SizedBox(height: 8),
                Text(
                  _hijriMonthNames[hijri.month.clamp(1, 12)],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: p.accent),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Upcoming events
          Text(
            l10n.translate('upcomingEvents').toUpperCase(),
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: p.muted, letterSpacing: 1.4),
          ),
          const SizedBox(height: 12),

          // Sort events by proximity to current Hijri date
          ..._getSortedEvents(hijri).map((e) {
            final eventColor = e.color(p);
            final isThisMonth = e.month == hijri.month;
            final isPast = e.month < hijri.month || (e.month == hijri.month && e.day < hijri.day);
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isThisMonth && !isPast ? eventColor.withOpacity(0.08) : p.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isThisMonth && !isPast ? eventColor.withOpacity(0.3) : p.divider),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: eventColor.withOpacity(0.12)),
                    child: Icon(e.icon, size: 18, color: eventColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.translate(e.nameKey), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: p.fg)),
                      Text(
                        '${e.day} ${_hijriMonthNames[e.month.clamp(1, 12)]}',
                        style: TextStyle(fontSize: 11, color: p.muted),
                      ),
                    ],
                  )),
                  if (isThisMonth && !isPast)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: eventColor.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                      child: Text(l10n.translate('soon'), style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: eventColor)),
                    ),
                  if (isPast)
                    Icon(Icons.check_circle, size: 18, color: p.muted.withOpacity(0.4)),
                ],
              ),
            );
          }),

          const SizedBox(height: 20),
          // Hijri months reference
          Text(
            l10n.translate('hijriMonths').toUpperCase(),
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: p.muted, letterSpacing: 1.4),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: List.generate(12, (i) {
              final m = i + 1;
              final isCurrent = m == hijri.month;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isCurrent ? p.accent.withOpacity(0.12) : p.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: isCurrent ? p.accent : p.divider),
                ),
                child: Column(children: [
                  Text('$m', style: TextStyle(fontSize: 11, color: p.muted, fontWeight: FontWeight.w600)),
                  Text(_hijriMonthNames[m], style: TextStyle(fontSize: 10, color: isCurrent ? p.accent : p.fg, fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w400)),
                ]),
              );
            }),
          ),
        ],
      ),
    );
  }

  List<_Event> _getSortedEvents(HijriCalendar hijri) {
    final sorted = List<_Event>.from(_events);
    sorted.sort((a, b) {
      final aVal = (a.month - hijri.month + 12) % 12 * 30 + a.day;
      final bVal = (b.month - hijri.month + 12) % 12 * 30 + b.day;
      return aVal.compareTo(bVal);
    });
    return sorted;
  }
}
