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

class _MoodDua {
  final String emoji, moodKey, arabicDua, duaKey, reference;
  final Color color;
  const _MoodDua(this.emoji, this.moodKey, this.arabicDua, this.duaKey, this.reference, this.color);
}

const _moods = [
  _MoodDua('😟', 'moodAnxious',
    'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ',
    'duaAnxiety', 'Bukhari 6369', Color(0xFF5C6BC0)),
  _MoodDua('😢', 'moodSad',
    'لَا إِلٰهَ إِلَّا أَنتَ سُبْحَانَكَ إِنِّي كُنتُ مِنَ الظَّالِمِينَ',
    'duaSadness', 'Quran 21:87', Color(0xFF42A5F5)),
  _MoodDua('😠', 'moodAngry',
    'أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ',
    'duaAnger', 'Bukhari 6115', Color(0xFFEF5350)),
  _MoodDua('😰', 'moodFearful',
    'حَسْبُنَا اللَّهُ وَنِعْمَ الْوَكِيلُ',
    'duaFear', 'Quran 3:173', Color(0xFF7E57C2)),
  _MoodDua('🤒', 'moodSick',
    'اللَّهُمَّ رَبَّ النَّاسِ أَذْهِبِ الْبَأْسَ اشْفِ أَنْتَ الشَّافِي',
    'duaSickness', 'Bukhari 5742', Color(0xFF26A69A)),
  _MoodDua('😊', 'moodGrateful',
    'الْحَمْدُ لِلَّهِ الَّذِي بِنِعْمَتِهِ تَتِمُّ الصَّالِحَاتُ',
    'duaGratitude', 'Ibn Majah 3803', Color(0xFFFFB300)),
  _MoodDua('😔', 'moodLonely',
    'اللَّهُمَّ آنِسْ وَحْشَتِي وَارْحَمْ غُرْبَتِي',
    'duaLoneliness', 'Hisnul Muslim', Color(0xFF78909C)),
  _MoodDua('💪', 'moodDetermined',
    'رَبِّ اشْرَحْ لِي صَدْرِي وَيَسِّرْ لِي أَمْرِي',
    'duaDetermination', 'Quran 20:25-26', Color(0xFFFF7043)),
  _MoodDua('🌙', 'moodSleepless',
    'اللَّهُمَّ غَارَتِ النُّجُومُ وَهَدَأَتِ الْعُيُونُ وَأَنْتَ حَيٌّ قَيُّومٌ',
    'duaSleepless', 'Ibn Hibban', Color(0xFF5C6BC0)),
  _MoodDua('🙏', 'moodHopeful',
    'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
    'duaHope', 'Quran 2:201', Color(0xFF66BB6A)),
];

class DuaByMoodScreen extends StatelessWidget {
  const DuaByMoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('duaByMood'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        itemCount: _moods.length,
        itemBuilder: (_, i) {
          final m = _moods[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: p.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: p.divider),
            ),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              leading: Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: m.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: Text(m.emoji, style: const TextStyle(fontSize: 22))),
              ),
              title: Text(l10n.translate(m.moodKey), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: p.fg)),
              shape: const Border(),
              collapsedShape: const Border(),
              children: [
                // Arabic dua
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: m.color.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    m.arabicDua,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: p.fg, height: 1.8),
                  ),
                ),
                const SizedBox(height: 12),
                // Translation
                Text(l10n.translate(m.duaKey), textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: p.muted, fontStyle: FontStyle.italic, height: 1.5)),
                const SizedBox(height: 8),
                // Reference
                Text('— ${m.reference}', style: TextStyle(fontSize: 11, color: m.color, fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                // Actions
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: '${m.arabicDua}\n\n${l10n.translate(m.duaKey)}\n\n— ${m.reference}'));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.translate('copied')), duration: const Duration(seconds: 1)));
                    },
                    icon: Icon(Icons.copy, size: 18, color: p.muted),
                  ),
                  IconButton(
                    onPressed: () => Share.share('${m.arabicDua}\n\n${l10n.translate(m.duaKey)}\n\n— ${m.reference}\n\nIslamic Companion App'),
                    icon: Icon(Icons.share_outlined, size: 18, color: p.muted),
                  ),
                ]),
              ],
            ),
          );
        },
      ),
    );
  }
}
