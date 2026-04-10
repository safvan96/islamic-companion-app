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

    // Cancel existing daily hadith notification
    await _plugin.cancel(100);

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
        100,
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
    await _plugin.cancel(100);
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
    if (offset.inHours == 3) return 'Europe/Istanbul';
    if (offset.inHours == 2) return 'Europe/Berlin';
    if (offset.inHours == 1) return 'Europe/London';
    if (offset.inHours == 0) return 'UTC';
    if (offset.inMinutes == 330) return 'Asia/Kolkata';
    if (offset.inHours == 7) return 'Asia/Jakarta';
    if (offset.inHours == 8) return 'Asia/Shanghai';
    if (offset.inHours == 9) return 'Asia/Tokyo';
    if (offset.inHours == 4) return 'Asia/Dubai';
    return 'UTC';
  }
}
