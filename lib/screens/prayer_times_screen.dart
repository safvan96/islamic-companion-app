import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/prayer_provider.dart';
import '../providers/app_provider.dart';
import '../services/hijri_calendar.dart';

class PrayerTimesScreen extends StatelessWidget {
  const PrayerTimesScreen({super.key});

  String _fmtCountdown(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    if (h > 0) return '${h}h ${m}m';
    return '${m} min';
  }

  void _showCityPicker(BuildContext context) {
    final prayerProvider = Provider.of<PrayerProvider>(context, listen: false);
    final cities = PrayerProvider.cities.keys.toList();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ...cities.map((city) {
              final isSelected = city == prayerProvider.locationName;
              return ListTile(
                leading: Icon(
                  Icons.location_city,
                  color: isSelected ? const Color(0xFF1B5E20) : Colors.grey,
                ),
                title: Text(
                  city,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? const Color(0xFF1B5E20) : null,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check_circle, color: Color(0xFF1B5E20))
                    : null,
                onTap: () {
                  prayerProvider.setCity(city);
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

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
                        GestureDetector(
                          onTap: () => _showCityPicker(context),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                prayerProvider.locationName,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_drop_down, color: Colors.white70, size: 20),
                            ],
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
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '${l10n.translate('nextPrayer')}: ${prayerProvider.nextPrayer}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (prayerProvider.timeUntilNext.inMinutes > 0)
                                  Text(
                                    _fmtCountdown(prayerProvider.timeUntilNext),
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 12,
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
              title: Text(l10n.translate('prayerTimes')),
            ),
          ),
          // Ramadan Suhoor/Iftar Banner
          if (HijriCalendar.now().isRamadan)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1A237E), Color(0xFF4A148C)],
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Text('🌙', style: TextStyle(fontSize: 32)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Ramadan Mubarak!',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.dark_mode, color: Color(0xFFD4AF37), size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Suhoor: ${prayerProvider.prayerTimes['Fajr'] ?? '--:--'}',
                                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                                  ),
                                  const SizedBox(width: 16),
                                  const Icon(Icons.wb_twilight, color: Color(0xFFD4AF37), size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Iftar: ${prayerProvider.prayerTimes['Maghrib'] ?? '--:--'}',
                                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                                  ),
                                ],
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
                          ? color.withOpacity(0.5)
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
                            color: color.withOpacity(0.12),
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
                                : color.withOpacity(0.1),
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
