import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';

class _P {
  final Color bg, surface, accent, gold, fg, muted, divider;
  const _P({required this.bg, required this.surface, required this.accent, required this.gold, required this.fg, required this.muted, required this.divider});
  static _P of(bool d) => d
      ? const _P(bg: Color(0xFF0E1A19), surface: Color(0xFF182624), accent: Color(0xFF4FBFA8), gold: Color(0xFFE3C77B), fg: Color(0xFFF5F1E8), muted: Color(0xFF8B968F), divider: Color(0xFF243532))
      : const _P(bg: Color(0xFFF8F5EE), surface: Color(0xFFFFFFFF), accent: Color(0xFF2C7A6B), gold: Color(0xFFB8902B), fg: Color(0xFF1F2937), muted: Color(0xFF6B6359), divider: Color(0xFFE8DDD0));
}

class DailyCheckinScreen extends StatefulWidget {
  const DailyCheckinScreen({super.key});
  @override
  State<DailyCheckinScreen> createState() => _DailyCheckinScreenState();
}

class _DailyCheckinScreenState extends State<DailyCheckinScreen> {
  Set<String> _checkedDays = {};
  int _streak = 0;

  @override
  void initState() { super.initState(); _load(); }

  String _key(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList('dailyCheckin');
    if (raw != null) _checkedDays = raw.toSet();
    _calcStreak();
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('dailyCheckin', _checkedDays.toList());
  }

  void _checkin() {
    final today = _key(DateTime.now());
    if (_checkedDays.contains(today)) return;
    HapticFeedback.mediumImpact();
    setState(() { _checkedDays.add(today); });
    _calcStreak();
    _save();
  }

  void _calcStreak() {
    final now = DateTime.now();
    _streak = 0;
    for (int i = 0; i < 365; i++) {
      final d = now.subtract(Duration(days: i));
      if (_checkedDays.contains(_key(d))) { _streak++; } else if (i > 0) { break; }
    }
  }

  bool get _checkedToday => _checkedDays.contains(_key(DateTime.now()));

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('dailyCheckin'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)), centerTitle: true),
      body: Column(children: [
        const Spacer(flex: 1),
        // Streak
        Text('$_streak', style: TextStyle(fontSize: 72, fontWeight: FontWeight.w200, color: p.gold)),
        Text(l10n.translate('dayStreak'), style: TextStyle(fontSize: 14, color: p.muted)),
        const SizedBox(height: 24),
        // Check-in button
        GestureDetector(
          onTap: _checkedToday ? null : _checkin,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 120, height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _checkedToday ? p.gold.withOpacity(0.15) : p.accent,
              border: Border.all(color: _checkedToday ? p.gold : p.accent, width: 3),
              boxShadow: _checkedToday ? [] : [BoxShadow(color: p.accent.withOpacity(0.3), blurRadius: 20)],
            ),
            child: Icon(_checkedToday ? Icons.check : Icons.fingerprint, size: 48, color: _checkedToday ? p.gold : Colors.white),
          ),
        ),
        const SizedBox(height: 12),
        Text(_checkedToday ? l10n.translate('checkedIn') : l10n.translate('tapToCheckin'),
          style: TextStyle(fontSize: 13, color: _checkedToday ? p.gold : p.muted, fontWeight: FontWeight.w600)),
        const Spacer(flex: 1),
        // This month calendar
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: p.divider)),
          child: Column(children: [
            Text('${l10n.translate('thisMonth')} - ${_checkedDays.where((d) => d.startsWith('${now.year}-${now.month.toString().padLeft(2, '0')}')).length}/$daysInMonth',
              style: TextStyle(fontSize: 12, color: p.muted, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Wrap(spacing: 6, runSpacing: 6, children: List.generate(daysInMonth, (i) {
              final day = i + 1;
              final date = DateTime(now.year, now.month, day);
              final checked = _checkedDays.contains(_key(date));
              final isToday = day == now.day;
              final isFuture = date.isAfter(now);
              return Container(
                width: 28, height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: checked ? p.gold.withOpacity(0.2) : Colors.transparent,
                  border: Border.all(color: isToday ? p.accent : checked ? p.gold.withOpacity(0.5) : p.divider, width: isToday ? 2 : 1),
                ),
                child: Center(child: checked
                  ? Icon(Icons.check, size: 12, color: p.gold)
                  : Text('$day', style: TextStyle(fontSize: 9, color: isFuture ? p.muted.withOpacity(0.3) : p.muted))),
              );
            })),
          ]),
        )),
        const SizedBox(height: 20),
      ]),
    );
  }
}
