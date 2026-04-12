import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tracks missed (qaza) prayers that need to be made up.
/// Each prayer type has a remaining count. Users increment when they miss
/// a prayer and decrement when they make it up.
class QazaProvider extends ChangeNotifier {
  // Prayer types: Fajr, Dhuhr, Asr, Maghrib, Isha, Witr
  static const prayerKeys = ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha', 'witr'];

  final Map<String, int> _counts = {};
  Map<String, int> get counts => Map.unmodifiable(_counts);

  int get totalRemaining => _counts.values.fold(0, (a, b) => a + b);
  int get totalCompleted => _completedTotal;
  int _completedTotal = 0;

  QazaProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    for (final key in prayerKeys) {
      _counts[key] = prefs.getInt('qaza_$key') ?? 0;
    }
    _completedTotal = prefs.getInt('qaza_completed_total') ?? 0;
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    for (final key in prayerKeys) {
      await prefs.setInt('qaza_$key', _counts[key] ?? 0);
    }
    await prefs.setInt('qaza_completed_total', _completedTotal);
  }

  /// Add missed prayers (e.g. bulk add years of missed prayers)
  Future<void> addMissed(String prayerKey, int amount) async {
    if (!prayerKeys.contains(prayerKey) || amount <= 0) return;
    _counts[prayerKey] = (_counts[prayerKey] ?? 0) + amount;
    await _save();
    notifyListeners();
  }

  /// Mark one prayer as made up
  Future<void> makeUp(String prayerKey) async {
    if (!prayerKeys.contains(prayerKey)) return;
    final current = _counts[prayerKey] ?? 0;
    if (current <= 0) return;
    _counts[prayerKey] = current - 1;
    _completedTotal++;
    await _save();
    notifyListeners();
  }

  /// Set exact count for a prayer
  Future<void> setCount(String prayerKey, int count) async {
    if (!prayerKeys.contains(prayerKey) || count < 0) return;
    _counts[prayerKey] = count;
    await _save();
    notifyListeners();
  }

  /// Reset all counts
  Future<void> resetAll() async {
    for (final key in prayerKeys) {
      _counts[key] = 0;
    }
    _completedTotal = 0;
    await _save();
    notifyListeners();
  }
}
