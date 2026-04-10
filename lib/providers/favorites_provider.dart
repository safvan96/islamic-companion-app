import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider extends ChangeNotifier {
  Set<int> _favHadiths = {};
  Set<int> _favSurahs = {};
  Set<int> _favDuas = {};

  Set<int> get favHadiths => _favHadiths;
  Set<int> get favSurahs => _favSurahs;
  Set<int> get favDuas => _favDuas;

  FavoritesProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _favHadiths = (prefs.getStringList('fav_hadiths') ?? [])
        .map((s) => int.tryParse(s) ?? -1)
        .where((i) => i >= 0)
        .toSet();
    _favSurahs = (prefs.getStringList('fav_surahs') ?? [])
        .map((s) => int.tryParse(s) ?? -1)
        .where((i) => i >= 0)
        .toSet();
    _favDuas = (prefs.getStringList('fav_duas') ?? [])
        .map((s) => int.tryParse(s) ?? -1)
        .where((i) => i >= 0)
        .toSet();
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'fav_hadiths', _favHadiths.map((e) => e.toString()).toList());
    await prefs.setStringList(
        'fav_surahs', _favSurahs.map((e) => e.toString()).toList());
    await prefs.setStringList(
        'fav_duas', _favDuas.map((e) => e.toString()).toList());
  }

  bool isHadithFav(int index) => _favHadiths.contains(index);
  bool isSurahFav(int number) => _favSurahs.contains(number);
  bool isDuaFav(int index) => _favDuas.contains(index);

  Future<void> toggleHadith(int index) async {
    if (_favHadiths.contains(index)) {
      _favHadiths.remove(index);
    } else {
      _favHadiths.add(index);
    }
    notifyListeners();
    await _save();
  }

  Future<void> toggleSurah(int number) async {
    if (_favSurahs.contains(number)) {
      _favSurahs.remove(number);
    } else {
      _favSurahs.add(number);
    }
    notifyListeners();
    await _save();
  }

  Future<void> toggleDua(int index) async {
    if (_favDuas.contains(index)) {
      _favDuas.remove(index);
    } else {
      _favDuas.add(index);
    }
    notifyListeners();
    await _save();
  }
}
