import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DhikrProvider extends ChangeNotifier {
  int _count = 0;
  int _totalCount = 0;
  int _targetCount = 33;
  int _selectedDhikrIndex = 0;

  int get count => _count;
  int get totalCount => _totalCount;
  int get targetCount => _targetCount;
  int get selectedDhikrIndex => _selectedDhikrIndex;
  bool get targetReached => _count >= _targetCount;

  static const List<Map<String, String>> dhikrList = [
    {
      'arabic': 'سُبْحَانَ اللّٰهِ',
      'transliteration': 'SubhanAllah',
      'meaning': 'Glory be to Allah',
    },
    {
      'arabic': 'الْحَمْدُ لِلّٰهِ',
      'transliteration': 'Alhamdulillah',
      'meaning': 'Praise be to Allah',
    },
    {
      'arabic': 'اللّٰهُ أَكْبَرُ',
      'transliteration': 'Allahu Akbar',
      'meaning': 'Allah is the Greatest',
    },
    {
      'arabic': 'لَا إِلٰهَ إِلَّا اللّٰهُ',
      'transliteration': 'La ilaha illAllah',
      'meaning': 'There is no god but Allah',
    },
    {
      'arabic': 'أَسْتَغْفِرُ اللّٰهَ',
      'transliteration': 'Astaghfirullah',
      'meaning': 'I seek forgiveness from Allah',
    },
    {
      'arabic': 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللّٰهِ',
      'transliteration': 'La hawla wa la quwwata illa billah',
      'meaning': 'There is no power except with Allah',
    },
    {
      'arabic': 'سُبْحَانَ اللّٰهِ وَبِحَمْدِهِ',
      'transliteration': 'SubhanAllahi wa bihamdihi',
      'meaning': 'Glory and praise be to Allah',
    },
    {
      'arabic': 'صَلَّى اللّٰهُ عَلَى مُحَمَّدٍ',
      'transliteration': 'Sallallahu ala Muhammad',
      'meaning': 'May Allah bless Muhammad',
    },
  ];

  DhikrProvider() {
    _loadTotal();
  }

  Future<void> _loadTotal() async {
    final prefs = await SharedPreferences.getInstance();
    _totalCount = prefs.getInt('totalDhikr') ?? 0;
    notifyListeners();
  }

  Future<void> increment() async {
    _count++;
    _totalCount++;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('totalDhikr', _totalCount);
    notifyListeners();
  }

  void reset() {
    _count = 0;
    notifyListeners();
  }

  void setTarget(int target) {
    _targetCount = target;
    notifyListeners();
  }

  void selectDhikr(int index) {
    _selectedDhikrIndex = index;
    _count = 0;
    notifyListeners();
  }
}
