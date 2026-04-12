import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';
import '../services/hijri_calendar.dart';

class QuranCertificateScreen extends StatelessWidget {
  final int surahsRead;
  final int totalAyahs;
  final int streak;
  const QuranCertificateScreen({super.key, required this.surahsRead, required this.totalAyahs, required this.streak});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final l10n = AppLocalizations.of(context)!;
    final hijri = HijriCalendar.now();
    final now = DateTime.now();
    final isComplete = surahsRead >= 114;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0E1A19) : const Color(0xFFF8F5EE),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0,
        foregroundColor: isDark ? Colors.white : Colors.black87,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF1B5E20)],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFD4AF37), width: 3),
              boxShadow: [
                BoxShadow(color: const Color(0xFFD4AF37).withOpacity(0.3), blurRadius: 20, spreadRadius: 2),
              ],
            ),
            child: Column(children: [
              // Bismillah
              const Text(
                'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 18, color: Color(0xFFD4AF37), height: 1.4),
              ),
              const SizedBox(height: 24),
              // Title
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFD4AF37), width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isComplete ? l10n.translate('khatmCertificate') : l10n.translate('quranProgress'),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2),
                ),
              ),
              const SizedBox(height: 24),
              // Icon
              Icon(
                isComplete ? Icons.emoji_events : Icons.auto_stories,
                size: 64, color: const Color(0xFFD4AF37),
              ),
              const SizedBox(height: 16),
              // Stats
              Text(
                '$surahsRead / 114 ${l10n.translate('surahs')}',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w200, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                '$totalAyahs ${l10n.translate('ayahsRead')}',
                style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.7)),
              ),
              if (streak > 0) ...[
                const SizedBox(height: 4),
                Text(
                  '$streak ${l10n.translate('dayStreak')}',
                  style: const TextStyle(fontSize: 14, color: Color(0xFFD4AF37)),
                ),
              ],
              const SizedBox(height: 24),
              // Date
              Container(width: 60, height: 1, color: const Color(0xFFD4AF37)),
              const SizedBox(height: 16),
              Text(
                '${now.day}/${now.month}/${now.year}',
                style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.6)),
              ),
              Text(
                hijri.format('en'),
                style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.6)),
              ),
              const SizedBox(height: 20),
              // Share
              OutlinedButton.icon(
                onPressed: () {
                  final msg = isComplete
                      ? 'Alhamdulillah! I completed reading the entire Quran (114 surahs, $totalAyahs ayahs) using Islamic Companion App!'
                      : 'I have read $surahsRead/114 surahs ($totalAyahs ayahs) using Islamic Companion App!';
                  Share.share('$msg\n\nhttps://play.google.com/store/apps/details?id=com.islamiccompanion.app');
                },
                icon: const Icon(Icons.share, color: Color(0xFFD4AF37), size: 18),
                label: Text(l10n.translate('shareProgress'), style: const TextStyle(color: Color(0xFFD4AF37))),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFFD4AF37))),
              ),
              const SizedBox(height: 8),
              Text(
                'Islamic Companion App',
                style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.4)),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
