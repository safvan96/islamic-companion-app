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

class _DuaCategory {
  final String titleKey;
  final IconData icon;
  final List<_DuaItem> duas;
  const _DuaCategory({required this.titleKey, required this.icon, required this.duas});
}

class _DuaItem {
  final String arabic;
  final String transliteration;
  final String translationKey;
  const _DuaItem({required this.arabic, required this.transliteration, required this.translationKey});
}

const _categories = [
  _DuaCategory(titleKey: 'dua_waking', icon: Icons.wb_sunny_outlined, duas: [
    _DuaItem(arabic: 'الْحَمْدُ لِلّٰهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ', transliteration: 'Alhamdu lillahil-ladhi ahyana ba\'da ma amatana wa ilayhin-nushur', translationKey: 'dua_waking_t'),
  ]),
  _DuaCategory(titleKey: 'dua_sleeping', icon: Icons.bedtime_outlined, duas: [
    _DuaItem(arabic: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا', transliteration: 'Bismika Allahumma amutu wa ahya', translationKey: 'dua_sleeping_t'),
  ]),
  _DuaCategory(titleKey: 'dua_eating', icon: Icons.restaurant_outlined, duas: [
    _DuaItem(arabic: 'بِسْمِ اللّٰهِ وَعَلَى بَرَكَةِ اللّٰهِ', transliteration: 'Bismillahi wa \'ala barakatillah', translationKey: 'dua_eating_t'),
  ]),
  _DuaCategory(titleKey: 'dua_aftereating', icon: Icons.done_all, duas: [
    _DuaItem(arabic: 'الْحَمْدُ لِلّٰهِ الَّذِي أَطْعَمَنَا وَسَقَانَا وَجَعَلَنَا مُسْلِمِينَ', transliteration: 'Alhamdu lillahil-ladhi at\'amana wa saqana wa ja\'alana muslimin', translationKey: 'dua_aftereating_t'),
  ]),
  _DuaCategory(titleKey: 'dua_travel', icon: Icons.flight_takeoff, duas: [
    _DuaItem(arabic: 'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هٰذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ وَإِنَّا إِلَى رَبِّنَا لَمُنْقَلِبُونَ', transliteration: 'Subhanal-ladhi sakhkhara lana hadha wa ma kunna lahu muqrinin wa inna ila Rabbina lamunqalibun', translationKey: 'dua_travel_t'),
  ]),
  _DuaCategory(titleKey: 'dua_entering_home', icon: Icons.home_outlined, duas: [
    _DuaItem(arabic: 'بِسْمِ اللّٰهِ وَلَجْنَا وَبِسْمِ اللّٰهِ خَرَجْنَا وَعَلَى اللّٰهِ رَبِّنَا تَوَكَّلْنَا', transliteration: 'Bismillahi walajna, wa bismillahi kharajna, wa \'alallahi Rabbina tawakkalna', translationKey: 'dua_entering_home_t'),
  ]),
  _DuaCategory(titleKey: 'dua_mosque', icon: Icons.mosque_outlined, duas: [
    _DuaItem(arabic: 'اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ', transliteration: 'Allahumma-ftah li abwaba rahmatik', translationKey: 'dua_mosque_t'),
  ]),
  _DuaCategory(titleKey: 'dua_leaving_mosque', icon: Icons.mosque, duas: [
    _DuaItem(arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ', transliteration: 'Allahumma inni as\'aluka min fadlik', translationKey: 'dua_leaving_mosque_t'),
  ]),
  _DuaCategory(titleKey: 'dua_rain', icon: Icons.water_drop_outlined, duas: [
    _DuaItem(arabic: 'اللَّهُمَّ صَيِّبًا نَافِعًا', transliteration: 'Allahumma sayyiban nafi\'an', translationKey: 'dua_rain_t'),
  ]),
  _DuaCategory(titleKey: 'dua_anxiety', icon: Icons.psychology_outlined, duas: [
    _DuaItem(arabic: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحُزْنِ وَأَعُوذُ بِكَ مِنَ الْعَجْزِ وَالْكَسَلِ وَأَعُوذُ بِكَ مِنَ الْجُبْنِ وَالْبُخْلِ وَأَعُوذُ بِكَ مِنْ غَلَبَةِ الدَّيْنِ وَقَهْرِ الرِّجَالِ', transliteration: 'Allahumma inni a\'udhu bika minal-hammi wal-hazan...', translationKey: 'dua_anxiety_t'),
  ]),
  _DuaCategory(titleKey: 'dua_forgiveness', icon: Icons.self_improvement, duas: [
    _DuaItem(arabic: 'رَبَّنَا ظَلَمْنَا أَنفُسَنَا وَإِن لَّمْ تَغْفِرْ لَنَا وَتَرْحَمْنَا لَنَكُونَنَّ مِنَ الْخَاسِرِينَ', transliteration: 'Rabbana zalamna anfusana wa in lam taghfir lana wa tarhamna lanakuunanna minal-khasirin', translationKey: 'dua_forgiveness_t'),
  ]),
  _DuaCategory(titleKey: 'dua_parents', icon: Icons.family_restroom, duas: [
    _DuaItem(arabic: 'رَبِّ ارْحَمْهُمَا كَمَا رَبَّيَانِي صَغِيرًا', transliteration: 'Rabbi irhamhuma kama rabbayani saghira', translationKey: 'dua_parents_t'),
  ]),
];

class DailyDuasScreen extends StatelessWidget {
  const DailyDuasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('duaForOccasions'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        itemCount: _categories.length,
        itemBuilder: (context, i) {
          final cat = _categories[i];
          return _CategoryCard(cat: cat, p: p, l10n: l10n);
        },
      ),
    );
  }
}

class _CategoryCard extends StatefulWidget {
  final _DuaCategory cat;
  final _P p;
  final AppLocalizations l10n;
  const _CategoryCard({required this.cat, required this.p, required this.l10n});
  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.p;
    final l10n = widget.l10n;
    final cat = widget.cat;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _expanded ? p.accent.withOpacity(0.3) : p.divider),
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: p.accent.withOpacity(0.1)),
                    child: Icon(cat.icon, size: 18, color: p.accent),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(l10n.translate(cat.titleKey), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: p.fg))),
                  Icon(_expanded ? Icons.expand_less : Icons.expand_more, color: p.muted, size: 20),
                ],
              ),
            ),
          ),
          // Content
          if (_expanded)
            ...cat.duas.map((dua) => Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: p.divider, height: 1),
                  const SizedBox(height: 12),
                  Text(dua.arabic, textDirection: TextDirection.rtl, style: TextStyle(fontSize: 20, color: p.fg, height: 1.8)),
                  const SizedBox(height: 8),
                  Text(dua.transliteration, style: TextStyle(fontSize: 12, color: p.accent, fontStyle: FontStyle.italic)),
                  const SizedBox(height: 6),
                  Text(l10n.translate(dua.translationKey), style: TextStyle(fontSize: 12, color: p.muted, height: 1.4)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: '${dua.arabic}\n\n${dua.transliteration}\n\n${l10n.translate(dua.translationKey)}'));
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Copied'), duration: Duration(seconds: 1)));
                        },
                        child: Icon(Icons.copy, size: 16, color: p.muted),
                      ),
                      const SizedBox(width: 16),
                      InkWell(
                        onTap: () => Share.share('${dua.arabic}\n\n${dua.transliteration}\n\n${l10n.translate(dua.translationKey)}\n\nIslamic Companion App'),
                        child: Icon(Icons.share_outlined, size: 16, color: p.muted),
                      ),
                    ],
                  ),
                ],
              ),
            )),
        ],
      ),
    );
  }
}
