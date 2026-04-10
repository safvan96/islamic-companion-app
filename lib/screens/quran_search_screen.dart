import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/app_provider.dart';

class QuranSearchScreen extends StatefulWidget {
  const QuranSearchScreen({super.key});

  @override
  State<QuranSearchScreen> createState() => _QuranSearchScreenState();
}

class _QuranSearchScreenState extends State<QuranSearchScreen> {
  final _controller = TextEditingController();
  List<Map<String, dynamic>> _results = [];
  bool _loading = false;
  String? _error;

  Future<void> _search(String query) async {
    if (query.trim().length < 3) return;
    setState(() { _loading = true; _error = null; _results = []; });

    try {
      final langCode =
          Provider.of<AppProvider>(context, listen: false).locale.languageCode;

      // Search in English edition (API only supports keyword search in specific editions)
      final editionMap = {
        'en': 'en.asad', 'tr': 'tr.ates', 'ru': 'ru.kuliev',
        'fr': 'fr.hamidullah', 'de': 'de.aburida', 'es': 'es.cortes',
        'id': 'id.indonesian', 'ur': 'ur.jalandhry', 'fa': 'fa.makarem',
      };
      final edition = editionMap[langCode] ?? 'en.asad';

      final response = await http.get(
        Uri.parse('https://api.alquran.cloud/v1/search/${Uri.encodeComponent(query.trim())}/all/$edition'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null && data['data']['matches'] != null) {
          final matches = (data['data']['matches'] as List).map((m) => {
            'text': m['text'] as String,
            'surahName': m['surah']['englishName'] as String,
            'surahNameAr': m['surah']['name'] as String,
            'surahNumber': m['surah']['number'] as int,
            'ayahNumber': m['numberInSurah'] as int,
          }).toList();
          if (mounted) setState(() { _results = matches; _loading = false; });
        } else {
          if (mounted) setState(() { _results = []; _loading = false; });
        }
      } else {
        if (mounted) setState(() { _error = 'Search failed'; _loading = false; });
      }
    } catch (e) {
      if (mounted) setState(() { _error = 'No internet connection'; _loading = false; });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Quran'),
        backgroundColor: const Color(0xFF1B5E20),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              onSubmitted: _search,
              decoration: InputDecoration(
                hintText: 'Search in Quran (min 3 chars)...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _search(_controller.text),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: isDark ? Colors.white.withOpacity(0.08) : Colors.grey.withOpacity(0.08),
              ),
            ),
          ),
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(color: Color(0xFF1B5E20)),
            ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Text(_error!, style: TextStyle(color: isDark ? Colors.white54 : Colors.black45)),
            ),
          if (!_loading && _results.isEmpty && _controller.text.length >= 3)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Text('No results found',
                  style: TextStyle(color: isDark ? Colors.white38 : Colors.black38)),
            ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final r = _results[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1B5E20).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${r['surahName']} ${r['ayahNumber']}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1B5E20),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              r['surahNameAr'],
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? const Color(0xFFD4AF37) : const Color(0xFF1B5E20),
                              ),
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () => Share.share(
                                '${r['text']}\n\n— ${r['surahName']} ${r['ayahNumber']}\n\n📱 Islamic Companion App',
                              ),
                              child: Icon(Icons.share_outlined, size: 18,
                                  color: isDark ? Colors.white38 : Colors.black26),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          r['text'],
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.6,
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
