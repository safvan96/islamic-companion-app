import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';
import '../providers/prayer_provider.dart';
import '../services/notification_service.dart';
import '../utils/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _adhanEnabled = true;
  bool _dailyHadithEnabled = false;
  int _dailyHadithHour = 8;
  int _dailyHadithMinute = 0;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _adhanEnabled = prefs.getBool('adhanEnabled') ?? true;
      _dailyHadithEnabled = prefs.getBool('dailyHadithEnabled') ?? false;
      _dailyHadithHour = prefs.getInt('dailyHadithHour') ?? 8;
      _dailyHadithMinute = prefs.getInt('dailyHadithMinute') ?? 0;
    });
  }

  Future<void> _toggleAdhan(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('adhanEnabled', value);
    setState(() => _adhanEnabled = value);
  }

  Future<void> _toggleDailyHadith(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dailyHadithEnabled', value);
    setState(() => _dailyHadithEnabled = value);
    if (value) {
      await NotificationService.instance
          .scheduleDailyHadith(hour: _dailyHadithHour, minute: _dailyHadithMinute);
    } else {
      await NotificationService.instance.cancelDailyHadith();
    }
  }

  void _showAbout(BuildContext context, bool isDark) {
    showAboutDialog(
      context: context,
      applicationName: 'Islamic Companion',
      applicationVersion: 'v3.0.0',
      applicationIcon: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFF1B5E20),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.mosque, color: Color(0xFFD4AF37), size: 24),
      ),
      children: [
        const SizedBox(height: 8),
        const Text(
          'Your all-in-one Islamic companion for daily spiritual needs.',
          style: TextStyle(fontSize: 13),
        ),
        const SizedBox(height: 12),
        const Text('12 Languages | 38 Cities | 20 Hadiths | 12 Surahs',
            style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic)),
        const SizedBox(height: 12),
        const Text('Features: Prayer Times, Qibla, Dhikr, Quran Recitation, '
            'Hadiths, Duas, 99 Names, Favorites, Notifications, Sadaqah.',
            style: TextStyle(fontSize: 11)),
        const SizedBox(height: 16),
        const Text(
          'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Color(0xFFD4AF37)),
        ),
      ],
    );
  }

  Future<void> _pickHadithTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _dailyHadithHour, minute: _dailyHadithMinute),
    );
    if (picked == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('dailyHadithHour', picked.hour);
    await prefs.setInt('dailyHadithMinute', picked.minute);
    setState(() {
      _dailyHadithHour = picked.hour;
      _dailyHadithMinute = picked.minute;
    });
    if (_dailyHadithEnabled) {
      await NotificationService.instance
          .scheduleDailyHadith(hour: picked.hour, minute: picked.minute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final appProvider = Provider.of<AppProvider>(context);
    final prayerProvider = Provider.of<PrayerProvider>(context);
    final isDark = appProvider.isDarkMode;
    final currentLang = appProvider.locale.languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('settings')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // City Selection
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B5E20).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.location_city, color: Color(0xFF1B5E20)),
              ),
              title: Text(
                l10n.translate('city'),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(prayerProvider.locationName),
              trailing: const Icon(Icons.chevron_right),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (_) => _CityBottomSheet(
                    currentCity: prayerProvider.locationName,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          // Adhan Notifications
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: SwitchListTile(
              secondary: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.notifications_active, color: Colors.teal),
              ),
              title: Text(
                l10n.translate('adhanNotifications'),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                l10n.translate('adhanNotificationsDesc'),
                style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.black45),
              ),
              value: _adhanEnabled,
              onChanged: _toggleAdhan,
              activeColor: Colors.teal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Daily Hadith Notification
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.auto_stories, color: Colors.amber),
                  ),
                  title: Text(
                    l10n.translate('dailyHadithNotif'),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    l10n.translate('dailyHadithNotifDesc'),
                    style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.black45),
                  ),
                  value: _dailyHadithEnabled,
                  onChanged: _toggleDailyHadith,
                  activeColor: Colors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                if (_dailyHadithEnabled)
                  ListTile(
                    contentPadding: const EdgeInsets.only(left: 72, right: 16, bottom: 8),
                    title: Text(
                      '${_dailyHadithHour.toString().padLeft(2, '0')}:${_dailyHadithMinute.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.amber.shade700,
                      ),
                    ),
                    trailing: const Icon(Icons.access_time, size: 20),
                    onTap: _pickHadithTime,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Dark Mode
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: SwitchListTile(
              secondary: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isDark ? Icons.dark_mode : Icons.light_mode,
                  color: Colors.deepPurple,
                ),
              ),
              title: Text(
                l10n.translate('darkMode'),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              value: isDark,
              onChanged: (_) => appProvider.toggleDarkMode(),
              activeColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Language
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.language, color: Colors.blue),
              ),
              title: Text(
                l10n.translate('language'),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                '${AppConstants.languageFlags[currentLang] ?? ''} ${AppConstants.languageNames[currentLang] ?? currentLang}',
              ),
              trailing: const Icon(Icons.chevron_right),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) => _LanguageBottomSheet(
                    currentLang: currentLang,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          // Rate Us
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.star_rate_rounded, color: Colors.orange),
              ),
              title: Text(
                l10n.translate('rateUs'),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                l10n.translate('rateUsDesc'),
                style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.black45),
              ),
              trailing: const Icon(Icons.chevron_right),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onTap: () {
                launchUrl(
                  Uri.parse('https://play.google.com/store/apps/details?id=com.islamiccompanion.app'),
                  mode: LaunchMode.externalApplication,
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          // Share App
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.share, color: Colors.green),
              ),
              title: Text(
                l10n.translate('shareApp'),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(Icons.chevron_right),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onTap: () {
                Share.share(
                  '${l10n.translate('appTitle')} - ${l10n.translate('shareAppMessage')}\n\nhttps://play.google.com/store/apps/details?id=com.islamiccompanion.app',
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          // App Info
          GestureDetector(
            onTap: () => _showAbout(context, isDark),
            child: Center(
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B5E20).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.mosque,
                      color: Color(0xFF1B5E20),
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.translate('appTitle'),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'v3.0.0',
                    style: TextStyle(
                      color: isDark ? Colors.white38 : Colors.black38,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tap for about',
                    style: TextStyle(
                      color: isDark ? Colors.white24 : Colors.black26,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _CityBottomSheet extends StatelessWidget {
  final String currentCity;
  const _CityBottomSheet({required this.currentCity});

  @override
  Widget build(BuildContext context) {
    final cities = PrayerProvider.cities.keys.toList();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              AppLocalizations.of(context)!.translate('selectCity'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          ...cities.map((city) {
            final isSelected = city == currentCity;
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
                Provider.of<PrayerProvider>(context, listen: false).setCity(city);
                Navigator.pop(context);
              },
            );
          }),
        ],
      ),
    );
  }
}

class _LanguageBottomSheet extends StatelessWidget {
  final String currentLang;

  const _LanguageBottomSheet({required this.currentLang});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          ...AppConstants.languageNames.entries.map((entry) {
            final isSelected = entry.key == currentLang;
            return ListTile(
              leading: Text(
                AppConstants.languageFlags[entry.key] ?? '',
                style: const TextStyle(fontSize: 24),
              ),
              title: Text(
                entry.value,
                style: TextStyle(
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? const Color(0xFF1B5E20) : null,
                ),
              ),
              trailing: isSelected
                  ? const Icon(Icons.check_circle, color: Color(0xFF1B5E20))
                  : null,
              onTap: () {
                Provider.of<AppProvider>(context, listen: false)
                    .setLocale(Locale(entry.key));
                Navigator.pop(context);
              },
            );
          }),
        ],
      ),
    );
  }
}
