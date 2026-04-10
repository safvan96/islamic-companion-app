import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';
import '../providers/qaza_provider.dart';

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

class QazaScreen extends StatelessWidget {
  const QazaScreen({super.key});

  static const _prayerIcons = {
    'fajr': Icons.wb_twilight,
    'dhuhr': Icons.wb_sunny,
    'asr': Icons.sunny_snowing,
    'maghrib': Icons.nights_stay_outlined,
    'isha': Icons.dark_mode_outlined,
    'witr': Icons.auto_awesome,
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _Palette.of(isDark);
    final l10n = AppLocalizations.of(context)!;
    final qaza = Provider.of<QazaProvider>(context);

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: p.fg,
        title: Text(
          l10n.translate('qazaTracker'),
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
            icon: Icon(Icons.add_rounded, color: p.fg),
            onPressed: () => _showBulkAddDialog(context, qaza, p, l10n),
            tooltip: l10n.translate('addMissed'),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          // Summary card
          _SummaryCard(p: p, qaza: qaza, l10n: l10n),
          const SizedBox(height: 24),
          // Section label
          Text(
            l10n.translate('prayersList').toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: p.muted,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          // Prayer cards
          ...QazaProvider.prayerKeys.map((key) => _PrayerCard(
                prayerKey: key,
                icon: _prayerIcons[key] ?? Icons.access_time,
                p: p,
                l10n: l10n,
                qaza: qaza,
              )),
        ],
      ),
    );
  }

  void _showBulkAddDialog(
    BuildContext context,
    QazaProvider qaza,
    _Palette p,
    AppLocalizations l10n,
  ) {
    final controllers = {
      for (final key in QazaProvider.prayerKeys) key: TextEditingController(),
    };
    // Quick fill: years calculator
    final yearsCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: p.surface,
          title: Text(
            l10n.translate('addMissed'),
            style: TextStyle(color: p.fg, fontSize: 16),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Quick fill by years
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: p.gold.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: p.gold.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.translate('quickFillYears'),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: p.gold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: yearsCtrl,
                              keyboardType: TextInputType.number,
                              style: TextStyle(color: p.fg),
                              decoration: InputDecoration(
                                hintText: l10n.translate('years'),
                                hintStyle: TextStyle(color: p.muted),
                                isDense: true,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: p.divider),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: p.gold),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: () {
                              final years =
                                  int.tryParse(yearsCtrl.text.trim()) ?? 0;
                              if (years <= 0) return;
                              final perPrayer = years * 365;
                              for (final key in QazaProvider.prayerKeys) {
                                if (key == 'witr') {
                                  controllers[key]!.text =
                                      perPrayer.toString();
                                } else {
                                  controllers[key]!.text =
                                      perPrayer.toString();
                                }
                              }
                              setDialogState(() {});
                            },
                            child: Text(
                              l10n.translate('calculate'),
                              style: TextStyle(color: p.gold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Individual prayer inputs
                ...QazaProvider.prayerKeys.map((key) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextField(
                        controller: controllers[key],
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: p.fg),
                        decoration: InputDecoration(
                          labelText: l10n.translate(key),
                          labelStyle: TextStyle(color: p.muted, fontSize: 13),
                          isDense: true,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: p.divider),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: p.accent),
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.translate('cancel'),
                  style: TextStyle(color: p.muted)),
            ),
            TextButton(
              onPressed: () async {
                for (final key in QazaProvider.prayerKeys) {
                  final amount =
                      int.tryParse(controllers[key]!.text.trim()) ?? 0;
                  if (amount > 0) {
                    await qaza.addMissed(key, amount);
                  }
                }
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child:
                  Text(l10n.translate('add'), style: TextStyle(color: p.accent)),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final _Palette p;
  final QazaProvider qaza;
  final AppLocalizations l10n;
  const _SummaryCard({
    required this.p,
    required this.qaza,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = qaza.totalRemaining;
    final completed = qaza.totalCompleted;
    final total = remaining + completed;
    final progress = total == 0 ? 0.0 : completed / total;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: p.divider),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.translate('remaining').toUpperCase(),
                      style: TextStyle(
                        fontSize: 9,
                        color: p.muted,
                        letterSpacing: 1.4,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _fmt(remaining),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: remaining > 0 ? p.gold : p.accent,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      l10n.translate('madeUp').toUpperCase(),
                      style: TextStyle(
                        fontSize: 9,
                        color: p.muted,
                        letterSpacing: 1.4,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _fmt(completed),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: p.accent,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (total > 0) ...[
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: progress),
                duration: const Duration(milliseconds: 600),
                builder: (_, value, __) => LinearProgressIndicator(
                  value: value,
                  minHeight: 6,
                  backgroundColor: p.divider,
                  valueColor: AlwaysStoppedAnimation(p.accent),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${(progress * 100).toStringAsFixed(1)}% ${l10n.translate('completed')}',
              style: TextStyle(
                fontSize: 11,
                color: p.muted,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _fmt(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return n.toString();
  }
}

class _PrayerCard extends StatelessWidget {
  final String prayerKey;
  final IconData icon;
  final _Palette p;
  final AppLocalizations l10n;
  final QazaProvider qaza;

  const _PrayerCard({
    required this.prayerKey,
    required this.icon,
    required this.p,
    required this.l10n,
    required this.qaza,
  });

  @override
  Widget build(BuildContext context) {
    final count = qaza.counts[prayerKey] ?? 0;
    final isDone = count == 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDone ? p.accent.withOpacity(0.3) : p.divider,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDone
                  ? p.accent.withOpacity(0.1)
                  : p.gold.withOpacity(0.1),
            ),
            child: Icon(
              icon,
              size: 20,
              color: isDone ? p.accent : p.gold,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.translate(prayerKey),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: p.fg,
                  ),
                ),
                if (count > 0)
                  Text(
                    '${_fmt(count)} ${l10n.translate('remaining').toLowerCase()}',
                    style: TextStyle(
                      fontSize: 11,
                      color: p.muted,
                    ),
                  )
                else
                  Text(
                    l10n.translate('allCaughtUp'),
                    style: TextStyle(
                      fontSize: 11,
                      color: p.accent,
                    ),
                  ),
              ],
            ),
          ),
          if (count > 0)
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  qaza.makeUp(prayerKey);
                },
                onLongPress: () => _showEditDialog(context),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: p.accent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '-1',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            )
          else
            Icon(Icons.check_circle, color: p.accent, size: 28),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final ctrl = TextEditingController(
        text: (qaza.counts[prayerKey] ?? 0).toString());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: p.surface,
        title: Text(l10n.translate(prayerKey),
            style: TextStyle(color: p.fg, fontSize: 16)),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          autofocus: true,
          style: TextStyle(color: p.fg, fontSize: 20),
          decoration: InputDecoration(
            labelText: l10n.translate('remaining'),
            labelStyle: TextStyle(color: p.muted),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: p.divider),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: p.accent),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.translate('cancel'),
                style: TextStyle(color: p.muted)),
          ),
          TextButton(
            onPressed: () {
              final val = int.tryParse(ctrl.text.trim()) ?? 0;
              qaza.setCount(prayerKey, val);
              Navigator.pop(ctx);
            },
            child:
                Text(l10n.translate('save'), style: TextStyle(color: p.accent)),
          ),
        ],
      ),
    );
  }

  String _fmt(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return n.toString();
  }
}
