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

class _Quote {
  final String arabic;
  final String translationKey;
  final String sourceKey;
  const _Quote({required this.arabic, required this.translationKey, required this.sourceKey});
}

const _quotes = [
  _Quote(arabic: 'إِنَّ مَعَ الْعُسْرِ يُسْرًا', translationKey: 'wisdom_1', sourceKey: 'wisdom_1_src'),
  _Quote(arabic: 'وَمَن يَتَوَكَّلْ عَلَى اللّٰهِ فَهُوَ حَسْبُهُ', translationKey: 'wisdom_2', sourceKey: 'wisdom_2_src'),
  _Quote(arabic: 'فَاذْكُرُونِي أَذْكُرْكُمْ وَاشْكُرُوا لِي وَلَا تَكْفُرُونِ', translationKey: 'wisdom_3', sourceKey: 'wisdom_3_src'),
  _Quote(arabic: 'وَلَسَوْفَ يُعْطِيكَ رَبُّكَ فَتَرْضَىٰ', translationKey: 'wisdom_4', sourceKey: 'wisdom_4_src'),
  _Quote(arabic: 'رَبِّ اشْرَحْ لِي صَدْرِي وَيَسِّرْ لِي أَمْرِي', translationKey: 'wisdom_5', sourceKey: 'wisdom_5_src'),
  _Quote(arabic: 'وَقُل رَّبِّ زِدْنِي عِلْمًا', translationKey: 'wisdom_6', sourceKey: 'wisdom_6_src'),
  _Quote(arabic: 'لَا يُكَلِّفُ اللّٰهُ نَفْسًا إِلَّا وُسْعَهَا', translationKey: 'wisdom_7', sourceKey: 'wisdom_7_src'),
  _Quote(arabic: 'وَنَحْنُ أَقْرَبُ إِلَيْهِ مِنْ حَبْلِ الْوَرِيدِ', translationKey: 'wisdom_8', sourceKey: 'wisdom_8_src'),
  _Quote(arabic: 'أَلَا بِذِكْرِ اللّٰهِ تَطْمَئِنُّ الْقُلُوبُ', translationKey: 'wisdom_9', sourceKey: 'wisdom_9_src'),
  _Quote(arabic: 'إِنَّ اللّٰهَ مَعَ الصَّابِرِينَ', translationKey: 'wisdom_10', sourceKey: 'wisdom_10_src'),
  _Quote(arabic: 'وَمَنْ يَتَّقِ اللّٰهَ يَجْعَل لَّهُ مَخْرَجًا', translationKey: 'wisdom_11', sourceKey: 'wisdom_11_src'),
  _Quote(arabic: 'فَإِنَّ مَعَ الْعُسْرِ يُسْرًا ۝ إِنَّ مَعَ الْعُسْرِ يُسْرًا', translationKey: 'wisdom_12', sourceKey: 'wisdom_12_src'),
  _Quote(arabic: 'وَلَنَبْلُوَنَّكُم بِشَيْءٍ مِّنَ الْخَوْفِ وَالْجُوعِ وَنَقْصٍ مِّنَ الْأَمْوَالِ وَالْأَنفُسِ وَالثَّمَرَاتِ ۗ وَبَشِّرِ الصَّابِرِينَ', translationKey: 'wisdom_13', sourceKey: 'wisdom_13_src'),
  _Quote(arabic: 'خَيْرُكُمْ مَنْ تَعَلَّمَ الْقُرْآنَ وَعَلَّمَهُ', translationKey: 'wisdom_14', sourceKey: 'wisdom_14_src'),
  _Quote(arabic: 'الدُّنْيَا سِجْنُ الْمُؤْمِنِ وَجَنَّةُ الْكَافِرِ', translationKey: 'wisdom_15', sourceKey: 'wisdom_15_src'),
  _Quote(arabic: 'تَبَسُّمُكَ فِي وَجْهِ أَخِيكَ صَدَقَةٌ', translationKey: 'wisdom_16', sourceKey: 'wisdom_16_src'),
  _Quote(arabic: 'مَنْ سَلَكَ طَرِيقًا يَلْتَمِسُ فِيهِ عِلْمًا سَهَّلَ اللّٰهُ لَهُ طَرِيقًا إِلَى الْجَنَّةِ', translationKey: 'wisdom_17', sourceKey: 'wisdom_17_src'),
  _Quote(arabic: 'إِنَّمَا الْأَعْمَالُ بِالنِّيَّاتِ', translationKey: 'wisdom_18', sourceKey: 'wisdom_18_src'),
  _Quote(arabic: 'الْمُؤْمِنُ الْقَوِيُّ خَيْرٌ وَأَحَبُّ إِلَى اللّٰهِ مِنَ الْمُؤْمِنِ الضَّعِيفِ', translationKey: 'wisdom_19', sourceKey: 'wisdom_19_src'),
  _Quote(arabic: 'لَا يُؤْمِنُ أَحَدُكُمْ حَتَّى يُحِبَّ لِأَخِيهِ مَا يُحِبُّ لِنَفْسِهِ', translationKey: 'wisdom_20', sourceKey: 'wisdom_20_src'),
];

class WisdomScreen extends StatefulWidget {
  const WisdomScreen({super.key});
  @override
  State<WisdomScreen> createState() => _WisdomScreenState();
}

class _WisdomScreenState extends State<WisdomScreen> {
  late PageController _pageCtrl;
  late int _initialPage;

  @override
  void initState() {
    super.initState();
    // Daily quote based on day of year
    _initialPage = DateTime.now().difference(DateTime(DateTime.now().year)).inDays % _quotes.length;
    _pageCtrl = PageController(initialPage: _initialPage);
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('wisdomQuotes'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)),
        centerTitle: true,
      ),
      body: PageView.builder(
        controller: _pageCtrl,
        itemCount: _quotes.length,
        itemBuilder: (context, i) {
          final q = _quotes[i];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                // Decorative top
                Icon(Icons.format_quote, size: 40, color: p.gold.withOpacity(0.3)),
                const SizedBox(height: 20),
                // Arabic
                Text(
                  q.arabic,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(fontSize: 26, color: p.fg, height: 1.8, fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 24),
                // Divider
                Container(width: 40, height: 2, decoration: BoxDecoration(color: p.gold, borderRadius: BorderRadius.circular(1))),
                const SizedBox(height: 24),
                // Translation
                Text(
                  l10n.translate(q.translationKey),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: p.fg.withOpacity(0.8), height: 1.6, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 16),
                // Source
                Text(
                  l10n.translate(q.sourceKey),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: p.gold, fontWeight: FontWeight.w600),
                ),
                const Spacer(flex: 2),
                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: '${q.arabic}\n\n${l10n.translate(q.translationKey)}\n\n— ${l10n.translate(q.sourceKey)}'));
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.translate('copied')), duration: const Duration(seconds: 1)));
                      },
                      icon: Icon(Icons.copy, color: p.muted, size: 20),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      onPressed: () => Share.share('${q.arabic}\n\n${l10n.translate(q.translationKey)}\n\n— ${l10n.translate(q.sourceKey)}\n\nIslamic Companion App'),
                      icon: Icon(Icons.share_outlined, color: p.muted, size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Page indicator
                Text('${i + 1} / ${_quotes.length}', style: TextStyle(fontSize: 11, color: p.muted)),
                const SizedBox(height: 4),
                Text(l10n.translate('swipeForMore'), style: TextStyle(fontSize: 10, color: p.muted.withOpacity(0.6))),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
