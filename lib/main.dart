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
import 'screens/language_selection_screen.dart';
import 'screens/home_screen.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final prefs = await SharedPreferences.getInstance();
  final hasSelectedLanguage = prefs.getBool('hasSelectedLanguage') ?? false;
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
      ],
      child: IslamicCompanionApp(
        hasSelectedLanguage: hasSelectedLanguage,
      ),
    ),
  );
}

class IslamicCompanionApp extends StatelessWidget {
  final bool hasSelectedLanguage;

  const IslamicCompanionApp({
    super.key,
    required this.hasSelectedLanguage,
  });

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
      home: hasSelectedLanguage
          ? const HomeScreen()
          : const LanguageSelectionScreen(),
    );
  }
}
