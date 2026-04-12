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

class TaraweehTrackerScreen extends StatefulWidget {
  const TaraweehTrackerScreen({super.key});
  @override
  State<TaraweehTrackerScreen> createState() => _TaraweehTrackerScreenState();
}

class _TaraweehTrackerScreenState extends State<TaraweehTrackerScreen> {
  // Track completed nights (1-30 for Ramadan)
  Set<int> _completedNights = {};
  int _rakaatPerNight = 20; // 20 (Hanafi) or 8 (other)

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('taraweehCompleted');
    if (raw != null) {
      try {
        _completedNights = Set<int>.from(jsonDecode(raw));
      } catch (_) {}
    }
    _rakaatPerNight = prefs.getInt('taraweehRakaat') ?? 20;
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('taraweehCompleted', jsonEncode(_completedNights.toList()));
    await prefs.setInt('taraweehRakaat', _rakaatPerNight);
  }

  void _toggleNight(int night) {
    HapticFeedback.lightImpact();
    setState(() {
      if (_completedNights.contains(night)) {
        _completedNights.remove(night);
      } else {
        _completedNights.add(night);
      }
    });
    _save();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;
    final progress = _completedNights.length / 30;
    final totalRakaat = _completedNights.length * _rakaatPerNight;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('taraweehTracker'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)),
        centerTitle: true,
        actions: [
          // Rakaat toggle
          TextButton(
            onPressed: () {
              setState(() => _rakaatPerNight = _rakaatPerNight == 20 ? 8 : 20);
              _save();
            },
            child: Text('$_rakaatPerNight rak.', style: TextStyle(color: p.gold, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        child: Column(
          children: [
            // Progress header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [p.gold.withOpacity(0.15), p.gold.withOpacity(0.05)]),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: p.gold.withOpacity(0.3)),
              ),
              child: Column(children: [
                Text('${_completedNights.length} / 30', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w200, color: p.fg)),
                const SizedBox(height: 4),
                Text(l10n.translate('nightsCompleted'), style: TextStyle(fontSize: 12, color: p.muted)),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: p.divider,
                    valueColor: AlwaysStoppedAnimation(p.gold),
                  ),
                ),
                const SizedBox(height: 12),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  _stat('$totalRakaat', l10n.translate('totalRakaat'), p),
                  _stat('${(progress * 100).toStringAsFixed(0)}%', '', p),
                  _stat('${30 - _completedNights.length}', l10n.translate('remaining'), p),
                ]),
              ]),
            ),
            const SizedBox(height: 20),
            // Night grid
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6, mainAxisSpacing: 8, crossAxisSpacing: 8,
                ),
                itemCount: 30,
                itemBuilder: (_, i) {
                  final night = i + 1;
                  final done = _completedNights.contains(night);
                  final isOdd = night % 2 == 1 && night >= 21; // Last 10 odd nights
                  return GestureDetector(
                    onTap: () => _toggleNight(night),
                    child: Container(
                      decoration: BoxDecoration(
                        color: done ? p.gold : p.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isOdd && !done ? p.gold.withOpacity(0.5) : p.divider, width: isOdd ? 2 : 1),
                      ),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text('$night', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: done ? Colors.white : p.fg)),
                        if (done) const Icon(Icons.check, size: 14, color: Colors.white),
                        if (isOdd && !done) Icon(Icons.star, size: 10, color: p.gold),
                      ]),
                    ),
                  );
                },
              ),
            ),
            // Legend
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.star, size: 12, color: p.gold),
                const SizedBox(width: 4),
                Text(l10n.translate('oddNightsLaylatul'), style: TextStyle(fontSize: 11, color: p.muted)),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(String value, String label, _P p) => Column(children: [
    Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: p.fg)),
    Text(label, style: TextStyle(fontSize: 10, color: p.muted)),
  ]);
}
