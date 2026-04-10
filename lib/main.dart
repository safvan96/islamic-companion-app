import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'l10n/app_localizations.dart';
import 'providers/app_provider.dart';
import 'providers/prayer_provider.dart';
import 'providers/dhikr_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/qaza_provider.dart';
import 'providers/fasting_provider.dart';
import 'screens/splash_screen.dart';
import 'services/adhan_service.dart';
import 'services/notification_service.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await MobileAds.instance.initialize();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await AdhanService.init();
    await NotificationService.instance.initialize();
  }

  final prefs = await SharedPreferences.getInstance();

  // Reschedule daily hadith if enabled
  final dailyHadithEnabled = prefs.getBool('dailyHadithEnabled') ?? false;
  if (dailyHadithEnabled) {
    final h = prefs.getInt('dailyHadithHour') ?? 8;
    final m = prefs.getInt('dailyHadithMinute') ?? 0;
    await NotificationService.instance.scheduleDailyHadith(hour: h, minute: m);
  }
  final savedLocale = prefs.getString('locale') ?? 'en';
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppProvider(
            locale: Locale(savedLocale),
            isDarkMode: isDarkMode,
          ),
        ),
        ChangeNotifierProvider(create: (_) => PrayerProvider()),
        ChangeNotifierProvider(create: (_) => DhikrProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => QazaProvider()),
        ChangeNotifierProvider(create: (_) => FastingProvider()),
      ],
      child: const IslamicCompanionApp(),
    ),
  );
}

class IslamicCompanionApp extends StatelessWidget {
  const IslamicCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    return MaterialApp(
      title: 'Islamic Companion',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: appProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      locale: appProvider.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const SplashScreen(),
    );
  }
}
