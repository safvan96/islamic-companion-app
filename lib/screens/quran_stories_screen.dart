import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';

class _P {
  final Color bg, surface, accent, gold, fg, muted, divider;
  const _P({required this.bg, required this.surface, required this.accent, required this.gold, required this.fg, required this.muted, required this.divider});
  static _P of(bool d) => d
      ? const _P(bg: Color(0xFF0E1A19), surface: Color(0xFF182624), accent: Color(0xFF4FBFA8), gold: Color(0xFFE3C77B), fg: Color(0xFFF5F1E8), muted: Color(0xFF8B968F), divider: Color(0xFF243532))
      : const _P(bg: Color(0xFFF8F5EE), surface: Color(0xFFFFFFFF), accent: Color(0xFF2C7A6B), gold: Color(0xFFB8902B), fg: Color(0xFF1F2937), muted: Color(0xFF6B6359), divider: Color(0xFFE8DDD0));
}

class _Story {
  final String titleKey, descKey, surahKey;
  final IconData icon;
  const _Story(this.titleKey, this.descKey, this.surahKey, this.icon);
}

const _stories = [
  _Story('story_adam', 'story_adam_d', 'Al-Baqarah, Al-Araf', Icons.park),
  _Story('story_nuh', 'story_nuh_d', 'Hud, Nuh', Icons.sailing),
  _Story('story_ibrahim', 'story_ibrahim_d', 'Al-Baqarah, Ibrahim, As-Saffat', Icons.local_fire_department),
  _Story('story_yusuf', 'story_yusuf_d', 'Yusuf', Icons.star),
  _Story('story_musa', 'story_musa_d', 'Al-Baqarah, Taha, Al-Qasas', Icons.water),
  _Story('story_dawud', 'story_dawud_d', 'Al-Baqarah, Sad', Icons.shield),
  _Story('story_sulaiman', 'story_sulaiman_d', 'An-Naml, Saba', Icons.diamond),
  _Story('story_yunus', 'story_yunus_d', 'Yunus, As-Saffat, Al-Anbiya', Icons.waves),
  _Story('story_maryam', 'story_maryam_d', 'Maryam, Ali Imran', Icons.child_care),
  _Story('story_isa', 'story_isa_d', 'Maryam, Ali Imran, Al-Maidah', Icons.auto_awesome),
  _Story('story_ashab', 'story_ashab_d', 'Al-Kahf', Icons.dark_mode),
  _Story('story_khidr', 'story_khidr_d', 'Al-Kahf', Icons.psychology),
  _Story('story_dhulqarnayn', 'story_dhulqarnayn_d', 'Al-Kahf', Icons.public),
  _Story('story_luqman', 'story_luqman_d', 'Luqman', Icons.school),
  _Story('story_qarun', 'story_qarun_d', 'Al-Qasas', Icons.monetization_on),
];

class QuranStoriesScreen extends StatelessWidget {
  const QuranStoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _P.of(isDark);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, foregroundColor: p.fg,
        title: Text(l10n.translate('quranStories'), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: p.muted, letterSpacing: 0.4)), centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        itemCount: _stories.length,
        itemBuilder: (_, i) {
          final s = _stories[i];
          return _StoryCard(story: s, index: i, p: p, l10n: l10n);
        },
      ),
    );
  }
}

class _StoryCard extends StatefulWidget {
  final _Story story; final int index; final _P p; final AppLocalizations l10n;
  const _StoryCard({required this.story, required this.index, required this.p, required this.l10n});
  @override
  State<_StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<_StoryCard> {
  bool _open = false;
  @override
  Widget build(BuildContext context) {
    final p = widget.p; final s = widget.story; final l10n = widget.l10n;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: _open ? p.gold.withOpacity(0.3) : p.divider)),
      child: Column(children: [
        InkWell(onTap: () => setState(() => _open = !_open), borderRadius: BorderRadius.circular(14),
          child: Padding(padding: const EdgeInsets.all(14), child: Row(children: [
            Container(width: 40, height: 40, decoration: BoxDecoration(shape: BoxShape.circle, color: p.gold.withOpacity(0.12)),
              child: Icon(s.icon, size: 20, color: p.gold)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l10n.translate(s.titleKey), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: p.fg)),
              Text(s.surahKey, style: TextStyle(fontSize: 11, color: p.accent)),
            ])),
            Icon(_open ? Icons.expand_less : Icons.expand_more, color: p.muted, size: 20),
          ]))),
        if (_open) Padding(padding: const EdgeInsets.fromLTRB(14, 0, 14, 14), child: Column(children: [
          Divider(color: p.divider, height: 1), const SizedBox(height: 10),
          Text(l10n.translate(s.descKey), style: TextStyle(fontSize: 13, color: p.muted, height: 1.6)),
        ])),
      ]),
    );
  }
}
