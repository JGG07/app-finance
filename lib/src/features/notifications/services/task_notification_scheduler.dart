enum NotificationPermissionStatus {
  notConfigured,
  granted,
  denied,
  blocked,
  unsupported,
}

abstract interface class TaskNotificationScheduler {
  bool get isSupported;

  Future<String?> initialize({void Function(String payload)? onPayload});

  Future<bool> areNotificationsEnabled();

  Future<bool> requestPermission();

  Future<void> showTestNotification();

  Future<void> scheduleTaskReminder({
    required int notificationId,
    required String title,
    required String body,
    required DateTime scheduledAt,
    required String payload,
  });

  Future<void> cancelTaskReminder(int notificationId);

  Future<List<int>> pendingTaskNotificationIds();

  Future<void> openSystemSettings();
}

class NoopTaskNotificationScheduler implements TaskNotificationScheduler {
  const NoopTaskNotificationScheduler();

  @override
  bool get isSupported => false;

  @override
  Future<String?> initialize({
    void Function(String payload)? onPayload,
  }) async =>
      null;

  @override
  Future<bool> areNotificationsEnabled() async => false;

  @override
  Future<bool> requestPermission() async => false;

  @override
  Future<void> showTestNotification() async {}

  @override
  Future<void> scheduleTaskReminder({
    required int notificationId,
    required String title,
    required String body,
    required DateTime scheduledAt,
    required String payload,
  }) async {}

  @override
  Future<void> cancelTaskReminder(int notificationId) async {}

  @override
  Future<List<int>> pendingTaskNotificationIds() async => const [];

  @override
  Future<void> openSystemSettings() async {}
}
