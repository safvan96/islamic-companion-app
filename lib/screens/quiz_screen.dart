import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import '../l10n/app_localizations.dart';
import '../models/quiz_model.dart';
import '../providers/app_provider.dart';

class _P {
  final Color bg, surface, accent, gold, fg, muted, divider;
  const _P({required this.bg, required this.surface, required this.accent, required this.gold, required this.fg, required this.muted, required this.divider});
  static _P of(bool d) => d
      ? const _P(bg: Color(0xFF0E1A19), surface: Color(0xFF182624), accent: Color(0xFF4FBFA8), gold: Color(0xFFE3C77B), fg: Color(0xFFF5F1E8), muted: Color(0xFF8B968F), divider: Color(0xFF243532))
      : const _P(bg: Color(0xFFF8F5EE), surface: Color(0xFFFFFFFF), accent: Color(0xFF2C7A6B), gold: Color(0xFFB8902B), fg: Color(0xFF1F2937), muted: Color(0xFF6B6359), divider: Color(0xFFE8DDD0));
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<QuizQuestion> _questions;
  int _current = 0;
  int _score = 0;
  int? _selected;
  bool _answered = false;
  bool _finished = false;
  int _bestScore = 0;
  int _totalPlayed = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
    _startQuiz();
  }

  Future<void> _loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _bestScore = prefs.getInt('quizBestScore') ?? 0;
      _totalPlayed = prefs.getInt('quizTotalPlayed') ?? 0;
    });
  }

  Future<void> _saveScore() async {
    final prefs = await SharedPreferences.getInstance();
    _totalPlayed++;
    await prefs.setInt('quizTotalPlayed', _totalPlayed);
    if (_score > _bestScore) {
      _bestScore = _score;
      await prefs.setInt('quizBestScore', _bestScore);
    }
  }

  void _startQuiz() {
    final rng = Random();
    final shuffled = List<QuizQuestion>.from(quizQuestions)..shuffle(rng);
    _questions = shuffled.take(10).toList();
    _current = 0;
    _score = 0;
    _selected = null;
    _answered = false;
    _finished = false;
    setState(() {});
  }

  void _selectAnswer(int index) {
    if (_answered) return;
    HapticFeedback.lightImpact();
    setState(() {
      _selected = index;
      _answered = true;
      if (index == _questions[_current].correctIndex) {
        _score++;
      }
    });
    // Auto-advance after delay
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      if (_current < _questions.length - 1) {
        setState(() {
          _current++;
          _selected = null;
          _answered = false;
        });
      } else {
        _saveScore();
        setState(() => _finished = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: p.fg,
        title: Text(
          l10n.translate('islamicQuiz'),
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _finished ? _buildResult(p, l10n) : _buildQuestion(p, l10n),
        ),
      ),
    );
  }

  Widget _buildQuestion(_P p, AppLocalizations l10n) {
    final q = _questions[_current];
    final progress = (_current + 1) / _questions.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        // Progress
        Row(
          children: [
            Text(
              '${_current + 1}/${_questions.length}',
              style: TextStyle(fontSize: 13, color: p.muted, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 5,
                  backgroundColor: p.divider,
                  valueColor: AlwaysStoppedAnimation(p.accent),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: p.gold.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star_rounded, size: 14, color: p.gold),
                  const SizedBox(width: 3),
                  Text('$_score', style: TextStyle(fontSize: 13, color: p.gold, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        // Category badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: p.accent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            l10n.translate('cat_${q.category}').toUpperCase(),
            style: TextStyle(fontSize: 10, color: p.accent, fontWeight: FontWeight.w700, letterSpacing: 1.0),
          ),
        ),
        const SizedBox(height: 16),
        // Question
        Text(
          l10n.translate(q.questionKey),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: p.fg, height: 1.4),
        ),
        const SizedBox(height: 28),
        // Options
        ...List.generate(q.optionKeys.length, (i) {
          final isCorrect = i == q.correctIndex;
          final isSelected = i == _selected;
          Color borderColor = p.divider;
          Color bgColor = p.surface;
          Color textColor = p.fg;
          IconData? icon;

          if (_answered) {
            if (isCorrect) {
              borderColor = const Color(0xFF4CAF50);
              bgColor = const Color(0xFF4CAF50).withOpacity(0.1);
              icon = Icons.check_circle;
            } else if (isSelected && !isCorrect) {
              borderColor = const Color(0xFFE53935);
              bgColor = const Color(0xFFE53935).withOpacity(0.1);
              textColor = const Color(0xFFE53935);
              icon = Icons.cancel;
            }
          } else if (isSelected) {
            borderColor = p.accent;
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: InkWell(
              onTap: () => _selectAnswer(i),
              borderRadius: BorderRadius.circular(14),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: borderColor, width: 1.5),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: p.bg,
                        border: Border.all(color: borderColor),
                      ),
                      child: Center(
                        child: icon != null
                            ? Icon(icon, size: 18, color: borderColor)
                            : Text(
                                String.fromCharCode(65 + i),
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: p.muted),
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.translate(q.optionKeys[i]),
                        style: TextStyle(fontSize: 15, color: textColor, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildResult(_P p, AppLocalizations l10n) {
    final pct = (_score / _questions.length * 100).round();
    final emoji = pct >= 80 ? '🏆' : pct >= 50 ? '👍' : '📖';
    final msgKey = pct >= 80 ? 'quizExcellent' : pct >= 50 ? 'quizGood' : 'quizKeepLearning';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(flex: 2),
        Text(emoji, style: const TextStyle(fontSize: 64)),
        const SizedBox(height: 20),
        Text(
          '$_score / ${_questions.length}',
          style: TextStyle(fontSize: 48, fontWeight: FontWeight.w700, color: p.fg),
        ),
        const SizedBox(height: 8),
        Text(
          '$pct%',
          style: TextStyle(fontSize: 18, color: p.accent, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.translate(msgKey),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: p.muted, height: 1.4),
        ),
        const SizedBox(height: 16),
        // Personal best + total played
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (_score >= _bestScore && _totalPlayed > 1)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: p.gold.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
              child: Text('🏆 ${l10n.translate('newBest')}!', style: TextStyle(fontSize: 12, color: p.gold, fontWeight: FontWeight.w600)),
            ),
          if (_score >= _bestScore && _totalPlayed > 1) const SizedBox(width: 12),
          Text('${l10n.translate('best')}: $_bestScore/${_questions.length}', style: TextStyle(fontSize: 12, color: p.muted)),
          const SizedBox(width: 12),
          Text('${l10n.translate('played')}: $_totalPlayed', style: TextStyle(fontSize: 12, color: p.muted)),
        ]),
        const Spacer(flex: 2),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _startQuiz,
            style: ElevatedButton.styleFrom(
              backgroundColor: p.accent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: Text(l10n.translate('playAgain'), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () {
            Share.share(
              'Islamic Quiz: $_score/${_questions.length} ($pct%)\n\n'
              '📱 Islamic Companion App',
            );
          },
          icon: Icon(Icons.share_outlined, size: 16, color: p.accent),
          label: Text(l10n.translate('shareResult'), style: TextStyle(color: p.accent)),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: p.divider),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          ),
        ),
        const Spacer(flex: 1),
      ],
    );
  }
}
