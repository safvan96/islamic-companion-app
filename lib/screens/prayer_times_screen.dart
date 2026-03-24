import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/prayer_provider.dart';
import '../providers/app_provider.dart';

class PrayerTimesScreen extends StatelessWidget {
  const PrayerTimesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final prayerProvider = Provider.of<PrayerProvider>(context);
    final isDark = Provider.of<AppProvider>(context).isDarkMode;

    final prayerIcons = {
      'Fajr': Icons.dark_mode_outlined,
      'Sunrise': Icons.wb_sunny_outlined,
      'Dhuhr': Icons.wb_sunny,
      'Asr': Icons.cloud_outlined,
      'Maghrib': Icons.wb_twilight,
      'Isha': Icons.nightlight_round,
    };

    final prayerColors = {
      'Fajr': const Color(0xFF1A237E),
      'Sunrise': const Color(0xFFFF6F00),
      'Dhuhr': const Color(0xFFF9A825),
      'Asr': const Color(0xFFEF6C00),
      'Maghrib': const Color(0xFFD84315),
      'Isha': const Color(0xFF283593),
    };

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                  ),
                ),
                child: SafeArea(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        Icon(Icons.location_on,
                            color: Colors.white70, size: 20),
                        const SizedBox(height: 4),
                        Text(
                          prayerProvider.locationName,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (prayerProvider.nextPrayer.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${l10n.translate('nextPrayer')}: ${prayerProvider.nextPrayer}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              title: Text(l10n.translate('prayerTimes')),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final entry =
                      prayerProvider.prayerTimes.entries.elementAt(index);
                  final isNext = entry.key == prayerProvider.nextPrayer;
                  final color = prayerColors[entry.key] ?? Colors.green;
                  final icon = prayerIcons[entry.key] ?? Icons.access_time;

                  final prayerKeyMap = {
                    'Fajr': 'fajr',
                    'Sunrise': 'sunrise',
                    'Dhuhr': 'dhuhr',
                    'Asr': 'asr',
                    'Maghrib': 'maghrib',
                    'Isha': 'isha',
                  };

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Card(
                      elevation: isNext ? 6 : 2,
                      shadowColor: isNext
                          ? color.withValues(alpha: 0.5)
                          : Colors.black12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: isNext
                            ? BorderSide(color: color, width: 2)
                            : BorderSide.none,
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(icon, color: color, size: 28),
                        ),
                        title: Text(
                          l10n.translate(
                              prayerKeyMap[entry.key] ?? entry.key),
                          style: TextStyle(
                            fontWeight:
                                isNext ? FontWeight.bold : FontWeight.w600,
                            fontSize: 16,
                            color: isNext
                                ? color
                                : isDark
                                    ? Colors.white
                                    : Colors.black87,
                          ),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isNext
                                ? color
                                : color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            entry.value,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color:
                                  isNext ? Colors.white : color,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                childCount: prayerProvider.prayerTimes.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
