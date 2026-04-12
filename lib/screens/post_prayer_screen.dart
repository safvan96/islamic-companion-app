import 'package:flutter/material.dart';
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

class _Step {
  final String titleKey, arabic, descKey;
  final IconData icon;
  final int? repeat;
  const _Step(this.titleKey, this.arabic, this.descKey, this.icon, {this.repeat});
}

const _steps = [
  _Step('pp_istighfar', '\u0623\u0633\u062a\u063a\u0641\u0631 \u0627\u0644\u0644\u0647', 'pp_istighfar_desc', Icons.self_improvement, repeat: 3),
  _Step('pp_allahumma', '\u0627\u0644\u0644\u0647\u0645 \u0623\u0646\u062a \u0627\u0644\u0633\u0644\u0627\u0645 \u0648\u0645\u0646\u0643 \u0627\u0644\u0633\u0644\u0627\u0645 \u062a\u0628\u0627\u0631\u0643\u062a \u064a\u0627 \u0630\u0627 \u0627\u0644\u062c\u0644\u0627\u0644 \u0648\u0627\u0644\u0625\u0643\u0631\u0627\u0645', 'pp_allahumma_desc', Icons.star),
  _Step('pp_ayatul_kursi', '\u0627\u0644\u0644\u0647 \u0644\u0627 \u0625\u0644\u0647 \u0625\u0644\u0627 \u0647\u0648 \u0627\u0644\u062d\u064a \u0627\u0644\u0642\u064a\u0648\u0645...', 'pp_ayatul_kursi_desc', Icons.menu_book),
  _Step('pp_subhanallah', '\u0633\u0628\u062d\u0627\u0646 \u0627\u0644\u0644\u0647', 'pp_subhanallah_desc', Icons.touch_app, repeat: 33),
  _Step('pp_alhamdulillah', '\u0627\u0644\u062d\u0645\u062f \u0644\u0644\u0647', 'pp_alhamdulillah_desc', Icons.touch_app, repeat: 33),
  _Step('pp_allahuakbar', '\u0627\u0644\u0644\u0647 \u0623\u0643\u0628\u0631', 'pp_allahuakbar_desc', Icons.touch_app, repeat: 34),
  _Step('pp_lailaha', '\u0644\u0627 \u0625\u0644\u0647 \u0625\u0644\u0627 \u0627\u0644\u0644\u0647 \u0648\u062d\u062f\u0647 \u0644\u0627 \u0634\u0631\u064a\u0643 \u0644\u0647 \u0644\u0647 \u0627\u0644\u0645\u0644\u0643 \u0648\u0644\u0647 \u0627\u0644\u062d\u0645\u062f \u0648\u0647\u0648 \u0639\u0644\u0649 \u0643\u0644 \u0634\u064a\u0621 \u0642\u062f\u064a\u0631', 'pp_lailaha_desc', Icons.auto_awesome),
  _Step('pp_dua', '', 'pp_dua_desc', Icons.front_hand),
];

class PostPrayerScreen extends StatelessWidget {
  const PostPrayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('postPrayer'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)), centerTitle: true),
      body: ListView(padding: const EdgeInsets.fromLTRB(20, 0, 20, 32), children: [
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: p.accent.withOpacity(0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: p.accent.withOpacity(0.2))),
          child: Row(children: [Icon(Icons.info_outline, color: p.accent, size: 18), const SizedBox(width: 10),
            Expanded(child: Text(l10n.translate('postPrayerInfo'), style: TextStyle(fontSize: 12, color: p.muted, height: 1.5)))])),
        const SizedBox(height: 16),
        ...List.generate(_steps.length, (i) {
          final s = _steps[i];
          final isLast = i == _steps.length - 1;
          return IntrinsicHeight(child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(width: 36, child: Column(children: [
              Container(width: 28, height: 28, decoration: BoxDecoration(shape: BoxShape.circle, color: p.gold.withOpacity(0.15), border: Border.all(color: p.gold, width: 1.5)),
                child: Center(child: Text('${i + 1}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: p.gold)))),
              if (!isLast) Expanded(child: Container(width: 2, margin: const EdgeInsets.symmetric(vertical: 4), color: p.divider)),
            ])),
            const SizedBox(width: 10),
            Expanded(child: Container(
              margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: p.divider)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Icon(s.icon, size: 16, color: p.gold), const SizedBox(width: 8),
                  Expanded(child: Text(l10n.translate(s.titleKey), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: p.fg))),
                  if (s.repeat != null) Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: p.accent.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                    child: Text('x${s.repeat}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: p.accent))),
                ]),
                if (s.arabic.isNotEmpty) ...[const SizedBox(height: 8),
                  Text(s.arabic, textDirection: TextDirection.rtl, style: TextStyle(fontSize: 16, color: p.fg, height: 1.6))],
                const SizedBox(height: 6),
                Text(l10n.translate(s.descKey), style: TextStyle(fontSize: 12, color: p.muted, height: 1.4)),
              ]),
            )),
          ]));
        }),
      ]),
    );
  }
}
