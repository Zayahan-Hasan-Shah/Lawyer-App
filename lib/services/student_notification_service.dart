import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class StudentNotificationService {
  static final StudentNotificationService _instance = StudentNotificationService._internal();
  factory StudentNotificationService() => _instance;
  StudentNotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap
    debugPrint('Notification tapped: ${response.payload}');
  }

  Future<void> showCertificationEnrollmentNotification(String certificationTitle) async {
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'student_certifications',
        'Certifications',
        channelDescription: 'Notifications for certification enrollments',
        importance: Importance.high,
        priority: Priority.high,
        color: Color(0xFF00D9FF),
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      'Certification Enrolled!',
      'You have successfully enrolled in $certificationTitle',
      notificationDetails,
      payload: 'certification_enrollment',
    );
  }

  Future<void> showInternshipApplicationNotification(String internshipTitle, String company) async {
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'student_internships',
        'Internships',
        channelDescription: 'Notifications for internship applications',
        importance: Importance.high,
        priority: Priority.high,
        color: Color(0xFF00D9FF),
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      'Internship Applied!',
      'Your application for $internshipTitle at $company has been submitted',
      notificationDetails,
      payload: 'internship_application',
    );
  }

  Future<void> showProgramEnrollmentNotification(String programTitle, bool isPaid) async {
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'student_programs',
        'Programs',
        channelDescription: 'Notifications for program enrollments',
        importance: Importance.high,
        priority: Priority.high,
        color: Color(0xFF00D9FF),
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      isPaid ? 'Program Enrolled!' : 'Program Started!',
      isPaid 
          ? 'You have successfully enrolled in $programTitle'
          : 'You have started learning $programTitle',
      notificationDetails,
      payload: 'program_enrollment',
    );
  }

  Future<void> showTaskReminderNotification(String taskTitle, String dueDate) async {
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'student_tasks',
        'Tasks',
        channelDescription: 'Notifications for task reminders',
        importance: Importance.max,
        priority: Priority.max,
        color: Color(0xFF00D9FF),
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      'Task Reminder',
      'Don\'t forget: $taskTitle is due on $dueDate',
      notificationDetails,
      payload: 'task_reminder',
    );
  }

  Future<void> showResearchJoinedNotification(String researchTitle, String supervisor) async {
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'student_research',
        'Research',
        channelDescription: 'Notifications for research activities',
        importance: Importance.high,
        priority: Priority.high,
        color: Color(0xFF00D9FF),
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      'Research Joined!',
      'You have joined "$researchTitle" under $supervisor',
      notificationDetails,
      payload: 'research_joined',
    );
  }

  Future<void> showTaskCompletedNotification(String taskTitle) async {
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'student_tasks',
        'Tasks',
        channelDescription: 'Notifications for task completions',
        importance: Importance.high,
        priority: Priority.high,
        color: Colors.green,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      'Task Completed!',
      'Congratulations! You completed "$taskTitle"',
      notificationDetails,
      payload: 'task_completed',
    );
  }

  Future<void> scheduleTaskReminder(String taskTitle, String dueDate, DateTime scheduledTime) async {
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'student_tasks',
        'Tasks',
        channelDescription: 'Notifications for task reminders',
        importance: Importance.max,
        priority: Priority.max,
        color: Color(0xFF00D9FF),
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _notifications.zonedSchedule(
      scheduledTime.millisecondsSinceEpoch.remainder(100000),
      'Task Reminder',
      'Don\'t forget: $taskTitle is due on $dueDate',
      tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      // uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'task_reminder_scheduled',
    );
  }

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}
