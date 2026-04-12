import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';

class _P {
  final Color bg, surface, accent, gold, fg, muted, divider;
  const _P({required this.bg, required this.surface, required this.accent, required this.gold, required this.fg, required this.muted, required this.divider});
  static _P of(bool d) => d
      ? const _P(bg: Color(0xFF0E1A19), surface: Color(0xFF182624), accent: Color(0xFF4FBFA8), gold: Color(0xFFE3C77B), fg: Color(0xFFF5F1E8), muted: Color(0xFF8B968F), divider: Color(0xFF243532))
      : const _P(bg: Color(0xFFF8F5EE), surface: Color(0xFFFFFFFF), accent: Color(0xFF2C7A6B), gold: Color(0xFFB8902B), fg: Color(0xFF1F2937), muted: Color(0xFF6B6359), divider: Color(0xFFE8DDD0));
}

const _istikharaDua = 'اللَّهُمَّ إِنِّي أَسْتَخِيرُكَ بِعِلْمِكَ وَأَسْتَقْدِرُكَ بِقُدْرَتِكَ وَأَسْأَلُكَ مِنْ فَضْلِكَ الْعَظِيمِ فَإِنَّكَ تَقْدِرُ وَلَا أَقْدِرُ وَتَعْلَمُ وَلَا أَعْلَمُ وَأَنْتَ عَلَّامُ الْغُيُوبِ اللَّهُمَّ إِنْ كُنْتَ تَعْلَمُ أَنَّ هٰذَا الْأَمْرَ خَيْرٌ لِي فِي دِينِي وَمَعَاشِي وَعَاقِبَةِ أَمْرِي فَاقْدُرْهُ لِي وَيَسِّرْهُ لِي ثُمَّ بَارِكْ لِي فِيهِ وَإِنْ كُنْتَ تَعْلَمُ أَنَّ هٰذَا الْأَمْرَ شَرٌّ لِي فِي دِينِي وَمَعَاشِي وَعَاقِبَةِ أَمْرِي فَاصْرِفْهُ عَنِّي وَاصْرِفْنِي عَنْهُ وَاقْدُرْ لِيَ الْخَيْرَ حَيْثُ كَانَ ثُمَّ أَرْضِنِي بِهِ';

class IstikharaScreen extends StatelessWidget {
  const IstikharaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;

    final steps = [
      {'icon': Icons.clean_hands, 'key': 'istikhara_s1'},
      {'icon': Icons.access_time, 'key': 'istikhara_s2'},
      {'icon': Icons.mosque, 'key': 'istikhara_s3'},
      {'icon': Icons.menu_book, 'key': 'istikhara_s4'},
      {'icon': Icons.front_hand, 'key': 'istikhara_s5'},
      {'icon': Icons.favorite, 'key': 'istikhara_s6'},
    ];

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('istikharaGuide'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          // Info card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: p.gold.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: p.gold.withOpacity(0.2)),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.info_outline, color: p.gold, size: 18),
              const SizedBox(width: 10),
              Expanded(child: Text(l10n.translate('istikharaInfo'), style: TextStyle(fontSize: 12, color: p.muted, height: 1.5))),
            ]),
          ),
          const SizedBox(height: 20),

          // Steps
          Text(l10n.translate('steps').toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: p.muted, letterSpacing: 1.4)),
          const SizedBox(height: 12),
          ...List.generate(steps.length, (i) {
            final step = steps[i];
            final isLast = i == steps.length - 1;
            return IntrinsicHeight(child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(width: 36, child: Column(children: [
                Container(width: 28, height: 28, decoration: BoxDecoration(shape: BoxShape.circle, color: p.accent.withOpacity(0.15), border: Border.all(color: p.accent, width: 1.5)),
                  child: Center(child: Text('${i + 1}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: p.accent)))),
                if (!isLast) Expanded(child: Container(width: 2, margin: const EdgeInsets.symmetric(vertical: 4), color: p.divider)),
              ])),
              const SizedBox(width: 10),
              Expanded(child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: p.divider)),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Icon(step['icon'] as IconData, size: 18, color: p.accent),
                  const SizedBox(width: 10),
                  Expanded(child: Text(l10n.translate(step['key'] as String), style: TextStyle(fontSize: 13, color: p.fg, height: 1.5))),
                ]),
              )),
            ]));
          }),
          const SizedBox(height: 20),

          // Dua
          Text(l10n.translate('istikharaDua').toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: p.muted, letterSpacing: 1.4)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: p.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: p.gold.withOpacity(0.3)),
            ),
            child: Column(children: [
              Text(
                _istikharaDua,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: p.fg, height: 1.9),
              ),
              const SizedBox(height: 16),
              Divider(color: p.divider),
              const SizedBox(height: 12),
              Text(
                l10n.translate('istikharaDuaTranslation'),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: p.muted, height: 1.5, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: '$_istikharaDua\n\n${l10n.translate('istikharaDuaTranslation')}'));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.translate('copied')), duration: const Duration(seconds: 1)));
                  },
                  icon: Icon(Icons.copy, color: p.muted, size: 20)),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: () => Share.share('$_istikharaDua\n\n${l10n.translate('istikharaDuaTranslation')}\n\nIslamic Companion App'),
                  icon: Icon(Icons.share_outlined, color: p.muted, size: 20)),
              ]),
            ]),
          ),
        ],
      ),
    );
  }
}
