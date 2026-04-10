import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';
import '../providers/prayer_provider.dart';
import '../utils/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _adhanEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadAdhanPref();
  }

  Future<void> _loadAdhanPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _adhanEnabled = prefs.getBool('adhanEnabled') ?? true;
    });
  }

  Future<void> _toggleAdhan(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('adhanEnabled', value);
    setState(() => _adhanEnabled = value);
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
          const SizedBox(height: 24),
          // App Info
          Center(
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
                  'v1.0.0',
                  style: TextStyle(
                    color: isDark ? Colors.white38 : Colors.black38,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
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
