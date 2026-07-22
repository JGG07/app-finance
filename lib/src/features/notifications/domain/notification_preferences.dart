import 'task_reminder.dart';

class NotificationPreferences {
  const NotificationPreferences({
    this.enabled = false,
    this.defaultReminderMode = TaskReminderMode.sameDay,
    this.defaultHour = 9,
    this.defaultMinute = 0,
    this.discoveryCardDismissed = false,
  })  : assert(defaultHour >= 0 && defaultHour <= 23),
        assert(defaultMinute >= 0 && defaultMinute <= 59);

  final bool enabled;
  final TaskReminderMode defaultReminderMode;
  final int defaultHour;
  final int defaultMinute;
  final bool discoveryCardDismissed;

  NotificationPreferences copyWith({
    bool? enabled,
    TaskReminderMode? defaultReminderMode,
    int? defaultHour,
    int? defaultMinute,
    bool? discoveryCardDismissed,
  }) {
    return NotificationPreferences(
      enabled: enabled ?? this.enabled,
      defaultReminderMode: defaultReminderMode ?? this.defaultReminderMode,
      defaultHour: defaultHour ?? this.defaultHour,
      defaultMinute: defaultMinute ?? this.defaultMinute,
      discoveryCardDismissed:
          discoveryCardDismissed ?? this.discoveryCardDismissed,
    );
  }
}
