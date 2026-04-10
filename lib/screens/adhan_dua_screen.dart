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

const _adhanDua = 'اللَّهُمَّ رَبَّ هٰذِهِ الدَّعْوَةِ التَّامَّةِ وَالصَّلَاةِ الْقَائِمَةِ آتِ مُحَمَّدًا الْوَسِيلَةَ وَالْفَضِيلَةَ وَابْعَثْهُ مَقَامًا مَحْمُودًا الَّذِي وَعَدْتَهُ';

class AdhanDuaScreen extends StatelessWidget {
  const AdhanDuaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('adhanDua'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)), centerTitle: true),
      body: ListView(padding: const EdgeInsets.fromLTRB(20, 0, 20, 32), children: [
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: p.accent.withOpacity(0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: p.accent.withOpacity(0.2))),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.info_outline, color: p.accent, size: 18), const SizedBox(width: 10),
            Expanded(child: Text(l10n.translate('adhanDuaInfo'), style: TextStyle(fontSize: 12, color: p.muted, height: 1.5)))])),
        const SizedBox(height: 20),

        // Step 1: Repeat after muezzin
        _step(p, l10n, '1', 'adhanStep1', Icons.hearing, l10n.translate('adhanStep1Desc')),
        const SizedBox(height: 10),
        // Step 2: Salawat
        _step(p, l10n, '2', 'adhanStep2', Icons.favorite, l10n.translate('adhanStep2Desc')),
        const SizedBox(height: 10),
        // Step 3: Dua
        _step(p, l10n, '3', 'adhanStep3', Icons.front_hand, null),
        const SizedBox(height: 16),

        // Main dua
        Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: p.gold.withOpacity(0.3))),
          child: Column(children: [
            Text(_adhanDua, textDirection: TextDirection.rtl, textAlign: TextAlign.center, style: TextStyle(fontSize: 20, color: p.fg, height: 1.9)),
            const SizedBox(height: 16),
            Container(width: 30, height: 2, color: p.gold),
            const SizedBox(height: 16),
            Text(l10n.translate('adhanDuaTranslation'), textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: p.muted, fontStyle: FontStyle.italic, height: 1.5)),
            const SizedBox(height: 4),
            Text('— Sahih al-Bukhari', style: TextStyle(fontSize: 11, color: p.gold, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              IconButton(onPressed: () { Clipboard.setData(ClipboardData(text: '$_adhanDua\n\n${l10n.translate('adhanDuaTranslation')}')); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied'), duration: Duration(seconds: 1))); },
                icon: Icon(Icons.copy, color: p.muted, size: 20)),
              const SizedBox(width: 12),
              IconButton(onPressed: () => Share.share('$_adhanDua\n\n${l10n.translate('adhanDuaTranslation')}\n\nIslamic Companion App'),
                icon: Icon(Icons.share_outlined, color: p.muted, size: 20)),
            ]),
          ])),
        const SizedBox(height: 20),

        // Reward
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: p.gold.withOpacity(0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: p.gold.withOpacity(0.2))),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.star, color: p.gold, size: 18), const SizedBox(width: 10),
            Expanded(child: Text(l10n.translate('adhanReward'), style: TextStyle(fontSize: 12, color: p.muted, height: 1.5)))])),
      ]),
    );
  }

  Widget _step(_P p, AppLocalizations l10n, String num, String titleKey, IconData icon, String? desc) => Container(
    padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: p.divider)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(width: 28, height: 28, decoration: BoxDecoration(shape: BoxShape.circle, color: p.accent.withOpacity(0.15), border: Border.all(color: p.accent, width: 1.5)),
          child: Center(child: Text(num, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: p.accent)))),
        const SizedBox(width: 10),
        Icon(icon, size: 16, color: p.accent),
        const SizedBox(width: 8),
        Expanded(child: Text(l10n.translate(titleKey), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: p.fg))),
      ]),
      if (desc != null) ...[const SizedBox(height: 6), Padding(padding: const EdgeInsets.only(left: 46), child: Text(desc, style: TextStyle(fontSize: 12, color: p.muted, height: 1.4)))],
    ]),
  );
}
