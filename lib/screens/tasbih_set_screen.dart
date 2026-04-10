import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';

/// Post-prayer tasbih set: 33 SubhanAllah → 33 Alhamdulillah → 33 Allahu Akbar
/// with automatic progression and celebration.

class _Palette {
  final Color bg;
  final Color surface;
  final Color accent;
  final Color gold;
  final Color fg;
  final Color muted;
  final Color divider;
  const _Palette({
    required this.bg,
    required this.surface,
    required this.accent,
    required this.gold,
    required this.fg,
    required this.muted,
    required this.divider,
  });

  static _Palette of(bool isDark) => isDark
      ? const _Palette(
          bg: Color(0xFF0E1A19),
          surface: Color(0xFF182624),
          accent: Color(0xFF4FBFA8),
          gold: Color(0xFFE3C77B),
          fg: Color(0xFFF5F1E8),
          muted: Color(0xFF8B968F),
          divider: Color(0xFF243532),
        )
      : const _Palette(
          bg: Color(0xFFF8F5EE),
          surface: Color(0xFFFFFFFF),
          accent: Color(0xFF2C7A6B),
          gold: Color(0xFFB8902B),
          fg: Color(0xFF1F2937),
          muted: Color(0xFF6B6359),
          divider: Color(0xFFE8DDD0),
        );
}

class _TasbihStep {
  final String arabic;
  final String transliteration;
  final String meaningKey;
  final int target;
  const _TasbihStep({
    required this.arabic,
    required this.transliteration,
    required this.meaningKey,
    required this.target,
  });
}

const _defaultSteps = [
  _TasbihStep(
    arabic: 'سُبْحَانَ اللّٰهِ',
    transliteration: 'SubhanAllah',
    meaningKey: 'subhanallahMeaning',
    target: 33,
  ),
  _TasbihStep(
    arabic: 'الْحَمْدُ لِلّٰهِ',
    transliteration: 'Alhamdulillah',
    meaningKey: 'alhamdulillahMeaning',
    target: 33,
  ),
  _TasbihStep(
    arabic: 'اللّٰهُ أَكْبَرُ',
    transliteration: 'Allahu Akbar',
    meaningKey: 'allahuAkbarMeaning',
    target: 33,
  ),
];

class TasbihSetScreen extends StatefulWidget {
  const TasbihSetScreen({super.key});

  @override
  State<TasbihSetScreen> createState() => _TasbihSetScreenState();
}

class _TasbihSetScreenState extends State<TasbihSetScreen>
    with SingleTickerProviderStateMixin {
  int _stepIndex = 0;
  int _count = 0;
  bool _completed = false;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _pulseAnim = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _onTap() {
    if (_completed) return;
    HapticFeedback.lightImpact();
    SystemSound.play(SystemSoundType.click);
    _pulseCtrl.forward().then((_) => _pulseCtrl.reverse());

    setState(() {
      _count++;
      final step = _defaultSteps[_stepIndex];
      if (_count >= step.target) {
        if (_stepIndex < _defaultSteps.length - 1) {
          // Move to next step
          _stepIndex++;
          _count = 0;
          HapticFeedback.mediumImpact();
        } else {
          // All steps completed
          _completed = true;
          HapticFeedback.heavyImpact();
        }
      }
    });
  }

  void _reset() {
    setState(() {
      _stepIndex = 0;
      _count = 0;
      _completed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _Palette.of(isDark);
    final l10n = AppLocalizations.of(context)!;
    final step = _defaultSteps[_stepIndex];
    final progress = _count / step.target;
    final totalProgress =
        (_stepIndex * 33 + _count) / (_defaultSteps.length * 33);

    return Scaffold(
      backgroundColor: p.bg,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: p.fg,
        title: Text(
          l10n.translate('tasbihSet'),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: p.muted,
            letterSpacing: 0.4,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: p.muted),
            onPressed: _reset,
            tooltip: l10n.translate('reset'),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _onTap,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: _completed
                ? _buildCompleted(p, l10n)
                : _buildCounting(p, l10n, step, progress, totalProgress),
          ),
        ),
      ),
    );
  }

  Widget _buildCounting(
    _Palette p,
    AppLocalizations l10n,
    _TasbihStep step,
    double progress,
    double totalProgress,
  ) {
    return Column(
      children: [
        const Spacer(flex: 2),
        // Step indicator (dots)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_defaultSteps.length, (i) {
            final active = i == _stepIndex;
            final done = i < _stepIndex;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              width: active ? 32 : 10,
              height: 10,
              decoration: BoxDecoration(
                color: done
                    ? p.gold
                    : active
                        ? p.accent
                        : p.divider,
                borderRadius: BorderRadius.circular(5),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Text(
          '${l10n.translate('step')} ${_stepIndex + 1}/${_defaultSteps.length}',
          style: TextStyle(
            fontSize: 11,
            color: p.muted,
            letterSpacing: 1.0,
          ),
        ),
        const Spacer(flex: 2),
        // Arabic text
        Text(
          step.arabic,
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w500,
            color: p.fg,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          step.transliteration,
          style: TextStyle(
            fontSize: 15,
            color: p.muted,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.translate(step.meaningKey),
          style: TextStyle(
            fontSize: 12,
            color: p.muted.withOpacity(0.75),
            fontStyle: FontStyle.italic,
          ),
        ),
        const Spacer(flex: 2),
        // Counter ring
        AnimatedBuilder(
          animation: _pulseCtrl,
          builder: (context, _) {
            return Transform.scale(
              scale: _pulseAnim.value,
              child: SizedBox(
                width: 240,
                height: 240,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 240,
                      height: 240,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: progress),
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        builder: (_, value, __) => CircularProgressIndicator(
                          value: value,
                          strokeWidth: 5,
                          strokeCap: StrokeCap.round,
                          backgroundColor: p.divider,
                          valueColor: AlwaysStoppedAnimation(p.accent),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _count.toString(),
                          style: TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.w200,
                            color: p.fg,
                            height: 1.0,
                            letterSpacing: -2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '/ ${step.target}',
                          style: TextStyle(
                            fontSize: 14,
                            color: p.muted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const Spacer(flex: 2),
        // Total progress bar
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.translate('totalProgress').toUpperCase(),
                  style: TextStyle(
                    fontSize: 9,
                    color: p.muted,
                    letterSpacing: 1.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${(_stepIndex * 33 + _count)} / ${_defaultSteps.length * 33}',
                  style: TextStyle(
                    fontSize: 12,
                    color: p.muted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: totalProgress),
                duration: const Duration(milliseconds: 400),
                builder: (_, value, __) => LinearProgressIndicator(
                  value: value,
                  minHeight: 6,
                  backgroundColor: p.divider,
                  valueColor: AlwaysStoppedAnimation(p.gold),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          l10n.translate('tapAnywhere'),
          style: TextStyle(
            fontSize: 10,
            color: p.muted.withOpacity(0.6),
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildCompleted(_Palette p, AppLocalizations l10n) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(flex: 3),
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: p.gold.withOpacity(0.15),
          ),
          child: Icon(
            Icons.check_rounded,
            size: 64,
            color: p.gold,
          ),
        ),
        const SizedBox(height: 32),
        Text(
          l10n.translate('tasbihComplete'),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: p.fg,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.translate('tasbihCompleteDesc'),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: p.muted,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '33 + 33 + 33 = 99',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: p.accent,
          ),
        ),
        const Spacer(flex: 2),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _reset,
            style: ElevatedButton.styleFrom(
              backgroundColor: p.accent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              l10n.translate('startAgain'),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            l10n.translate('done'),
            style: TextStyle(color: p.muted, fontSize: 14),
          ),
        ),
        const Spacer(flex: 1),
      ],
    );
  }
}
