import 'package:app_finance/src/features/notifications/domain/notification_preferences.dart';
import 'package:app_finance/src/features/notifications/domain/task_reminder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('notification preferences use safe defaults', () {
    const preferences = NotificationPreferences();
    expect(preferences.enabled, isFalse);
    expect(preferences.defaultReminderMode, TaskReminderMode.sameDay);
    expect(preferences.defaultHour, 9);
    expect(preferences.defaultMinute, 0);
    expect(preferences.discoveryCardDismissed, isFalse);
  });

  test('same-day reminder uses configured time', () {
    final value = calculateTaskReminderDate(
      dueDate: DateTime(2026, 7, 27),
      mode: TaskReminderMode.sameDay,
      hour: 9,
      minute: 15,
    );
    expect(value, DateTime(2026, 7, 27, 9, 15));
  });

  test('one day before crosses month boundary', () {
    final value = calculateTaskReminderDate(
      dueDate: DateTime(2026, 8),
      mode: TaskReminderMode.oneDayBefore,
      hour: 9,
      minute: 0,
    );
    expect(value, DateTime(2026, 7, 31, 9));
  });

  test('three days before crosses year boundary', () {
    final value = calculateTaskReminderDate(
      dueDate: DateTime(2027),
      mode: TaskReminderMode.threeDaysBefore,
      hour: 8,
      minute: 30,
    );
    expect(value, DateTime(2026, 12, 29, 8, 30));
  });

  test('custom reminder returns exact selected date', () {
    final custom = DateTime(2026, 7, 25, 18, 45);
    final value = calculateTaskReminderDate(
      dueDate: DateTime(2026, 7, 27),
      mode: TaskReminderMode.custom,
      hour: 9,
      minute: 0,
      customScheduledAt: custom,
    );
    expect(value, custom);
  });

  test('missing due date cannot calculate a standard reminder', () {
    expect(
      calculateTaskReminderDate(
        dueDate: null,
        mode: TaskReminderMode.sameDay,
        hour: 9,
        minute: 0,
      ),
      isNull,
    );
  });

  test('custom date must be future and no later than due date', () {
    final now = DateTime(2026, 7, 20, 10);
    final due = DateTime(2026, 7, 21);
    expect(
      isValidCustomReminderDate(
        scheduledAt: DateTime(2026, 7, 20, 11),
        dueDate: due,
        now: now,
      ),
      isTrue,
    );
    expect(
      isValidCustomReminderDate(
        scheduledAt: DateTime(2026, 7, 20, 9),
        dueDate: due,
        now: now,
      ),
      isFalse,
    );
    expect(
      isValidCustomReminderDate(
        scheduledAt: DateTime(2026, 7, 22),
        dueDate: due,
        now: now,
      ),
      isFalse,
    );
  });

  test('task reminder preserves its stable positive notification id', () {
    final now = DateTime(2026, 7, 20);
    final reminder = TaskReminder(
      taskId: 'task-1',
      notificationId: 1000,
      enabled: true,
      mode: TaskReminderMode.sameDay,
      hour: 9,
      minute: 0,
      createdAt: now,
      updatedAt: now,
    );
    expect(reminder.copyWith(hour: 10).notificationId, 1000);
  });
}
