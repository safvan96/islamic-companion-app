import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class PrayerGuideScreen extends StatelessWidget {
  const PrayerGuideScreen({super.key});

  static const _steps = [
    {
      'icon': Icons.water_drop,
      'title': {'en': 'Wudu (Ablution)', 'tr': 'Abdest'},
      'desc': {
        'en': 'Perform wudu by washing hands, mouth, nose, face, arms, wiping head, and washing feet.',
        'tr': 'Elleri, ağzı, burnu, yüzü, kolları yıka, başı mesh et, ayakları yıka.',
      },
      'arabic': 'الوُضُوء',
    },
    {
      'icon': Icons.my_location,
      'title': {'en': 'Face the Qibla', 'tr': 'Kıbleye Dön'},
      'desc': {
        'en': 'Stand facing the direction of the Kaaba in Makkah.',
        'tr': 'Mekke\'deki Kabe\'nin yönüne doğru dur.',
      },
      'arabic': 'اسْتِقْبَالُ الْقِبْلَةِ',
    },
    {
      'icon': Icons.record_voice_over,
      'title': {'en': 'Niyyah (Intention)', 'tr': 'Niyet'},
      'desc': {
        'en': 'Make the intention in your heart for the specific prayer you are about to perform.',
        'tr': 'Kılacağın namaz için kalbinde niyet et.',
      },
      'arabic': 'النِّيَّةُ',
    },
    {
      'icon': Icons.pan_tool,
      'title': {'en': 'Takbir - Allahu Akbar', 'tr': 'Tekbir - Allahu Ekber'},
      'desc': {
        'en': 'Raise both hands to ear level and say "Allahu Akbar" (Allah is the Greatest).',
        'tr': 'İki elini kulak hizasına kaldır ve "Allahu Ekber" de.',
      },
      'arabic': 'اللَّهُ أَكْبَرُ',
    },
    {
      'icon': Icons.menu_book,
      'title': {'en': 'Qiyam - Standing', 'tr': 'Kıyam - Ayakta Durma'},
      'desc': {
        'en': 'Place right hand over left on chest. Recite Al-Fatiha and a short surah.',
        'tr': 'Sağ eli sol elin üzerine göğse koy. Fatiha ve kısa bir sure oku.',
      },
      'arabic': 'الْقِيَامُ - الْفَاتِحَة',
    },
    {
      'icon': Icons.arrow_downward,
      'title': {'en': 'Ruku - Bowing', 'tr': 'Rükû - Eğilme'},
      'desc': {
        'en': 'Bow with hands on knees, back straight. Say "Subhana Rabbiyal Azim" 3 times.',
        'tr': 'Elleri dizlere koy, sırtı düz tut. "Sübhane Rabbiyel Azim" 3 kez de.',
      },
      'arabic': 'سُبْحَانَ رَبِّيَ الْعَظِيمِ',
    },
    {
      'icon': Icons.straight,
      'title': {'en': 'Stand from Ruku', 'tr': 'Rükûdan Kalkma'},
      'desc': {
        'en': 'Rise saying "Sami Allahu liman hamidah, Rabbana lakal hamd".',
        'tr': '"Semiallahu limen hamideh, Rabbena lekel hamd" diyerek kalk.',
      },
      'arabic': 'سَمِعَ اللَّهُ لِمَنْ حَمِدَهُ',
    },
    {
      'icon': Icons.south,
      'title': {'en': 'Sujud - Prostration', 'tr': 'Secde'},
      'desc': {
        'en': 'Place forehead, nose, palms, knees, and toes on ground. Say "Subhana Rabbiyal A\'la" 3 times.',
        'tr': 'Alnını, burnunu, avuçlarını, dizlerini ve ayak parmaklarını yere koy. "Sübhane Rabbiyel A\'la" 3 kez de.',
      },
      'arabic': 'سُبْحَانَ رَبِّيَ الأَعْلَى',
    },
    {
      'icon': Icons.event_seat,
      'title': {'en': 'Sitting between Sujud', 'tr': 'İki Secde Arası Oturma'},
      'desc': {
        'en': 'Sit briefly and say "Rabbighfirli" (My Lord, forgive me). Then do second sujud.',
        'tr': 'Kısa otur ve "Rabbigfirli" de (Rabbim beni bağışla). Sonra ikinci secdeyi yap.',
      },
      'arabic': 'رَبِّ اغْفِرْ لِي',
    },
    {
      'icon': Icons.repeat,
      'title': {'en': 'Repeat', 'tr': 'Tekrar'},
      'desc': {
        'en': 'This completes one rak\'ah. Repeat for the required number of rak\'ahs.',
        'tr': 'Bu bir rekât tamamlar. Gerekli rekât sayısı kadar tekrarla.',
      },
      'arabic': 'رَكْعَة',
    },
    {
      'icon': Icons.chair,
      'title': {'en': 'Tashahhud - Final Sitting', 'tr': 'Tahiyyat - Son Oturuş'},
      'desc': {
        'en': 'In the last rak\'ah, sit and recite At-Tahiyyat, then Salawat on the Prophet.',
        'tr': 'Son rekâtta otur, Tahiyyat\'ı oku, sonra Peygamber\'e salavat getir.',
      },
      'arabic': 'التَّحِيَّاتُ',
    },
    {
      'icon': Icons.waving_hand,
      'title': {'en': 'Taslim - Salaam', 'tr': 'Selam'},
      'desc': {
        'en': 'Turn head right saying "Assalamu alaikum wa rahmatullah", then left.',
        'tr': 'Başını sağa çevir "Esselamu aleyküm ve rahmetullah" de, sonra sola.',
      },
      'arabic': 'السَّلَامُ عَلَيْكُمْ وَرَحْمَةُ اللَّهِ',
    },
  ];

  // Rak'ah counts per prayer
  static const _rakahs = {
    'en': {'Fajr': '2 Sunnah + 2 Fard', 'Dhuhr': '4 Sunnah + 4 Fard + 2 Sunnah', 'Asr': '4 Fard', 'Maghrib': '3 Fard + 2 Sunnah', 'Isha': '4 Fard + 2 Sunnah + 3 Witr'},
    'tr': {'Fajr': '2 Sünnet + 2 Farz', 'Dhuhr': '4 Sünnet + 4 Farz + 2 Sünnet', 'Asr': '4 Farz', 'Maghrib': '3 Farz + 2 Sünnet', 'Isha': '4 Farz + 2 Sünnet + 3 Vitir'},
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final langCode = Provider.of<AppProvider>(context).locale.languageCode;
    final lang = (langCode == 'tr') ? 'tr' : 'en';

    return Scaffold(
      appBar: AppBar(
        title: Text(lang == 'tr' ? 'Namaz Rehberi' : 'Prayer Guide'),
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
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Rak'ah info card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: isDark ? const Color(0xFF1A2A20) : const Color(0xFFE8F5E9),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lang == 'tr' ? 'Rekât Sayıları' : 'Rak\'ah Counts',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isDark ? Colors.white : const Color(0xFF1B5E20),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...(_rakahs[lang] ?? _rakahs['en']!).entries.map((e) =>
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 70,
                              child: Text(e.key, style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white70 : Colors.black87,
                              )),
                            ),
                            Expanded(child: Text(e.value, style: TextStyle(
                              fontSize: 13,
                              color: isDark ? Colors.white54 : Colors.black54,
                            ))),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Steps
            ...List.generate(_steps.length, (i) {
              final step = _steps[i];
              final title = (step['title'] as Map<String, String>)[lang] ??
                  (step['title'] as Map<String, String>)['en']!;
              final desc = (step['desc'] as Map<String, String>)[lang] ??
                  (step['desc'] as Map<String, String>)['en']!;

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B5E20).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(step['icon'] as IconData,
                              color: const Color(0xFF1B5E20), size: 22),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${i + 1}. $title',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              step['arabic'] as String,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontSize: 16,
                                color: isDark ? const Color(0xFFD4AF37) : const Color(0xFF1B5E20),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              desc,
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.5,
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
