import 'dart:convert';
import 'package:flutter/material.dart';
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

// Total pages in Quran ≈ 604
const _totalPages = 604;
const _totalJuz = 30;

class KhatmPlannerScreen extends StatefulWidget {
  const KhatmPlannerScreen({super.key});
  @override
  State<KhatmPlannerScreen> createState() => _KhatmPlannerScreenState();
}

class _KhatmPlannerScreenState extends State<KhatmPlannerScreen> {
  int _targetDays = 30;
  int _currentPage = 0;
  int _completedKhatms = 0;
  String _startDate = '';

  static const _presets = [7, 15, 30, 60, 90, 180, 365];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _targetDays = prefs.getInt('khatm_target') ?? 30;
    _currentPage = prefs.getInt('khatm_page') ?? 0;
    _completedKhatms = prefs.getInt('khatm_completed') ?? 0;
    _startDate = prefs.getString('khatm_start') ?? '';
    if (_startDate.isEmpty) {
      final now = DateTime.now();
      _startDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      await prefs.setString('khatm_start', _startDate);
    }
    setState(() {});
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('khatm_target', _targetDays);
    await prefs.setInt('khatm_page', _currentPage);
    await prefs.setInt('khatm_completed', _completedKhatms);
    await prefs.setString('khatm_start', _startDate);
  }

  void _addPages(int n) {
    setState(() {
      _currentPage += n;
      if (_currentPage >= _totalPages) {
        _completedKhatms++;
        _currentPage = 0;
        final now = DateTime.now();
        _startDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      }
    });
    _save();
  }

  void _reset() {
    setState(() { _currentPage = 0; });
    _save();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;
    final pagesPerDay = (_totalPages / _targetDays).ceil();
    final progress = _currentPage / _totalPages;
    final currentJuz = (_currentPage / (_totalPages / _totalJuz)).floor() + 1;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('khatmPlanner'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.refresh_rounded, color: p.muted, size: 20), onPressed: _reset),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          // Progress card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [p.gold.withOpacity(0.12), p.accent.withOpacity(0.06)]),
              borderRadius: BorderRadius.circular(20), border: Border.all(color: p.gold.withOpacity(0.2)),
            ),
            child: Column(children: [
              // Circular progress
              SizedBox(
                width: 160, height: 160,
                child: Stack(alignment: Alignment.center, children: [
                  SizedBox(width: 160, height: 160,
                    child: CircularProgressIndicator(value: progress, strokeWidth: 8, strokeCap: StrokeCap.round, backgroundColor: p.divider, valueColor: AlwaysStoppedAnimation(p.gold))),
                  Column(mainAxisSize: MainAxisSize.min, children: [
                    Text('${(progress * 100).toStringAsFixed(1)}%', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: p.fg)),
                    Text('$_currentPage / $_totalPages', style: TextStyle(fontSize: 12, color: p.muted)),
                    Text('${l10n.translate('juz')} $currentJuz', style: TextStyle(fontSize: 11, color: p.gold, fontWeight: FontWeight.w600)),
                  ]),
                ]),
              ),
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                _mini(l10n.translate('pagesPerDay'), '$pagesPerDay', p),
                _mini(l10n.translate('daysLeft'), '${((_totalPages - _currentPage) / pagesPerDay).ceil()}', p),
                _mini(l10n.translate('khatmsDone'), '$_completedKhatms', p),
              ]),
            ]),
          ),
          const SizedBox(height: 20),

          // Add pages
          Text(l10n.translate('addPagesRead').toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: p.muted, letterSpacing: 1.4)),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 8, children: [1, 2, 5, 10, 20].map((n) =>
            ElevatedButton(
              onPressed: () => _addPages(n),
              style: ElevatedButton.styleFrom(backgroundColor: p.accent, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10)),
              child: Text('+$n', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
            ),
          ).toList()),
          const SizedBox(height: 24),

          // Target selector
          Text(l10n.translate('khatmTarget').toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: p.muted, letterSpacing: 1.4)),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 8, children: _presets.map((d) {
            final active = d == _targetDays;
            final label = d == 7 ? '1 ${l10n.translate('week')}' : d == 30 ? '1 ${l10n.translate('month')}' : d == 365 ? '1 ${l10n.translate('year')}' : '$d ${l10n.translate('days')}';
            return ChoiceChip(
              label: Text(label), selected: active,
              onSelected: (_) { setState(() => _targetDays = d); _save(); },
              selectedColor: p.gold, backgroundColor: p.surface, side: BorderSide(color: p.divider),
              labelStyle: TextStyle(color: active ? Colors.white : p.fg, fontSize: 12, fontWeight: FontWeight.w500), showCheckmark: false,
            );
          }).toList()),
          const SizedBox(height: 20),

          // Daily schedule
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: p.gold.withOpacity(0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: p.gold.withOpacity(0.2))),
            child: Row(children: [
              Icon(Icons.schedule, color: p.gold, size: 18),
              const SizedBox(width: 10),
              Expanded(child: Text(
                '${l10n.translate('readDaily')}: $pagesPerDay ${l10n.translate('pages')} (≈${(pagesPerDay / 20).toStringAsFixed(1)} ${l10n.translate('juz')})',
                style: TextStyle(fontSize: 13, color: p.fg, fontWeight: FontWeight.w500),
              )),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _mini(String label, String value, _P p) => Column(children: [
    Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: p.fg)),
    Text(label, style: TextStyle(fontSize: 9, color: p.muted, fontWeight: FontWeight.w600)),
  ]);
}
