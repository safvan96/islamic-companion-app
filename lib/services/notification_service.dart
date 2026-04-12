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

  // Daily wisdom quotes for variety (days without hadith)
  static const _dailyWisdom = [
    ('Patience (Sabr)', 'Indeed, Allah is with the patient. — Quran 2:153'),
    ('Gratitude (Shukr)', 'If you are grateful, I will surely increase you. — Quran 14:7'),
    ('Trust (Tawakkul)', 'Whoever relies upon Allah, He is sufficient. — Quran 65:3'),
    ('Remembrance', 'In the remembrance of Allah do hearts find rest. — Quran 13:28'),
    ('Mercy', 'My mercy encompasses all things. — Quran 7:156'),
    ('Knowledge', 'Say: My Lord, increase me in knowledge. — Quran 20:114'),
    ('Prayer', 'Seek help through patience and prayer. — Quran 2:45'),
    ('Kindness', 'Speak to people good words. — Quran 2:83'),
    ('Forgiveness', 'Let them pardon and overlook. — Quran 24:22'),
    ('Hope', 'Do not despair of the mercy of Allah. — Quran 39:53'),
  ];

  /// Schedule daily wisdom notification at given hour:minute.
  /// Rotates between hadith (even days) and Quran wisdom (odd days).
  Future<void> scheduleDailyHadith({int hour = 8, int minute = 0}) async {
    if (!_initialized) await initialize();

    // Cancel existing daily notification (ID 200)
    await _plugin.cancel(200);

    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString('locale') ?? 'en';

    final dayOfYear = DateTime.now()
        .difference(DateTime(DateTime.now().year, 1, 1))
        .inDays;

    String title;
    String body;

    if (dayOfYear % 3 != 0) {
      // Hadith days (2 out of 3)
      final hadithIndex = dayOfYear % HadithModel.hadiths.length;
      final hadith = HadithModel.hadiths[hadithIndex];
      final translation =
          hadith.translations[langCode] ?? hadith.translations['en']!;
      title = '\u{1F4D6} ${hadith.source}';
      body = translation.length > 100 ? '${translation.substring(0, 100)}...' : translation;
    } else {
      // Quran wisdom day (1 out of 3)
      final wisdomIndex = dayOfYear % _dailyWisdom.length;
      final (wisdomTitle, wisdomBody) = _dailyWisdom[wisdomIndex];
      title = '\u2728 $wisdomTitle';
      body = wisdomBody;
    }

    try {
      await _plugin.zonedSchedule(
        200, // Hadith ID=200, Adhan IDs=100-119
        title,
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
