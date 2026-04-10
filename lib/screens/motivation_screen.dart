import 'dart:math';
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

const _quotes = [
  ('مَنْ جَدَّ وَجَدَ', 'motivation_1', 'Hadith'),
  ('إِذَا أَرَادَ اللّٰهُ بِقَوْمٍ خَيْرًا أَدْخَلَ عَلَيْهِمُ الرِّفْقَ', 'motivation_2', 'Hadith'),
  ('التَّأَنِّي مِنَ اللّٰهِ وَالْعَجَلَةُ مِنَ الشَّيْطَانِ', 'motivation_3', 'Hadith'),
  ('مَا قَلَّ وَكَفَى خَيْرٌ مِمَّا كَثُرَ وَأَلْهَى', 'motivation_4', 'Hadith'),
  ('الْمُؤْمِنُ مِرْآةُ الْمُؤْمِنِ', 'motivation_5', 'Hadith'),
  ('كُلُّ مَعْرُوفٍ صَدَقَةٌ', 'motivation_6', 'Hadith'),
  ('خَيْرُ النَّاسِ أَنْفَعُهُمْ لِلنَّاسِ', 'motivation_7', 'Hadith'),
  ('الْيَدُ الْعُلْيَا خَيْرٌ مِنَ الْيَدِ السُّفْلَى', 'motivation_8', 'Hadith'),
  ('إ��نَّ اللّٰهَ جَمِيلٌ يُحِبُّ الْجَمَالَ', 'motivation_9', 'Hadith'),
  ('الدُّنْيَا مَزْرَعَةُ الْآخِرَةِ', 'motivation_10', 'Saying'),
];

class MotivationScreen extends StatefulWidget {
  const MotivationScreen({super.key});
  @override
  State<MotivationScreen> createState() => _MotivationScreenState();
}

class _MotivationScreenState extends State<MotivationScreen> {
  late PageController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = PageController(initialPage: Random().nextInt(_quotes.length));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('motivation'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)),
        centerTitle: true,
      ),
      body: PageView.builder(
        controller: _ctrl,
        itemCount: _quotes.length,
        itemBuilder: (_, i) {
          final (arabic, key, source) = _quotes[i];
          final colors = [
            [const Color(0xFF1B5E20), const Color(0xFF2E7D32)],
            [const Color(0xFF0D47A1), const Color(0xFF1565C0)],
            [const Color(0xFF4A148C), const Color(0xFF6A1B9A)],
            [const Color(0xFFBF360C), const Color(0xFFD84315)],
            [const Color(0xFF1A237E), const Color(0xFF283593)],
          ];
          final gradient = colors[i % colors.length];

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Spacer(flex: 1),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [gradient[0], gradient[1]], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: gradient[0].withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
                ),
                child: Column(children: [
                  Text('"', style: TextStyle(fontSize: 48, color: Colors.white.withOpacity(0.3), height: 0.5)),
                  const SizedBox(height: 16),
                  Text(arabic, textDirection: TextDirection.rtl, textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 26, color: Colors.white, height: 1.8)),
                  const SizedBox(height: 20),
                  Container(width: 40, height: 2, color: Colors.white.withOpacity(0.4)),
                  const SizedBox(height: 20),
                  Text(l10n.translate(key), textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.9), height: 1.5, fontStyle: FontStyle.italic)),
                  const SizedBox(height: 12),
                  Text('— $source', style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.6), fontWeight: FontWeight.w600)),
                ]),
              ),
              const Spacer(flex: 1),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                IconButton(onPressed: () {
                  Clipboard.setData(ClipboardData(text: '$arabic\n\n${l10n.translate(key)}'));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied'), duration: Duration(seconds: 1)));
                }, icon: Icon(Icons.copy, color: p.muted)),
                const SizedBox(width: 12),
                IconButton(onPressed: () => Share.share('$arabic\n\n${l10n.translate(key)}\n\n— $source\n\nIslamic Companion App'),
                  icon: Icon(Icons.share_outlined, color: p.muted)),
              ]),
              Text('${i + 1} / ${_quotes.length}', style: TextStyle(fontSize: 11, color: p.muted)),
              Text(l10n.translate('swipeForMore'), style: TextStyle(fontSize: 10, color: p.muted.withOpacity(0.5))),
              const SizedBox(height: 16),
            ]),
          );
        },
      ),
    );
  }
}
