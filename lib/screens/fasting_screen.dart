import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';
import '../providers/fasting_provider.dart';

class _P {
  final Color bg, surface, accent, gold, fg, muted, divider;
  const _P({required this.bg, required this.surface, required this.accent, required this.gold, required this.fg, required this.muted, required this.divider});
  static _P of(bool d) => d
      ? const _P(bg: Color(0xFF0E1A19), surface: Color(0xFF182624), accent: Color(0xFF4FBFA8), gold: Color(0xFFE3C77B), fg: Color(0xFFF5F1E8), muted: Color(0xFF8B968F), divider: Color(0xFF243532))
      : const _P(bg: Color(0xFFF8F5EE), surface: Color(0xFFFFFFFF), accent: Color(0xFF2C7A6B), gold: Color(0xFFB8902B), fg: Color(0xFF1F2937), muted: Color(0xFF6B6359), divider: Color(0xFFE8DDD0));
}

class FastingScreen extends StatefulWidget {
  const FastingScreen({super.key});
  @override
  State<FastingScreen> createState() => _FastingScreenState();
}

class _FastingScreenState extends State<FastingScreen> {
  late DateTime _viewMonth;
  String _selectedType = 'voluntary';

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _viewMonth = DateTime(now.year, now.month);
  }

  void _prevMonth() => setState(() => _viewMonth = DateTime(_viewMonth.year, _viewMonth.month - 1));
  void _nextMonth() => setState(() => _viewMonth = DateTime(_viewMonth.year, _viewMonth.month + 1));

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;
    final fasting = Provider.of<FastingProvider>(context);

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: p.fg,
        title: Text(
          l10n.translate('fastingTracker'),
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          // Stats row
          _StatsRow(p: p, l10n: l10n, fasting: fasting),
          const SizedBox(height: 20),

          // Fast type selector
          _TypeSelector(
            p: p,
            l10n: l10n,
            selected: _selectedType,
            onChanged: (t) => setState(() => _selectedType = t),
          ),
          const SizedBox(height: 20),

          // Calendar
          _CalendarView(
            p: p,
            l10n: l10n,
            fasting: fasting,
            viewMonth: _viewMonth,
            selectedType: _selectedType,
            onPrevMonth: _prevMonth,
            onNextMonth: _nextMonth,
          ),
          const SizedBox(height: 20),

          // Sunnah fasting info
          _SunnahInfo(p: p, l10n: l10n),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final _P p;
  final AppLocalizations l10n;
  final FastingProvider fasting;
  const _StatsRow({required this.p, required this.l10n, required this.fasting});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCard(p: p, label: l10n.translate('total'), value: fasting.totalFasts.toString(), color: p.accent),
        const SizedBox(width: 8),
        _StatCard(p: p, label: l10n.translate('ramadanShort'), value: fasting.ramadanFasts.toString(), color: p.gold),
        const SizedBox(width: 8),
        _StatCard(p: p, label: l10n.translate('voluntaryShort'), value: fasting.voluntaryFasts.toString(), color: p.accent),
        const SizedBox(width: 8),
        _StatCard(p: p, label: l10n.translate('streak'), value: '${fasting.currentStreak}', color: Colors.orange),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final _P p;
  final String label, value;
  final Color color;
  const _StatCard({required this.p, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          color: p.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: p.divider),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: color)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 8, color: p.muted, fontWeight: FontWeight.w600, letterSpacing: 0.8), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

class _TypeSelector extends StatelessWidget {
  final _P p;
  final AppLocalizations l10n;
  final String selected;
  final ValueChanged<String> onChanged;
  const _TypeSelector({required this.p, required this.l10n, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const types = ['ramadan', 'voluntary', 'makeup'];
    final labels = {
      'ramadan': l10n.translate('ramadanShort'),
      'voluntary': l10n.translate('voluntaryShort'),
      'makeup': l10n.translate('makeupFast'),
    };
    final colors = {'ramadan': p.gold, 'voluntary': p.accent, 'makeup': Colors.orange};

    return Row(
      children: types.map((t) {
        final active = t == selected;
        final color = colors[t] ?? p.accent;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(t),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: active ? color.withOpacity(0.15) : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: active ? color : p.divider),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 8, height: 8,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    labels[t] ?? t,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                      color: active ? color : p.muted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _CalendarView extends StatelessWidget {
  final _P p;
  final AppLocalizations l10n;
  final FastingProvider fasting;
  final DateTime viewMonth;
  final String selectedType;
  final VoidCallback onPrevMonth, onNextMonth;

  const _CalendarView({
    required this.p, required this.l10n, required this.fasting,
    required this.viewMonth, required this.selectedType,
    required this.onPrevMonth, required this.onNextMonth,
  });

  static const _dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  static const _monthNames = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  static const _typeColors = {'ramadan': Color(0xFFE3C77B), 'voluntary': Color(0xFF4FBFA8), 'makeup': Color(0xFFFF9800)};

  @override
  Widget build(BuildContext context) {
    final year = viewMonth.year;
    final month = viewMonth.month;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final firstWeekday = DateTime(year, month, 1).weekday; // 1=Mon
    final today = DateTime.now();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: p.divider),
      ),
      child: Column(
        children: [
          // Month nav
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(icon: Icon(Icons.chevron_left, color: p.fg), onPressed: onPrevMonth),
              Text(
                '${_monthNames[month]} $year',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: p.fg),
              ),
              IconButton(icon: Icon(Icons.chevron_right, color: p.fg), onPressed: onNextMonth),
            ],
          ),
          const SizedBox(height: 8),
          // Day headers
          Row(
            children: _dayLabels.map((d) => Expanded(
              child: Center(child: Text(d, style: TextStyle(fontSize: 10, color: p.muted, fontWeight: FontWeight.w600))),
            )).toList(),
          ),
          const SizedBox(height: 6),
          // Days grid
          ...List.generate(6, (week) {
            return Row(
              children: List.generate(7, (dow) {
                final dayNum = week * 7 + dow + 1 - (firstWeekday - 1);
                if (dayNum < 1 || dayNum > daysInMonth) {
                  return const Expanded(child: SizedBox(height: 40));
                }
                final date = DateTime(year, month, dayNum);
                final fastType = fasting.getFastType(date);
                final isToday = date.year == today.year && date.month == today.month && date.day == today.day;
                final isFuture = date.isAfter(today);
                final color = fastType != null ? (_typeColors[fastType] ?? p.accent) : null;

                return Expanded(
                  child: GestureDetector(
                    onTap: isFuture ? null : () {
                      HapticFeedback.lightImpact();
                      if (fastType != null) {
                        fasting.removeFast(date);
                      } else {
                        fasting.setFast(date, selectedType);
                      }
                    },
                    child: Container(
                      height: 40,
                      margin: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: color?.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: isToday ? Border.all(color: p.accent, width: 1.5) : null,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              dayNum.toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: isFuture ? p.muted.withOpacity(0.4) : (color ?? p.fg),
                                fontWeight: fastType != null ? FontWeight.w700 : FontWeight.w400,
                              ),
                            ),
                            if (fastType != null)
                              Container(
                                width: 4, height: 4,
                                margin: const EdgeInsets.only(top: 1),
                                decoration: BoxDecoration(shape: BoxShape.circle, color: color),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            );
          }),
        ],
      ),
    );
  }
}

class _SunnahInfo extends StatelessWidget {
  final _P p;
  final AppLocalizations l10n;
  const _SunnahInfo({required this.p, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: p.gold.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: p.gold.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: p.gold, size: 16),
              const SizedBox(width: 8),
              Text(
                l10n.translate('sunnahFasting'),
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: p.gold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _infoRow(l10n.translate('mondayThursday'), p),
          _infoRow(l10n.translate('whitedays'), p),
          _infoRow(l10n.translate('ashura'), p),
          _infoRow(l10n.translate('arafah'), p),
        ],
      ),
    );
  }

  Widget _infoRow(String text, _P p) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(color: p.muted, fontSize: 12)),
          Expanded(child: Text(text, style: TextStyle(color: p.muted, fontSize: 12, height: 1.3))),
        ],
      ),
    );
  }
}
