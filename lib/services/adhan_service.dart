import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

  /// Schedule adhan notifications for today's prayer times.
  /// [prayerTimes] is a map like {'Fajr': '04:32', 'Dhuhr': '12:45', ...}
  static Future<void> scheduleAdhan(Map<String, String> prayerTimes) async {
    if (!_initialized) await init();

    // Cancel all existing adhan notifications
    await _notif.cancelAll();

    int id = 0;
    final now = tz.TZDateTime.now(tz.local);

    for (final entry in prayerTimes.entries) {
      if (entry.key == 'Sunrise') continue; // No adhan for sunrise

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

      // If time already passed today, skip
      if (scheduled.isBefore(now)) continue;

      try {
        await _notif.zonedSchedule(
          id++,
          'Adhan — ${entry.key}',
          'It is time for ${entry.key} prayer',
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
    // Common mappings
    if (offset.inHours == 3) return 'Europe/Istanbul';
    if (offset.inHours == 2) return 'Europe/Berlin';
    if (offset.inHours == 1) return 'Europe/London';
    if (offset.inHours == 0) return 'UTC';
    if (offset.inHours == 5 && offset.inMinutes == 330) return 'Asia/Kolkata';
    if (offset.inHours == 7) return 'Asia/Jakarta';
    if (offset.inHours == 8) return 'Asia/Shanghai';
    if (offset.inHours == 9) return 'Asia/Tokyo';
    return 'UTC';
  }
}
