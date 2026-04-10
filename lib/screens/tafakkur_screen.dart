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

const _reflections = [
  '\u0625\u0650\u0646\u0651\u064e \u0641\u0650\u064a \u062e\u064e\u0644\u0652\u0642\u0650 \u0627\u0644\u0633\u0651\u064e\u0645\u064e\u0627\u0648\u064e\u0627\u062a\u0650 \u0648\u064e\u0627\u0644\u0652\u0623\u064e\u0631\u0652\u0636\u0650 \u0644\u064e\u0622\u064a\u064e\u0627\u062a\u064d \u0644\u0651\u0650\u0623\u064f\u0648\u0644\u0650\u064a \u0627\u0644\u0652\u0623\u064e\u0644\u0652\u0628\u064e\u0627\u0628\u0650',
  '\u0623\u064e\u0641\u064e\u0644\u064e\u0627 \u064a\u064e\u0646\u0638\u064f\u0631\u064f\u0648\u0646\u064e \u0625\u0650\u0644\u064e\u0649 \u0627\u0644\u0652\u0625\u0650\u0628\u0650\u0644\u0650 \u0643\u064e\u064a\u0652\u0641\u064e \u062e\u064f\u0644\u0650\u0642\u064e\u062a\u0652',
  '\u0648\u064e\u0641\u0650\u064a \u0623\u064e\u0646\u0641\u064f\u0633\u0650\u0643\u064f\u0645\u0652 \u0623\u064e\u0641\u064e\u0644\u064e\u0627 \u062a\u064f\u0628\u0652\u0635\u0650\u0631\u064f\u0648\u0646\u064e',
];

class TafakkurScreen extends StatefulWidget {
  const TafakkurScreen({super.key});
  @override
  State<TafakkurScreen> createState() => _TafakkurScreenState();
}

class _TafakkurScreenState extends State<TafakkurScreen> {
  int _minutes = 5;
  int _seconds = 0;
  bool _running = false;
  int _verseIndex = 0;
  Timer? _timer;

  void _start() {
    _seconds = _minutes * 60;
    _running = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_seconds <= 0) { _stop(); HapticFeedback.heavyImpact(); return; }
      setState(() { _seconds--; if (_seconds % 60 == 0 && _seconds > 0) _verseIndex = (_verseIndex + 1) % _reflections.length; });
    });
    setState(() {});
  }

  void _stop() { _timer?.cancel(); setState(() => _running = false); }
  @override
  void dispose() { _timer?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;
    final m = _seconds ~/ 60; final s = _seconds % 60;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('tafakkur'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)), centerTitle: true),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Spacer(flex: 2),
        if (_running) ...[
          Text(_reflections[_verseIndex], textDirection: TextDirection.rtl, textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, color: p.fg.withOpacity(0.7), height: 1.8)),
          const SizedBox(height: 32),
        ],
        // Timer
        Text('${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}',
          style: TextStyle(fontSize: 64, fontWeight: FontWeight.w100, color: _running ? p.gold : p.fg, letterSpacing: -2)),
        if (!_running && _seconds == 0) ...[
          const SizedBox(height: 16),
          Text(l10n.translate('tafakkurDesc'), textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: p.muted, height: 1.5)),
        ],
        const Spacer(flex: 1),
        if (!_running) ...[
          Wrap(spacing: 8, children: [3, 5, 10, 15].map((m) => ChoiceChip(
            label: Text('$m min'), selected: m == _minutes,
            onSelected: (_) => setState(() => _minutes = m),
            selectedColor: p.accent, backgroundColor: p.surface, side: BorderSide(color: p.divider),
            labelStyle: TextStyle(color: m == _minutes ? Colors.white : p.fg, fontSize: 12), showCheckmark: false,
          )).toList()),
          const SizedBox(height: 20),
        ],
        Padding(padding: const EdgeInsets.symmetric(horizontal: 40), child:
          SizedBox(width: double.infinity, child: ElevatedButton(
            onPressed: _running ? _stop : _start,
            style: ElevatedButton.styleFrom(backgroundColor: _running ? Colors.red.withOpacity(0.8) : p.accent, foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
            child: Text(_running ? l10n.translate('stop') : l10n.translate('startTafakkur'), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          ))),
        const SizedBox(height: 30),
      ]),
    );
  }
}
