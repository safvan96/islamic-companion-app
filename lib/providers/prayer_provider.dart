import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import '../services/adhan_service.dart';

enum PrayerMethod {
  mwl,    // Muslim World League: Fajr 18°, Isha 17°
  isna,   // ISNA (North America): Fajr 15°, Isha 15°
  egypt,  // Egyptian Authority: Fajr 19.5°, Isha 17.5°
  karachi,// Karachi: Fajr 18°, Isha 18°
  makkah, // Umm al-Qura: Fajr 18.5°, Isha 90min after Maghrib
}

class PrayerProvider extends ChangeNotifier {
  Map<String, String> _prayerTimes = {};
  String _nextPrayer = '';
  Duration _timeUntilNext = Duration.zero;
  double _latitude = 0;
  double _longitude = 0;
  String _locationName = '';
  PrayerMethod _method = PrayerMethod.mwl;
  bool _hanafi = false; // Asr: Hanafi (shadow=2x) vs Shafi'i (shadow=1x)
  Timer? _ticker;

  PrayerMethod get method => _method;
  bool get isHanafi => _hanafi;

  static const methodNames = {
    PrayerMethod.mwl: 'Muslim World League',
    PrayerMethod.isna: 'ISNA (North America)',
    PrayerMethod.egypt: 'Egyptian Authority',
    PrayerMethod.karachi: 'Univ. of Karachi',
    PrayerMethod.makkah: 'Umm al-Qura (Makkah)',
  };

  static const _fajrAngles = {
    PrayerMethod.mwl: 18.0,
    PrayerMethod.isna: 15.0,
    PrayerMethod.egypt: 19.5,
    PrayerMethod.karachi: 18.0,
    PrayerMethod.makkah: 18.5,
  };

  static const _ishaAngles = {
    PrayerMethod.mwl: 17.0,
    PrayerMethod.isna: 15.0,
    PrayerMethod.egypt: 17.5,
    PrayerMethod.karachi: 18.0,
    PrayerMethod.makkah: 0.0, // Uses 90min offset instead
  };

  Map<String, String> get prayerTimes => _prayerTimes;
  String get nextPrayer => _nextPrayer;
  Duration get timeUntilNext => _timeUntilNext;
  String get locationName => _locationName;

  PrayerProvider() {
    _startTicker();
  }

  void _startTicker() {
    _ticker = Timer.periodic(const Duration(seconds: 60), (_) {
      if (_prayerTimes.isNotEmpty) {
        _calculateNextPrayer(DateTime.now());
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  /// Known cities for prayer times
  static const Map<String, List<double>> cities = {
    // Türkiye
    'Istanbul': [41.0082, 28.9784],
    'Ankara': [39.9334, 32.8597],
    'Konya': [37.8746, 32.4932],
    'Izmir': [38.4237, 27.1428],
    'Bursa': [40.1885, 29.0610],
    'Antalya': [36.8969, 30.7133],
    'Adana': [37.0000, 35.3213],
    'Gaziantep': [37.0662, 37.3833],
    'Kayseri': [38.7312, 35.4787],
    'Trabzon': [41.0027, 39.7168],
    'Diyarbakir': [37.9144, 40.2306],
    'Samsun': [41.2867, 36.3300],
    'Mersin': [36.8121, 34.6415],
    'Eskisehir': [39.7767, 30.5206],
    // Orta Doğu
    'Mecca': [21.4225, 39.8262],
    'Medina': [24.4672, 39.6112],
    'Jeddah': [21.5433, 39.1728],
    'Cairo': [30.0444, 31.2357],
    'Dubai': [25.2048, 55.2708],
    'Abu Dhabi': [24.4539, 54.3773],
    'Riyadh': [24.7136, 46.6753],
    'Baghdad': [33.3152, 44.3661],
    'Doha': [25.2854, 51.5310],
    'Kuwait City': [29.3759, 47.9774],
    'Amman': [31.9454, 35.9284],
    'Beirut': [33.8938, 35.5018],
    'Tehran': [35.6892, 51.3890],
    'Muscat': [23.5880, 58.3829],
    // Avrupa
    'London': [51.5074, -0.1278],
    'Berlin': [52.5200, 13.4050],
    'Paris': [48.8566, 2.3522],
    'Amsterdam': [52.3676, 4.9041],
    'Moscow': [55.7558, 37.6173],
    'Vienna': [48.2082, 16.3738],
    'Stockholm': [59.3293, 18.0686],
    'Brussels': [50.8503, 4.3517],
    'Sarajevo': [43.8563, 18.4131],
    'Rome': [41.9028, 12.4964],
    'Cologne': [50.9375, 6.9603],
    // Güney & Güneydoğu Asya
    'Jakarta': [-6.2088, 106.8456],
    'New Delhi': [28.6139, 77.2090],
    'Mumbai': [19.0760, 72.8777],
    'Beijing': [39.9042, 116.4074],
    'Kuala Lumpur': [3.1390, 101.6869],
    'Karachi': [24.8607, 67.0011],
    'Lahore': [31.5204, 74.3587],
    'Dhaka': [23.8103, 90.4125],
    'Islamabad': [33.6844, 73.0479],
    'Tokyo': [35.6762, 139.6503],
    'Seoul': [37.5665, 126.9780],
    'Singapore': [1.3521, 103.8198],
    'Bangkok': [13.7563, 100.5018],
    'Colombo': [6.9271, 79.8612],
    // Orta Asya & Kafkasya
    'Tashkent': [41.2995, 69.2401],
    'Almaty': [43.2220, 76.8512],
    'Baku': [40.4093, 49.8671],
    // Amerika
    'New York': [40.7128, -74.0060],
    'Los Angeles': [34.0522, -118.2437],
    'Chicago': [41.8781, -87.6298],
    'Houston': [29.7604, -95.3698],
    'Toronto': [43.6532, -79.3832],
    'Sao Paulo': [-23.5505, -46.6333],
    // Afrika
    'Mogadishu': [2.0469, 45.3182],
    'Lagos': [6.5244, 3.3792],
    'Dar es Salaam': [-6.7924, 39.2083],
    'Casablanca': [33.5731, -7.5898],
    'Nairobi': [-1.2921, 36.8219],
    'Johannesburg': [-26.2041, 28.0473],
    'Dakar': [14.7167, -17.4677],
    // Avustralya
    'Sydney': [-33.8688, 151.2093],
    'Melbourne': [-37.8136, 144.9631],
  };

  double get latitude => _latitude;
  double get longitude => _longitude;

  /// Initialize with saved city and calculation method
  Future<void> initLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCity = prefs.getString('selectedCity') ?? 'Istanbul';
    final savedMethod = prefs.getString('prayerMethod') ?? 'mwl';
    _method = PrayerMethod.values.firstWhere(
      (m) => m.name == savedMethod,
      orElse: () => PrayerMethod.mwl,
    );
    _hanafi = prefs.getBool('asrHanafi') ?? false;
    final coords = cities[savedCity];
    if (coords != null) {
      setLocation(coords[0], coords[1], savedCity);
    } else {
      setLocation(41.0082, 28.9784, 'Istanbul');
    }
  }

  /// Change calculation method and recalculate
  Future<void> setMethod(PrayerMethod m) async {
    _method = m;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('prayerMethod', m.name);
    calculatePrayerTimes();
  }

  /// Toggle Hanafi Asr (later Asr time)
  Future<void> setHanafi(bool value) async {
    _hanafi = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('asrHanafi', value);
    calculatePrayerTimes();
  }

  /// Set city by name and persist
  Future<void> setCity(String name) async {
    final coords = cities[name];
    if (coords != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selectedCity', name);
      setLocation(coords[0], coords[1], name);
    }
  }

  void setLocation(double lat, double lng, String name) {
    _latitude = lat;
    _longitude = lng;
    _locationName = name;
    calculatePrayerTimes();
  }

  void calculatePrayerTimes() {
    final now = DateTime.now();
    final dayOfYear = _getDayOfYear(now);
    final timeZoneOffset = now.timeZoneOffset.inMinutes / 60.0;

    final declination = -23.45 * cos(2 * pi * (dayOfYear + 10) / 365);
    final declinationRad = declination * pi / 180;
    final latRad = _latitude * pi / 180;

    final b = 2 * pi * (dayOfYear - 81) / 365;
    final eot = 9.87 * sin(2 * b) - 7.53 * cos(b) - 1.5 * sin(b);

    final solarNoon = 12.0 - _longitude / 15.0 + timeZoneOffset - eot / 60.0;

    final cosHA = -tan(latRad) * tan(declinationRad);
    final ha = acos(cosHA.clamp(-1.0, 1.0)) * 180 / pi / 15;

    final fajrAngle = _fajrAngles[_method]!;
    final cosFajr =
        (cos((90 + fajrAngle) * pi / 180) - sin(latRad) * sin(declinationRad)) /
            (cos(latRad) * cos(declinationRad));
    final fajrHA = acos(cosFajr.clamp(-1.0, 1.0)) * 180 / pi / 15;

    final ishaAngle = _ishaAngles[_method]!;
    final double ishaHA;
    if (_method == PrayerMethod.makkah) {
      ishaHA = 0; // Isha = Maghrib + 90min (handled below)
    } else {
      final cosIsha =
          (cos((90 + ishaAngle) * pi / 180) - sin(latRad) * sin(declinationRad)) /
              (cos(latRad) * cos(declinationRad));
      ishaHA = acos(cosIsha.clamp(-1.0, 1.0)) * 180 / pi / 15;
    }

    final asrShadowFactor = _hanafi ? 2 : 1; // Hanafi: shadow=2x, Shafi'i: shadow=1x
    final asrAngle = atan(1 / (asrShadowFactor + tan((latRad - declinationRad).abs())));
    final cosAsr = (sin(asrAngle) - sin(latRad) * sin(declinationRad)) /
        (cos(latRad) * cos(declinationRad));
    final asrHA = acos(cosAsr.clamp(-1.0, 1.0)) * 180 / pi / 15;

    final fajr = solarNoon - fajrHA;
    final sunrise = solarNoon - ha;
    final dhuhr = solarNoon + 0.0167;
    final asr = solarNoon + asrHA;
    final maghrib = solarNoon + ha;
    final isha = _method == PrayerMethod.makkah
        ? maghrib + 1.5 // 90 minutes after Maghrib
        : solarNoon + ishaHA;

    _prayerTimes = {
      'Fajr': _formatTime(fajr),
      'Sunrise': _formatTime(sunrise),
      'Dhuhr': _formatTime(dhuhr),
      'Asr': _formatTime(asr),
      'Maghrib': _formatTime(maghrib),
      'Isha': _formatTime(isha),
    };

    _calculateNextPrayer(now);
    // Schedule adhan notifications if enabled
    _scheduleAdhanIfEnabled();
    notifyListeners();
  }

  Future<void> _scheduleAdhanIfEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool('adhanEnabled') ?? true;
    if (enabled) {
      AdhanService.scheduleAdhan(_prayerTimes);
    }
  }

  void _calculateNextPrayer(DateTime now) {
    final currentMinutes = now.hour * 60 + now.minute;

    for (final entry in _prayerTimes.entries) {
      if (entry.key == 'Sunrise') continue;
      final parts = entry.value.split(':');
      if (parts.length < 2) continue;
      final h = int.tryParse(parts[0]);
      final m = int.tryParse(parts[1]);
      if (h == null || m == null) continue;
      final prayerMinutes = h * 60 + m;
      if (prayerMinutes > currentMinutes) {
        _nextPrayer = entry.key;
        _timeUntilNext = Duration(minutes: prayerMinutes - currentMinutes);
        return;
      }
    }
    _nextPrayer = 'Fajr';
    _timeUntilNext = const Duration(hours: 24);
  }

  int _getDayOfYear(DateTime date) {
    return date.difference(DateTime(date.year, 1, 1)).inDays + 1;
  }

  String _formatTime(double time) {
    var hours = time.floor();
    var minutes = ((time - hours) * 60).round();
    if (minutes >= 60) { hours += 1; minutes -= 60; }
    if (hours >= 24) hours -= 24;
    if (hours < 0) hours += 24;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }
}
