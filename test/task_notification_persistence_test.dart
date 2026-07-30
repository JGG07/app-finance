import 'dart:io';

import 'package:app_finance/src/core/database/app_database.dart';
import 'package:app_finance/src/core/database/repositories/finance_repository.dart';
import 'package:app_finance/src/core/state/finance_state.dart';
import 'package:app_finance/src/features/notifications/domain/task_reminder.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/fake_task_notification_scheduler.dart';

void main() {
  test('migrates schema 5 to 6 by adding card transaction columns', () async {
    final directory =
        await Directory.systemTemp.createTemp('notifications_v5_');
    final file = File('${directory.path}/migration.sqlite');
    AppDatabase? database;
    try {
      database = AppDatabase.forTesting(
        NativeDatabase(
          file,
          setup: (sqlite) {
            if (sqlite.userVersion != 0) return;
            sqlite.execute(
              'CREATE TABLE legacy_marker (id TEXT NOT NULL PRIMARY KEY)',
            );
            sqlite.execute("INSERT INTO legacy_marker VALUES ('kept')");
            sqlite.userVersion = 5;
          },
        ),
      );
      final tableInfo = await database
          .customSelect("PRAGMA table_info('transactions')")
          .get();
      final marker = await database
          .customSelect(
            'SELECT id FROM legacy_marker',
          )
          .getSingle();
      final columnNames =
          tableInfo.map((row) => row.read<String>('name')).toSet();
      expect(columnNames, contains('credit_card_id'));
      expect(columnNames, contains('card_transaction_kind'));
      expect(marker.read<String>('id'), 'kept');
      expect(database.schemaVersion, 6);
    } finally {
      await database?.close();
      await directory.delete(recursive: true);
    }
  });

  test('persists preferences and stable reminders across reopen', () async {
    final directory =
        await Directory.systemTemp.createTemp('notifications_reopen_');
    final file = File('${directory.path}/finance.sqlite');
    FinanceRepository? repository;
    try {
      final scheduler = FakeTaskNotificationScheduler();
      repository = FinanceRepository(
        AppDatabase.forTesting(NativeDatabase(file)),
      );
      final state = FinanceState(
        repository: repository,
        notificationScheduler: scheduler,
      );
      await state.initialize();
      await state.enableTaskReminders();
      state.updateDefaultTaskReminder(
        mode: TaskReminderMode.threeDaysBefore,
        hour: 8,
        minute: 30,
      );
      final taskId = state.addManualFinancialTask(
        title: 'Persistente',
        amount: 0,
        dueDate: DateTime.now().add(const Duration(days: 5)),
      )!;
      state.updateTaskReminder(taskId, enabled: true);
      await state.flushPendingSaves();
      final notificationId = state.taskReminderFor(taskId)!.notificationId;
      state.dispose();
      await repository.close();

      repository = FinanceRepository(
        AppDatabase.forTesting(NativeDatabase(file)),
      );
      final reopened = FinanceState(
        repository: repository,
        notificationScheduler: FakeTaskNotificationScheduler(),
      );
      await reopened.initialize();
      expect(reopened.notificationPreferences.enabled, isTrue);
      expect(reopened.notificationPreferences.defaultHour, 8);
      expect(reopened.notificationPreferences.defaultMinute, 30);
      expect(
        reopened.notificationPreferences.defaultReminderMode,
        TaskReminderMode.threeDaysBefore,
      );
      expect(reopened.taskReminderFor(taskId)!.notificationId, notificationId);

      reopened.updateMonthlyIncome(1000);
      await reopened.flushPendingSaves();
      expect(reopened.notificationPreferences.enabled, isTrue);
      expect(reopened.taskReminderFor(taskId), isNotNull);
      reopened.dispose();
    } finally {
      await repository?.close();
      await directory.delete(recursive: true);
    }
  });
}
