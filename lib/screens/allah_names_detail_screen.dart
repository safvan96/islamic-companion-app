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

/// Daily Ayah of the Day - shows a different ayah each day with swipe navigation
class AyahOfDayScreen extends StatefulWidget {
  const AyahOfDayScreen({super.key});
  @override
  State<AyahOfDayScreen> createState() => _AyahOfDayScreenState();
}

class _AyahOfDayScreenState extends State<AyahOfDayScreen> {
  late PageController _ctrl;

  static const _ayahs = [
    {'arabic': 'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيمِ', 'ref': '1:1', 'key': 'ayah_1'},
    {'arabic': 'الْحَمْدُ لِلّٰهِ رَبِّ الْعَالَمِينَ', 'ref': '1:2', 'key': 'ayah_2'},
    {'arabic': 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ', 'ref': '1:5', 'key': 'ayah_3'},
    {'arabic': 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ', 'ref': '1:6', 'key': 'ayah_4'},
    {'arabic': 'ذٰلِكَ الْكِتَابُ لَا رَيْبَ فِيهِ هُدًى لِّلْمُتَّقِينَ', 'ref': '2:2', 'key': 'ayah_5'},
    {'arabic': 'وَاسْتَعِينُوا بِالصَّبْرِ وَالصَّلَاةِ', 'ref': '2:45', 'key': 'ayah_6'},
    {'arabic': 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ', 'ref': '2:201', 'key': 'ayah_7'},
    {'arabic': 'اللّٰهُ لَا إِلٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ', 'ref': '2:255', 'key': 'ayah_8'},
    {'arabic': 'لَا يُكَلِّفُ اللّٰهُ نَفْسًا إِلَّا وُسْعَهَا', 'ref': '2:286', 'key': 'ayah_9'},
    {'arabic': 'رَبَّنَا لَا تُزِغْ قُلُوبَنَا بَعْدَ إِذْ هَدَيْتَنَا وَهَبْ لَنَا مِن لَّدُنكَ رَحْمَةً', 'ref': '3:8', 'key': 'ayah_10'},
    {'arabic': 'وَمَا النَّصْرُ إِلَّا مِنْ عِندِ اللّٰهِ الْعَزِيزِ الْحَكِيمِ', 'ref': '3:126', 'key': 'ayah_11'},
    {'arabic': 'وَمَن يَتَوَكَّلْ عَلَى اللّٰهِ فَهُوَ حَسْبُهُ', 'ref': '65:3', 'key': 'ayah_12'},
    {'arabic': 'فَإِنَّ مَعَ الْعُسْرِ يُسْرًا ۝ إِنَّ مَعَ الْعُسْرِ يُسْرًا', 'ref': '94:5-6', 'key': 'ayah_13'},
    {'arabic': 'وَلَسَوْفَ يُعْطِيكَ رَبُّكَ فَتَرْضَىٰ', 'ref': '93:5', 'key': 'ayah_14'},
    {'arabic': 'إِنَّ اللّٰهَ وَمَلَائِكَتَهُ يُصَلُّونَ عَلَى النَّبِيِّ', 'ref': '33:56', 'key': 'ayah_15'},
    {'arabic': 'وَاذْكُر رَّبَّكَ فِي نَفْسِكَ تَضَرُّعًا وَخِيفَةً', 'ref': '7:205', 'key': 'ayah_16'},
    {'arabic': 'رَبِّ اشْرَحْ لِي صَدْرِي ۝ وَيَسِّرْ لِي أَمْرِي', 'ref': '20:25-26', 'key': 'ayah_17'},
    {'arabic': 'حَسْبُنَا اللّٰهُ وَنِعْمَ الْوَكِيلُ', 'ref': '3:173', 'key': 'ayah_18'},
    {'arabic': 'وَقُل رَّبِّ زِدْنِي عِلْمًا', 'ref': '20:114', 'key': 'ayah_19'},
    {'arabic': 'أَلَا بِذِكْرِ اللّٰهِ تَطْمَئِنُّ الْقُلُوبُ', 'ref': '13:28', 'key': 'ayah_20'},
    {'arabic': 'رَبَّنَا هَبْ لَنَا مِنْ أَزْوَاجِنَا وَذُرِّيَّاتِنَا قُرَّةَ أَعْيُنٍ', 'ref': '25:74', 'key': 'ayah_21'},
    {'arabic': 'وَنُنَزِّلُ مِنَ الْقُرْآنِ مَا هُوَ شِفَاءٌ وَرَحْمَةٌ لِّلْمُؤْمِنِينَ', 'ref': '17:82', 'key': 'ayah_22'},
    {'arabic': 'إِنَّ اللّٰهَ مَعَ الصَّابِرِينَ', 'ref': '2:153', 'key': 'ayah_23'},
    {'arabic': 'وَمَنْ يَتَّقِ اللّٰهَ يَجْعَل لَّهُ مَخْرَجًا ۝ وَيَرْزُقْهُ مِنْ حَيْثُ لَا يَحْتَسِبُ', 'ref': '65:2-3', 'key': 'ayah_24'},
    {'arabic': 'قُلْ هُوَ اللّٰهُ أَحَدٌ ۝ اللّٰهُ الصَّمَدُ ۝ لَمْ يَلِدْ وَلَمْ يُولَدْ ۝ وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ', 'ref': '112:1-4', 'key': 'ayah_25'},
    {'arabic': 'رَبَّنَا اغْفِرْ لَنَا ذُنُوبَنَا وَإِسْرَافَنَا فِي أَمْرِنَا', 'ref': '3:147', 'key': 'ayah_26'},
    {'arabic': 'وَإِذَا سَأَلَكَ عِبَادِي عَنِّي فَإِنِّي قَرِيبٌ', 'ref': '2:186', 'key': 'ayah_27'},
    {'arabic': 'رَبِّ أَوْزِعْنِي أَنْ أَشْكُرَ نِعْمَتَكَ الَّتِي أَنْعَمْتَ عَلَيَّ', 'ref': '27:19', 'key': 'ayah_28'},
    {'arabic': 'يَا أَيُّهَا الَّذِينَ آمَنُوا اسْتَعِينُوا بِالصَّبْرِ وَالصَّلَاةِ', 'ref': '2:153', 'key': 'ayah_29'},
    {'arabic': 'وَلَنَبْلُوَنَّكُم حَتَّىٰ نَعْلَمَ الْمُجَاهِدِينَ مِنكُمْ وَالصَّابِرِينَ', 'ref': '47:31', 'key': 'ayah_30'},
  ];

  @override
  void initState() {
    super.initState();
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
    _ctrl = PageController(initialPage: dayOfYear % _ayahs.length);
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
        title: Text(l10n.translate('ayahOfDay'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)),
        centerTitle: true,
      ),
      body: PageView.builder(
        controller: _ctrl,
        itemCount: _ayahs.length,
        itemBuilder: (_, i) {
          final a = _ayahs[i];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Spacer(flex: 2),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: p.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: p.gold.withOpacity(0.3)),
                ),
                child: Column(children: [
                  Text(a['arabic']!, textDirection: TextDirection.rtl, textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 26, color: p.fg, height: 1.9)),
                  const SizedBox(height: 20),
                  Container(width: 30, height: 2, color: p.gold),
                  const SizedBox(height: 16),
                  Text(l10n.translate(a['key']!), textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: p.muted, height: 1.5, fontStyle: FontStyle.italic)),
                  const SizedBox(height: 12),
                  Text('— ${a['ref']}', style: TextStyle(fontSize: 12, color: p.gold, fontWeight: FontWeight.w600)),
                ]),
              ),
              const Spacer(flex: 1),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                IconButton(onPressed: () {
                  Clipboard.setData(ClipboardData(text: '${a['arabic']}\n\n${l10n.translate(a['key']!)}\n\n— Quran ${a['ref']}'));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied'), duration: Duration(seconds: 1)));
                }, icon: Icon(Icons.copy, color: p.muted, size: 20)),
                const SizedBox(width: 16),
                IconButton(onPressed: () => Share.share('${a['arabic']}\n\n${l10n.translate(a['key']!)}\n\n— Quran ${a['ref']}\n\nIslamic Companion App'),
                  icon: Icon(Icons.share_outlined, color: p.muted, size: 20)),
              ]),
              Text('${i + 1} / ${_ayahs.length}', style: TextStyle(fontSize: 11, color: p.muted)),
              const SizedBox(height: 4),
              Text(l10n.translate('swipeForMore'), style: TextStyle(fontSize: 10, color: p.muted.withOpacity(0.5))),
              const Spacer(flex: 1),
            ]),
          );
        },
      ),
    );
  }
}
