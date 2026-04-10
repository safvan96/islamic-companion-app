import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';

class _P {
  final Color bg, surface, accent, gold, fg, muted, divider;
  const _P({required this.bg, required this.surface, required this.accent, required this.gold, required this.fg, required this.muted, required this.divider});
  static _P of(bool d) => d
      ? const _P(bg: Color(0xFF0E1A19), surface: Color(0xFF182624), accent: Color(0xFF4FBFA8), gold: Color(0xFFE3C77B), fg: Color(0xFFF5F1E8), muted: Color(0xFF8B968F), divider: Color(0xFF243532))
      : const _P(bg: Color(0xFFF8F5EE), surface: Color(0xFFFFFFFF), accent: Color(0xFF2C7A6B), gold: Color(0xFFB8902B), fg: Color(0xFF1F2937), muted: Color(0xFF6B6359), divider: Color(0xFFE8DDD0));
}

class _Name {
  final String name;
  final String arabic;
  final String meaning;
  final bool isMale;
  const _Name(this.name, this.arabic, this.meaning, this.isMale);
}

const _names = [
  // Male names
  _Name('Muhammad', 'مُحَمَّد', 'Praised, praiseworthy', true),
  _Name('Ahmad', 'أَحْمَد', 'Most commendable', true),
  _Name('Ali', 'عَلِيّ', 'Exalted, noble', true),
  _Name('Omar', 'عُمَر', 'Flourishing, long-lived', true),
  _Name('Ibrahim', 'إِبْرَاهِيم', 'Father of nations', true),
  _Name('Yusuf', 'يُوسُف', 'God increases', true),
  _Name('Hassan', 'حَسَن', 'Beautiful, good', true),
  _Name('Hussein', 'حُسَيْن', 'Beautiful, handsome', true),
  _Name('Khalid', 'خَالِد', 'Eternal, immortal', true),
  _Name('Bilal', 'بِلَال', 'Moisture, freshness', true),
  _Name('Hamza', 'حَمْزَة', 'Strong, steadfast', true),
  _Name('Zayd', 'زَيْد', 'Growth, abundance', true),
  _Name('Tariq', 'طَارِق', 'Morning star', true),
  _Name('Amir', 'أَمِير', 'Prince, commander', true),
  _Name('Idris', 'إِدْرِيس', 'Interpreter, studious', true),
  _Name('Ismail', 'إِسْمَاعِيل', 'God will hear', true),
  _Name('Adam', 'آدَم', 'Man, earth', true),
  _Name('Nuh', 'نُوح', 'Rest, comfort', true),
  _Name('Dawud', 'دَاوُد', 'Beloved', true),
  _Name('Sulaiman', 'سُلَيْمَان', 'Man of peace', true),
  _Name('Isa', 'عِيسَى', 'God is salvation', true),
  _Name('Musa', 'مُوسَى', 'Drawn from water', true),
  _Name('Rayyan', 'رَيَّان', 'Gate of paradise for fasting', true),
  _Name('Zain', 'زَيْن', 'Beauty, grace', true),
  _Name('Faris', 'فَارِس', 'Knight, horseman', true),
  // Female names
  _Name('Aisha', 'عَائِشَة', 'Living, alive', false),
  _Name('Fatima', 'فَاطِمَة', 'Captivating, one who abstains', false),
  _Name('Khadija', 'خَدِيجَة', 'Premature child, trustworthy', false),
  _Name('Maryam', 'مَرْيَم', 'Beloved, sea of sorrow', false),
  _Name('Zahra', 'زَهْرَاء', 'Radiant, brilliant', false),
  _Name('Amina', 'آمِنَة', 'Trustworthy, faithful', false),
  _Name('Hafsa', 'حَفْصَة', 'Young lioness', false),
  _Name('Sumaya', 'سُمَيَّة', 'High above', false),
  _Name('Layla', 'لَيْلَى', 'Night, dark beauty', false),
  _Name('Noor', 'نُور', 'Light, radiance', false),
  _Name('Sarah', 'سَارَة', 'Princess, noble lady', false),
  _Name('Hana', 'هَنَاء', 'Happiness, bliss', false),
  _Name('Yasmin', 'يَاسْمِين', 'Jasmine flower', false),
  _Name('Safiya', 'صَفِيَّة', 'Pure, chosen', false),
  _Name('Ruqayya', 'رُقَيَّة', 'Ascent, progress', false),
  _Name('Asiya', 'آسِيَة', 'One who heals', false),
  _Name('Salma', 'سَلْمَى', 'Peaceful', false),
  _Name('Zainab', 'زَيْنَب', 'Fragrant flower', false),
  _Name('Iman', 'إِيمَان', 'Faith, belief', false),
  _Name('Rahma', 'رَحْمَة', 'Mercy, compassion', false),
  _Name('Dua', 'دُعَاء', 'Prayer, supplication', false),
  _Name('Malak', 'مَلَك', 'Angel', false),
  _Name('Jana', 'جَنَّة', 'Paradise, garden', false),
  _Name('Huda', 'هُدَى', 'Guidance', false),
  _Name('Nur', 'نُور', 'Light', false),
];

class NamesScreen extends StatefulWidget {
  const NamesScreen({super.key});
  @override
  State<NamesScreen> createState() => _NamesScreenState();
}

class _NamesScreenState extends State<NamesScreen> {
  String _search = '';
  bool? _genderFilter; // null = all, true = male, false = female

  List<_Name> get _filtered {
    var list = _names.toList();
    if (_genderFilter != null) {
      list = list.where((n) => n.isMale == _genderFilter).toList();
    }
    if (_search.isNotEmpty) {
      final q = _search.toLowerCase();
      list = list.where((n) =>
        n.name.toLowerCase().contains(q) ||
        n.meaning.toLowerCase().contains(q) ||
        n.arabic.contains(q)
      ).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;
    final names = _filtered;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: p.fg,
        title: Text(
          l10n.translate('islamicNames'),
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // Search
                Container(
                  decoration: BoxDecoration(
                    color: p.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: p.divider),
                  ),
                  child: TextField(
                    onChanged: (v) => setState(() => _search = v),
                    style: TextStyle(color: p.fg, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: l10n.translate('searchNames'),
                      hintStyle: TextStyle(color: p.muted),
                      prefixIcon: Icon(Icons.search, color: p.muted, size: 20),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Gender filter
                Row(
                  children: [
                    _FilterChip(label: l10n.translate('allNames'), active: _genderFilter == null, color: p.accent, p: p, onTap: () => setState(() => _genderFilter = null)),
                    const SizedBox(width: 8),
                    _FilterChip(label: l10n.translate('boys'), active: _genderFilter == true, color: const Color(0xFF42A5F5), p: p, onTap: () => setState(() => _genderFilter = true)),
                    const SizedBox(width: 8),
                    _FilterChip(label: l10n.translate('girls'), active: _genderFilter == false, color: const Color(0xFFEC407A), p: p, onTap: () => setState(() => _genderFilter = false)),
                    const Spacer(),
                    Text('${names.length}', style: TextStyle(fontSize: 12, color: p.muted)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              itemCount: names.length,
              itemBuilder: (context, i) {
                final n = names[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: p.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: p.divider),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (n.isMale ? const Color(0xFF42A5F5) : const Color(0xFFEC407A)).withOpacity(0.12),
                        ),
                        child: Icon(
                          n.isMale ? Icons.male : Icons.female,
                          size: 18,
                          color: n.isMale ? const Color(0xFF42A5F5) : const Color(0xFFEC407A),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(n.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: p.fg)),
                                const SizedBox(width: 8),
                                Text(n.arabic, textDirection: TextDirection.rtl, style: TextStyle(fontSize: 14, color: p.gold)),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(n.meaning, style: TextStyle(fontSize: 12, color: p.muted)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.share_outlined, size: 18, color: p.muted),
                        onPressed: () => Share.share('${n.name} (${n.arabic})\n${n.meaning}\n\nIslamic Companion App'),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      ),
                    ],
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

class _FilterChip extends StatelessWidget {
  final String label;
  final bool active;
  final Color color;
  final _P p;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.active, required this.color, required this.p, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active ? color.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: active ? color : p.divider),
        ),
        child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: active ? color : p.muted)),
      ),
    );
  }
}
