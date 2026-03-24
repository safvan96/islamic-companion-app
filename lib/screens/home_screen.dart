import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';
import '../providers/prayer_provider.dart';
import '../utils/theme.dart';
import 'prayer_times_screen.dart';
import 'qibla_screen.dart';
import 'dhikr_screen.dart';
import 'hadith_screen.dart';
import 'surah_screen.dart';
import 'sadaqah_screen.dart';
import 'asma_al_husna_screen.dart';
import 'dua_screen.dart';
import 'settings_screen.dart';

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
    _initLocation();
  }

  Future<void> _initLocation() async {
    // Simplified: set a default location, real app would use geolocator
    final prayerProvider =
        Provider.of<PrayerProvider>(context, listen: false);
    prayerProvider.setLocation(41.0082, 28.9784, 'Istanbul');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Provider.of<AppProvider>(context).isDarkMode;

    final pages = [
      _HomeContent(l10n: l10n),
      const PrayerTimesScreen(),
      const DhikrScreen(),
      const SurahScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        backgroundColor: isDark ? AppTheme.darkCard : Colors.white,
        indicatorColor: AppTheme.primaryGreen.withOpacity(0.15),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l10n.translate('home'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.access_time_outlined),
            selectedIcon: const Icon(Icons.access_time_filled),
            label: l10n.translate('prayerTimes'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.touch_app_outlined),
            selectedIcon: const Icon(Icons.touch_app),
            label: l10n.translate('dhikr'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.menu_book_outlined),
            selectedIcon: const Icon(Icons.menu_book),
            label: l10n.translate('surahs'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l10n.translate('settings'),
          ),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  final AppLocalizations l10n;

  const _HomeContent({required this.l10n});

  @override
  Widget build(BuildContext context) {
    final prayerProvider = Provider.of<PrayerProvider>(context);
    final isDark = Provider.of<AppProvider>(context).isDarkMode;

    return CustomScrollView(
      slivers: [
        // Gradient App Bar
        SliverAppBar(
          expandedHeight: 200,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                        style: TextStyle(
                          fontSize: 22,
                          color: const Color(0xFFD4AF37),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      if (prayerProvider.nextPrayer.isNotEmpty) ...[
                        Text(
                          '${l10n.translate('nextPrayer')}: ${prayerProvider.nextPrayer}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          prayerProvider.prayerTimes[prayerProvider.nextPrayer] ??
                              '',
                          style: const TextStyle(
                            fontSize: 36,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            title: Text(
              l10n.translate('appTitle'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        // Feature Grid
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.1,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
            ),
            delegate: SliverChildListDelegate([
              _FeatureCard(
                icon: Icons.access_time_filled,
                title: l10n.translate('prayerTimes'),
                color: const Color(0xFF1B5E20),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const PrayerTimesScreen()),
                ),
              ),
              _FeatureCard(
                icon: Icons.explore,
                title: l10n.translate('qibla'),
                color: const Color(0xFF0277BD),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QiblaScreen()),
                ),
              ),
              _FeatureCard(
                icon: Icons.touch_app,
                title: l10n.translate('dhikr'),
                color: const Color(0xFF6A1B9A),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DhikrScreen()),
                ),
              ),
              _FeatureCard(
                icon: Icons.auto_stories,
                title: l10n.translate('hadiths'),
                color: const Color(0xFFE65100),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HadithScreen()),
                ),
              ),
              _FeatureCard(
                icon: Icons.menu_book,
                title: l10n.translate('surahs'),
                color: const Color(0xFF00695C),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SurahScreen()),
                ),
              ),
              _FeatureCard(
                icon: Icons.favorite,
                title: l10n.translate('sadaqah'),
                color: const Color(0xFFC62828),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const SadaqahScreen()),
                ),
              ),
              _FeatureCard(
                icon: Icons.star,
                title: '99 Names',
                color: const Color(0xFF4A148C),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const AsmaAlHusnaScreen()),
                ),
              ),
              _FeatureCard(
                icon: Icons.front_hand,
                title: 'Duas',
                color: const Color(0xFF00838F),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DuaScreen()),
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDarkMode;

    return Card(
      elevation: 4,
      shadowColor: color.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(isDark ? 0.3 : 0.1),
                color.withOpacity(isDark ? 0.15 : 0.05),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 36, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
