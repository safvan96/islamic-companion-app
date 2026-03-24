import 'package:flutter/material.dart';

/// Notification service for prayer time reminders.
/// In production, integrate with flutter_local_notifications and
/// android_alarm_manager_plus for precise scheduling.
///
/// Usage:
/// ```dart
/// NotificationService.instance.schedulePrayerNotification(
///   prayerName: 'Fajr',
///   scheduledTime: DateTime(...),
/// );
/// ```
class NotificationService {
  static final NotificationService instance = NotificationService._();
  NotificationService._();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    // TODO: Initialize flutter_local_notifications plugin
    // final initSettings = InitializationSettings(
    //   android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    //   iOS: DarwinInitializationSettings(),
    // );
    // await flutterLocalNotificationsPlugin.initialize(initSettings);
    _initialized = true;
    debugPrint('NotificationService initialized');
  }

  Future<void> schedulePrayerNotification({
    required String prayerName,
    required DateTime scheduledTime,
  }) async {
    // TODO: Schedule notification at exact prayer time
    // await flutterLocalNotificationsPlugin.zonedSchedule(
    //   id,
    //   'Islamic Companion',
    //   'Time for $prayerName prayer',
    //   tz.TZDateTime.from(scheduledTime, tz.local),
    //   notificationDetails,
    //   androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    //   matchDateTimeComponents: DateTimeComponents.time,
    // );
    debugPrint('Scheduled notification for $prayerName at $scheduledTime');
  }

  Future<void> cancelAllNotifications() async {
    // await flutterLocalNotificationsPlugin.cancelAll();
    debugPrint('All notifications cancelled');
  }

  Future<void> scheduleAllPrayerNotifications(
      Map<String, String> prayerTimes) async {
    await cancelAllNotifications();

    final now = DateTime.now();
    for (final entry in prayerTimes.entries) {
      if (entry.key == 'Sunrise') continue; // Skip sunrise

      final parts = entry.value.split(':');
      if (parts.length != 2) continue;

      final hour = int.tryParse(parts[0]) ?? 0;
      final minute = int.tryParse(parts[1]) ?? 0;

      var scheduledTime = DateTime(
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      // If the time has already passed today, schedule for tomorrow
      if (scheduledTime.isBefore(now)) {
        scheduledTime = scheduledTime.add(const Duration(days: 1));
      }

      await schedulePrayerNotification(
        prayerName: entry.key,
        scheduledTime: scheduledTime,
      );
    }
  }
}
