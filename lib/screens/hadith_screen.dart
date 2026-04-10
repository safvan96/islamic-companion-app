import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/hadith_model.dart';
import '../providers/app_provider.dart';
import '../providers/favorites_provider.dart';
import '../services/share_service.dart';

class HadithScreen extends StatelessWidget {
  const HadithScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final langCode = Provider.of<AppProvider>(context).locale.languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('hadiths')),
        backgroundColor: const Color(0xFFE65100),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF1A1A1A), const Color(0xFF121212)]
                : [const Color(0xFFFFF3E0), const Color(0xFFFFE0B2)],
          ),
        ),
        child: Builder(builder: (context) {
          final dayOfYear = DateTime.now()
              .difference(DateTime(DateTime.now().year, 1, 1))
              .inDays;
          final todayIndex = dayOfYear % HadithModel.hadiths.length;

          return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: HadithModel.hadiths.length,
          itemBuilder: (context, index) {
            final hadith = HadithModel.hadiths[index];
            final translation =
                hadith.translations[langCode] ?? hadith.translations['en']!;
            final isToday = index == todayIndex;

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Card(
                elevation: isToday ? 6 : 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFD4AF37).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Hadith number badge
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE65100),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '#${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            if (isToday) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD4AF37),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  l10n.translate('todayHadith'),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                            const Spacer(),
                            Consumer<FavoritesProvider>(
                              builder: (_, fav, __) => InkWell(
                                onTap: () => fav.toggleHadith(index),
                                child: Icon(
                                  fav.isHadithFav(index)
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  color: const Color(0xFFD4AF37),
                                  size: 22,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () => ShareService.shareHadith(hadith, langCode),
                              child: Icon(
                                Icons.share_outlined,
                                color: isDark ? Colors.white38 : Colors.black38,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Arabic text
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withOpacity(0.05)
                                : const Color(0xFFFFF8E1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            hadith.arabic,
                            style: TextStyle(
                              fontSize: 20,
                              color: isDark
                                  ? const Color(0xFFD4AF37)
                                  : const Color(0xFF3E2723),
                              height: 2.0,
                            ),
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Translation
                        Text(
                          translation,
                          style: TextStyle(
                            fontSize: 15,
                            color: isDark ? Colors.white70 : Colors.black87,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Source
                        Divider(
                          color: isDark ? Colors.white12 : Colors.black12,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.source_outlined,
                              size: 14,
                              color: isDark ? Colors.white38 : Colors.black38,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                '${hadith.source} — ${hadith.narrator}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? Colors.white38
                                      : Colors.black38,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
        }),
      ),
    );
  }
}
