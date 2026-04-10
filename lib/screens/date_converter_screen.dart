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

class DateConverterScreen extends StatefulWidget {
  const DateConverterScreen({super.key});
  @override
  State<DateConverterScreen> createState() => _DateConverterScreenState();
}

class _DateConverterScreenState extends State<DateConverterScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;
    final hijri = HijriCalendar.fromGregorian(_selectedDate);
    final langCode = Localizations.localeOf(context).languageCode;
    final isToday = _selectedDate.year == DateTime.now().year && _selectedDate.month == DateTime.now().month && _selectedDate.day == DateTime.now().day;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('dateConverter'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)), centerTitle: true),
      body: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
        // Gregorian card
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime(1900), lastDate: DateTime(2100));
            if (picked != null) setState(() => _selectedDate = picked);
          },
          child: Container(
            width: double.infinity, padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: p.accent.withOpacity(0.08), borderRadius: BorderRadius.circular(20), border: Border.all(color: p.accent.withOpacity(0.3))),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.calendar_today, color: p.accent, size: 18), const SizedBox(width: 8),
                Text(l10n.translate('gregorian').toUpperCase(), style: TextStyle(fontSize: 11, color: p.accent, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
              ]),
              const SizedBox(height: 12),
              Text('${_selectedDate.day}', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w200, color: p.fg)),
              Text(_monthName(_selectedDate.month), style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: p.fg)),
              Text('${_selectedDate.year}', style: TextStyle(fontSize: 16, color: p.muted)),
              if (isToday) ...[const SizedBox(height: 6),
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: p.accent.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                  child: Text(l10n.translate('today'), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: p.accent)))],
              const SizedBox(height: 8),
              Text(l10n.translate('tapToChange'), style: TextStyle(fontSize: 10, color: p.muted)),
            ]),
          ),
        ),
        const SizedBox(height: 16),
        // Arrow
        Icon(Icons.swap_vert_rounded, size: 32, color: p.gold),
        const SizedBox(height: 16),
        // Hijri card
        Container(
          width: double.infinity, padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: p.gold.withOpacity(0.08), borderRadius: BorderRadius.circular(20), border: Border.all(color: p.gold.withOpacity(0.3))),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.nightlight_round, color: p.gold, size: 18), const SizedBox(width: 8),
              Text(l10n.translate('hijriLabel').toUpperCase(), style: TextStyle(fontSize: 11, color: p.gold, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
            ]),
            const SizedBox(height: 12),
            Text('${hijri.day}', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w200, color: p.fg)),
            Text(hijri.format(langCode), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: p.fg)),
          ]),
        ),
        const Spacer(),
        // Quick dates
        Text(l10n.translate('quickDates').toUpperCase(), style: TextStyle(fontSize: 10, color: p.muted, letterSpacing: 1.2, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Wrap(spacing: 8, runSpacing: 8, alignment: WrapAlignment.center, children: [
          _quickBtn(l10n.translate('today'), DateTime.now(), p),
          _quickBtn(l10n.translate('tomorrow'), DateTime.now().add(const Duration(days: 1)), p),
          _quickBtn(l10n.translate('nextWeek'), DateTime.now().add(const Duration(days: 7)), p),
          _quickBtn(l10n.translate('nextMonth'), DateTime(DateTime.now().year, DateTime.now().month + 1, DateTime.now().day), p),
        ]),
        const SizedBox(height: 20),
      ])),
    );
  }

  Widget _quickBtn(String label, DateTime date, _P p) => GestureDetector(
    onTap: () => setState(() => _selectedDate = date),
    child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(8), border: Border.all(color: p.divider)),
      child: Text(label, style: TextStyle(fontSize: 11, color: p.fg, fontWeight: FontWeight.w500))),
  );

  String _monthName(int m) => const ['','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][m];
}
