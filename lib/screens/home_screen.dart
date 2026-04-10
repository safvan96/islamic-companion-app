import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import '../models/hadith_model.dart';
import '../models/surah_model.dart';
import '../services/quran_stats_service.dart';
import '../providers/app_provider.dart';
import '../providers/prayer_provider.dart';
import '../providers/dhikr_provider.dart';
import '../services/hijri_calendar.dart';
import '../utils/constants.dart';
import 'prayer_times_screen.dart';
import 'qibla_screen.dart';
import 'dhikr_screen.dart';
import 'hadith_screen.dart';
import 'surah_screen.dart';
import 'sadaqah_screen.dart';
import 'asma_al_husna_screen.dart';
import 'dua_screen.dart';
import 'favorites_screen.dart';
import 'quran_reader_screen.dart';
import 'juz_screen.dart';
import 'prayer_guide_screen.dart';
import 'tasbih_set_screen.dart';
import 'qaza_screen.dart';
import 'zakat_screen.dart';
import 'quiz_screen.dart';
import 'fasting_screen.dart';
import 'adhkar_screen.dart';
import 'hajj_guide_screen.dart';
import 'names_screen.dart';
import 'hifz_screen.dart';
import 'charity_screen.dart';
import 'daily_duas_screen.dart';
import 'islamic_calendar_screen.dart';
import 'good_deeds_screen.dart';
import 'dua_journal_screen.dart';
import 'wisdom_screen.dart';
import 'visual_tasbih_screen.dart';
import 'stats_dashboard_screen.dart';
import 'istikhara_screen.dart';
import 'tajweed_screen.dart';
import 'janazah_screen.dart';
import 'allah_names_detail_screen.dart';
import 'wudu_screen.dart';
import 'prophets_screen.dart';
import 'ruqyah_screen.dart';
import 'adab_screen.dart';
import 'nikah_screen.dart';
import 'glossary_screen.dart';
import 'tayammum_screen.dart';
import 'hijri_months_screen.dart';
import 'ghusl_screen.dart';
import 'fidyah_screen.dart';
import 'salawat_screen.dart';
import 'timeline_screen.dart';
import 'tawbah_screen.dart';
import 'khatm_planner_screen.dart';
import 'patience_duas_screen.dart';
import 'daily_tips_screen.dart';
import 'faq_screen.dart';
import 'muhasaba_screen.dart';
import 'quran_words_screen.dart';
import 'motivation_screen.dart';
import 'adhan_dua_screen.dart';
import 'sajdah_screen.dart';
import 'surah_virtues_screen.dart';
import 'post_prayer_screen.dart';
import 'settings_screen.dart';

// ─── Palette ────────────────────────────────────────────────────────────────
class _Palette {
  final Color bg;
  final Color surface;
  final Color accent;
  final Color gold;
  final Color fg;
  final Color muted;
  final Color divider;
  const _Palette({
    required this.bg,
    required this.surface,
    required this.accent,
    required this.gold,
    required this.fg,
    required this.muted,
    required this.divider,
  });

  static _Palette of(bool isDark) => isDark
      ? const _Palette(
          bg: Color(0xFF0E1A19),
          surface: Color(0xFF182624),
          accent: Color(0xFF4FBFA8),
          gold: Color(0xFFE3C77B),
          fg: Color(0xFFF5F1E8),
          muted: Color(0xFF8B968F),
          divider: Color(0xFF243532),
        )
      : const _Palette(
          bg: Color(0xFFF8F5EE),
          surface: Color(0xFFFFFFFF),
          accent: Color(0xFF2C7A6B),
          gold: Color(0xFFB8902B),
          fg: Color(0xFF1F2937),
          muted: Color(0xFF6B6359),
          divider: Color(0xFFE8DDD0),
        );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  static const _currentVersion = '2.8.0';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PrayerProvider>(context, listen: false).initLocation();
      _checkWhatsNew();
    });
  }

  Future<void> _checkWhatsNew() async {
    final prefs = await SharedPreferences.getInstance();
    final lastVersion = prefs.getString('lastSeenVersion') ?? '';
    if (lastVersion != _currentVersion) {
      await prefs.setString('lastSeenVersion', _currentVersion);
      if (lastVersion.isNotEmpty && mounted) {
        _showWhatsNew();
      }
    }
  }

  void _showWhatsNew() {
    final isDark = Provider.of<AppProvider>(context, listen: false).isDarkMode;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.new_releases, color: Color(0xFFD4AF37)),
            const SizedBox(width: 10),
            Text("What's New", style: TextStyle(fontSize: 18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _whatsNewItem('30+ new features!'),
            _whatsNewItem('Tasbih Set, Qaza Tracker, Zakat Calculator'),
            _whatsNewItem('Islamic Quiz, Fasting Tracker, Adhkar'),
            _whatsNewItem('Hajj/Umrah Guide, Islamic Names, Hifz Tracker'),
            _whatsNewItem('Tajweed Guide, Janazah Guide, Istikhara'),
            _whatsNewItem('Good Deeds, Dua Journal, Wisdom Quotes'),
            _whatsNewItem('Statistics Dashboard, Islamic Calendar'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK', style: TextStyle(color: Color(0xFF1B5E20))),
          ),
        ],
      ),
    );
  }

  Widget _whatsNewItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF1B5E20), size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Provider.of<AppProvider>(context).isDarkMode;
    final p = _Palette.of(isDark);

    final pages = [
      _HomeContent(palette: p),
      const PrayerTimesScreen(),
      const DhikrScreen(),
      const SurahScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      backgroundColor: p.bg,
      body: pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        backgroundColor: p.surface,
        indicatorColor: p.accent.withOpacity(0.15),
        surfaceTintColor: Colors.transparent,
        height: 64,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: p.muted),
            selectedIcon: Icon(Icons.home_rounded, color: p.accent),
            label: l10n.translate('home'),
          ),
          NavigationDestination(
            icon: Icon(Icons.access_time_outlined, color: p.muted),
            selectedIcon: Icon(Icons.access_time_filled, color: p.accent),
            label: l10n.translate('prayerTimes'),
          ),
          NavigationDestination(
            icon: Icon(Icons.touch_app_outlined, color: p.muted),
            selectedIcon: Icon(Icons.touch_app, color: p.accent),
            label: l10n.translate('dhikr'),
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined, color: p.muted),
            selectedIcon: Icon(Icons.menu_book, color: p.accent),
            label: l10n.translate('surahs'),
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined, color: p.muted),
            selectedIcon: Icon(Icons.settings, color: p.accent),
            label: l10n.translate('settings'),
          ),
        ],
      ),
    );
  }
}

// ─── Home content ───────────────────────────────────────────────────────────

class _HomeContent extends StatefulWidget {
  final _Palette palette;
  const _HomeContent({required this.palette});

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;
  late Animation<double> _pulseAnim;
  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 180));
    _pulseAnim = Tween<double>(begin: 1.0, end: 0.96)
        .animate(CurvedAnimation(parent: _pulse, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  Future<void> _onTapCounter(DhikrProvider dp) async {
    if (dp.hapticEnabled) HapticFeedback.lightImpact();
    _pulse.forward().then((_) => _pulse.reverse());
    await dp.increment();
    if (!mounted) return;
    if (dp.justReachedTarget) {
      dp.markTargetCelebrated();
      if (dp.hapticEnabled) HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          backgroundColor: widget.palette.gold,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text('${AppLocalizations.of(context)!.translate('target')} ${dp.targetCount} ✓',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      );
    }
  }

  double _qiblaBearing(double lat, double lng) {
    final latRad = lat * pi / 180;
    final lngRad = lng * pi / 180;
    const kLat = AppConstants.kaabaLatitude * pi / 180;
    const kLng = AppConstants.kaabaLongitude * pi / 180;
    final dLng = kLng - lngRad;
    final y = sin(dLng) * cos(kLat);
    final x = cos(latRad) * sin(kLat) - sin(latRad) * cos(kLat) * cos(dLng);
    return ((atan2(y, x) * 180 / pi) + 360) % 360;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final p = widget.palette;
    final prayer = Provider.of<PrayerProvider>(context);
    final dhikr = Provider.of<DhikrProvider>(context);
    final hijri = HijriCalendar.now();
    final langCode = Provider.of<AppProvider>(context).locale.languageCode;
    final qibla = _qiblaBearing(prayer.latitude, prayer.longitude);

    return SafeArea(
      child: LayoutBuilder(builder: (context, constraints) {
        final w = constraints.maxWidth;
        // Center widget responsively sized
        final centerSize = (w * 0.78).clamp(240.0, 360.0);
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Top bar: hijri + greeting ──
              _TopBar(palette: p, hijri: hijri, langCode: langCode),
              const SizedBox(height: 16),
              // ── Bismillah ──
              Text(
                'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: p.accent,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              // ── Special day banner ──
              if (hijri.getSpecialDay(langCode) != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [p.gold.withOpacity(0.15), p.gold.withOpacity(0.05)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: p.gold.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.star, color: p.gold, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          hijri.getSpecialDay(langCode)!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: p.gold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              // ── Next prayer card ──
              _NextPrayerCard(prayer: prayer, palette: p, l10n: l10n),
              const SizedBox(height: 24),
              // ── Central widget: dhikr counter + qibla ring ──
              Center(
                child: _CentralWidget(
                  size: centerSize,
                  palette: p,
                  dhikr: dhikr,
                  qiblaBearing: qibla,
                  pulseAnim: _pulseAnim,
                  pulseController: _pulse,
                  onTap: () => _onTapCounter(dhikr),
                ),
              ),
              const SizedBox(height: 16),
              // ── Stats row ──
              _StatsRow(palette: p, dhikr: dhikr),
              const SizedBox(height: 16),
              // ── Quran reading progress ──
              _QuranProgressBar(palette: p),
              const SizedBox(height: 20),
              // ── Daily hadith card ──
              _DailyHadithCard(palette: p, langCode: langCode),
              const SizedBox(height: 12),
              // ── Daily ayah card ──
              _DailyAyahCard(palette: p, langCode: langCode),
              const SizedBox(height: 12),
              // ── Daily dua card ──
              _DailyDuaCard(palette: p, langCode: langCode),
              const SizedBox(height: 20),
              // ── Quick actions ──
              _SectionLabel(l10n.translate('quickAccess').toUpperCase(), p),
              const SizedBox(height: 10),
              _QuickActions(palette: p, l10n: l10n),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }
}

// ─── Top bar ────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final _Palette palette;
  final HijriCalendar hijri;
  final String langCode;
  const _TopBar(
      {required this.palette, required this.hijri, required this.langCode});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hour = DateTime.now().hour;
    String greeting;
    IconData icon;
    if (hour < 5) {
      greeting = l10n.translate('goodNight');
      icon = Icons.nightlight_round;
    } else if (hour < 12) {
      greeting = l10n.translate('goodMorning');
      icon = Icons.wb_sunny_outlined;
    } else if (hour < 18) {
      greeting = l10n.translate('goodAfternoon');
      icon = Icons.wb_sunny;
    } else {
      greeting = l10n.translate('goodEvening');
      icon = Icons.nights_stay_outlined;
    }
    return Row(
      children: [
        Icon(icon, color: palette.accent, size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: palette.fg,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                hijri.format(langCode),
                style: TextStyle(
                  fontSize: 12,
                  color: palette.muted,
                ),
              ),
            ],
          ),
        ),
        if (hijri.isRamadan)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: palette.gold.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: palette.gold.withOpacity(0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🌙', style: TextStyle(fontSize: 12)),
                const SizedBox(width: 4),
                Text(
                  'Ramadan',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: palette.gold,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// ─── Next prayer card ───────────────────────────────────────────────────────

// Public-domain adhan from archive.org (Doha collection)
const String _kAdhanUrl =
    'https://archive.org/download/adhan.recordings.from.doha.qatar/Maghrib%20Adhan.mp3';

class _NextPrayerCard extends StatefulWidget {
  final PrayerProvider prayer;
  final _Palette palette;
  final AppLocalizations l10n;
  const _NextPrayerCard(
      {required this.prayer, required this.palette, required this.l10n});

  @override
  State<_NextPrayerCard> createState() => _NextPrayerCardState();
}

class _NextPrayerCardState extends State<_NextPrayerCard> {
  final AudioPlayer _player = AudioPlayer();
  bool _playing = false;

  @override
  void initState() {
    super.initState();
    _player.onPlayerStateChanged.listen((s) {
      if (mounted) setState(() => _playing = s == PlayerState.playing);
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  String _formatCountdown(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    if (h > 0) return '${h}h ${m}m';
    return '${m}m';
  }

  Future<void> _toggleAdhan() async {
    if (_playing) {
      await _player.stop();
    } else {
      try {
        await _player.play(UrlSource(_kAdhanUrl));
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('No internet connection'),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final prayer = widget.prayer;
    final palette = widget.palette;
    final l10n = widget.l10n;
    final next = prayer.nextPrayer;
    final time = prayer.prayerTimes[next] ?? '--:--';
    final all = prayer.prayerTimes.entries.toList();

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.access_time_rounded,
                  color: palette.accent, size: 16),
              const SizedBox(width: 6),
              Text(
                l10n.translate('nextPrayer').toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.4,
                  color: palette.muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (prayer.locationName.isNotEmpty)
                Row(
                  children: [
                    Icon(Icons.place_outlined,
                        size: 12, color: palette.muted),
                    const SizedBox(width: 2),
                    Text(
                      prayer.locationName,
                      style:
                          TextStyle(fontSize: 11, color: palette.muted),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    next.isEmpty ? '—' : next,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: palette.fg,
                    ),
                  ),
                  if (prayer.timeUntilNext.inMinutes > 0)
                    Text(
                      _formatCountdown(prayer.timeUntilNext),
                      style: TextStyle(
                        fontSize: 11,
                        color: palette.muted,
                      ),
                    ),
                ],
              ),
              const Spacer(),
              Text(
                time,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w300,
                  color: palette.accent,
                  height: 1.0,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 10),
              // Adhan play button
              Material(
                color: palette.accent.withOpacity(0.12),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: _toggleAdhan,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      _playing
                          ? Icons.stop_rounded
                          : Icons.play_arrow_rounded,
                      color: palette.accent,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(height: 1, color: palette.divider),
          const SizedBox(height: 10),
          // All 5 prayer times — small row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: all.map((e) {
              final isNext = e.key == next;
              return Column(
                children: [
                  Text(
                    e.key,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: isNext ? palette.accent : palette.muted,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    e.value,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isNext ? FontWeight.w700 : FontWeight.w400,
                      color: isNext ? palette.accent : palette.fg,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ─── Central widget: dhikr counter ringed with qibla compass ───────────────

class _CentralWidget extends StatelessWidget {
  final double size;
  final _Palette palette;
  final DhikrProvider dhikr;
  final double qiblaBearing;
  final Animation<double> pulseAnim;
  final AnimationController pulseController;
  final VoidCallback onTap;

  const _CentralWidget({
    required this.size,
    required this.palette,
    required this.dhikr,
    required this.qiblaBearing,
    required this.pulseAnim,
    required this.pulseController,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currentDhikr =
        dhikr.allDhikrList[dhikr.selectedDhikrIndex];
    final progress =
        (dhikr.count / dhikr.targetCount).clamp(0.0, 1.0);
    final reached = dhikr.targetReached;
    final ringColor = reached ? palette.gold : palette.accent;
    final innerSize = size - 70;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer compass ring (qibla)
          CustomPaint(
            size: Size(size, size),
            painter: _CompassRingPainter(palette: palette),
          ),
          // N E S W marks
          ..._buildMarks(),
          // Qibla arrow on outer ring
          Transform.rotate(
            angle: qiblaBearing * pi / 180,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: palette.gold,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.navigation, color: Colors.white, size: 14),
                    SizedBox(width: 3),
                    Text(
                      'QIBLA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Inner tap zone
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: AnimatedBuilder(
              animation: pulseController,
              builder: (_, __) => Transform.scale(
                scale: pulseAnim.value,
                child: SizedBox(
                  width: innerSize,
                  height: innerSize,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Filled circle background
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: palette.surface,
                          boxShadow: [
                            BoxShadow(
                              color: palette.accent.withOpacity(0.06),
                              blurRadius: 30,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                      // Progress ring
                      SizedBox(
                        width: innerSize,
                        height: innerSize,
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: progress),
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeOutCubic,
                          builder: (_, value, __) =>
                              CircularProgressIndicator(
                            value: value,
                            strokeWidth: 4,
                            strokeCap: StrokeCap.round,
                            backgroundColor: palette.divider,
                            valueColor: AlwaysStoppedAnimation(ringColor),
                          ),
                        ),
                      ),
                      // Content
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              currentDhikr['arabic']!,
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: palette.fg,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              currentDhikr['transliteration']!,
                              style: TextStyle(
                                fontSize: 10,
                                color: palette.muted,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              dhikr.count.toString(),
                              style: TextStyle(
                                fontSize: 64,
                                fontWeight: FontWeight.w200,
                                color: palette.fg,
                                height: 1.0,
                                letterSpacing: -2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '/ ${dhikr.targetCount}',
                              style: TextStyle(
                                fontSize: 12,
                                color: palette.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMarks() {
    const dirs = ['N', 'E', 'S', 'W'];
    const angles = [0.0, 90.0, 180.0, 270.0];
    return List.generate(4, (i) {
      return Transform.rotate(
        angle: angles[i] * pi / 180,
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 28),
            child: Transform.rotate(
              angle: -angles[i] * pi / 180,
              child: Text(
                dirs[i],
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: i == 0 ? palette.accent : palette.muted,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _CompassRingPainter extends CustomPainter {
  final _Palette palette;
  _CompassRingPainter({required this.palette});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 1;
    final ringPaint = Paint()
      ..color = palette.divider
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawCircle(center, radius, ringPaint);
    // Inner subtle ring
    final innerPaint = Paint()
      ..color = palette.divider.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawCircle(center, radius - 22, innerPaint);
    // Tick marks every 30°
    final tickPaint = Paint()
      ..color = palette.muted.withOpacity(0.5)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 12; i++) {
      final angle = i * 30 * pi / 180 - pi / 2;
      final outer = Offset(
          center.dx + cos(angle) * radius, center.dy + sin(angle) * radius);
      final inner = Offset(center.dx + cos(angle) * (radius - 6),
          center.dy + sin(angle) * (radius - 6));
      canvas.drawLine(outer, inner, tickPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CompassRingPainter old) =>
      old.palette != palette;
}

// ─── Stats row ──────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final _Palette palette;
  final DhikrProvider dhikr;
  const _StatsRow({required this.palette, required this.dhikr});

  String _fmt(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return n.toString();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
            child: _statTile(
                l10n.translate('today').toUpperCase(), _fmt(dhikr.todayCount))),
        const SizedBox(width: 10),
        Expanded(
            child: _statTile(
                l10n.translate('total').toUpperCase(), _fmt(dhikr.totalCount))),
        const SizedBox(width: 10),
        Expanded(
            child: _statTile(l10n.translate('streak').toUpperCase(),
                '${dhikr.streak}d')),
      ],
    );
  }

  Widget _statTile(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: palette.divider),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              letterSpacing: 1.2,
              color: palette.muted,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: palette.fg,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section label ──────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  final _Palette palette;
  const _SectionLabel(this.text, this.palette);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: palette.muted,
        letterSpacing: 1.4,
      ),
    );
  }
}

// ─── Quick actions ──────────────────────────────────────────────────────────

class _QuickActions extends StatelessWidget {
  final _Palette palette;
  final AppLocalizations l10n;
  const _QuickActions({required this.palette, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final items = <_QuickItem>[
      _QuickItem(Icons.explore, l10n.translate('qibla'), const QiblaScreen()),
      _QuickItem(Icons.auto_stories, l10n.translate('hadiths'),
          const HadithScreen()),
      _QuickItem(Icons.menu_book, l10n.translate('surahs'),
          const SurahScreen()),
      _QuickItem(Icons.front_hand, l10n.translate('duas'), const DuaScreen()),
      _QuickItem(
          Icons.star_outline, l10n.translate('names99'), const AsmaAlHusnaScreen()),
      _QuickItem(Icons.favorite_border, l10n.translate('sadaqah'),
          const SadaqahScreen()),
      _QuickItem(Icons.bookmark_outlined, l10n.translate('favorites'),
          const FavoritesScreen()),
      _QuickItem(Icons.chrome_reader_mode, 'Quran',
          const QuranReaderScreen()),
      _QuickItem(Icons.school, 'Guide',
          const PrayerGuideScreen()),
      _QuickItem(Icons.repeat_rounded, l10n.translate('tasbihSet'),
          const TasbihSetScreen()),
      _QuickItem(Icons.history_rounded, l10n.translate('qazaTracker'),
          const QazaScreen()),
      _QuickItem(Icons.calculate_outlined, l10n.translate('zakatCalculator'),
          const ZakatScreen()),
      _QuickItem(Icons.quiz_outlined, l10n.translate('islamicQuiz'),
          const QuizScreen()),
      _QuickItem(Icons.restaurant_outlined, l10n.translate('fastingTracker'),
          const FastingScreen()),
      _QuickItem(Icons.wb_twilight_rounded, l10n.translate('adhkar'),
          const AdhkarScreen()),
      _QuickItem(Icons.location_city, l10n.translate('hajjUmrah'),
          const HajjGuideScreen()),
      _QuickItem(Icons.child_care, l10n.translate('islamicNames'),
          const NamesScreen()),
      _QuickItem(Icons.auto_stories_outlined, l10n.translate('hifzTracker'),
          const HifzScreen()),
      _QuickItem(Icons.volunteer_activism, l10n.translate('charityTracker'),
          const CharityScreen()),
      _QuickItem(Icons.menu_book_outlined, l10n.translate('duaForOccasions'),
          const DailyDuasScreen()),
      _QuickItem(Icons.calendar_month, l10n.translate('islamicCalendar'),
          const IslamicCalendarScreen()),
      _QuickItem(Icons.checklist_rounded, l10n.translate('goodDeeds'),
          const GoodDeedsScreen()),
      _QuickItem(Icons.edit_note, l10n.translate('duaJournal'),
          const DuaJournalScreen()),
      _QuickItem(Icons.auto_awesome, l10n.translate('wisdomQuotes'),
          const WisdomScreen()),
      _QuickItem(Icons.radio_button_checked, l10n.translate('visualTasbih'),
          const VisualTasbihScreen()),
      _QuickItem(Icons.bar_chart_rounded, l10n.translate('statsDashboard'),
          const StatsDashboardScreen()),
      _QuickItem(Icons.help_outline, l10n.translate('istikharaGuide'),
          const IstikharaScreen()),
      _QuickItem(Icons.record_voice_over, l10n.translate('tajweedGuide'),
          const TajweedScreen()),
      _QuickItem(Icons.people_outline, l10n.translate('janazahGuide'),
          const JanazahScreen()),
      _QuickItem(Icons.format_quote_rounded, l10n.translate('ayahOfDay'),
          const AyahOfDayScreen()),
      _QuickItem(Icons.water_drop_outlined, l10n.translate('wuduGuide'),
          const WuduScreen()),
      _QuickItem(Icons.groups_outlined, l10n.translate('prophetsOfIslam'),
          const ProphetsScreen()),
      _QuickItem(Icons.healing, l10n.translate('ruqyahGuide'),
          const RuqyahScreen()),
      _QuickItem(Icons.auto_fix_high, l10n.translate('islamicAdab'),
          const AdabScreen()),
      _QuickItem(Icons.favorite_border, l10n.translate('nikahGuide'),
          const NikahScreen()),
      _QuickItem(Icons.library_books_outlined, l10n.translate('islamicGlossary'),
          const GlossaryScreen()),
      _QuickItem(Icons.landscape, l10n.translate('tayammumGuide'),
          const TayammumScreen()),
      _QuickItem(Icons.date_range, l10n.translate('hijriMonthsGuide'),
          const HijriMonthsScreen()),
      _QuickItem(Icons.shower, l10n.translate('ghuslGuide'),
          const GhuslScreen()),
      _QuickItem(Icons.paid_outlined, l10n.translate('fidyahCalc'),
          const FidyahScreen()),
      _QuickItem(Icons.mosque_outlined, l10n.translate('salawatCollection'),
          const SalawatScreen()),
      _QuickItem(Icons.timeline, l10n.translate('islamicTimeline'),
          const TimelineScreen()),
      _QuickItem(Icons.self_improvement, l10n.translate('tawbahGuide'),
          const TawbahScreen()),
      _QuickItem(Icons.import_contacts, l10n.translate('khatmPlanner'),
          const KhatmPlannerScreen()),
      _QuickItem(Icons.healing_outlined, l10n.translate('patienceDuas'),
          const PatienceDuasScreen()),
      _QuickItem(Icons.tips_and_updates, l10n.translate('dailyTips'),
          const DailyTipsScreen()),
      _QuickItem(Icons.question_answer, l10n.translate('islamicFaq'),
          const FaqScreen()),
      _QuickItem(Icons.nightlight_round, l10n.translate('muhasaba'),
          const MuhasabaScreen()),
      _QuickItem(Icons.translate, l10n.translate('quranWords'),
          const QuranWordsScreen()),
      _QuickItem(Icons.format_paint, l10n.translate('motivation'),
          const MotivationScreen()),
      _QuickItem(Icons.notifications_active, l10n.translate('adhanDua'),
          const AdhanDuaScreen()),
      _QuickItem(Icons.airline_seat_flat, l10n.translate('sajdahTilawah'),
          const SajdahScreen()),
      _QuickItem(Icons.auto_stories, l10n.translate('surahVirtues'),
          const SurahVirtuesScreen()),
      _QuickItem(Icons.playlist_add_check, l10n.translate('postPrayer'),
          const PostPrayerScreen()),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.85,
      ),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final it = items[i];
        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => it.screen),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: palette.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: palette.divider),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: palette.accent.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(it.icon, color: palette.accent, size: 20),
                ),
                const SizedBox(height: 6),
                Text(
                  it.label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: palette.fg,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _QuickItem {
  final IconData icon;
  final String label;
  final Widget screen;
  const _QuickItem(this.icon, this.label, this.screen);
}

// ─── Daily hadith card ─────────────────────────────────────────────────────

class _DailyHadithCard extends StatelessWidget {
  final _Palette palette;
  final String langCode;
  const _DailyHadithCard({required this.palette, required this.langCode});

  @override
  Widget build(BuildContext context) {
    final dayOfYear = DateTime.now()
        .difference(DateTime(DateTime.now().year, 1, 1))
        .inDays;
    final hadith =
        HadithModel.hadiths[dayOfYear % HadithModel.hadiths.length];
    final translation =
        hadith.translations[langCode] ?? hadith.translations['en']!;
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const HadithScreen()),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: palette.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_stories, color: palette.gold, size: 16),
                const SizedBox(width: 6),
                Text(
                  l10n.translate('todayHadith').toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 1.2,
                    color: palette.gold,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              translation,
              style: TextStyle(
                fontSize: 13,
                color: palette.fg,
                height: 1.5,
                fontStyle: FontStyle.italic,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              '— ${hadith.source}',
              style: TextStyle(
                fontSize: 11,
                color: palette.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Daily ayah card ───────────────────────────────────────────────────────

class _DailyAyahCard extends StatelessWidget {
  final _Palette palette;
  final String langCode;
  const _DailyAyahCard({required this.palette, required this.langCode});

  static const _ayahs = [
    {'ar': 'إِنَّ مَعَ الْعُسْرِ يُسْرًا', 'en': 'Indeed, with hardship comes ease.', 'tr': 'Muhakkak ki zorlukla beraber kolaylık vardır.', 'ref': '94:6'},
    {'ar': 'وَمَن يَتَوَكَّلْ عَلَى اللَّهِ فَهُوَ حَسْبُهُ', 'en': 'Whoever relies upon Allah - then He is sufficient for him.', 'tr': 'Kim Allah\'a tevekkül ederse O, ona yeter.', 'ref': '65:3'},
    {'ar': 'فَاذْكُرُونِي أَذْكُرْكُمْ', 'en': 'So remember Me; I will remember you.', 'tr': 'Beni anın ki ben de sizi anayım.', 'ref': '2:152'},
    {'ar': 'وَلَسَوْفَ يُعْطِيكَ رَبُّكَ فَتَرْضَىٰ', 'en': 'And your Lord is going to give you, and you will be satisfied.', 'tr': 'Rabbin sana verecek ve sen razı olacaksın.', 'ref': '93:5'},
    {'ar': 'إِنَّ اللَّهَ مَعَ الصَّابِرِينَ', 'en': 'Indeed, Allah is with the patient.', 'tr': 'Şüphesiz Allah sabredenlerle beraberdir.', 'ref': '2:153'},
    {'ar': 'وَهُوَ مَعَكُمْ أَيْنَ مَا كُنتُمْ', 'en': 'And He is with you wherever you are.', 'tr': 'Nerede olursanız olun O sizinle beraberdir.', 'ref': '57:4'},
    {'ar': 'رَبِّ اشْرَحْ لِي صَدْرِي', 'en': 'My Lord, expand for me my breast.', 'tr': 'Rabbim! Gönlümü aç.', 'ref': '20:25'},
    {'ar': 'وَقُل رَّبِّ زِدْنِي عِلْمًا', 'en': 'And say: My Lord, increase me in knowledge.', 'tr': 'Rabbim! İlmimi artır.', 'ref': '20:114'},
    {'ar': 'لَا تَحْزَنْ إِنَّ اللَّهَ مَعَنَا', 'en': 'Do not grieve; indeed Allah is with us.', 'tr': 'Üzülme, Allah bizimle beraberdir.', 'ref': '9:40'},
    {'ar': 'وَنَحْنُ أَقْرَبُ إِلَيْهِ مِنْ حَبْلِ الْوَرِيدِ', 'en': 'And We are closer to him than his jugular vein.', 'tr': 'Biz ona şah damarından daha yakınız.', 'ref': '50:16'},
  ];

  @override
  Widget build(BuildContext context) {
    final dayOfYear = DateTime.now()
        .difference(DateTime(DateTime.now().year, 1, 1))
        .inDays;
    final ayah = _ayahs[dayOfYear % _ayahs.length];
    final text = ayah[langCode] ?? ayah['en']!;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: palette.accent, size: 14),
              const SizedBox(width: 6),
              Text(
                'AYAH OF THE DAY',
                style: TextStyle(
                  fontSize: 9,
                  letterSpacing: 1.2,
                  color: palette.accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                ayah['ref']!,
                style: TextStyle(fontSize: 10, color: palette.muted),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            ayah['ar']!,
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: 18,
              color: palette.gold,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: palette.muted,
              fontStyle: FontStyle.italic,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Daily dua card ────────────────────────────────────────────────────────

class _DailyDuaCard extends StatelessWidget {
  final _Palette palette;
  final String langCode;
  const _DailyDuaCard({required this.palette, required this.langCode});

  static const _duaTexts = [
    {'ar': 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ', 'en': 'We have reached the morning and the dominion belongs to Allah.', 'tr': 'Sabaha erdik, mülk de Allah\'a ait olarak sabaha erdi.'},
    {'ar': 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا', 'en': 'In Your name, O Allah, I die and I live.', 'tr': 'Senin adınla ölür ve dirilirim, Allah\'ım.'},
    {'ar': 'بِسْمِ اللَّهِ وَعَلَى بَرَكَةِ اللَّهِ', 'en': 'In the name of Allah and with the blessings of Allah.', 'tr': 'Allah\'ın adıyla ve Allah\'ın bereketine sığınarak.'},
    {'ar': 'اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ', 'en': 'O Allah, open the gates of Your mercy for me.', 'tr': 'Allah\'ım, bana rahmet kapılarını aç.'},
    {'ar': 'رَبِّ اغْفِرْ لِي وَتُبْ عَلَيَّ', 'en': 'My Lord, forgive me and accept my repentance.', 'tr': 'Rabbim, beni bağışla ve tövbemi kabul et.'},
  ];

  @override
  Widget build(BuildContext context) {
    final dayOfYear = DateTime.now()
        .difference(DateTime(DateTime.now().year, 1, 1))
        .inDays;
    final dua = _duaTexts[dayOfYear % _duaTexts.length];
    final text = dua[langCode] ?? dua['en']!;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const DuaScreen()),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: palette.divider),
        ),
        child: Row(
          children: [
            Icon(Icons.front_hand, color: palette.accent, size: 18),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dua['ar']!,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: 14,
                      color: palette.fg,
                      height: 1.4,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 11,
                      color: palette.muted,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: palette.muted, size: 18),
          ],
        ),
      ),
    );
  }
}

// ─── Quran reading progress ────────────────────────────────────────────────

class _QuranProgressBar extends StatefulWidget {
  final _Palette palette;
  const _QuranProgressBar({required this.palette});

  @override
  State<_QuranProgressBar> createState() => _QuranProgressBarState();
}

class _QuranProgressBarState extends State<_QuranProgressBar>
    with WidgetsBindingObserver {
  int _readCount = 0;
  int _totalAyahs = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _load();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('readSurahs') ?? [];
    final stats = await QuranStatsService.getStats();
    if (mounted) {
      setState(() {
        _readCount = list.length;
        _totalAyahs = stats['totalAyahs'] ?? 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.palette;
    final total = SurahModel.shortSurahs.length;
    final progress = total == 0 ? 0.0 : (_readCount / total).clamp(0.0, 1.0);

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SurahScreen()),
        );
        _load();
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: p.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: p.divider),
        ),
        child: Row(
          children: [
            Icon(Icons.menu_book, color: p.accent, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Quran',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: p.fg,
                        ),
                      ),
                      const Spacer(),
                      if (_totalAyahs > 0)
                        Text(
                          '$_totalAyahs ayahs  ',
                          style: TextStyle(
                            fontSize: 10,
                            color: p.accent,
                          ),
                        ),
                      Text(
                        '$_readCount / $total',
                        style: TextStyle(
                          fontSize: 11,
                          color: p.muted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 5,
                      backgroundColor: p.divider,
                      valueColor: AlwaysStoppedAnimation(p.accent),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
