import 'dart:math';
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

const _allWords = [
  ('\u0627\u0644\u0644\u0647', 'Allah'), ('\u0631\u0628', 'Lord'), ('\u0631\u062d\u0645\u0629', 'Mercy'),
  ('\u0635\u0644\u0627\u0629', 'Prayer'), ('\u062c\u0646\u0629', 'Paradise'), ('\u0646\u0648\u0631', 'Light'),
  ('\u0633\u0644\u0627\u0645', 'Peace'), ('\u0639\u0644\u0645', 'Knowledge'), ('\u062d\u0642', 'Truth'),
  ('\u0635\u0628\u0631', 'Patience'), ('\u0634\u0643\u0631', 'Gratitude'), ('\u062a\u0648\u0628\u0629', 'Repentance'),
  ('\u0642\u0644\u0628', 'Heart'), ('\u0647\u062f\u0649', 'Guidance'), ('\u0628\u0631\u0643\u0629', 'Blessing'),
  ('\u0639\u062f\u0644', 'Justice'), ('\u0623\u062c\u0631', 'Reward'), ('\u0631\u0632\u0642', 'Provision'),
];

class WordMatchScreen extends StatefulWidget {
  const WordMatchScreen({super.key});
  @override
  State<WordMatchScreen> createState() => _WordMatchScreenState();
}

class _WordMatchScreenState extends State<WordMatchScreen> {
  late List<(String, String)> _pairs;
  late List<String> _arabicCards;
  late List<String> _meaningCards;
  Set<int> _matchedArabic = {};
  Set<int> _matchedMeaning = {};
  int? _selectedArabic;
  int? _selectedMeaning;
  int _score = 0;
  int _attempts = 0;
  bool _gameOver = false;

  @override
  void initState() { super.initState(); _startGame(); }

  void _startGame() {
    final rng = Random();
    final shuffled = List<(String, String)>.from(_allWords)..shuffle(rng);
    _pairs = shuffled.take(6).toList();
    _arabicCards = _pairs.map((p) => p.$1).toList()..shuffle(rng);
    _meaningCards = _pairs.map((p) => p.$2).toList()..shuffle(rng);
    _matchedArabic = {};
    _matchedMeaning = {};
    _selectedArabic = null;
    _selectedMeaning = null;
    _score = 0;
    _attempts = 0;
    _gameOver = false;
    setState(() {});
  }

  void _selectArabic(int i) {
    if (_matchedArabic.contains(i)) return;
    HapticFeedback.lightImpact();
    setState(() => _selectedArabic = i);
    _checkMatch();
  }

  void _selectMeaning(int i) {
    if (_matchedMeaning.contains(i)) return;
    HapticFeedback.lightImpact();
    setState(() => _selectedMeaning = i);
    _checkMatch();
  }

  void _checkMatch() {
    if (_selectedArabic == null || _selectedMeaning == null) return;
    _attempts++;
    final arabic = _arabicCards[_selectedArabic!];
    final meaning = _meaningCards[_selectedMeaning!];
    final isMatch = _pairs.any((p) => p.$1 == arabic && p.$2 == meaning);
    if (isMatch) {
      _score++;
      _matchedArabic.add(_selectedArabic!);
      _matchedMeaning.add(_selectedMeaning!);
      HapticFeedback.mediumImpact();
      if (_matchedArabic.length == _pairs.length) _gameOver = true;
    }
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() { _selectedArabic = null; _selectedMeaning = null; });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('wordMatch'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)), centerTitle: true),
      body: _gameOver ? _buildResult(p, l10n) : _buildGame(p, l10n),
    );
  }

  Widget _buildGame(_P p, AppLocalizations l10n) {
    return Padding(padding: const EdgeInsets.all(20), child: Column(children: [
      // Score
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('$_score / ${_pairs.length}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: p.fg)),
        Text('${l10n.translate('attempts')}: $_attempts', style: TextStyle(fontSize: 13, color: p.muted)),
      ]),
      const SizedBox(height: 16),
      // Two columns
      Expanded(child: Row(children: [
        // Arabic column
        Expanded(child: Column(children: [
          Text(l10n.translate('arabicText'), style: TextStyle(fontSize: 11, color: p.gold, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          ...List.generate(_arabicCards.length, (i) {
            final matched = _matchedArabic.contains(i);
            final selected = _selectedArabic == i;
            return GestureDetector(
              onTap: matched ? null : () => _selectArabic(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: matched ? p.gold.withOpacity(0.1) : selected ? p.gold.withOpacity(0.2) : p.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: matched ? p.gold.withOpacity(0.4) : selected ? p.gold : p.divider, width: selected ? 2 : 1),
                ),
                child: Center(child: Text(_arabicCards[i], textDirection: TextDirection.rtl,
                  style: TextStyle(fontSize: 22, color: matched ? p.muted : p.fg, decoration: matched ? TextDecoration.lineThrough : null))),
              ),
            );
          }),
        ])),
        const SizedBox(width: 12),
        // Meaning column
        Expanded(child: Column(children: [
          Text(l10n.translate('meaning'), style: TextStyle(fontSize: 11, color: p.accent, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          ...List.generate(_meaningCards.length, (i) {
            final matched = _matchedMeaning.contains(i);
            final selected = _selectedMeaning == i;
            return GestureDetector(
              onTap: matched ? null : () => _selectMeaning(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: matched ? p.accent.withOpacity(0.1) : selected ? p.accent.withOpacity(0.2) : p.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: matched ? p.accent.withOpacity(0.4) : selected ? p.accent : p.divider, width: selected ? 2 : 1),
                ),
                child: Center(child: Text(_meaningCards[i],
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: matched ? p.muted : p.fg, decoration: matched ? TextDecoration.lineThrough : null))),
              ),
            );
          }),
        ])),
      ])),
    ]));
  }

  Widget _buildResult(_P p, AppLocalizations l10n) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.check_circle, size: 64, color: p.gold),
      const SizedBox(height: 16),
      Text('$_score/${_pairs.length}', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700, color: p.fg)),
      Text('$_attempts ${l10n.translate('attempts')}', style: TextStyle(fontSize: 16, color: p.muted)),
      const SizedBox(height: 24),
      ElevatedButton(onPressed: _startGame, style: ElevatedButton.styleFrom(backgroundColor: p.accent, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
        child: Text(l10n.translate('playAgain'), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600))),
    ]));
  }
}
