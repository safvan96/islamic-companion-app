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

class MukabeleScreen extends StatefulWidget {
  const MukabeleScreen({super.key});
  @override
  State<MukabeleScreen> createState() => _MukabeleScreenState();
}

class _MukabeleScreenState extends State<MukabeleScreen> {
  // Track 30 juz completion
  List<bool> _completed = List.filled(30, false);

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('mukabele');
    if (raw != null) {
      try { _completed = List<bool>.from(jsonDecode(raw)); } catch (_) {}
      if (_completed.length != 30) _completed = List.filled(30, false);
    }
    setState(() {});
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('mukabele', jsonEncode(_completed));
  }

  void _toggle(int i) {
    HapticFeedback.lightImpact();
    setState(() => _completed[i] = !_completed[i]);
    _save();
  }

  void _reset() {
    setState(() => _completed = List.filled(30, false));
    _save();
  }

  int get _doneCount => _completed.where((c) => c).length;

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;
    final progress = _doneCount / 30;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('mukabele'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)), centerTitle: true,
        actions: [IconButton(icon: Icon(Icons.refresh, color: p.muted, size: 20), onPressed: _reset)]),
      body: Column(children: [
        // Progress
        Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 0), child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(gradient: LinearGradient(colors: [p.gold.withOpacity(0.12), p.accent.withOpacity(0.06)]), borderRadius: BorderRadius.circular(16), border: Border.all(color: p.gold.withOpacity(0.2))),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('$_doneCount / 30 ${l10n.translate('juz')}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: p.fg)),
              Text('${(progress * 100).toStringAsFixed(0)}%', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: p.gold)),
            ]),
            const SizedBox(height: 8),
            ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: progress, minHeight: 8, backgroundColor: p.divider, valueColor: AlwaysStoppedAnimation(p.gold))),
            if (_doneCount == 30) ...[const SizedBox(height: 10),
              Text(l10n.translate('mukabeleComplete'), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: p.gold))],
          ]),
        )),
        const SizedBox(height: 12),
        // Grid
        Expanded(child: GridView.builder(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 1),
          itemCount: 30,
          itemBuilder: (_, i) {
            final done = _completed[i];
            return GestureDetector(
              onTap: () => _toggle(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: done ? p.gold.withOpacity(0.15) : p.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: done ? p.gold : p.divider, width: done ? 1.5 : 1),
                ),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  if (done) Icon(Icons.check_circle, size: 22, color: p.gold)
                  else Text('${i + 1}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: p.fg)),
                  const SizedBox(height: 2),
                  Text('${l10n.translate('juz')} ${i + 1}', style: TextStyle(fontSize: 8, color: done ? p.gold : p.muted, fontWeight: FontWeight.w600)),
                ]),
              ),
            );
          },
        )),
      ]),
    );
  }
}
