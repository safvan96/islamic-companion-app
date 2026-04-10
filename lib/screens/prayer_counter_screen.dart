import 'dart:convert';
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

const _prayers = ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha'];
const _icons = [Icons.wb_twilight, Icons.wb_sunny, Icons.sunny_snowing, Icons.nights_stay_outlined, Icons.dark_mode_outlined];

class PrayerCounterScreen extends StatefulWidget {
  const PrayerCounterScreen({super.key});
  @override
  State<PrayerCounterScreen> createState() => _PrayerCounterScreenState();
}

class _PrayerCounterScreenState extends State<PrayerCounterScreen> {
  Map<String, bool> _prayed = {};
  String _todayKey = '';
  int _totalPrayed = 0;

  @override
  void initState() { super.initState(); final now = DateTime.now(); _todayKey = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}'; _load(); }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('prayerCounter_$_todayKey');
    if (raw != null) _prayed = Map<String, bool>.from(jsonDecode(raw));
    _totalPrayed = prefs.getInt('prayerCounterTotal') ?? 0;
    setState(() {});
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('prayerCounter_$_todayKey', jsonEncode(_prayed));
    await prefs.setInt('prayerCounterTotal', _totalPrayed);
  }

  void _toggle(String prayer) {
    HapticFeedback.lightImpact();
    setState(() {
      final was = _prayed[prayer] ?? false;
      _prayed[prayer] = !was;
      _totalPrayed += was ? -1 : 1;
    });
    _save();
  }

  int get _todayCount => _prayed.values.where((v) => v).length;

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;
    final progress = _todayCount / 5;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('prayerCounter'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)), centerTitle: true),
      body: Column(children: [
        const Spacer(flex: 1),
        // Circle progress
        SizedBox(width: 180, height: 180, child: Stack(alignment: Alignment.center, children: [
          SizedBox(width: 180, height: 180, child: CircularProgressIndicator(value: progress, strokeWidth: 8, strokeCap: StrokeCap.round, backgroundColor: p.divider, valueColor: AlwaysStoppedAnimation(progress >= 1 ? p.gold : p.accent))),
          Column(mainAxisSize: MainAxisSize.min, children: [
            Text('$_todayCount/5', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w200, color: p.fg)),
            Text(l10n.translate('today'), style: TextStyle(fontSize: 12, color: p.muted)),
            if (_todayCount == 5) ...[const SizedBox(height: 4), Icon(Icons.check_circle, color: p.gold, size: 20)],
          ]),
        ])),
        const SizedBox(height: 12),
        Text('${l10n.translate('totalPrayed')}: $_totalPrayed', style: TextStyle(fontSize: 12, color: p.muted)),
        const Spacer(flex: 1),
        // Prayer toggles
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Column(children:
          List.generate(5, (i) {
            final prayer = _prayers[i];
            final done = _prayed[prayer] ?? false;
            return GestureDetector(
              onTap: () => _toggle(prayer),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: done ? p.gold.withOpacity(0.08) : p.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: done ? p.gold.withOpacity(0.4) : p.divider),
                ),
                child: Row(children: [
                  AnimatedContainer(duration: const Duration(milliseconds: 200), width: 28, height: 28,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: done ? p.gold : Colors.transparent, border: Border.all(color: done ? p.gold : p.divider, width: 1.5)),
                    child: done ? const Icon(Icons.check, size: 16, color: Colors.white) : null),
                  const SizedBox(width: 12),
                  Icon(_icons[i], size: 18, color: done ? p.gold : p.muted),
                  const SizedBox(width: 10),
                  Expanded(child: Text(l10n.translate(prayer), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600,
                    color: done ? p.muted : p.fg, decoration: done ? TextDecoration.lineThrough : null, decorationColor: p.muted.withOpacity(0.3)))),
                ]),
              ),
            );
          }),
        )),
        const SizedBox(height: 20),
      ]),
    );
  }
}
