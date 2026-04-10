import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/hadith_model.dart';
import '../models/surah_model.dart';
import '../providers/app_provider.dart';
import '../providers/favorites_provider.dart';
import '../services/share_service.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Provider.of<AppProvider>(context).isDarkMode;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.translate('favorites')),
          backgroundColor: const Color(0xFFD4AF37),
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            tabs: [
              Tab(text: l10n.translate('hadiths')),
              Tab(text: l10n.translate('surahs')),
              Tab(text: l10n.translate('duas')),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _FavHadithsTab(isDark: isDark),
            _FavSurahsTab(isDark: isDark),
            _FavDuasTab(isDark: isDark),
          ],
        ),
      ),
    );
  }
}

class _FavHadithsTab extends StatelessWidget {
  final bool isDark;
  const _FavHadithsTab({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final fav = Provider.of<FavoritesProvider>(context);
    final langCode = Provider.of<AppProvider>(context).locale.languageCode;
    final indices = fav.favHadiths.toList()..sort();

    if (indices.isEmpty) return _EmptyState(isDark: isDark);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: indices.length,
      itemBuilder: (context, i) {
        final index = indices[i];
        if (index >= HadithModel.hadiths.length) return const SizedBox();
        final hadith = HadithModel.hadiths[index];
        final translation =
            hadith.translations[langCode] ?? hadith.translations['en']!;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  hadith.arabic,
                  style: TextStyle(
                    fontSize: 18,
                    color: isDark
                        ? const Color(0xFFD4AF37)
                        : const Color(0xFF3E2723),
                    height: 1.8,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 10),
                Text(
                  translation,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.black87,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '${hadith.source} — ${hadith.narrator}',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? Colors.white38 : Colors.black38,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () =>
                          ShareService.shareHadith(hadith, langCode),
                      child: Icon(Icons.share_outlined,
                          size: 18,
                          color: isDark ? Colors.white38 : Colors.black38),
                    ),
                    const SizedBox(width: 12),
                    InkWell(
                      onTap: () => fav.toggleHadith(index),
                      child: const Icon(Icons.bookmark,
                          size: 20, color: Color(0xFFD4AF37)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FavSurahsTab extends StatelessWidget {
  final bool isDark;
  const _FavSurahsTab({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final fav = Provider.of<FavoritesProvider>(context);
    final langCode = Provider.of<AppProvider>(context).locale.languageCode;
    final surahs = SurahModel.shortSurahs
        .where((s) => fav.isSurahFav(s.number))
        .toList();

    if (surahs.isEmpty) return _EmptyState(isDark: isDark);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: surahs.length,
      itemBuilder: (context, i) {
        final surah = surahs[i];
        final translation =
            surah.translations[langCode] ?? surah.translations['en']!;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00695C).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          surah.number.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00695C),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(surah.transliteration,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        Text(surah.nameArabic,
                            style: TextStyle(
                                color: isDark
                                    ? const Color(0xFFD4AF37)
                                    : const Color(0xFF00695C))),
                      ],
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () =>
                          ShareService.shareSurah(surah, langCode),
                      child: Icon(Icons.share_outlined,
                          size: 18,
                          color: isDark ? Colors.white38 : Colors.black38),
                    ),
                    const SizedBox(width: 12),
                    InkWell(
                      onTap: () => fav.toggleSurah(surah.number),
                      child: const Icon(Icons.bookmark,
                          size: 20, color: Color(0xFFD4AF37)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  translation,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white70 : Colors.black87,
                    height: 1.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FavDuasTab extends StatelessWidget {
  final bool isDark;
  const _FavDuasTab({required this.isDark});

  // Access dua data — same as in DuaScreen
  static const List<Map<String, dynamic>> _duas = [
    {'category': 'morning', 'arabic': 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ', 'transliteration': 'Asbahna wa asbahal mulku lillah...'},
    {'category': 'evening', 'arabic': 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ', 'transliteration': 'Amsayna wa amsal mulku lillah...'},
    {'category': 'sleep', 'arabic': 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا', 'transliteration': 'Bismika Allahumma amutu wa ahya'},
    {'category': 'food', 'arabic': 'بِسْمِ اللَّهِ وَعَلَى بَرَكَةِ اللَّهِ', 'transliteration': 'Bismillahi wa ala barakatillah'},
    {'category': 'travel', 'arabic': 'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا', 'transliteration': 'Subhanal-ladhi sakh-khara lana hadha...'},
    {'category': 'mosque', 'arabic': 'اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ', 'transliteration': 'Allahumma iftah li abwaba rahmatik'},
    {'category': 'protection', 'arabic': 'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ', 'transliteration': 'Bismillahil-ladhi la yadurru...'},
    {'category': 'forgiveness', 'arabic': 'رَبِّ اغْفِرْ لِي وَتُبْ عَلَيَّ', 'transliteration': 'Rabbighfir li wa tub alayya...'},
  ];

  static const Map<String, String> _categoryNames = {
    'morning': 'Morning', 'evening': 'Evening', 'sleep': 'Before Sleep',
    'food': 'Before Eating', 'travel': 'Travel', 'mosque': 'Entering Mosque',
    'protection': 'Protection', 'forgiveness': 'Forgiveness',
  };

  @override
  Widget build(BuildContext context) {
    final fav = Provider.of<FavoritesProvider>(context);
    final indices = fav.favDuas.toList()..sort();

    if (indices.isEmpty) return _EmptyState(isDark: isDark);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: indices.length,
      itemBuilder: (context, i) {
        final index = indices[i];
        if (index >= _duas.length) return const SizedBox();
        final dua = _duas[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text(
                      _categoryNames[dua['category']] ?? '',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () => fav.toggleDua(index),
                      child: const Icon(Icons.bookmark,
                          size: 20, color: Color(0xFFD4AF37)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  dua['arabic'] as String,
                  style: TextStyle(
                    fontSize: 18,
                    color: isDark
                        ? const Color(0xFFD4AF37)
                        : const Color(0xFF00695C),
                    height: 1.8,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 6),
                Text(
                  dua['transliteration'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: isDark ? Colors.white54 : Colors.black45,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isDark;
  const _EmptyState({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bookmark_border,
              size: 64, color: isDark ? Colors.white24 : Colors.black12),
          const SizedBox(height: 16),
          Text(
            l10n.translate('noFavorites'),
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white38 : Colors.black38,
            ),
          ),
        ],
      ),
    );
  }
}
