import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';
import '../services/quran_stats_service.dart';
import 'quran_search_screen.dart';
import 'juz_screen.dart';

class QuranReaderScreen extends StatefulWidget {
  const QuranReaderScreen({super.key});

  @override
  State<QuranReaderScreen> createState() => _QuranReaderScreenState();
}

class _QuranReaderScreenState extends State<QuranReaderScreen> {
  List<Map<String, dynamic>> _surahs = [];
  bool _loading = true;
  String? _error;
  String _searchQuery = '';
  int? _lastReadSurah;
  String? _lastReadName;

  @override
  void initState() {
    super.initState();
    _loadLastRead();
    _loadSurahList();
  }

  Future<void> _loadLastRead() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _lastReadSurah = prefs.getInt('lastReadSurah');
        _lastReadName = prefs.getString('lastReadSurahName');
      });
    }
  }

  Future<void> _saveLastRead(int number, String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastReadSurah', number);
    await prefs.setString('lastReadSurahName', name);
    if (!mounted) return;
    setState(() {
      _lastReadSurah = number;
      _lastReadName = name;
    });
  }

  Future<void> _loadSurahList() async {
    final prefs = await SharedPreferences.getInstance();
    // Try cache first
    final cached = prefs.getString('quran_surah_list');
    if (cached != null) {
      try {
        final list = (json.decode(cached) as List).cast<Map<String, dynamic>>();
        if (mounted) setState(() { _surahs = list; _loading = false; });
        // Refresh in background
        _fetchSurahListFromApi(prefs);
        return;
      } catch (_) {}
    }
    // No cache — fetch from API
    await _fetchSurahListFromApi(prefs);
  }

  Future<void> _fetchSurahListFromApi(SharedPreferences prefs) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.alquran.cloud/v1/surah'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final list = (data['data'] as List).map((s) => {
          'number': s['number'] as int,
          'name': s['name'] as String,
          'englishName': s['englishName'] as String,
          'englishNameTranslation': s['englishNameTranslation'] as String,
          'numberOfAyahs': s['numberOfAyahs'] as int,
          'revelationType': s['revelationType'] as String,
        }).toList();
        // Cache the list
        await prefs.setString('quran_surah_list', json.encode(list));
        if (mounted) setState(() { _surahs = list; _loading = false; });
      } else {
        if (mounted && _surahs.isEmpty) setState(() { _error = 'Failed to load'; _loading = false; });
      }
    } catch (e) {
      if (mounted && _surahs.isEmpty) setState(() { _error = 'No internet connection'; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quran / القرآن الكريم'),
        backgroundColor: const Color(0xFF1B5E20),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_stories),
            tooltip: 'Browse by Juz',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const JuzScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search in Quran',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const QuranSearchScreen()),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.translate('searchSurah'),
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.7)),
                filled: true,
                fillColor: Colors.white.withOpacity(0.15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF0E1A19), const Color(0xFF121212)]
                : [const Color(0xFFF1F8E9), const Color(0xFFE8F5E9)],
          ),
        ),
        child: _loading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF1B5E20)))
            : _error != null
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.cloud_off, size: 48,
                            color: isDark ? Colors.white38 : Colors.black26),
                        const SizedBox(height: 12),
                        Text(_error!, style: TextStyle(
                            color: isDark ? Colors.white54 : Colors.black45)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() { _loading = true; _error = null; });
                            _loadSurahList();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1B5E20),
                          ),
                          child: Text(AppLocalizations.of(context)!.translate('retry'), style: const TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  )
                : Builder(builder: (context) {
                    final filtered = _searchQuery.isEmpty
                        ? _surahs
                        : _surahs.where((s) {
                            final q = _searchQuery.toLowerCase();
                            return s['englishName'].toString().toLowerCase().contains(q) ||
                                s['name'].toString().contains(_searchQuery) ||
                                s['number'].toString() == _searchQuery;
                          }).toList();

                    return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: filtered.length + (_lastReadSurah != null && _searchQuery.isEmpty ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Last read banner
                      if (_lastReadSurah != null && _searchQuery.isEmpty && index == 0) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          color: isDark ? const Color(0xFF1A2A20) : const Color(0xFFE8F5E9),
                          child: ListTile(
                            leading: const Icon(Icons.history, color: Color(0xFF1B5E20)),
                            title: Text('Continue: $_lastReadName',
                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                            subtitle: Text('Surah $_lastReadSurah',
                                style: TextStyle(fontSize: 11, color: isDark ? Colors.white38 : Colors.black38)),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF1B5E20)),
                            onTap: () {
                              final s = _surahs.firstWhere((s) => s['number'] == _lastReadSurah, orElse: () => {});
                              if (s.isNotEmpty) {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (_) => _SurahDetailScreen(
                                    surahNumber: s['number'], surahName: s['englishName'], arabicName: s['name']),
                                ));
                              }
                            },
                          ),
                        );
                      }

                      final adjustedIndex = (_lastReadSurah != null && _searchQuery.isEmpty) ? index - 1 : index;
                      final surah = filtered[adjustedIndex];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 6),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          leading: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1B5E20).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                surah['number'].toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1B5E20),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  surah['englishName'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600, fontSize: 15),
                                ),
                              ),
                              Text(
                                surah['name'],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isDark
                                      ? const Color(0xFFD4AF37)
                                      : const Color(0xFF1B5E20),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            '${surah['englishNameTranslation']} • ${surah['numberOfAyahs']} ayahs • ${surah['revelationType']}',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? Colors.white38 : Colors.black38,
                            ),
                          ),
                          onTap: () {
                            _saveLastRead(surah['number'], surah['englishName']);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => _SurahDetailScreen(
                                  surahNumber: surah['number'],
                                  surahName: surah['englishName'],
                                  arabicName: surah['name'],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                }),
      ),
    );
  }
}

// ─── Surah Detail Screen ────────────────────────────────────────────────────

class _SurahDetailScreen extends StatefulWidget {
  final int surahNumber;
  final String surahName;
  final String arabicName;

  const _SurahDetailScreen({
    required this.surahNumber,
    required this.surahName,
    required this.arabicName,
  });

  @override
  State<_SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<_SurahDetailScreen> {
  static const _reciters = {
    'ar.alafasy': 'Mishary Alafasy',
    'ar.abdulbasitmurattal': 'Abdul Basit (Murattal)',
    'ar.abdurrahmaansudais': 'Abdurrahman As-Sudais',
    'ar.hudhaify': 'Ali Al-Hudhaify',
    'ar.minshawi': 'Mohamed Al-Minshawi',
  };
  List<Map<String, String>> _ayahs = [];
  bool _loading = true;
  String? _error;
  final AudioPlayer _player = AudioPlayer();
  int? _playingAyah;
  bool _continuousPlay = false;
  double _arabicFontSize = 22.0;
  int _themeMode = 0; // 0=default, 1=sepia, 2=dark
  Set<String> _bookmarkedAyahs = {};
  final ScrollController _scrollController = ScrollController();
  String _reciter = 'ar.alafasy';

  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('quranBookmarks') ?? [];
    if (mounted) setState(() => _bookmarkedAyahs = list.toSet());
  }

  Future<void> _toggleBookmark(String ayahKey) async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      if (_bookmarkedAyahs.contains(ayahKey)) {
        _bookmarkedAyahs.remove(ayahKey);
      } else {
        _bookmarkedAyahs.add(ayahKey);
      }
    });
    await prefs.setStringList('quranBookmarks', _bookmarkedAyahs.toList());
  }

  static const _langMap = {
    'en': 'en.asad',
    'tr': 'tr.ates',
    'ru': 'ru.kuliev',
    'fr': 'fr.hamidullah',
    'de': 'de.aburida',
    'es': 'es.cortes',
    'id': 'id.indonesian',
    'ur': 'ur.jalandhry',
    'fa': 'fa.makarem',
    'nl': 'nl.keyzer',
    'pt': 'pt.elhayek',
    'ms': 'ms.basmeih',
    'ko': 'ko.korean',
    'ja': 'ja.japanese',
    'so': 'so.abduh',
    'sw': 'sw.barwani',
    'bn': 'bn.bengali',
    'zh': 'zh.majian',
    'hi': 'hi.hindi',
  };

  @override
  void initState() {
    super.initState();
    _player.onPlayerStateChanged.listen((s) {
      if (!mounted) return;
      if (s == PlayerState.completed) {
        if (_continuousPlay && _playingAyah != null && _playingAyah! + 1 < _ayahs.length) {
          _playAyah(_playingAyah! + 1);
        } else {
          setState(() => _playingAyah = null);
        }
      } else if (s == PlayerState.stopped) {
        setState(() => _playingAyah = null);
      }
    });
    _loadReciterAndContent();
  }

  Future<void> _loadReciterAndContent() async {
    final prefs = await SharedPreferences.getInstance();
    _reciter = prefs.getString('quranReciter') ?? 'ar.alafasy';
    _loadBookmarks();
    _loadAyahs();
  }

  @override
  void dispose() {
    _player.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadAyahs() async {
    final langCode =
        Provider.of<AppProvider>(context, listen: false).locale.languageCode;
    final edition = _langMap[langCode] ?? 'en.asad';
    final cacheKey = 'quran_surah_${widget.surahNumber}_$edition';

    // Try cache first
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(cacheKey);
    if (cached != null) {
      try {
        final ayahs = (json.decode(cached) as List)
            .map((e) => Map<String, String>.from(e))
            .toList();
        if (mounted) setState(() { _ayahs = ayahs; _loading = false; });
        QuranStatsService.markSurahRead(widget.surahNumber, ayahs.length);
        return;
      } catch (_) {}
    }

    // Fetch from API
    try {
      final responses = await Future.wait([
        http.get(Uri.parse(
            'https://api.alquran.cloud/v1/surah/${widget.surahNumber}/$_reciter')),
        http.get(Uri.parse(
            'https://api.alquran.cloud/v1/surah/${widget.surahNumber}/$edition')),
      ]);

      if (responses[0].statusCode == 200 && responses[1].statusCode == 200) {
        final arabicData = json.decode(responses[0].body)['data']['ayahs'] as List;
        final transData = json.decode(responses[1].body)['data']['ayahs'] as List;

        final ayahs = <Map<String, String>>[];
        for (var i = 0; i < arabicData.length; i++) {
          ayahs.add({
            'number': arabicData[i]['numberInSurah'].toString(),
            'arabic': arabicData[i]['text'] as String,
            'translation': i < transData.length
                ? transData[i]['text'] as String
                : '',
            'audio': arabicData[i]['audio'] as String? ?? '',
          });
        }
        // Cache for offline
        await prefs.setString(cacheKey, json.encode(ayahs));
        if (mounted) setState(() { _ayahs = ayahs; _loading = false; });
        QuranStatsService.markSurahRead(widget.surahNumber, ayahs.length);
      } else {
        if (mounted) setState(() { _error = 'Failed to load'; _loading = false; });
      }
    } catch (e) {
      if (mounted) setState(() { _error = 'No internet connection'; _loading = false; });
    }
  }

  Future<void> _playAyah(int index) async {
    final audio = _ayahs[index]['audio'] ?? '';
    if (audio.isEmpty) return;

    if (_playingAyah == index) {
      await _player.stop();
      if (mounted) setState(() => _playingAyah = null);
      return;
    }

    try {
      await _player.stop();
      if (mounted) {
        setState(() => _playingAyah = index);
        // Auto-scroll to playing ayah
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            index * 200.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      }
      await _player.play(UrlSource(audio));
    } catch (e) {
      if (mounted) setState(() => _playingAyah = null);
    }
  }

  Color _bgColor(bool isDark) {
    if (_themeMode == 1) return const Color(0xFFF5E6C8); // sepia
    if (_themeMode == 2) return const Color(0xFF0A0A0A); // dark
    return isDark ? const Color(0xFF0E1A19) : const Color(0xFFFFFDE7);
  }

  Color _cardColor(bool isDark) {
    if (_themeMode == 1) return const Color(0xFFFAF0DC);
    if (_themeMode == 2) return const Color(0xFF1A1A1A);
    return isDark ? const Color(0xFF1A2420) : Colors.white;
  }

  Color _textColor(bool isDark) {
    if (_themeMode == 1) return const Color(0xFF3E2723);
    if (_themeMode == 2) return const Color(0xFFE0E0E0);
    return isDark ? Colors.white70 : Colors.black87;
  }

  Color _arabicColor(bool isDark) {
    if (_themeMode == 1) return const Color(0xFF5D4037);
    if (_themeMode == 2) return const Color(0xFFD4AF37);
    return isDark ? const Color(0xFFD4AF37) : const Color(0xFF1B5E20);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: _bgColor(isDark),
      appBar: AppBar(
        title: Text('${widget.surahName} ${widget.arabicName}'),
        backgroundColor: const Color(0xFF1B5E20),
        actions: [
          // Reciter selector
          IconButton(
            icon: const Icon(Icons.record_voice_over, size: 20),
            tooltip: 'Reciter',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                builder: (_) => Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
                    const SizedBox(height: 16),
                    const Text('Reciter / القارئ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ..._reciters.entries.map((e) {
                      final selected = e.key == _reciter;
                      return ListTile(
                        leading: Icon(Icons.person, color: selected ? const Color(0xFF1B5E20) : Colors.grey),
                        title: Text(e.value, style: TextStyle(fontWeight: selected ? FontWeight.bold : FontWeight.normal, color: selected ? const Color(0xFF1B5E20) : null)),
                        trailing: selected ? const Icon(Icons.check_circle, color: Color(0xFF1B5E20)) : null,
                        onTap: () async {
                          final nav = Navigator.of(context);
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString('quranReciter', e.key);
                          if (!mounted) return;
                          setState(() { _reciter = e.key; _loading = true; });
                          nav.pop();
                          _loadAyahs();
                        },
                      );
                    }),
                  ]),
                ),
              );
            },
          ),
          // Reading theme toggle
          IconButton(
            icon: Icon(
              _themeMode == 0 ? Icons.brightness_auto
                  : _themeMode == 1 ? Icons.brightness_5
                  : Icons.brightness_2,
              size: 20,
              color: _themeMode == 1 ? const Color(0xFFD4AF37) : Colors.white,
            ),
            tooltip: 'Reading theme',
            onPressed: () => setState(() => _themeMode = (_themeMode + 1) % 3),
          ),
          // Font size controls
          IconButton(
            icon: const Icon(Icons.text_decrease, size: 20),
            tooltip: 'Smaller text',
            onPressed: () {
              if (_arabicFontSize > 16) setState(() => _arabicFontSize -= 2);
            },
          ),
          IconButton(
            icon: const Icon(Icons.text_increase, size: 20),
            tooltip: 'Larger text',
            onPressed: () {
              if (_arabicFontSize < 40) setState(() => _arabicFontSize += 2);
            },
          ),
          // Continuous play toggle
          IconButton(
            icon: Icon(
              _continuousPlay ? Icons.repeat_on : Icons.repeat,
              color: _continuousPlay ? const Color(0xFFD4AF37) : Colors.white70,
              size: 22,
            ),
            tooltip: 'Continuous Play',
            onPressed: () => setState(() => _continuousPlay = !_continuousPlay),
          ),
          // Play all from beginning
          if (_ayahs.isNotEmpty)
            IconButton(
              icon: Icon(
                _playingAyah != null ? Icons.stop : Icons.play_arrow,
                color: Colors.white,
              ),
              tooltip: _playingAyah != null ? 'Stop' : 'Play All',
              onPressed: () {
                if (_playingAyah != null) {
                  _player.stop();
                } else {
                  _continuousPlay = true;
                  _playAyah(0);
                }
              },
            ),
          const SizedBox(width: 4),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF0E1A19), const Color(0xFF121212)]
                : [const Color(0xFFFFFDE7), const Color(0xFFF1F8E9)],
          ),
        ),
        child: _loading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF1B5E20)))
            : _error != null
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.cloud_off, size: 48,
                            color: isDark ? Colors.white38 : Colors.black26),
                        const SizedBox(height: 12),
                        Text(_error!),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() { _loading = true; _error = null; });
                            _loadAyahs();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1B5E20)),
                          child: Text(AppLocalizations.of(context)!.translate('retry'), style: const TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    // +1 for the Bismillah header (shown except for At-Tawbah surah 9)
                    itemCount: _ayahs.length + (widget.surahNumber != 9 && widget.surahNumber != 1 ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Bismillah header for all surahs except At-Tawbah (9) and Al-Fatiha (already contains it)
                      if (widget.surahNumber != 9 && widget.surahNumber != 1 && index == 0) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 20, top: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isDark
                                  ? [const Color(0xFF1A2A20), const Color(0xFF182624)]
                                  : [const Color(0xFFFFF8E1), const Color(0xFFFFFDE7)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.5), width: 1.5),
                          ),
                          child: Column(children: [
                            Text(
                              'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w500,
                                color: isDark ? const Color(0xFFE3C77B) : const Color(0xFF1B5E20),
                                height: 1.8,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(width: 40, height: 1, color: const Color(0xFFD4AF37).withOpacity(0.5)),
                          ]),
                        );
                      }
                      final ayahIndex = widget.surahNumber != 9 && widget.surahNumber != 1 ? index - 1 : index;
                      final ayah = _ayahs[ayahIndex];
                      final isPlaying = _playingAyah == ayahIndex;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isPlaying
                              ? (isDark ? const Color(0xFF1A3020) : const Color(0xFFE8F5E9))
                              : _cardColor(isDark),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isPlaying
                                ? const Color(0xFF1B5E20)
                                : (isDark ? const Color(0xFF2A3A34) : const Color(0xFFE0E0E0)),
                            width: isPlaying ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Ayah number + play button
                            Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1B5E20)
                                        .withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      ayah['number']!,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1B5E20),
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                // Bookmark
                                Builder(builder: (_) {
                                  final key = '${widget.surahNumber}:${ayah['number']}';
                                  final isBookmarked = _bookmarkedAyahs.contains(key);
                                  return InkWell(
                                    onTap: () => _toggleBookmark(key),
                                    child: Icon(
                                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                      color: const Color(0xFFD4AF37),
                                      size: 22,
                                    ),
                                  );
                                }),
                                const SizedBox(width: 8),
                                // Share ayah
                                InkWell(
                                  onTap: () {
                                    Share.share(
                                      '${ayah['arabic']}\n\n${ayah['translation']}\n\n— ${widget.surahName} ${ayah['number']}\n\n📱 Islamic Companion App',
                                    );
                                  },
                                  child: Icon(Icons.share_outlined,
                                      color: isDark ? Colors.white38 : Colors.black26, size: 20),
                                ),
                                const SizedBox(width: 12),
                                // Play
                                if (ayah['audio']!.isNotEmpty)
                                  InkWell(
                                    onTap: () => _playAyah(ayahIndex),
                                    child: Icon(
                                      isPlaying
                                          ? Icons.stop_circle
                                          : Icons.play_circle,
                                      color: const Color(0xFF1B5E20),
                                      size: 28,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Arabic text
                            Text(
                              ayah['arabic']!,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontSize: _arabicFontSize,
                                height: 2.0,
                                color: _arabicColor(isDark),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Translation
                            Text(
                              ayah['translation']!,
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.6,
                                color: _textColor(isDark),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
