import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PrayerProvider>(context, listen: false).initLocation();
    });
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
              const SizedBox(height: 24),
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

  Future<void> _toggleAdhan() async {
    if (_playing) {
      await _player.stop();
    } else {
      await _player.play(UrlSource(_kAdhanUrl));
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
              Text(
                next.isEmpty ? '—' : next,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: palette.fg,
                ),
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
        DhikrProvider.dhikrList[dhikr.selectedDhikrIndex];
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
            child: _statTile(l10n.translate('target').toUpperCase(),
                dhikr.targetCount.toString())),
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
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.05,
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
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: palette.accent.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(it.icon, color: palette.accent, size: 22),
                ),
                const SizedBox(height: 8),
                Text(
                  it.label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
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
