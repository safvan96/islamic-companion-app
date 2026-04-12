import 'dart:math';
import 'package:flutter/material.dart';
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

const _ayahs = [
  ('\u0625\u0650\u0646\u0651\u064e \u0645\u064e\u0639\u064e \u0627\u0644\u0652\u0639\u064f\u0633\u0652\u0631\u0650 \u064a\u064f\u0633\u0652\u0631\u064b\u0627', 'Verily, with hardship comes ease.', '94:6'),
  ('\u0648\u064e\u0645\u064e\u0646 \u064a\u064e\u062a\u064e\u0648\u064e\u0643\u0651\u064e\u0644\u0652 \u0639\u064e\u0644\u064e\u0649 \u0627\u0644\u0644\u0651\u064e\u0647\u0650 \u0641\u064e\u0647\u064f\u0648\u064e \u062d\u064e\u0633\u0652\u0628\u064f\u0647\u064f', 'Whoever relies upon Allah - then He is sufficient.', '65:3'),
  ('\u0623\u064e\u0644\u064e\u0627 \u0628\u0650\u0630\u0650\u0643\u0652\u0631\u0650 \u0627\u0644\u0644\u0651\u064e\u0647\u0650 \u062a\u064e\u0637\u0652\u0645\u064e\u0626\u0650\u0646\u0651\u064f \u0627\u0644\u0652\u0642\u064f\u0644\u064f\u0648\u0628\u064f', 'In the remembrance of Allah do hearts find rest.', '13:28'),
  ('\u0648\u064e\u0644\u064e\u0633\u064e\u0648\u0652\u0641\u064e \u064a\u064f\u0639\u0652\u0637\u0650\u064a\u0643\u064e \u0631\u064e\u0628\u0651\u064f\u0643\u064e \u0641\u064e\u062a\u064e\u0631\u0652\u0636\u064e\u0649\u0670', 'Your Lord will give you, and you will be satisfied.', '93:5'),
  ('\u0631\u064e\u0628\u0651\u0650 \u0627\u0634\u0652\u0631\u064e\u062d\u0652 \u0644\u0650\u064a \u0635\u064e\u062f\u0652\u0631\u0650\u064a', 'My Lord, expand for me my chest.', '20:25'),
  ('\u062d\u064e\u0633\u0652\u0628\u064f\u0646\u064e\u0627 \u0627\u0644\u0644\u0651\u064e\u0647\u064f \u0648\u064e\u0646\u0650\u0639\u0652\u0645\u064e \u0627\u0644\u0652\u0648\u064e\u0643\u0650\u064a\u0644\u064f', 'Sufficient for us is Allah, the best Disposer.', '3:173'),
];

const _gradients = [
  [Color(0xFF1B5E20), Color(0xFF2E7D32)],
  [Color(0xFF0D47A1), Color(0xFF1565C0)],
  [Color(0xFF4A148C), Color(0xFF6A1B9A)],
  [Color(0xFF37474F), Color(0xFF455A64)],
  [Color(0xFFBF360C), Color(0xFFD84315)],
  [Color(0xFF1A237E), Color(0xFF283593)],
];

class ShareCardScreen extends StatefulWidget {
  const ShareCardScreen({super.key});
  @override
  State<ShareCardScreen> createState() => _ShareCardScreenState();
}

class _ShareCardScreenState extends State<ShareCardScreen> {
  int _ayahIndex = 0;
  int _gradientIndex = 0;

  @override
  void initState() {
    super.initState();
    _ayahIndex = Random().nextInt(_ayahs.length);
    _gradientIndex = Random().nextInt(_gradients.length);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;
    final (arabic, translation, ref) = _ayahs[_ayahIndex];
    final gradient = _gradients[_gradientIndex];

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('shareCard'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)), centerTitle: true),
      body: Column(children: [
        const Spacer(flex: 1),
        // Card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: gradient[0].withOpacity(0.4), blurRadius: 24, offset: const Offset(0, 12))],
            ),
            child: Column(children: [
              Text('"', style: TextStyle(fontSize: 48, color: Colors.white.withOpacity(0.2), height: 0.5)),
              const SizedBox(height: 12),
              Text(arabic, textDirection: TextDirection.rtl, textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 28, color: Colors.white, height: 1.8)),
              const SizedBox(height: 20),
              Container(width: 40, height: 2, color: Colors.white.withOpacity(0.4)),
              const SizedBox(height: 16),
              Text(translation, textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.white.withOpacity(0.9), height: 1.5, fontStyle: FontStyle.italic)),
              const SizedBox(height: 12),
              Text('— Quran $ref', style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.6), fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              Text('Islamic Companion', style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.3), letterSpacing: 2)),
            ]),
          ),
        ),
        const Spacer(flex: 1),
        // Controls
        Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: Row(children: [
          // Change ayah
          Expanded(child: OutlinedButton.icon(
            onPressed: () => setState(() => _ayahIndex = (_ayahIndex + 1) % _ayahs.length),
            icon: Icon(Icons.refresh, size: 16, color: p.accent),
            label: Text(l10n.translate('changeAyah'), style: TextStyle(color: p.accent, fontSize: 12)),
            style: OutlinedButton.styleFrom(side: BorderSide(color: p.divider), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), padding: const EdgeInsets.symmetric(vertical: 10)),
          )),
          const SizedBox(width: 8),
          // Change color
          Expanded(child: OutlinedButton.icon(
            onPressed: () => setState(() => _gradientIndex = (_gradientIndex + 1) % _gradients.length),
            icon: Icon(Icons.palette, size: 16, color: p.gold),
            label: Text(l10n.translate('changeColor'), style: TextStyle(color: p.gold, fontSize: 12)),
            style: OutlinedButton.styleFrom(side: BorderSide(color: p.divider), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), padding: const EdgeInsets.symmetric(vertical: 10)),
          )),
        ])),
        const SizedBox(height: 12),
        // Share
        Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: SizedBox(width: double.infinity, child: ElevatedButton.icon(
          onPressed: () => Share.share('$arabic\n\n$translation\n\n— Quran $ref\n\nIslamic Companion App'),
          icon: const Icon(Icons.share, size: 18),
          label: Text(l10n.translate('shareResult'), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          style: ElevatedButton.styleFrom(backgroundColor: p.accent, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
        ))),
        const SizedBox(height: 20),
      ]),
    );
  }
}
