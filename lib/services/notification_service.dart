import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;
import '../models/hadith_model.dart';

class NotificationService {
  static final NotificationService instance = NotificationService._();
  NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(_guessTimeZone()));

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(initSettings);

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    _initialized = true;
    debugPrint('NotificationService initialized');
  }

  /// Schedule daily hadith notification at given hour:minute.
  /// Uses a deterministic hadith based on day of year.
  Future<void> scheduleDailyHadith({int hour = 8, int minute = 0}) async {
    if (!_initialized) await initialize();

    // Cancel existing daily hadith notification (ID 200)
    await _plugin.cancel(200);

    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString('locale') ?? 'en';

    final dayOfYear = DateTime.now()
        .difference(DateTime(DateTime.now().year, 1, 1))
        .inDays;
    final hadithIndex = dayOfYear % HadithModel.hadiths.length;
    final hadith = HadithModel.hadiths[hadithIndex];
    final translation =
        hadith.translations[langCode] ?? hadith.translations['en']!;

    // Truncate for notification body
    final body = translation.length > 100
        ? '${translation.substring(0, 100)}...'
        : translation;

    try {
      await _plugin.zonedSchedule(
        200, // Hadith ID=200, Adhan IDs=100-119
        '📖 ${hadith.source}',
        body,
        _nextInstanceOfTime(hour, minute),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_hadith',
            'Daily Hadith',
            channelDescription: 'Daily hadith reminder',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
          ),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      debugPrint('Scheduled daily hadith at $hour:$minute');
    } catch (e) {
      debugPrint('Failed to schedule daily hadith: $e');
    }
  }

  Future<void> cancelDailyHadith() async {
    await _plugin.cancel(200);
  }

  Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  static String _guessTimeZone() {
    final offset = DateTime.now().timeZoneOffset;
    final mins = offset.inMinutes;
    const offsetMap = {
      -300: 'America/New_York',
      -360: 'America/Chicago',
      -420: 'America/Denver',
      -480: 'America/Los_Angeles',
      -180: 'America/Sao_Paulo',
      0: 'UTC',
      60: 'Europe/London',
      120: 'Europe/Berlin',
      180: 'Europe/Istanbul',
      210: 'Asia/Tehran',
      240: 'Asia/Dubai',
      270: 'Asia/Kabul',
      300: 'Asia/Karachi',
      330: 'Asia/Kolkata',
      345: 'Asia/Kathmandu',
      360: 'Asia/Dhaka',
      420: 'Asia/Jakarta',
      480: 'Asia/Shanghai',
      540: 'Asia/Tokyo',
      570: 'Australia/Adelaide',
      600: 'Australia/Sydney',
      720: 'Pacific/Auckland',
    };
    return offsetMap[mins] ?? 'UTC';
  }
}
