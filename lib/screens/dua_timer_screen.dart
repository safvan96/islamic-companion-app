import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class DuaTimerScreen extends StatefulWidget {
  const DuaTimerScreen({super.key});
  @override
  State<DuaTimerScreen> createState() => _DuaTimerScreenState();
}

class _DuaTimerScreenState extends State<DuaTimerScreen> {
  int _minutes = 5;
  int _secondsLeft = 0;
  bool _running = false;
  Timer? _timer;
  static const _presets = [1, 3, 5, 10, 15, 30];

  final _duas = [
    '\u0631\u064e\u0628\u0651\u064e\u0646\u064e\u0627 \u0622\u062a\u0650\u0646\u064e\u0627 \u0641\u0650\u064a \u0627\u0644\u062f\u0651\u064f\u0646\u0652\u064a\u064e\u0627 \u062d\u064e\u0633\u064e\u0646\u064e\u0629\u064b \u0648\u064e\u0641\u0650\u064a \u0627\u0644\u0652\u0622\u062e\u0650\u0631\u064e\u0629\u0650 \u062d\u064e\u0633\u064e\u0646\u064e\u0629\u064b',
    '\u0631\u064e\u0628\u0651\u0650 \u0627\u0634\u0652\u0631\u064e\u062d\u0652 \u0644\u0650\u064a \u0635\u064e\u062f\u0652\u0631\u0650\u064a \u0648\u064e\u064a\u064e\u0633\u0651\u0650\u0631\u0652 \u0644\u0650\u064a \u0623\u064e\u0645\u0652\u0631\u0650\u064a',
    '\u062d\u064e\u0633\u0652\u0628\u064f\u0646\u064e\u0627 \u0627\u0644\u0644\u0651\u064e\u0647\u064f \u0648\u064e\u0646\u0650\u0639\u0652\u0645\u064e \u0627\u0644\u0652\u0648\u064e\u0643\u0650\u064a\u0644\u064f',
    '\u0644\u064e\u0627 \u0625\u0650\u0644\u064e\u0647\u064e \u0625\u0650\u0644\u0651\u064e\u0627 \u0623\u064e\u0646\u062a\u064e \u0633\u064f\u0628\u0652\u062d\u064e\u0627\u0646\u064e\u0643\u064e \u0625\u0650\u0646\u0651\u0650\u064a \u0643\u064f\u0646\u062a\u064f \u0645\u0650\u0646\u064e \u0627\u0644\u0638\u0651\u064e\u0627\u0644\u0650\u0645\u0650\u064a\u0646\u064e',
  ];

  void _start() {
    _secondsLeft = _minutes * 60;
    _running = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft <= 0) { _stop(); HapticFeedback.heavyImpact(); return; }
      setState(() => _secondsLeft--);
    });
    setState(() {});
  }

  void _stop() {
    _timer?.cancel();
    _running = false;
    setState(() {});
  }

  void _reset() {
    _stop();
    _secondsLeft = 0;
    setState(() {});
  }

  @override
  void dispose() { _timer?.cancel(); super.dispose(); }

  String get _timeDisplay {
    final m = _secondsLeft ~/ 60;
    final s = _secondsLeft % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;
    final progress = _minutes * 60 == 0 ? 0.0 : 1.0 - (_secondsLeft / (_minutes * 60));
    final done = !_running && _secondsLeft == 0 && progress > 0;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('duaTimer'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)), centerTitle: true),
      body: Column(children: [
        const Spacer(flex: 1),
        // Timer circle
        SizedBox(width: 240, height: 240, child: Stack(alignment: Alignment.center, children: [
          SizedBox(width: 240, height: 240, child: CircularProgressIndicator(
            value: _running || done ? progress : 0, strokeWidth: 6, strokeCap: StrokeCap.round,
            backgroundColor: p.divider, valueColor: AlwaysStoppedAnimation(done ? p.gold : p.accent))),
          Column(mainAxisSize: MainAxisSize.min, children: [
            Text(_running || done ? _timeDisplay : '${_minutes}:00', style: TextStyle(fontSize: 56, fontWeight: FontWeight.w200, color: p.fg, letterSpacing: -2)),
            if (done) Text(l10n.translate('duaTimeUp'), style: TextStyle(fontSize: 14, color: p.gold, fontWeight: FontWeight.w600)),
            if (!_running && !done) Text(l10n.translate('minutes'), style: TextStyle(fontSize: 13, color: p.muted)),
          ]),
        ])),
        const SizedBox(height: 24),
        // Dua suggestion
        if (_running) Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(_duas[(_secondsLeft ~/ 30) % _duas.length], textDirection: TextDirection.rtl, textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: p.fg.withOpacity(0.6), height: 1.6)),
        ),
        const Spacer(flex: 1),
        // Duration selector
        if (!_running) Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Column(children: [
          Text(l10n.translate('selectDuration').toUpperCase(), style: TextStyle(fontSize: 10, color: p.muted, letterSpacing: 1.2, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Wrap(spacing: 8, children: _presets.map((m) {
            final active = m == _minutes;
            return ChoiceChip(label: Text('$m min'), selected: active,
              onSelected: (_) => setState(() { _minutes = m; _secondsLeft = 0; }),
              selectedColor: p.accent, backgroundColor: p.surface, side: BorderSide(color: p.divider),
              labelStyle: TextStyle(color: active ? Colors.white : p.fg, fontSize: 12), showCheckmark: false);
          }).toList()),
        ])),
        const SizedBox(height: 20),
        // Controls
        Padding(padding: const EdgeInsets.symmetric(horizontal: 40), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (_running) ...[
            ElevatedButton(onPressed: _stop, style: ElevatedButton.styleFrom(backgroundColor: Colors.red.withOpacity(0.8), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              child: Text(l10n.translate('stop'), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600))),
          ] else ...[
            Expanded(child: ElevatedButton(onPressed: _start, style: ElevatedButton.styleFrom(backgroundColor: p.accent, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              child: Text(done ? l10n.translate('startAgain') : l10n.translate('startDua'), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)))),
          ],
        ])),
        const SizedBox(height: 24),
      ]),
    );
  }
}
