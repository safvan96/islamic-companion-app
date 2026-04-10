import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/adhkar_model.dart';
import '../providers/app_provider.dart';

class _P {
  final Color bg, surface, accent, gold, fg, muted, divider;
  const _P({required this.bg, required this.surface, required this.accent, required this.gold, required this.fg, required this.muted, required this.divider});
  static _P of(bool d) => d
      ? const _P(bg: Color(0xFF0E1A19), surface: Color(0xFF182624), accent: Color(0xFF4FBFA8), gold: Color(0xFFE3C77B), fg: Color(0xFFF5F1E8), muted: Color(0xFF8B968F), divider: Color(0xFF243532))
      : const _P(bg: Color(0xFFF8F5EE), surface: Color(0xFFFFFFFF), accent: Color(0xFF2C7A6B), gold: Color(0xFFB8902B), fg: Color(0xFF1F2937), muted: Color(0xFF6B6359), divider: Color(0xFFE8DDD0));
}

class AdhkarScreen extends StatefulWidget {
  const AdhkarScreen({super.key});
  @override
  State<AdhkarScreen> createState() => _AdhkarScreenState();
}

class _AdhkarScreenState extends State<AdhkarScreen> {
  bool _isMorning = true;
  late List<int> _counts;
  int _completedCount = 0;

  @override
  void initState() {
    super.initState();
    _resetCounts();
  }

  void _resetCounts() {
    final list = _isMorning ? morningAdhkar : eveningAdhkar;
    _counts = List<int>.filled(list.length, 0);
    _completedCount = 0;
  }

  void _switchMode(bool morning) {
    setState(() {
      _isMorning = morning;
      _resetCounts();
    });
  }

  List<Dhikr> get _currentList => _isMorning ? morningAdhkar : eveningAdhkar;

  void _onTap(int index) {
    final dhikr = _currentList[index];
    if (_counts[index] >= dhikr.repeat) return;
    HapticFeedback.lightImpact();
    setState(() {
      _counts[index]++;
      if (_counts[index] >= dhikr.repeat) {
        _completedCount++;
        HapticFeedback.mediumImpact();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;
    final list = _currentList;
    final totalDhikrs = list.length;
    final progress = totalDhikrs == 0 ? 0.0 : _completedCount / totalDhikrs;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: p.fg,
        title: Text(
          l10n.translate('adhkar'),
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: p.muted, size: 22),
            onPressed: () => setState(() => _resetCounts()),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          // Morning/Evening toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: p.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: p.divider),
              ),
              child: Row(
                children: [
                  _TabBtn(
                    label: l10n.translate('morning'),
                    icon: Icons.wb_sunny_outlined,
                    active: _isMorning,
                    color: p.gold,
                    p: p,
                    onTap: () => _switchMode(true),
                  ),
                  _TabBtn(
                    label: l10n.translate('evening'),
                    icon: Icons.nights_stay_outlined,
                    active: !_isMorning,
                    color: p.accent,
                    p: p,
                    onTap: () => _switchMode(false),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Progress
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  '$_completedCount / $totalDhikrs ${l10n.translate('completed')}',
                  style: TextStyle(fontSize: 12, color: p.muted),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 4,
                      backgroundColor: p.divider,
                      valueColor: AlwaysStoppedAnimation(_isMorning ? p.gold : p.accent),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Adhkar list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              itemCount: list.length,
              itemBuilder: (context, i) {
                final dhikr = list[i];
                final count = _counts[i];
                final done = count >= dhikr.repeat;
                final itemProgress = dhikr.repeat == 0 ? 1.0 : count / dhikr.repeat;

                return GestureDetector(
                  onTap: () => _onTap(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: done ? (_isMorning ? p.gold : p.accent).withOpacity(0.08) : p.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: done ? (_isMorning ? p.gold : p.accent).withOpacity(0.3) : p.divider,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Arabic
                        Text(
                          dhikr.arabic,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontSize: 18,
                            color: done ? p.muted : p.fg,
                            height: 1.8,
                            decoration: done ? TextDecoration.lineThrough : null,
                            decorationColor: p.muted.withOpacity(0.3),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Translation
                        Text(
                          l10n.translate(dhikr.translationKey),
                          style: TextStyle(
                            fontSize: 12,
                            color: p.muted,
                            fontStyle: FontStyle.italic,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Counter row
                        Row(
                          children: [
                            // Progress bar
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: LinearProgressIndicator(
                                  value: itemProgress,
                                  minHeight: 4,
                                  backgroundColor: p.divider,
                                  valueColor: AlwaysStoppedAnimation(
                                    done ? (_isMorning ? p.gold : p.accent) : p.accent.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Count badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: done
                                    ? (_isMorning ? p.gold : p.accent)
                                    : p.bg,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                done ? '✓' : '$count / ${dhikr.repeat}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: done ? Colors.white : p.fg,
                                ),
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
          ),
        ],
      ),
    );
  }
}

class _TabBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final Color color;
  final _P p;
  final VoidCallback onTap;
  const _TabBtn({required this.label, required this.icon, required this.active, required this.color, required this.p, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? color.withOpacity(0.12) : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: active ? color : p.muted),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  color: active ? color : p.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
