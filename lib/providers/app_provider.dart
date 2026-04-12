import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeSetting { light, dark, system }

class AppProvider extends ChangeNotifier {
  Locale _locale;
  ThemeSetting _themeSetting;

  AppProvider({
    required Locale locale,
    required ThemeSetting themeSetting,
  })  : _locale = locale,
        _themeSetting = themeSetting;

  Locale get locale => _locale;
  ThemeSetting get themeSetting => _themeSetting;

  bool get isDarkMode {
    if (_themeSetting == ThemeSetting.system) {
      return SchedulerBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
    }
    return _themeSetting == ThemeSetting.dark;
  }

  ThemeMode get themeMode {
    switch (_themeSetting) {
      case ThemeSetting.light: return ThemeMode.light;
      case ThemeSetting.dark: return ThemeMode.dark;
      case ThemeSetting.system: return ThemeMode.system;
    }
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
    await prefs.setBool('hasSelectedLanguage', true);
    notifyListeners();
  }

  Future<void> setTheme(ThemeSetting setting) async {
    _themeSetting = setting;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeSetting', setting.name);
    notifyListeners();
  }

  // Legacy toggle: cycles light → dark → system → light
  Future<void> toggleDarkMode() async {
    final next = ThemeSetting.values[(_themeSetting.index + 1) % ThemeSetting.values.length];
    await setTheme(next);
  }
}
