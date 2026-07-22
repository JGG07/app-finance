enum TaskReminderMode {
  sameDay,
  oneDayBefore,
  threeDaysBefore,
  custom,
}

class TaskReminder {
  const TaskReminder({
    required this.taskId,
    required this.notificationId,
    required this.enabled,
    required this.mode,
    required this.hour,
    required this.minute,
    required this.createdAt,
    required this.updatedAt,
    this.customScheduledAt,
  })  : assert(taskId != ''),
        assert(notificationId > 0),
        assert(hour >= 0 && hour <= 23),
        assert(minute >= 0 && minute <= 59),
        assert(
          mode == TaskReminderMode.custom || customScheduledAt == null,
          'customScheduledAt only applies to custom reminders.',
        );

  final String taskId;
  final int notificationId;
  final bool enabled;
  final TaskReminderMode mode;
  final int hour;
  final int minute;
  final DateTime? customScheduledAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  DateTime? scheduledAtFor(DateTime? dueDate) {
    return calculateTaskReminderDate(
      dueDate: dueDate,
      mode: mode,
      hour: hour,
      minute: minute,
      customScheduledAt: customScheduledAt,
    );
  }

  TaskReminder copyWith({
    bool? enabled,
    TaskReminderMode? mode,
    int? hour,
    int? minute,
    DateTime? customScheduledAt,
    DateTime? updatedAt,
    bool clearCustomScheduledAt = false,
  }) {
    final nextMode = mode ?? this.mode;
    return TaskReminder(
      taskId: taskId,
      notificationId: notificationId,
      enabled: enabled ?? this.enabled,
      mode: nextMode,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      customScheduledAt:
          nextMode != TaskReminderMode.custom || clearCustomScheduledAt
              ? null
              : customScheduledAt ?? this.customScheduledAt,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

DateTime? calculateTaskReminderDate({
  required DateTime? dueDate,
  required TaskReminderMode mode,
  required int hour,
  required int minute,
  DateTime? customScheduledAt,
}) {
  if (mode == TaskReminderMode.custom) return customScheduledAt;
  if (dueDate == null) return null;

  final daysBefore = switch (mode) {
    TaskReminderMode.sameDay => 0,
    TaskReminderMode.oneDayBefore => 1,
    TaskReminderMode.threeDaysBefore => 3,
    TaskReminderMode.custom => 0,
  };
  final localDueDate = DateTime(
    dueDate.year,
    dueDate.month,
    dueDate.day,
    hour,
    minute,
  );
  return localDueDate.subtract(Duration(days: daysBefore));
}

bool isValidCustomReminderDate({
  required DateTime scheduledAt,
  required DateTime dueDate,
  required DateTime now,
}) {
  final dueDateEnd = DateTime(
    dueDate.year,
    dueDate.month,
    dueDate.day,
    23,
    59,
    59,
    999,
  );
  return scheduledAt.isAfter(now) && !scheduledAt.isAfter(dueDateEnd);
}
