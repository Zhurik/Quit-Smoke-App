import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const CHANNEL_ID = 'quitsmoke';
const CHANNEL_NAME = 'Quitsmoke';
const CHANNEL_DESC = 'Reminders';

class NotificationManager {
  static const NotificationDetails _details = NotificationDetails(
    android: AndroidNotificationDetails(
      CHANNEL_ID,
      CHANNEL_NAME,
      channelDescription: CHANNEL_DESC,
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    ),
  );

  static Future<void> sendNotification({String? title, String? body}) async {
    await flutterLocalNotificationsPlugin.show(id: 0, title: title, body: body, notificationDetails: _details,);
  }

  static Future<void> scheduleNotification({String? title, String? body}) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: 0,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.now(tz.local).add(const Duration(seconds: 20)),
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: null,
    );
  }

  static Future<void> cancelAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  static Future<void> initializeLocalNotifiations() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(android: android, iOS: darwin, macOS: darwin);

    await flutterLocalNotificationsPlugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {},
      onDidReceiveBackgroundNotificationResponse: _onBackgroundNotification,
    );
  }
}

@pragma('vm:entry-point')
void _onBackgroundNotification(NotificationResponse response) {}
