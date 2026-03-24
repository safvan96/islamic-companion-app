import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider extends ChangeNotifier {
  Locale _locale;
  bool _isDarkMode;

  AppProvider({
    required Locale locale,
    required bool isDarkMode,
  })  : _locale = locale,
        _isDarkMode = isDarkMode;

  Locale get locale => _locale;
  bool get isDarkMode => _isDarkMode;

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
    await prefs.setBool('hasSelectedLanguage', true);
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }
}
