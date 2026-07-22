import 'package:app_settings/app_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'task_notification_scheduler.dart';

const taskReminderChannelId = 'task_reminders';
const taskReminderChannelName = 'Recordatorios de tareas';
const taskReminderChannelDescription =
    'Avisos sobre tareas financieras pendientes';

class LocalTaskNotificationScheduler implements TaskNotificationScheduler {
  LocalTaskNotificationScheduler({FlutterLocalNotificationsPlugin? plugin})
      : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;

  @override
  bool get isSupported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  @override
  Future<String?> initialize({void Function(String payload)? onPayload}) async {
    if (!isSupported) return null;
    if (!_initialized) {
      tz_data.initializeTimeZones();
      try {
        final deviceTimezone = await FlutterTimezone.getLocalTimezone();
        tz.setLocalLocation(tz.getLocation(deviceTimezone.identifier));
      } catch (error) {
        debugPrint('Unable to initialize the device timezone: $error');
        throw StateError('No se pudo configurar la zona horaria del equipo.');
      }

      await _plugin.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('ic_stat_app_finance'),
          iOS: DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
          ),
        ),
        onDidReceiveNotificationResponse: (response) {
          final payload = response.payload;
          if (payload != null && payload.isNotEmpty) onPayload?.call(payload);
        },
      );
      _initialized = true;
    }

    final launch = await _plugin.getNotificationAppLaunchDetails();
    if (launch?.didNotificationLaunchApp ?? false) {
      return launch?.notificationResponse?.payload;
    }
    return null;
  }

  @override
  Future<bool> areNotificationsEnabled() async {
    if (!isSupported) return false;
    if (defaultTargetPlatform == TargetPlatform.android) {
      return await _plugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.areNotificationsEnabled() ??
          false;
    }
    final settings = await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.checkPermissions();
    return settings?.isEnabled ?? false;
  }

  @override
  Future<bool> requestPermission() async {
    if (!isSupported) return false;
    if (defaultTargetPlatform == TargetPlatform.android) {
      return await _plugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.requestNotificationsPermission() ??
          false;
    }
    return await _plugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(alert: true, sound: true, badge: false) ??
        false;
  }

  @override
  Future<void> showTestNotification() {
    return _plugin.show(
      id: 1,
      title: 'App Finance',
      body: 'Los recordatorios de tus tareas están funcionando.',
      notificationDetails: _details,
    );
  }

  @override
  Future<void> scheduleTaskReminder({
    required int notificationId,
    required String title,
    required String body,
    required DateTime scheduledAt,
    required String payload,
  }) {
    return _plugin.zonedSchedule(
      id: notificationId,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(scheduledAt, tz.local),
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: payload,
    );
  }

  @override
  Future<void> cancelTaskReminder(int notificationId) {
    return _plugin.cancel(id: notificationId);
  }

  @override
  Future<List<int>> pendingTaskNotificationIds() async {
    final pending = await _plugin.pendingNotificationRequests();
    return pending.map((item) => item.id).toList(growable: false);
  }

  @override
  Future<void> openSystemSettings() {
    return AppSettings.openAppSettings(type: AppSettingsType.notification);
  }

  static const _details = NotificationDetails(
    android: AndroidNotificationDetails(
      taskReminderChannelId,
      taskReminderChannelName,
      channelDescription: taskReminderChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
      visibility: NotificationVisibility.private,
      icon: 'ic_stat_app_finance',
    ),
    iOS: DarwinNotificationDetails(presentBadge: false),
  );
}
