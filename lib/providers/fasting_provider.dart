import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FastingProvider extends ChangeNotifier {
  // date key → type ('ramadan' | 'voluntary' | 'makeup')
  Map<String, String> _fastDays = {};
  Map<String, String> get fastDays => Map.unmodifiable(_fastDays);

  int get totalFasts => _fastDays.length;
  int get ramadanFasts => _fastDays.values.where((v) => v == 'ramadan').length;
  int get voluntaryFasts => _fastDays.values.where((v) => v == 'voluntary').length;
  int get makeupFasts => _fastDays.values.where((v) => v == 'makeup').length;

  /// Current month streak
  int get currentStreak {
    final now = DateTime.now();
    int count = 0;
    for (int i = 0; i < 365; i++) {
      final d = now.subtract(Duration(days: i));
      final key = _dateKey(d);
      if (_fastDays.containsKey(key)) {
        count++;
      } else if (i > 0) {
        break;
      }
    }
    return count;
  }

  FastingProvider() {
    _load();
  }

  static String _dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('fastingDays');
    if (raw != null) {
      try {
        final map = Map<String, dynamic>.from(jsonDecode(raw));
        _fastDays = map.map((k, v) => MapEntry(k, v.toString()));
      } catch (_) {}
    }
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fastingDays', jsonEncode(_fastDays));
  }

  Future<void> toggleFast(DateTime date, String type) async {
    final key = _dateKey(date);
    if (_fastDays.containsKey(key)) {
      _fastDays.remove(key);
    } else {
      _fastDays[key] = type;
    }
    await _save();
    notifyListeners();
  }

  Future<void> setFast(DateTime date, String type) async {
    final key = _dateKey(date);
    _fastDays[key] = type;
    await _save();
    notifyListeners();
  }

  Future<void> removeFast(DateTime date) async {
    final key = _dateKey(date);
    _fastDays.remove(key);
    await _save();
    notifyListeners();
  }

  String? getFastType(DateTime date) => _fastDays[_dateKey(date)];

  bool isFasting(DateTime date) => _fastDays.containsKey(_dateKey(date));

  /// Get fasts for a specific month
  List<MapEntry<int, String>> getFastsForMonth(int year, int month) {
    final result = <MapEntry<int, String>>[];
    final daysInMonth = DateTime(year, month + 1, 0).day;
    for (int d = 1; d <= daysInMonth; d++) {
      final key = _dateKey(DateTime(year, month, d));
      if (_fastDays.containsKey(key)) {
        result.add(MapEntry(d, _fastDays[key]!));
      }
    }
    return result;
  }
}
