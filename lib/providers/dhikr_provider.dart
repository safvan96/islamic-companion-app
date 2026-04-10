import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DhikrProvider extends ChangeNotifier {
  int _count = 0;
  int _totalCount = 0;
  int _targetCount = 33;
  int _selectedDhikrIndex = 0;
  bool _hapticEnabled = true;
  bool get hapticEnabled => _hapticEnabled;

  int _todayCount = 0;
  String _todayKey = '';
  int get todayCount => _todayCount;

  // Map of date key -> count, kept trimmed to last 7 days
  Map<String, int> _history = {};
  /// Last 7 days oldest→newest as (label, count). Missing days = 0.
  List<MapEntry<String, int>> get last7Days {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final d = now.subtract(Duration(days: 6 - i));
      return MapEntry(_dateKey(d), _history[_dateKey(d)] ?? 0);
    });
  }

  static String _dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

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

  // Per-dhikr lifetime counts (parallel to dhikrList by index)
  List<int> _perDhikrCounts = List<int>.filled(dhikrList.length, 0);
  List<int> get perDhikrCounts => List.unmodifiable(_perDhikrCounts);

  // Fires once when target is reached on this session
  bool _targetCelebrated = false;
  bool get justReachedTarget => targetReached && !_targetCelebrated;

  DhikrProvider() {
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    _totalCount = prefs.getInt('totalDhikr') ?? 0;
    _count = prefs.getInt('currentDhikrCount') ?? 0;
    _targetCount = prefs.getInt('targetDhikrCount') ?? 33;
    _selectedDhikrIndex = prefs.getInt('selectedDhikrIndex') ?? 0;
    if (_selectedDhikrIndex < 0 || _selectedDhikrIndex >= dhikrList.length) {
      _selectedDhikrIndex = 0;
    }
    final stored = prefs.getStringList('perDhikrCounts');
    if (stored != null && stored.length == dhikrList.length) {
      _perDhikrCounts =
          stored.map((s) => int.tryParse(s) ?? 0).toList(growable: false);
    }
    _hapticEnabled = prefs.getBool('dhikrHaptic') ?? true;
    final today = _dateKey(DateTime.now());
    final storedDay = prefs.getString('todayDhikrDay') ?? '';
    if (storedDay == today) {
      _todayCount = prefs.getInt('todayDhikrCount') ?? 0;
    } else {
      _todayCount = 0;
      await prefs.setString('todayDhikrDay', today);
      await prefs.setInt('todayDhikrCount', 0);
    }
    _todayKey = today;
    final histRaw = prefs.getStringList('dhikrHistory') ?? const [];
    _history = {
      for (final entry in histRaw)
        if (entry.contains('|'))
          entry.split('|')[0]: int.tryParse(entry.split('|')[1]) ?? 0,
    };
    if (_todayCount > 0) _history[today] = _todayCount;
    _trimHistory();
    _targetCelebrated = _count >= _targetCount;
    notifyListeners();
  }

  void _trimHistory() {
    if (_history.isEmpty) return;
    final cutoff = DateTime.now().subtract(const Duration(days: 30));
    _history.removeWhere((k, _) {
      final parts = k.split('-');
      if (parts.length != 3) return true;
      final d = DateTime.tryParse(k);
      return d == null || d.isBefore(cutoff);
    });
  }

  List<String> _historyToList() =>
      _history.entries.map((e) => '${e.key}|${e.value}').toList();

  Future<void> setHapticEnabled(bool value) async {
    _hapticEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dhikrHaptic', value);
    notifyListeners();
  }

  Future<void> increment() async {
    _count++;
    _totalCount++;
    _perDhikrCounts[_selectedDhikrIndex]++;
    final today = _dateKey(DateTime.now());
    if (today != _todayKey) {
      _todayKey = today;
      _todayCount = 0;
    }
    _todayCount++;
    _history[_todayKey] = _todayCount;
    _trimHistory();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('totalDhikr', _totalCount);
    await prefs.setInt('currentDhikrCount', _count);
    await prefs.setString('todayDhikrDay', _todayKey);
    await prefs.setInt('todayDhikrCount', _todayCount);
    await prefs.setStringList('dhikrHistory', _historyToList());
    await prefs.setStringList(
      'perDhikrCounts',
      _perDhikrCounts.map((e) => e.toString()).toList(),
    );
    notifyListeners();
  }

  void markTargetCelebrated() {
    _targetCelebrated = true;
  }

  Future<void> reset() async {
    _count = 0;
    _targetCelebrated = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentDhikrCount', 0);
    notifyListeners();
  }

  Future<void> setTarget(int target) async {
    _targetCount = target;
    _targetCelebrated = _count >= _targetCount;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('targetDhikrCount', target);
    notifyListeners();
  }

  Future<void> resetLifetimeFor(int index) async {
    if (index < 0 || index >= dhikrList.length) return;
    final removed = _perDhikrCounts[index];
    _perDhikrCounts[index] = 0;
    _totalCount = (_totalCount - removed).clamp(0, 1 << 31);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('totalDhikr', _totalCount);
    await prefs.setStringList(
      'perDhikrCounts',
      _perDhikrCounts.map((e) => e.toString()).toList(),
    );
    notifyListeners();
  }

  Future<void> selectDhikr(int index) async {
    _selectedDhikrIndex = index;
    _count = 0;
    _targetCelebrated = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedDhikrIndex', index);
    await prefs.setInt('currentDhikrCount', 0);
    notifyListeners();
  }
}
