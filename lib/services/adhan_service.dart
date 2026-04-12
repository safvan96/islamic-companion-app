import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;

class AdhanService {
  static final FlutterLocalNotificationsPlugin _notif =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  /// Initialize the notification plugin + timezone data.
  /// Call once at app startup.
  static Future<void> init() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(_guessTimeZone()));

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _notif.initialize(initSettings);

    // Request notification permission (Android 13+)
    await _notif
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    _initialized = true;
  }

  // Adhan notification IDs: 100-199 (reserved range, avoids colliding with hadith IDs)
  static const _adhanIdBase = 100;

  /// Schedule adhan notifications for today's remaining prayer times.
  /// [prayerTimes] is a map like {'Fajr': '04:32', 'Dhuhr': '12:45', ...}
  static Future<void> scheduleAdhan(Map<String, String> prayerTimes) async {
    if (!_initialized) await init();

    // Cancel only adhan notifications (100-199), not hadith or other notifications
    for (int i = _adhanIdBase; i < _adhanIdBase + 20; i++) {
      await _notif.cancel(i);
    }

    int id = _adhanIdBase;
    final now = tz.TZDateTime.now(tz.local);

    final prefs = await SharedPreferences.getInstance();

    // Schedule pre-Fajr wake-up alarm if enabled
    final preFajrMins = prefs.getInt('preFajrMinutes') ?? 0;
    if (preFajrMins > 0 && prayerTimes.containsKey('Fajr')) {
      final fajrParts = prayerTimes['Fajr']!.split(':');
      if (fajrParts.length == 2) {
        final fH = int.tryParse(fajrParts[0]);
        final fM = int.tryParse(fajrParts[1]);
        if (fH != null && fM != null) {
          var preFajr = tz.TZDateTime(tz.local, now.year, now.month, now.day, fH, fM)
              .subtract(Duration(minutes: preFajrMins));
          if (preFajr.isBefore(now)) preFajr = preFajr.add(const Duration(days: 1));
          try {
            await _notif.zonedSchedule(
              _adhanIdBase + 18, // Pre-Fajr ID
              'Tahajjud / Suhoor',
              '$preFajrMins min before Fajr',
              preFajr,
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'pre_fajr_channel',
                  'Pre-Fajr Wake Up',
                  channelDescription: 'Wake up before Fajr for Tahajjud or Suhoor',
                  importance: Importance.max,
                  priority: Priority.high,
                  enableVibration: true,
                  fullScreenIntent: true,
                ),
              ),
              uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
              androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            );
          } catch (e) {
            debugPrint('Failed to schedule pre-Fajr: $e');
          }
        }
      }
    }

    for (final entry in prayerTimes.entries) {
      if (entry.key == 'Sunrise') continue; // No adhan for sunrise

      // Check per-prayer toggle (default: enabled)
      final prayerEnabled = prefs.getBool('adhan_${entry.key}') ?? true;
      if (!prayerEnabled) continue;

      final parts = entry.value.split(':');
      if (parts.length != 2) continue;
      final hour = int.tryParse(parts[0]) ?? 0;
      final minute = int.tryParse(parts[1]) ?? 0;

      var scheduled = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      // If time already passed today, schedule for tomorrow
      if (scheduled.isBefore(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }

      try {
        await _notif.zonedSchedule(
          id++,
          '${entry.key} \u2022 \u0627\u0644\u0644\u0647 \u0623\u0643\u0628\u0631',
          '${entry.key} — ${entry.value}',
          scheduled,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'adhan_channel',
              'Adhan Notifications',
              channelDescription: 'Prayer time adhan alerts',
              importance: Importance.max,
              priority: Priority.high,
              sound: RawResourceAndroidNotificationSound('adhan'),
              playSound: true,
              enableVibration: true,
              fullScreenIntent: true,
            ),
          ),
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
        debugPrint('Scheduled adhan for ${entry.key} at ${entry.value}');
      } catch (e) {
        debugPrint('Failed to schedule ${entry.key}: $e');
      }
    }
  }

  static String _guessTimeZone() {
    final offset = DateTime.now().timeZoneOffset;
    final mins = offset.inMinutes;
    // Map UTC offset (minutes) → representative IANA timezone
    const offsetMap = {
      -300: 'America/New_York',     // UTC-5
      -360: 'America/Chicago',      // UTC-6
      -420: 'America/Denver',       // UTC-7
      -480: 'America/Los_Angeles',  // UTC-8
      -180: 'America/Sao_Paulo',    // UTC-3
      0: 'UTC',                     // UTC+0
      60: 'Europe/London',          // UTC+1
      120: 'Europe/Berlin',         // UTC+2
      180: 'Europe/Istanbul',       // UTC+3
      210: 'Asia/Tehran',           // UTC+3:30
      240: 'Asia/Dubai',            // UTC+4
      270: 'Asia/Kabul',            // UTC+4:30
      300: 'Asia/Karachi',          // UTC+5
      330: 'Asia/Kolkata',          // UTC+5:30
      345: 'Asia/Kathmandu',        // UTC+5:45
      360: 'Asia/Dhaka',            // UTC+6
      420: 'Asia/Jakarta',          // UTC+7
      480: 'Asia/Shanghai',         // UTC+8
      540: 'Asia/Tokyo',            // UTC+9
      570: 'Australia/Adelaide',    // UTC+9:30
      600: 'Australia/Sydney',      // UTC+10
      720: 'Pacific/Auckland',      // UTC+12
    };
    return offsetMap[mins] ?? 'UTC';
  }
}
