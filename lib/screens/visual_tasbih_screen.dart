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

class VisualTasbihScreen extends StatefulWidget {
  const VisualTasbihScreen({super.key});
  @override
  State<VisualTasbihScreen> createState() => _VisualTasbihScreenState();
}

class _VisualTasbihScreenState extends State<VisualTasbihScreen>
    with SingleTickerProviderStateMixin {
  int _count = 0;
  int _total = 33;
  int _rounds = 0;
  late AnimationController _animCtrl;

  static const _totals = [33, 99, 100, 500, 1000];

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  void _onTap() {
    HapticFeedback.lightImpact();
    _animCtrl.forward().then((_) => _animCtrl.reverse());
    setState(() {
      _count++;
      if (_count >= _total) {
        _rounds++;
        _count = 0;
        HapticFeedback.heavyImpact();
      }
    });
  }

  void _reset() => setState(() { _count = 0; _rounds = 0; });

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;
    final progress = _total == 0 ? 0.0 : _count / _total;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('visualTasbih'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.refresh_rounded, color: p.muted, size: 20), onPressed: _reset),
          const SizedBox(width: 4),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _onTap,
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 1),
              // Bead circle
              SizedBox(
                width: 300,
                height: 300,
                child: CustomPaint(
                  painter: _BeadPainter(
                    total: _total > 33 ? 33 : _total,
                    filled: _count % (_total > 33 ? 33 : _total),
                    beadColor: p.gold,
                    emptyColor: p.divider,
                    stringColor: p.muted.withOpacity(0.3),
                  ),
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _animCtrl,
                      builder: (_, __) => Transform.scale(
                        scale: 1.0 - _animCtrl.value * 0.05,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$_count',
                              style: TextStyle(fontSize: 64, fontWeight: FontWeight.w200, color: p.fg, letterSpacing: -2),
                            ),
                            Text('/ $_total', style: TextStyle(fontSize: 14, color: p.muted)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Rounds
              if (_rounds > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(color: p.gold.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.loop, size: 14, color: p.gold),
                    const SizedBox(width: 6),
                    Text('$_rounds ${l10n.translate('rounds')}', style: TextStyle(fontSize: 13, color: p.gold, fontWeight: FontWeight.w600)),
                  ]),
                ),
              const Spacer(flex: 1),
              // Progress bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(value: progress, minHeight: 5, backgroundColor: p.divider, valueColor: AlwaysStoppedAnimation(p.gold)),
                ),
              ),
              const SizedBox(height: 20),
              // Target selector
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Wrap(
                  spacing: 8,
                  children: _totals.map((t) {
                    final active = t == _total;
                    return ChoiceChip(
                      label: Text('$t'),
                      selected: active,
                      onSelected: (_) => setState(() { _total = t; _count = 0; _rounds = 0; }),
                      selectedColor: p.gold,
                      backgroundColor: p.surface,
                      side: BorderSide(color: p.divider),
                      labelStyle: TextStyle(color: active ? Colors.white : p.fg, fontWeight: FontWeight.w500, fontSize: 13),
                      showCheckmark: false,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
              Text(l10n.translate('tapAnywhere'), style: TextStyle(fontSize: 10, color: p.muted.withOpacity(0.6), letterSpacing: 1.5)),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _BeadPainter extends CustomPainter {
  final int total;
  final int filled;
  final Color beadColor;
  final Color emptyColor;
  final Color stringColor;

  _BeadPainter({required this.total, required this.filled, required this.beadColor, required this.emptyColor, required this.stringColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;
    final beadRadius = total <= 33 ? 8.0 : 6.0;

    // Draw string circle
    final stringPaint = Paint()..color = stringColor..style = PaintingStyle.stroke..strokeWidth = 1.5;
    canvas.drawCircle(center, radius, stringPaint);

    // Draw beads
    for (int i = 0; i < total; i++) {
      final angle = -pi / 2 + (2 * pi * i / total);
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      final isFilled = i < filled;

      final paint = Paint()
        ..color = isFilled ? beadColor : emptyColor
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), beadRadius, paint);

      // Border
      if (isFilled) {
        final borderPaint = Paint()
          ..color = beadColor.withOpacity(0.6)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
        canvas.drawCircle(Offset(x, y), beadRadius + 1, borderPaint);
      }
    }

    // Draw marker bead at top (larger, different style)
    final markerPaint = Paint()..color = beadColor..style = PaintingStyle.fill;
    final markerPos = Offset(center.dx, center.dy - radius);
    canvas.drawCircle(markerPos, beadRadius + 3, markerPaint);
    final markerBorder = Paint()..color = beadColor.withOpacity(0.4)..style = PaintingStyle.stroke..strokeWidth = 2;
    canvas.drawCircle(markerPos, beadRadius + 5, markerBorder);
  }

  @override
  bool shouldRepaint(covariant _BeadPainter oldDelegate) =>
      oldDelegate.filled != filled || oldDelegate.total != total;
}
