import 'dart:developer';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_init;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Initialize timezone data (required for scheduled notifications)
    tz_init.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings(
          '@mipmap/launcher_icon',
        ); // Use your app icon

    const DarwinInitializationSettings iOSSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iOSSettings,
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        // Optional: handle tap on notification
        log('Notification tapped: ${details.payload}');
      },
    );

    // Request permissions on Android 13+ and iOS
    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    if (Platform.isIOS) {
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } else if (Platform.isAndroid) {
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestExactAlarmsPermission();

      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    }
  }

  Future<void> showApplicationSubmittedNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'new_case_channel_id',
          'New Case Applications',
          channelDescription: 'Notifications for new case submissions',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          playSound: true,
          enableVibration: true,
        );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await _notificationsPlugin.show(
      1001, // Notification ID
      'Application Submitted',
      'Your application has been sent successfully!',
      platformDetails,
      payload: 'new_case_submitted', // Optional payload
    );
  }

  Future<void> scheduleAppointmentReminders({
    required int appointmentId,
    required String title,
    required String body,
    required DateTime appointmentTime,
  }) async {
    final now = DateTime.now();

    final scheduleTimes = [
      appointmentTime.subtract(const Duration(minutes: 30)),
      appointmentTime.subtract(const Duration(minutes: 10)),
      appointmentTime,
    ];

    for (int i = 0; i < scheduleTimes.length; i++) {
      final scheduleTime = scheduleTimes[i];
      if (scheduleTime.isAfter(now)) {
        final reminderMinutes = i == 0 ? 30 : (i == 1 ? 10 : 0);
        final reminderText = reminderMinutes > 0
            ? "Reminder: Your appointment starts in $reminderMinutes minutes!"
            : "Your appointment is starting now! Tap to join.";

        final tz.TZDateTime tzScheduleTime = tz.TZDateTime.from(scheduleTime, tz.local);

        await _notificationsPlugin.zonedSchedule(
          appointmentId * 10 + i, // Unique notification ID
          title,
          reminderText,
          tzScheduleTime,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'appointment_reminders_channel',
              'Appointment Reminders',
              channelDescription: 'Scheduled reminders for upcoming video calls',
              importance: Importance.high,
              priority: Priority.high,
              playSound: true,
              enableVibration: true,
            ),
            iOS: DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          payload: 'appointment_call_$appointmentId',
        );
      }
    }
  }
}
