import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/app_localizations.dart';
import '../models/surah_model.dart';
import '../providers/app_provider.dart';

class SurahScreen extends StatelessWidget {
  const SurahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Provider.of<AppProvider>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('surahs')),
        backgroundColor: const Color(0xFF00695C),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF1A1A1A), const Color(0xFF121212)]
                : [const Color(0xFFE0F2F1), const Color(0xFFB2DFDB)],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: SurahModel.shortSurahs.length,
          itemBuilder: (context, index) {
            final surah = SurahModel.shortSurahs[index];
            return _SurahCard(surah: surah, isDark: isDark, l10n: l10n);
          },
        ),
      ),
    );
  }
}

class _SurahCard extends StatelessWidget {
  final SurahModel surah;
  final bool isDark;
  final AppLocalizations l10n;

  const _SurahCard({
    required this.surah,
    required this.isDark,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final langCode = Provider.of<AppProvider>(context).locale.languageCode;
    final translation =
        surah.translations[langCode] ?? surah.translations['en']!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          leading: Container(
            width: 45,
            height: 45,
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
                  fontSize: 16,
                ),
              ),
            ),
          ),
          title: Text(
            surah.transliteration,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          subtitle: Row(
            children: [
              Text(
                surah.nameArabic,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? const Color(0xFFD4AF37) : const Color(0xFF00695C),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${surah.versesCount} ayat',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white38 : Colors.black38,
                ),
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Arabic text
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(0.05)
                          : const Color(0xFFF1F8E9),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      surah.arabicText,
                      style: TextStyle(
                        fontSize: 22,
                        color: isDark
                            ? const Color(0xFFD4AF37)
                            : const Color(0xFF1B5E20),
                        height: 2.2,
                      ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Translation header
                  Text(
                    l10n.translate('translation'),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white54 : Colors.black45,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    translation,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white70 : Colors.black87,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // YouTube button
                  ElevatedButton.icon(
                    onPressed: () => _launchYouTube(surah.youtubeUrl),
                    icon: const Icon(Icons.play_circle_fill, size: 20),
                    label: Text(l10n.translate('listenRecitation')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC62828),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchYouTube(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
