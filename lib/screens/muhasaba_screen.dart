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

const _questions = [
  ('muhasaba_q1', Icons.mosque),        // Did I pray all 5 prayers?
  ('muhasaba_q2', Icons.menu_book),     // Did I read Quran?
  ('muhasaba_q3', Icons.touch_app),     // Did I make dhikr?
  ('muhasaba_q4', Icons.front_hand),    // Did I make dua?
  ('muhasaba_q5', Icons.favorite),      // Did I help someone?
  ('muhasaba_q6', Icons.psychology),    // Did I control my anger?
  ('muhasaba_q7', Icons.record_voice_over), // Did I avoid backbiting?
  ('muhasaba_q8', Icons.visibility),    // Did I guard my gaze?
  ('muhasaba_q9', Icons.access_time),   // Did I use my time wisely?
  ('muhasaba_q10', Icons.self_improvement), // Did I seek forgiveness?
];

class MuhasabaScreen extends StatefulWidget {
  const MuhasabaScreen({super.key});
  @override
  State<MuhasabaScreen> createState() => _MuhasabaScreenState();
}

class _MuhasabaScreenState extends State<MuhasabaScreen> {
  Set<int> _checked = {};
  String _todayKey = '';
  Map<String, int> _history = {};

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _todayKey = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('muhasaba_$_todayKey');
    if (raw != null) {
      try { _checked = Set<int>.from(jsonDecode(raw)); } catch (_) {}
    }
    final histRaw = prefs.getString('muhasabaHistory');
    if (histRaw != null) {
      try { _history = Map<String, int>.from(jsonDecode(histRaw)); } catch (_) {}
    }
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('muhasaba_$_todayKey', jsonEncode(_checked.toList()));
    _history[_todayKey] = _checked.length;
    await prefs.setString('muhasabaHistory', jsonEncode(_history));
  }

  void _toggle(int i) {
    HapticFeedback.lightImpact();
    setState(() { _checked.contains(i) ? _checked.remove(i) : _checked.add(i); });
    _save();
  }

  int get _streak {
    final now = DateTime.now();
    int s = 0;
    for (int i = 0; i < 365; i++) {
      final d = now.subtract(Duration(days: i));
      final key = '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
      if (i == 0 && _checked.isNotEmpty) { s++; continue; }
      if (i == 0) continue;
      if ((_history[key] ?? 0) > 0) { s++; } else { break; }
    }
    return s;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;
    final progress = _questions.isEmpty ? 0.0 : _checked.length / _questions.length;
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('muhasaba'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(gradient: LinearGradient(colors: [p.accent.withOpacity(0.1), p.gold.withOpacity(0.05)]), borderRadius: BorderRadius.circular(16), border: Border.all(color: p.accent.withOpacity(0.2))),
            child: Column(children: [
              Text('حَاسِبُوا أَنفُسَكُم قَبْلَ أَن تُحَاسَبُوا', textDirection: TextDirection.rtl, style: TextStyle(fontSize: 18, color: p.fg, height: 1.6)),
              const SizedBox(height: 6),
              Text(l10n.translate('muhasabaHadith'), textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: p.muted, fontStyle: FontStyle.italic)),
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                _mini('${_checked.length}/${_questions.length}', l10n.translate('today'), p),
                _mini('${(progress * 100).round()}%', l10n.translate('score'), p),
                _mini('$_streak', l10n.translate('streak'), p),
              ]),
              const SizedBox(height: 10),
              ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: progress, minHeight: 6, backgroundColor: p.divider, valueColor: AlwaysStoppedAnimation(p.gold))),
            ]),
          ),
          const SizedBox(height: 16),
          // Week chart
          SizedBox(height: 50, child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: List.generate(7, (i) {
            final d = now.subtract(Duration(days: 6 - i));
            final key = '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
            final count = i == 6 ? _checked.length : (_history[key] ?? 0);
            final ratio = _questions.isEmpty ? 0.0 : count / _questions.length;
            final isToday = i == 6;
            const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
            final wd = (d.weekday - 1) % 7;
            return Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              if (count > 0) Text('$count', style: TextStyle(fontSize: 8, color: p.muted)),
              Container(margin: const EdgeInsets.symmetric(horizontal: 3), height: (ratio * 30).clamp(2.0, 30.0), decoration: BoxDecoration(color: isToday ? p.gold : p.gold.withOpacity(0.3), borderRadius: BorderRadius.circular(3))),
              const SizedBox(height: 3),
              Text(labels[wd], style: TextStyle(fontSize: 9, color: isToday ? p.gold : p.muted, fontWeight: isToday ? FontWeight.w700 : FontWeight.w400)),
            ]));
          }))),
          const SizedBox(height: 16),
          // Questions
          ...List.generate(_questions.length, (i) {
            final (qKey, icon) = _questions[i];
            final done = _checked.contains(i);
            return GestureDetector(
              onTap: () => _toggle(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(color: done ? p.gold.withOpacity(0.08) : p.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: done ? p.gold.withOpacity(0.3) : p.divider)),
                child: Row(children: [
                  AnimatedContainer(duration: const Duration(milliseconds: 200), width: 24, height: 24,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: done ? p.gold : Colors.transparent, border: Border.all(color: done ? p.gold : p.divider, width: 1.5)),
                    child: done ? const Icon(Icons.check, size: 14, color: Colors.white) : null),
                  const SizedBox(width: 10),
                  Icon(icon, size: 16, color: done ? p.gold : p.muted),
                  const SizedBox(width: 10),
                  Expanded(child: Text(l10n.translate(qKey), style: TextStyle(fontSize: 13, color: done ? p.muted : p.fg,
                    decoration: done ? TextDecoration.lineThrough : null, decorationColor: p.muted.withOpacity(0.3)))),
                ]),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _mini(String value, String label, _P p) => Column(children: [
    Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: p.fg)),
    Text(label, style: TextStyle(fontSize: 9, color: p.muted, fontWeight: FontWeight.w600)),
  ]);
}
