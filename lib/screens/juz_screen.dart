import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class JuzScreen extends StatelessWidget {
  const JuzScreen({super.key});

  static const _juzNames = [
    'Alif Lam Mim', 'Sayaqool', 'Tilkar Rusul', 'Lan Tanaloo',
    'Wal Muhsanat', 'La Yuhibbullah', 'Wa Iza Samiu', 'Wa Lau Annana',
    'Qalal Mala', 'Wa Alamu', 'Yatazeroon', 'Wa Ma Min Dabbah',
    'Wa Ma Ubarriu', 'Rubama', 'Subhanallazi', 'Qal Alam',
    'Iqtaraba', 'Qad Aflaha', 'Wa Qalallazina', 'Amman Khalaq',
    'Utlu Ma Uhiya', 'Wa Man Yaqnut', 'Wa Mali', 'Faman Azlamu',
    'Ilaihi Yuraddu', 'Ha Mim', 'Qala Fama Khatbukum',
    'Qad Sami Allahu', 'Tabarakallazi', 'Amma',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Juz / أجزاء'),
        backgroundColor: const Color(0xFF1B5E20),
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
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: 30,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.only(bottom: 6),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              child: ListTile(
                leading: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4AF37).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD4AF37),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  'Juz ${index + 1}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 15),
                ),
                subtitle: Text(
                  _juzNames[index],
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white38 : Colors.black38,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right, size: 18),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => _JuzDetailScreen(juzNumber: index + 1),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _JuzDetailScreen extends StatefulWidget {
  final int juzNumber;
  const _JuzDetailScreen({required this.juzNumber});

  @override
  State<_JuzDetailScreen> createState() => _JuzDetailScreenState();
}

class _JuzDetailScreenState extends State<_JuzDetailScreen> {
  List<Map<String, dynamic>> _ayahs = [];
  bool _loading = true;
  String? _error;

  static const _editionMap = {
    'en': 'en.asad', 'tr': 'tr.ates', 'ru': 'ru.kuliev',
    'fr': 'fr.hamidullah', 'de': 'de.aburida', 'id': 'id.indonesian',
    'ur': 'ur.jalandhry', 'fa': 'fa.makarem', 'es': 'es.cortes',
    'hi': 'hi.hindi', 'zh': 'zh.majian', 'bn': 'bn.bengali',
  };

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final langCode =
          Provider.of<AppProvider>(context, listen: false).locale.languageCode;
      final edition = _editionMap[langCode] ?? 'en.asad';

      final responses = await Future.wait([
        http.get(Uri.parse(
            'https://api.alquran.cloud/v1/juz/${widget.juzNumber}/quran-uthmani')),
        http.get(Uri.parse(
            'https://api.alquran.cloud/v1/juz/${widget.juzNumber}/$edition')),
      ]);

      if (responses[0].statusCode == 200 && responses[1].statusCode == 200) {
        final arData =
            json.decode(responses[0].body)['data']['ayahs'] as List;
        final trData =
            json.decode(responses[1].body)['data']['ayahs'] as List;

        final ayahs = <Map<String, dynamic>>[];
        for (var i = 0; i < arData.length; i++) {
          ayahs.add({
            'arabic': arData[i]['text'],
            'translation': i < trData.length ? trData[i]['text'] : '',
            'surahName': arData[i]['surah']['englishName'],
            'ayahNumber': arData[i]['numberInSurah'],
          });
        }
        if (mounted) setState(() { _ayahs = ayahs; _loading = false; });
      } else {
        if (mounted)
          setState(() { _error = 'Failed to load'; _loading = false; });
      }
    } catch (e) {
      if (mounted)
        setState(
            () { _error = 'No internet connection'; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text('Juz ${widget.juzNumber}'),
        backgroundColor: const Color(0xFF1B5E20),
      ),
      body: _loading
          ? const Center(
              child:
                  CircularProgressIndicator(color: Color(0xFF1B5E20)))
          : _error != null
              ? Center(
                  child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.cloud_off,
                        size: 48,
                        color: isDark ? Colors.white38 : Colors.black26),
                    const SizedBox(height: 12),
                    Text(_error!),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        setState(() { _loading = true; _error = null; });
                        _load();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B5E20)),
                      child: const Text('Retry',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _ayahs.length,
                  itemBuilder: (context, index) {
                    final a = _ayahs[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1A2420)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: isDark
                                ? const Color(0xFF2A3A34)
                                : const Color(0xFFE0E0E0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            '${a['surahName']} : ${a['ayahNumber']}',
                            style: TextStyle(
                                fontSize: 10,
                                color: isDark
                                    ? Colors.white38
                                    : Colors.black38),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            a['arabic'],
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontSize: 20,
                              height: 2.0,
                              color: isDark
                                  ? const Color(0xFFD4AF37)
                                  : const Color(0xFF1B5E20),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            a['translation'],
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.5,
                              color: isDark
                                  ? Colors.white70
                                  : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
