import 'package:flutter/material.dart';
import 'dart:math';

class PrayerProvider extends ChangeNotifier {
  Map<String, String> _prayerTimes = {};
  String _nextPrayer = '';
  Duration _timeUntilNext = Duration.zero;
  double _latitude = 0;
  double _longitude = 0;
  String _locationName = '';

  Map<String, String> get prayerTimes => _prayerTimes;
  String get nextPrayer => _nextPrayer;
  Duration get timeUntilNext => _timeUntilNext;
  String get locationName => _locationName;

  void setLocation(double lat, double lng, String name) {
    _latitude = lat;
    _longitude = lng;
    _locationName = name;
    calculatePrayerTimes();
  }

  void calculatePrayerTimes() {
    final now = DateTime.now();
    final dayOfYear = _getDayOfYear(now);
    final timeZoneOffset = now.timeZoneOffset.inHours.toDouble();

    // Simplified prayer time calculation using astronomical formulas
    final declination = -23.45 * cos(2 * pi * (dayOfYear + 10) / 365);
    final declinationRad = declination * pi / 180;
    final latRad = _latitude * pi / 180;

    // Equation of time (simplified)
    final b = 2 * pi * (dayOfYear - 81) / 365;
    final eot = 9.87 * sin(2 * b) - 7.53 * cos(b) - 1.5 * sin(b);

    // Solar noon
    final solarNoon = 12.0 - _longitude / 15.0 + timeZoneOffset - eot / 60.0;

    // Hour angle for sunrise/sunset
    final cosHA = -tan(latRad) * tan(declinationRad);
    final ha = acos(cosHA.clamp(-1.0, 1.0)) * 180 / pi / 15;

    // Fajr (18 degrees below horizon)
    final cosFajr = (cos(108 * pi / 180) - sin(latRad) * sin(declinationRad)) /
        (cos(latRad) * cos(declinationRad));
    final fajrHA = acos(cosFajr.clamp(-1.0, 1.0)) * 180 / pi / 15;

    // Isha (17 degrees below horizon)
    final cosIsha = (cos(107 * pi / 180) - sin(latRad) * sin(declinationRad)) /
        (cos(latRad) * cos(declinationRad));
    final ishaHA = acos(cosIsha.clamp(-1.0, 1.0)) * 180 / pi / 15;

    // Asr (Hanafi: shadow = 2x object height)
    final asrAngle = atan(1 / (1 + tan((latRad - declinationRad).abs())));
    final cosAsr = (sin(asrAngle) - sin(latRad) * sin(declinationRad)) /
        (cos(latRad) * cos(declinationRad));
    final asrHA = acos(cosAsr.clamp(-1.0, 1.0)) * 180 / pi / 15;

    final fajr = solarNoon - fajrHA;
    final sunrise = solarNoon - ha;
    final dhuhr = solarNoon + 0.0167; // slight adjustment
    final asr = solarNoon + asrHA;
    final maghrib = solarNoon + ha;
    final isha = solarNoon + ishaHA;

    _prayerTimes = {
      'Fajr': _formatTime(fajr),
      'Sunrise': _formatTime(sunrise),
      'Dhuhr': _formatTime(dhuhr),
      'Asr': _formatTime(asr),
      'Maghrib': _formatTime(maghrib),
      'Isha': _formatTime(isha),
    };

    _calculateNextPrayer(now);
    notifyListeners();
  }

  void _calculateNextPrayer(DateTime now) {
    final currentMinutes = now.hour * 60 + now.minute;

    for (final entry in _prayerTimes.entries) {
      if (entry.key == 'Sunrise') continue;
      final parts = entry.value.split(':');
      final prayerMinutes = int.parse(parts[0]) * 60 + int.parse(parts[1]);
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
    final hours = time.floor();
    final minutes = ((time - hours) * 60).round();
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }
}
