import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import '../models/surah_model.dart';
import '../providers/app_provider.dart';
import '../providers/favorites_provider.dart';
import '../services/share_service.dart';

class SurahScreen extends StatefulWidget {
  const SurahScreen({super.key});
  @override
  State<SurahScreen> createState() => _SurahScreenState();
}

class _SurahScreenState extends State<SurahScreen> {
  final AudioPlayer _player = AudioPlayer();
  int? _playingIndex;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  Set<int> _readSurahs = {};

  Future<void> _loadReadSurahs() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('readSurahs') ?? [];
    setState(() {
      _readSurahs = list.map((s) => int.tryParse(s) ?? -1).where((i) => i >= 0).toSet();
    });
  }

  Future<void> _toggleRead(int surahNumber) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_readSurahs.contains(surahNumber)) {
        _readSurahs.remove(surahNumber);
      } else {
        _readSurahs.add(surahNumber);
      }
    });
    await prefs.setStringList('readSurahs', _readSurahs.map((e) => e.toString()).toList());
  }

  // Clean Quran recitations — Mishary Alafasy via Islamic Network CDN
  static const String _cdnBase =
      'https://cdn.islamic.network/quran/audio-surah/128/ar.alafasy';

  String _audioUrl(SurahModel surah) => '$_cdnBase/${surah.number}.mp3';

  @override
  void initState() {
    super.initState();
    _loadReadSurahs();
    _player.setReleaseMode(ReleaseMode.stop);
    _player.onPlayerStateChanged.listen((s) {
      if (!mounted) return;
      if (s == PlayerState.completed || s == PlayerState.stopped) {
        setState(() => _playingIndex = null);
      }
    });
    _player.onDurationChanged.listen((d) {
      if (mounted) setState(() => _duration = d);
    });
    _player.onPositionChanged.listen((p) {
      if (mounted) setState(() => _position = p);
    });
  }

  Future<void> _toggle(int index, SurahModel surah) async {
    if (_playingIndex == index) {
      await _player.stop();
      if (mounted) setState(() => _playingIndex = null);
      return;
    }
    try {
      await _player.stop();
      if (mounted) {
        setState(() {
          _playingIndex = index;
          _position = Duration.zero;
          _duration = Duration.zero;
        });
      }
      await _player.setSourceUrl(_audioUrl(surah));
      await _player.resume();
    } catch (e) {
      debugPrint('Surah audio error: $e');
      if (mounted) {
        setState(() => _playingIndex = null);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Audio error: $e',
                style: const TextStyle(color: Colors.white)),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

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
            return _SurahCard(
              surah: surah,
              index: index,
              isDark: isDark,
              l10n: l10n,
              isPlaying: _playingIndex == index,
              position: _playingIndex == index ? _position : Duration.zero,
              duration: _playingIndex == index ? _duration : Duration.zero,
              onToggle: () => _toggle(index, surah),
              fmt: _fmt,
              isRead: _readSurahs.contains(surah.number),
              onToggleRead: () => _toggleRead(surah.number),
            );
          },
        ),
      ),
    );
  }
}

class _SurahCard extends StatelessWidget {
  final SurahModel surah;
  final int index;
  final bool isDark;
  final AppLocalizations l10n;
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final VoidCallback onToggle;
  final String Function(Duration) fmt;
  final bool isRead;
  final VoidCallback onToggleRead;

  const _SurahCard({
    required this.surah,
    required this.index,
    required this.isDark,
    required this.l10n,
    required this.isPlaying,
    required this.position,
    required this.duration,
    required this.onToggle,
    required this.fmt,
    required this.isRead,
    required this.onToggleRead,
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
          leading: Stack(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: isRead
                      ? const Color(0xFF00695C).withOpacity(0.2)
                      : const Color(0xFF00695C).withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: isRead
                      ? Border.all(color: const Color(0xFF00695C), width: 2)
                      : null,
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
          if (isRead)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: Color(0xFF00695C),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 10),
              ),
            ),
          ],
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
                  color: isDark
                      ? const Color(0xFFD4AF37)
                      : const Color(0xFF00695C),
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
                  // Translation
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
                  // Bookmark + Share row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Consumer<FavoritesProvider>(
                        builder: (_, fav, __) => IconButton(
                          icon: Icon(
                            fav.isSurahFav(surah.number)
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color: const Color(0xFFD4AF37),
                          ),
                          onPressed: () => fav.toggleSurah(surah.number),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.share_outlined,
                          color: isDark ? Colors.white38 : Colors.black38,
                        ),
                        onPressed: () {
                          final lang = Provider.of<AppProvider>(context, listen: false)
                              .locale.languageCode;
                          ShareService.shareSurah(surah, lang);
                        },
                      ),
                    ],
                  ),
                  // Read toggle + audio player
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onToggleRead,
                          icon: Icon(
                            isRead ? Icons.check_circle : Icons.check_circle_outline,
                            size: 18,
                            color: isRead ? const Color(0xFF00695C) : Colors.grey,
                          ),
                          label: Text(
                            isRead ? 'Read' : 'Mark as Read',
                            style: TextStyle(
                              color: isRead ? const Color(0xFF00695C) : Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: isRead
                                  ? const Color(0xFF00695C)
                                  : Colors.grey.withOpacity(0.3),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildPlayer(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayer() {
    final progress = (duration.inMilliseconds == 0)
        ? 0.0
        : (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF00695C).withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF00695C).withOpacity(0.25),
        ),
      ),
      child: Row(
        children: [
          Material(
            color: const Color(0xFF00695C),
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onToggle,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  isPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: isPlaying ? progress : 0,
                    minHeight: 4,
                    backgroundColor:
                        const Color(0xFF00695C).withOpacity(0.15),
                    valueColor: const AlwaysStoppedAnimation(
                        Color(0xFF00695C)),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isPlaying ? fmt(position) : '00:00',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                    Text(
                      isPlaying && duration > Duration.zero
                          ? fmt(duration)
                          : 'Mishary Alafasy',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
