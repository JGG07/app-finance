import 'package:app_finance/src/features/notifications/services/task_notification_scheduler.dart';

class ScheduledTaskNotification {
  const ScheduledTaskNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduledAt,
    required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final DateTime scheduledAt;
  final String payload;
}

class FakeTaskNotificationScheduler implements TaskNotificationScheduler {
  bool permissionGranted = false;
  bool requestPermissionResult = true;
  String? launchPayload;
  int initializeCalls = 0;
  int permissionRequestCalls = 0;
  int testNotificationCalls = 0;
  int openSettingsCalls = 0;
  final Map<int, ScheduledTaskNotification> scheduled = {};
  final List<int> cancelled = [];
  void Function(String payload)? onPayload;

  @override
  bool get isSupported => true;

  @override
  Future<String?> initialize({void Function(String payload)? onPayload}) async {
    initializeCalls++;
    this.onPayload = onPayload;
    return launchPayload;
  }

  @override
  Future<bool> areNotificationsEnabled() async => permissionGranted;

  @override
  Future<bool> requestPermission() async {
    permissionRequestCalls++;
    permissionGranted = requestPermissionResult;
    return requestPermissionResult;
  }

  @override
  Future<void> showTestNotification() async {
    testNotificationCalls++;
  }

  @override
  Future<void> scheduleTaskReminder({
    required int notificationId,
    required String title,
    required String body,
    required DateTime scheduledAt,
    required String payload,
  }) async {
    scheduled[notificationId] = ScheduledTaskNotification(
      id: notificationId,
      title: title,
      body: body,
      scheduledAt: scheduledAt,
      payload: payload,
    );
  }

  @override
  Future<void> cancelTaskReminder(int notificationId) async {
    cancelled.add(notificationId);
    scheduled.remove(notificationId);
  }

  @override
  Future<List<int>> pendingTaskNotificationIds() async =>
      scheduled.keys.toList();

  @override
  Future<void> openSystemSettings() async {
    openSettingsCalls++;
  }

  void tap(String taskId) => onPayload?.call('task:$taskId');
}
