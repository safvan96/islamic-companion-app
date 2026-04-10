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

class _Deed {
  final String nameKey;
  final IconData icon;
  const _Deed(this.nameKey, this.icon);
}

const _defaultDeeds = [
  _Deed('deed_fajr', Icons.wb_twilight),
  _Deed('deed_dhuhr', Icons.wb_sunny),
  _Deed('deed_asr', Icons.sunny_snowing),
  _Deed('deed_maghrib', Icons.nights_stay_outlined),
  _Deed('deed_isha', Icons.dark_mode_outlined),
  _Deed('deed_quran', Icons.menu_book),
  _Deed('deed_dhikr', Icons.touch_app),
  _Deed('deed_sadaqah', Icons.favorite),
  _Deed('deed_dua', Icons.front_hand),
  _Deed('deed_sunnah', Icons.star_outline),
  _Deed('deed_family', Icons.family_restroom),
  _Deed('deed_kindness', Icons.emoji_people),
];

class GoodDeedsScreen extends StatefulWidget {
  const GoodDeedsScreen({super.key});
  @override
  State<GoodDeedsScreen> createState() => _GoodDeedsScreenState();
}

class _GoodDeedsScreenState extends State<GoodDeedsScreen> {
  Set<int> _checked = {};
  String _todayKey = '';
  int _streak = 0;
  Map<String, int> _history = {}; // dateKey -> count

  @override
  void initState() {
    super.initState();
    _todayKey = _dateKey(DateTime.now());
    _load();
  }

  static String _dateKey(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('goodDeeds_$_todayKey');
    if (raw != null) {
      _checked = Set<int>.from(jsonDecode(raw));
    }
    final histRaw = prefs.getString('goodDeedsHistory');
    if (histRaw != null) {
      _history = Map<String, int>.from(jsonDecode(histRaw));
    }
    _calcStreak();
    setState(() {});
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('goodDeeds_$_todayKey', jsonEncode(_checked.toList()));
    _history[_todayKey] = _checked.length;
    await prefs.setString('goodDeedsHistory', jsonEncode(_history));
  }

  void _calcStreak() {
    final now = DateTime.now();
    _streak = 0;
    for (int i = 0; i < 365; i++) {
      final d = now.subtract(Duration(days: i));
      final key = _dateKey(d);
      if (i == 0 && _checked.isNotEmpty) { _streak++; continue; }
      if (i == 0) continue;
      if ((_history[key] ?? 0) > 0) { _streak++; } else { break; }
    }
  }

  void _toggle(int index) {
    HapticFeedback.lightImpact();
    setState(() {
      if (_checked.contains(index)) {
        _checked.remove(index);
      } else {
        _checked.add(index);
      }
    });
    _save();
    _calcStreak();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;
    final progress = _defaultDeeds.isEmpty ? 0.0 : _checked.length / _defaultDeeds.length;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('goodDeeds'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          // Stats
          Row(children: [
            _StatCard(p: p, value: '${_checked.length}/${_defaultDeeds.length}', label: l10n.translate('today'), color: p.accent),
            const SizedBox(width: 8),
            _StatCard(p: p, value: '$_streak', label: l10n.translate('streak'), color: Colors.orange),
            const SizedBox(width: 8),
            _StatCard(p: p, value: '${(progress * 100).round()}%', label: l10n.translate('completed'), color: p.gold),
          ]),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(value: progress, minHeight: 6, backgroundColor: p.divider, valueColor: AlwaysStoppedAnimation(p.gold)),
          ),
          const SizedBox(height: 20),
          // Last 7 days mini chart
          _WeekChart(p: p, history: _history, todayCount: _checked.length, total: _defaultDeeds.length),
          const SizedBox(height: 20),
          // Deeds list
          ...List.generate(_defaultDeeds.length, (i) {
            final deed = _defaultDeeds[i];
            final done = _checked.contains(i);
            return GestureDetector(
              onTap: () => _toggle(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: done ? p.gold.withOpacity(0.08) : p.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: done ? p.gold.withOpacity(0.3) : p.divider),
                ),
                child: Row(children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 28, height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: done ? p.gold : Colors.transparent,
                      border: Border.all(color: done ? p.gold : p.divider, width: 1.5),
                    ),
                    child: done ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                  ),
                  const SizedBox(width: 12),
                  Icon(deed.icon, size: 18, color: done ? p.gold : p.muted),
                  const SizedBox(width: 10),
                  Expanded(child: Text(
                    l10n.translate(deed.nameKey),
                    style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500,
                      color: done ? p.muted : p.fg,
                      decoration: done ? TextDecoration.lineThrough : null,
                      decorationColor: p.muted.withOpacity(0.3),
                    ),
                  )),
                ]),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final _P p; final String value, label; final Color color;
  const _StatCard({required this.p, required this.value, required this.label, required this.color});
  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: p.divider)),
      child: Column(children: [
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: color)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 9, color: p.muted, fontWeight: FontWeight.w600)),
      ]),
    ));
  }
}

class _WeekChart extends StatelessWidget {
  final _P p;
  final Map<String, int> history;
  final int todayCount;
  final int total;
  const _WeekChart({required this.p, required this.history, required this.todayCount, required this.total});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return SizedBox(
      height: 70,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(7, (i) {
          final d = now.subtract(Duration(days: 6 - i));
          final key = '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
          final count = i == 6 ? todayCount : (history[key] ?? 0);
          final ratio = total == 0 ? 0.0 : count / total;
          final isToday = i == 6;
          final wd = ((d.weekday - 1) % 7);

          return Expanded(child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (count > 0) Text('$count', style: TextStyle(fontSize: 8, color: p.muted)),
              const SizedBox(height: 3),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: (ratio * 40).clamp(3.0, 40.0),
                decoration: BoxDecoration(
                  color: isToday ? p.gold : p.gold.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 4),
              Text(labels[wd], style: TextStyle(fontSize: 9, color: isToday ? p.gold : p.muted, fontWeight: isToday ? FontWeight.w700 : FontWeight.w400)),
            ],
          ));
        }),
      ),
    );
  }
}
