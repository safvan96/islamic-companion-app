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
  final Map<String, bool> _prayerNotifs = {
    'Fajr': true, 'Dhuhr': true, 'Asr': true, 'Maghrib': true, 'Isha': true,
  };
  bool _dailyHadithEnabled = false;
  int _dailyHadithHour = 8;
  int _dailyHadithMinute = 0;
  int _preFajrMinutes = 0;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _adhanEnabled = prefs.getBool('adhanEnabled') ?? true;
      for (final p in _prayerNotifs.keys) {
        _prayerNotifs[p] = prefs.getBool('adhan_$p') ?? true;
      }
      _dailyHadithEnabled = prefs.getBool('dailyHadithEnabled') ?? false;
      _dailyHadithHour = prefs.getInt('dailyHadithHour') ?? 8;
      _dailyHadithMinute = prefs.getInt('dailyHadithMinute') ?? 0;
      _preFajrMinutes = prefs.getInt('preFajrMinutes') ?? 0;
    });
  }

  Future<void> _toggleAdhan(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('adhanEnabled', value);
    if (!mounted) return;
    setState(() => _adhanEnabled = value);
  }

  Future<void> _togglePrayerNotif(String prayer, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('adhan_$prayer', value);
    if (!mounted) return;
    setState(() => _prayerNotifs[prayer] = value);
  }

  Future<void> _toggleDailyHadith(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dailyHadithEnabled', value);
    if (!mounted) return;
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
      applicationVersion: 'v4.7.0',
      applicationIcon: Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          color: Color(0xFF1B5E20),
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
        const Text('20 Languages | 71 Cities | 122 Screens | 115+ Features',
            style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic)),
        const SizedBox(height: 12),
        const Text('Features: Prayer Times, Qibla, Dhikr, Quran, Hadiths, '
            'Duas, Zakat, Hajj, Fasting, Quiz, Adhkar and much more.',
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
    if (!mounted) return;
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
          // Calculation Method
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.calculate, color: Colors.indigo),
              ),
              title: Text(
                l10n.translate('calculationMethod'),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(PrayerProvider.methodNames[prayerProvider.method]!,
                style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.black45)),
              trailing: const Icon(Icons.chevron_right),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              onTap: () {
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
                        Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
                        const SizedBox(height: 16),
                        Text(l10n.translate('calculationMethod'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        ...PrayerMethod.values.map((m) {
                          final isSelected = m == prayerProvider.method;
                          return ListTile(
                            leading: Icon(Icons.calculate, color: isSelected ? Colors.indigo : Colors.grey),
                            title: Text(PrayerProvider.methodNames[m]!, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? Colors.indigo : null)),
                            trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.indigo) : null,
                            onTap: () { prayerProvider.setMethod(m); Navigator.pop(context); },
                          );
                        }),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          // Asr Method (Hanafi/Shafi'i)
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: SwitchListTile(
              secondary: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), shape: BoxShape.circle),
                child: const Icon(Icons.compare_arrows, color: Colors.orange),
              ),
              title: Text(l10n.translate('asrMethod'), style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(
                prayerProvider.isHanafi ? 'Hanafi (${l10n.translate('laterAsr')})' : "Shafi'i / Hanbali / Maliki",
                style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.black45),
              ),
              value: prayerProvider.isHanafi,
              onChanged: (v) => prayerProvider.setHanafi(v),
              activeColor: Colors.orange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
          const SizedBox(height: 12),
          // Adhan Notifications
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
                if (_adhanEnabled) ...[
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      children: _prayerNotifs.entries.map((e) => Row(
                        children: [
                          const SizedBox(width: 48),
                          Expanded(child: Text(l10n.translate(e.key.toLowerCase()),
                            style: TextStyle(fontSize: 14, color: isDark ? Colors.white70 : Colors.black87))),
                          Switch(
                            value: e.value,
                            onChanged: (v) => _togglePrayerNotif(e.key, v),
                            activeColor: Colors.teal,
                          ),
                        ],
                      )).toList(),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Pre-Fajr Wake Up
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.indigo.withOpacity(0.1), shape: BoxShape.circle),
                child: const Icon(Icons.alarm, color: Colors.indigo),
              ),
              title: Text(l10n.translate('preFajrAlarm'), style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(
                _preFajrMinutes > 0 ? '$_preFajrMinutes ${l10n.translate('minBeforeFajr')}' : l10n.translate('off'),
                style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.black45),
              ),
              trailing: const Icon(Icons.chevron_right),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                  builder: (_) => Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
                      const SizedBox(height: 16),
                      Text(l10n.translate('preFajrAlarm'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      ...[0, 15, 30, 45, 60].map((mins) {
                        final selected = mins == _preFajrMinutes;
                        final label = mins == 0 ? l10n.translate('off') : '$mins ${l10n.translate('minutes')}';
                        return ListTile(
                          leading: Icon(mins == 0 ? Icons.alarm_off : Icons.alarm, color: selected ? Colors.indigo : Colors.grey),
                          title: Text(label, style: TextStyle(fontWeight: selected ? FontWeight.bold : FontWeight.normal, color: selected ? Colors.indigo : null)),
                          trailing: selected ? const Icon(Icons.check_circle, color: Colors.indigo) : null,
                          onTap: () async {
                            final nav = Navigator.of(context);
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setInt('preFajrMinutes', mins);
                            if (!mounted) return;
                            setState(() => _preFajrMinutes = mins);
                            nav.pop();
                          },
                        );
                      }),
                    ]),
                  ),
                );
              },
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
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  appProvider.themeSetting == ThemeSetting.system ? Icons.brightness_auto :
                  isDark ? Icons.dark_mode : Icons.light_mode,
                  color: Colors.deepPurple,
                ),
              ),
              title: Text(
                l10n.translate('theme'),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                appProvider.themeSetting == ThemeSetting.system ? l10n.translate('systemTheme') :
                isDark ? l10n.translate('darkMode') : l10n.translate('lightMode'),
                style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.black45),
              ),
              trailing: const Icon(Icons.chevron_right),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                  builder: (_) => Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
                      const SizedBox(height: 16),
                      Text(l10n.translate('theme'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      ...ThemeSetting.values.map((t) {
                        final selected = t == appProvider.themeSetting;
                        final icon = t == ThemeSetting.light ? Icons.light_mode : t == ThemeSetting.dark ? Icons.dark_mode : Icons.brightness_auto;
                        final label = t == ThemeSetting.light ? l10n.translate('lightMode') : t == ThemeSetting.dark ? l10n.translate('darkMode') : l10n.translate('systemTheme');
                        return ListTile(
                          leading: Icon(icon, color: selected ? Colors.deepPurple : Colors.grey),
                          title: Text(label, style: TextStyle(fontWeight: selected ? FontWeight.bold : FontWeight.normal, color: selected ? Colors.deepPurple : null)),
                          trailing: selected ? const Icon(Icons.check_circle, color: Colors.deepPurple) : null,
                          onTap: () { appProvider.setTheme(t); Navigator.pop(context); },
                        );
                      }),
                    ]),
                  ),
                );
              },
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
                    'v4.7.0',
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

class _CityBottomSheet extends StatefulWidget {
  final String currentCity;
  const _CityBottomSheet({required this.currentCity});

  @override
  State<_CityBottomSheet> createState() => _CityBottomSheetState();
}

class _CityBottomSheetState extends State<_CityBottomSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final allCities = PrayerProvider.cities.keys.toList();
    final filtered = _query.isEmpty
        ? allCities
        : allCities.where((c) => c.toLowerCase().contains(_query.toLowerCase())).toList();
    final isDark = Provider.of<AppProvider>(context).isDarkMode;

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              AppLocalizations.of(context)!.translate('selectCity'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.translate('search'),
                prefixIcon: const Icon(Icons.search, size: 20),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.black12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, i) {
                final city = filtered[i];
                final isSelected = city == widget.currentCity;
                return ListTile(
                  leading: Icon(Icons.location_city, color: isSelected ? const Color(0xFF1B5E20) : Colors.grey),
                  title: Text(city, style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? const Color(0xFF1B5E20) : null,
                  )),
                  trailing: isSelected ? const Icon(Icons.check_circle, color: Color(0xFF1B5E20)) : null,
                  onTap: () {
                    Provider.of<PrayerProvider>(context, listen: false).setCity(city);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
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
