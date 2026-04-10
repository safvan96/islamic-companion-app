import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';

class _P {
  final Color bg, surface, accent, gold, fg, muted, divider;
  const _P({required this.bg, required this.surface, required this.accent, required this.gold, required this.fg, required this.muted, required this.divider});
  static _P of(bool d) => d
      ? const _P(bg: Color(0xFF0E1A19), surface: Color(0xFF182624), accent: Color(0xFF4FBFA8), gold: Color(0xFFE3C77B), fg: Color(0xFFF5F1E8), muted: Color(0xFF8B968F), divider: Color(0xFF243532))
      : const _P(bg: Color(0xFFF8F5EE), surface: Color(0xFFFFFFFF), accent: Color(0xFF2C7A6B), gold: Color(0xFFB8902B), fg: Color(0xFF1F2937), muted: Color(0xFF6B6359), divider: Color(0xFFE8DDD0));
}

// All 114 surahs with verse count
const _surahs = [
  (1,'Al-Fatiha',7),(2,'Al-Baqarah',286),(3,'Ali Imran',200),(4,'An-Nisa',176),
  (5,'Al-Maidah',120),(6,'Al-Anam',165),(7,'Al-Araf',206),(8,'Al-Anfal',75),
  (9,'At-Tawbah',129),(10,'Yunus',109),(11,'Hud',123),(12,'Yusuf',111),
  (13,'Ar-Rad',43),(14,'Ibrahim',52),(15,'Al-Hijr',99),(16,'An-Nahl',128),
  (17,'Al-Isra',111),(18,'Al-Kahf',110),(19,'Maryam',98),(20,'Taha',135),
  (21,'Al-Anbiya',112),(22,'Al-Hajj',78),(23,'Al-Muminun',118),(24,'An-Nur',64),
  (25,'Al-Furqan',77),(26,'Ash-Shuara',227),(27,'An-Naml',93),(28,'Al-Qasas',88),
  (29,'Al-Ankabut',69),(30,'Ar-Rum',60),(31,'Luqman',34),(32,'As-Sajdah',30),
  (33,'Al-Ahzab',73),(34,'Saba',54),(35,'Fatir',45),(36,'Ya-Sin',83),
  (37,'As-Saffat',182),(38,'Sad',88),(39,'Az-Zumar',75),(40,'Ghafir',85),
  (41,'Fussilat',54),(42,'Ash-Shura',53),(43,'Az-Zukhruf',89),(44,'Ad-Dukhan',59),
  (45,'Al-Jathiyah',37),(46,'Al-Ahqaf',35),(47,'Muhammad',38),(48,'Al-Fath',29),
  (49,'Al-Hujurat',18),(50,'Qaf',45),(51,'Adh-Dhariyat',60),(52,'At-Tur',49),
  (53,'An-Najm',62),(54,'Al-Qamar',55),(55,'Ar-Rahman',78),(56,'Al-Waqiah',96),
  (57,'Al-Hadid',29),(58,'Al-Mujadila',22),(59,'Al-Hashr',24),(60,'Al-Mumtahina',13),
  (61,'As-Saff',14),(62,'Al-Jumuah',11),(63,'Al-Munafiqun',11),(64,'At-Taghabun',18),
  (65,'At-Talaq',12),(66,'At-Tahrim',12),(67,'Al-Mulk',30),(68,'Al-Qalam',52),
  (69,'Al-Haqqah',52),(70,'Al-Maarij',44),(71,'Nuh',28),(72,'Al-Jinn',28),
  (73,'Al-Muzzammil',20),(74,'Al-Muddaththir',56),(75,'Al-Qiyamah',40),(76,'Al-Insan',31),
  (77,'Al-Mursalat',50),(78,'An-Naba',40),(79,'An-Naziat',46),(80,'Abasa',42),
  (81,'At-Takwir',29),(82,'Al-Infitar',19),(83,'Al-Mutaffifin',36),(84,'Al-Inshiqaq',25),
  (85,'Al-Buruj',22),(86,'At-Tariq',17),(87,'Al-Ala',19),(88,'Al-Ghashiyah',26),
  (89,'Al-Fajr',30),(90,'Al-Balad',20),(91,'Ash-Shams',15),(92,'Al-Layl',21),
  (93,'Ad-Duha',11),(94,'Ash-Sharh',8),(95,'At-Tin',8),(96,'Al-Alaq',19),
  (97,'Al-Qadr',5),(98,'Al-Bayyinah',8),(99,'Az-Zalzalah',8),(100,'Al-Adiyat',11),
  (101,'Al-Qariah',11),(102,'At-Takathur',8),(103,'Al-Asr',3),(104,'Al-Humazah',9),
  (105,'Al-Fil',5),(106,'Quraysh',4),(107,'Al-Maun',7),(108,'Al-Kawthar',3),
  (109,'Al-Kafirun',6),(110,'An-Nasr',3),(111,'Al-Masad',5),(112,'Al-Ikhlas',4),
  (113,'Al-Falaq',5),(114,'An-Nas',6),
];

class HifzScreen extends StatefulWidget {
  const HifzScreen({super.key});
  @override
  State<HifzScreen> createState() => _HifzScreenState();
}

class _HifzScreenState extends State<HifzScreen> {
  // Status: 0=not started, 1=learning, 2=memorized
  List<int> _status = List<int>.filled(114, 0);
  String _search = '';
  int _filter = -1; // -1=all, 0=not started, 1=learning, 2=memorized

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('hifzStatus');
    if (raw != null) {
      try {
        final list = List<int>.from(jsonDecode(raw));
        if (list.length == 114) _status = list;
      } catch (_) {}
    }
    setState(() {});
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('hifzStatus', jsonEncode(_status));
  }

  void _cycle(int index) {
    HapticFeedback.lightImpact();
    setState(() {
      _status[index] = (_status[index] + 1) % 3;
    });
    _save();
  }

  int get _memorizedCount => _status.where((s) => s == 2).length;
  int get _learningCount => _status.where((s) => s == 1).length;
  int get _memorizedAyahs => _status.asMap().entries
      .where((e) => e.value == 2)
      .fold(0, (sum, e) => sum + _surahs[e.key].$3);

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;
    final totalAyahs = _surahs.fold(0, (sum, s) => sum + s.$3);

    // Filter & search
    final indices = List.generate(114, (i) => i).where((i) {
      if (_filter >= 0 && _status[i] != _filter) return false;
      if (_search.isNotEmpty) {
        final q = _search.toLowerCase();
        final s = _surahs[i];
        if (!s.$2.toLowerCase().contains(q) && !s.$1.toString().contains(q)) return false;
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0,
        foregroundColor: p.fg,
        title: Text(l10n.translate('hifzTracker'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // Stats
                Row(
                  children: [
                    _Stat(p: p, value: '$_memorizedCount', label: l10n.translate('memorized'), color: p.gold),
                    const SizedBox(width: 8),
                    _Stat(p: p, value: '$_learningCount', label: l10n.translate('learning'), color: p.accent),
                    const SizedBox(width: 8),
                    _Stat(p: p, value: '$_memorizedAyahs', label: l10n.translate('ayahs'), color: p.fg),
                  ],
                ),
                const SizedBox(height: 8),
                // Progress
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: totalAyahs == 0 ? 0 : _memorizedAyahs / totalAyahs,
                    minHeight: 5,
                    backgroundColor: p.divider,
                    valueColor: AlwaysStoppedAnimation(p.gold),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$_memorizedAyahs / $totalAyahs ${l10n.translate('ayahs')} (${(_memorizedAyahs / totalAyahs * 100).toStringAsFixed(1)}%)',
                  style: TextStyle(fontSize: 10, color: p.muted),
                ),
                const SizedBox(height: 12),
                // Search
                Container(
                  decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: p.divider)),
                  child: TextField(
                    onChanged: (v) => setState(() => _search = v),
                    style: TextStyle(color: p.fg, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: l10n.translate('searchSurah'),
                      hintStyle: TextStyle(color: p.muted, fontSize: 13),
                      prefixIcon: Icon(Icons.search, color: p.muted, size: 18),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Filter chips
                Row(
                  children: [
                    _Chip(label: l10n.translate('allNames'), active: _filter == -1, color: p.accent, p: p, onTap: () => setState(() => _filter = -1)),
                    const SizedBox(width: 6),
                    _Chip(label: l10n.translate('memorized'), active: _filter == 2, color: p.gold, p: p, onTap: () => setState(() => _filter = 2)),
                    const SizedBox(width: 6),
                    _Chip(label: l10n.translate('learning'), active: _filter == 1, color: p.accent, p: p, onTap: () => setState(() => _filter = 1)),
                    const SizedBox(width: 6),
                    _Chip(label: l10n.translate('notStarted'), active: _filter == 0, color: p.muted, p: p, onTap: () => setState(() => _filter = 0)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              itemCount: indices.length,
              itemBuilder: (context, i) {
                final idx = indices[i];
                final s = _surahs[idx];
                final status = _status[idx];
                final statusColor = status == 2 ? p.gold : status == 1 ? p.accent : p.divider;
                final statusLabel = status == 2 ? '✓' : status == 1 ? '◐' : '○';

                return GestureDetector(
                  onTap: () => _cycle(idx),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: status == 2 ? p.gold.withOpacity(0.06) : p.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: status > 0 ? statusColor.withOpacity(0.4) : p.divider),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32, height: 32,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: statusColor.withOpacity(0.15), border: Border.all(color: statusColor, width: 1.5)),
                          child: Center(child: Text(statusLabel, style: TextStyle(fontSize: 14, color: statusColor))),
                        ),
                        const SizedBox(width: 10),
                        Text('${s.$1}', style: TextStyle(fontSize: 12, color: p.muted, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 8),
                        Expanded(child: Text(s.$2, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: p.fg))),
                        Text('${s.$3} ${l10n.translate('ayahs')}', style: TextStyle(fontSize: 10, color: p.muted)),
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

class _Stat extends StatelessWidget {
  final _P p; final String value, label; final Color color;
  const _Stat({required this.p, required this.value, required this.label, required this.color});
  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: p.divider)),
      child: Column(children: [
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: color)),
        Text(label, style: TextStyle(fontSize: 8, color: p.muted, fontWeight: FontWeight.w600, letterSpacing: 0.5), maxLines: 1, overflow: TextOverflow.ellipsis),
      ]),
    ));
  }
}

class _Chip extends StatelessWidget {
  final String label; final bool active; final Color color; final _P p; final VoidCallback onTap;
  const _Chip({required this.label, required this.active, required this.color, required this.p, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: active ? color.withOpacity(0.15) : Colors.transparent, borderRadius: BorderRadius.circular(6), border: Border.all(color: active ? color : p.divider)),
      child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: active ? color : p.muted)),
    ));
  }
}
