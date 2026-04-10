import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/dhikr_provider.dart';
import '../providers/app_provider.dart';

// Color palette — calm, modern, Islamic-inspired
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

class DhikrScreen extends StatefulWidget {
  const DhikrScreen({super.key});

  @override
  State<DhikrScreen> createState() => _DhikrScreenState();
}

class _DhikrScreenState extends State<DhikrScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _onTap(DhikrProvider provider) async {
    if (provider.hapticEnabled) HapticFeedback.lightImpact();
    _pulseController.forward().then((_) => _pulseController.reverse());
    await provider.increment();
    if (!mounted) return;
    if (provider.justReachedTarget) {
      provider.markTargetCelebrated();
      if (provider.hapticEnabled) {
        HapticFeedback.heavyImpact();
        await Future.delayed(const Duration(milliseconds: 80));
        if (!mounted) return;
        HapticFeedback.heavyImpact();
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      final l10n = AppLocalizations.of(context)!;
      final p = _Palette.of(
          Provider.of<AppProvider>(context, listen: false).isDarkMode);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          backgroundColor: p.gold,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                '${l10n.translate('target')} ${provider.targetCount} ✓',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  void _openSheet(DhikrProvider provider, _Palette p) {
    showModalBottomSheet(
      context: context,
      backgroundColor: p.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => _DhikrSheet(provider: provider, palette: p),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dhikrProvider = Provider.of<DhikrProvider>(context);
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _Palette.of(isDark);
    final currentDhikr =
        DhikrProvider.dhikrList[dhikrProvider.selectedDhikrIndex];
    final progress =
        (dhikrProvider.count / dhikrProvider.targetCount).clamp(0.0, 1.0);
    final reached = dhikrProvider.targetReached;
    final ringColor = reached ? p.gold : p.accent;

    return Scaffold(
      backgroundColor: p.bg,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: p.fg,
        title: Text(
          l10n.translate('dhikr'),
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
            icon: Icon(Icons.tune_rounded, color: p.fg),
            onPressed: () => _openSheet(dhikrProvider, p),
            tooltip: 'Options',
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onTap(dhikrProvider),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const Spacer(flex: 3),
                // Arabic text
                Text(
                  currentDhikr['arabic']!,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w500,
                    color: p.fg,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  currentDhikr['transliteration']!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: p.muted,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  currentDhikr['meaning']!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: p.muted.withOpacity(0.75),
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const Spacer(flex: 2),
                // Counter ring
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, _) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: SizedBox(
                        width: 260,
                        height: 260,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 260,
                              height: 260,
                              child: TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0, end: progress),
                                duration: const Duration(milliseconds: 350),
                                curve: Curves.easeOutCubic,
                                builder: (_, value, __) =>
                                    CircularProgressIndicator(
                                  value: value,
                                  strokeWidth: 5,
                                  strokeCap: StrokeCap.round,
                                  backgroundColor: p.divider,
                                  valueColor:
                                      AlwaysStoppedAnimation(ringColor),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  dhikrProvider.count.toString(),
                                  style: TextStyle(
                                    fontSize: 92,
                                    fontWeight: FontWeight.w200,
                                    color: p.fg,
                                    height: 1.0,
                                    letterSpacing: -3,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '/ ${dhikrProvider.targetCount}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: p.muted,
                                    fontWeight: FontWeight.w400,
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
                const Spacer(flex: 3),
                // Bottom strip — today + reset
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _MiniStat(
                      label: l10n.translate('today').toUpperCase(),
                      value: dhikrProvider.todayCount.toString(),
                      palette: p,
                    ),
                    _MiniStat(
                      label: l10n.translate('total').toUpperCase(),
                      value: _formatNumber(dhikrProvider.totalCount),
                      palette: p,
                    ),
                    InkResponse(
                      onTap: () => dhikrProvider.reset(),
                      radius: 28,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.refresh_rounded,
                          color: p.muted,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
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
            ),
          ),
        ),
      ),
    );
  }

  static String _formatNumber(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return n.toString();
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final _Palette palette;
  const _MiniStat({
    required this.label,
    required this.value,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            color: palette.muted,
            letterSpacing: 1.4,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: palette.fg,
            height: 1.0,
          ),
        ),
      ],
    );
  }
}

// ─── Bottom sheet ────────────────────────────────────────────────────────────

class _DhikrSheet extends StatelessWidget {
  final DhikrProvider provider;
  final _Palette palette;
  const _DhikrSheet({required this.provider, required this.palette});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollCtrl) => ListView(
        controller: scrollCtrl,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: palette.divider,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _SectionTitle(l10n.translate('chooseDhikr'), palette),
          const SizedBox(height: 8),
          ...List.generate(DhikrProvider.dhikrList.length, (i) {
            final d = DhikrProvider.dhikrList[i];
            final selected = i == provider.selectedDhikrIndex;
            final lifetime = provider.perDhikrCounts[i];
            return _DhikrTile(
              arabic: d['arabic']!,
              name: d['transliteration']!,
              meaning: d['meaning']!,
              lifetime: lifetime,
              selected: selected,
              palette: palette,
              onTap: () {
                provider.selectDhikr(i);
                Navigator.pop(context);
              },
              onLongPress: lifetime == 0
                  ? null
                  : () => _confirmReset(context, i, d['transliteration']!),
            );
          }),
          const SizedBox(height: 24),
          _SectionTitle(l10n.translate('target'), palette),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: [33, 99, 100, 500, 1000].map((t) {
              final active = provider.targetCount == t;
              return ChoiceChip(
                label: Text(t.toString()),
                selected: active,
                onSelected: (_) => provider.setTarget(t),
                selectedColor: palette.accent,
                backgroundColor: palette.bg,
                side: BorderSide(color: palette.divider),
                labelStyle: TextStyle(
                  color: active ? Colors.white : palette.fg,
                  fontWeight: FontWeight.w500,
                ),
                showCheckmark: false,
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          _SectionTitle(l10n.translate('thisWeek'), palette),
          const SizedBox(height: 12),
          _Last7DaysChart(data: provider.last7Days, palette: palette),
          const SizedBox(height: 24),
          _SectionTitle(l10n.translate('settings'), palette),
          const SizedBox(height: 4),
          SwitchListTile(
            value: provider.hapticEnabled,
            onChanged: provider.setHapticEnabled,
            activeColor: palette.accent,
            contentPadding: EdgeInsets.zero,
            title: Text(
              l10n.translate('hapticFeedback'),
              style: TextStyle(color: palette.fg, fontSize: 14),
            ),
            secondary: Icon(Icons.vibration, color: palette.muted, size: 20),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context, int index, String name) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: palette.surface,
        title: Text(name, style: TextStyle(color: palette.fg)),
        content: Text(
          'Reset lifetime count (${provider.perDhikrCounts[index]})?',
          style: TextStyle(color: palette.muted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(AppLocalizations.of(context)!.translate('cancel'),
                style: TextStyle(color: palette.muted)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(AppLocalizations.of(context)!.translate('reset'),
                style: TextStyle(color: palette.gold)),
          ),
        ],
      ),
    );
    if (ok == true) await provider.resetLifetimeFor(index);
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final _Palette palette;
  const _SectionTitle(this.title, this.palette);

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: palette.muted,
        letterSpacing: 1.4,
      ),
    );
  }
}

class _DhikrTile extends StatelessWidget {
  final String arabic;
  final String name;
  final String meaning;
  final int lifetime;
  final bool selected;
  final _Palette palette;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const _DhikrTile({
    required this.arabic,
    required this.name,
    required this.meaning,
    required this.lifetime,
    required this.selected,
    required this.palette,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: selected ? palette.accent.withOpacity(0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected ? palette.accent : palette.divider,
          width: selected ? 1.4 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        arabic,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontSize: 18,
                          color: palette.fg,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 13,
                          color: palette.fg,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        meaning,
                        style: TextStyle(
                          fontSize: 11,
                          color: palette.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                if (lifetime > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: palette.bg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _DhikrScreenState._formatNumber(lifetime),
                      style: TextStyle(
                        fontSize: 12,
                        color: palette.muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Last7DaysChart extends StatelessWidget {
  final List<MapEntry<String, int>> data;
  final _Palette palette;
  const _Last7DaysChart({required this.data, required this.palette});

  @override
  Widget build(BuildContext context) {
    final maxVal =
        data.map((e) => e.value).fold<int>(0, (p, c) => c > p ? c : p);
    const dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final today = DateTime.now().weekday; // 1..7

    return SizedBox(
      height: 96,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(data.length, (i) {
          final v = data[i].value;
          final ratio = maxVal == 0 ? 0.0 : v / maxVal;
          final isToday = i == data.length - 1;
          // weekday for label: today's weekday minus (6 - i)
          final wd = ((today - 1 - (6 - i)) % 7 + 7) % 7;
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  v == 0 ? '' : v.toString(),
                  style: TextStyle(fontSize: 9, color: palette.muted),
                ),
                const SizedBox(height: 4),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: (ratio * 56).clamp(3.0, 56.0),
                  decoration: BoxDecoration(
                    color: isToday
                        ? palette.accent
                        : palette.accent.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  dayLabels[wd],
                  style: TextStyle(
                    fontSize: 10,
                    color: isToday ? palette.accent : palette.muted,
                    fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
