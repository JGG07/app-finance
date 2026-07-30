import 'package:app_finance/src/core/state/finance_state.dart';
import 'package:app_finance/src/features/cards/domain/credit_card_monthly_payment.dart';
import 'package:app_finance/src/features/notifications/domain/task_reminder.dart';
import 'package:app_finance/src/features/notifications/services/task_notification_scheduler.dart';
import 'package:app_finance/src/features/tasks/domain/financial_task.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/fake_task_notification_scheduler.dart';

void main() {
  late FakeTaskNotificationScheduler scheduler;
  late FinanceState state;

  setUp(() async {
    scheduler = FakeTaskNotificationScheduler();
    state = FinanceState(notificationScheduler: scheduler);
    await state.initialize();
  });

  tearDown(() => state.dispose());

  test('permission is requested only after explicit enable', () async {
    expect(scheduler.permissionRequestCalls, 0);
    expect(state.notificationPreferences.enabled, isFalse);
    expect(await state.enableTaskReminders(), isTrue);
    expect(scheduler.permissionRequestCalls, 1);
    expect(state.notificationPreferences.enabled, isTrue);
    expect(
      state.notificationPermissionStatus,
      NotificationPermissionStatus.granted,
    );
  });

  test('denied permission keeps reminders disabled', () async {
    scheduler.requestPermissionResult = false;
    expect(await state.enableTaskReminders(), isFalse);
    expect(state.notificationPreferences.enabled, isFalse);
    expect(scheduler.scheduled, isEmpty);
  });

  test('creates and edits reminder while preserving notification id', () async {
    await state.enableTaskReminders();
    final taskId = state.addManualFinancialTask(
      title: 'Pendiente',
      amount: 0,
      dueDate: DateTime.now().add(const Duration(days: 2)),
    )!;
    state.updateTaskReminder(taskId, enabled: true);
    await state.reconcileTaskReminders();
    final originalId = state.taskReminderFor(taskId)!.notificationId;
    expect(scheduler.scheduled, hasLength(1));

    state.updateTaskReminder(
      taskId,
      enabled: true,
      mode: TaskReminderMode.oneDayBefore,
      hour: 10,
    );
    await state.reconcileTaskReminders();
    expect(state.taskReminderFor(taskId)!.notificationId, originalId);
    expect(scheduler.scheduled.keys.single, originalId);
  });

  test('completed and skipped tasks cancel reminders', () async {
    await state.enableTaskReminders();
    final taskId = _addReminderTask(state);
    await state.reconcileTaskReminders();
    expect(scheduler.scheduled, isNotEmpty);
    state.updateFinancialTaskStatus(taskId, FinancialTaskStatus.done);
    await state.reconcileTaskReminders();
    expect(scheduler.scheduled, isEmpty);
    state.updateFinancialTaskStatus(taskId, FinancialTaskStatus.pending);
    await state.reconcileTaskReminders();
    expect(scheduler.scheduled, isNotEmpty);
    state.updateFinancialTaskStatus(taskId, FinancialTaskStatus.skipped);
    await state.reconcileTaskReminders();
    expect(scheduler.scheduled, isEmpty);
  });

  test('deleting manual task cancels and removes its reminder', () async {
    await state.enableTaskReminders();
    final taskId = _addReminderTask(state);
    await state.reconcileTaskReminders();
    final id = state.taskReminderFor(taskId)!.notificationId;
    state.deleteManualFinancialTask(taskId);
    await state.reconcileTaskReminders();
    expect(state.taskReminderFor(taskId), isNull);
    expect(scheduler.cancelled, contains(id));
    expect(scheduler.scheduled, isEmpty);
  });

  test('global disable cancels and re-enable schedules again', () async {
    await state.enableTaskReminders();
    _addReminderTask(state);
    await state.reconcileTaskReminders();
    expect(scheduler.scheduled, hasLength(1));
    await state.setTaskRemindersEnabled(false);
    expect(scheduler.scheduled, isEmpty);
    await state.enableTaskReminders();
    await state.reconcileTaskReminders();
    expect(scheduler.scheduled, hasLength(1));
  });

  test('task without due date is never scheduled', () async {
    await state.enableTaskReminders();
    final taskId = state.addManualFinancialTask(
      title: 'Sin fecha',
      amount: 0,
    )!;
    state.updateTaskReminder(taskId, enabled: true);
    await state.reconcileTaskReminders();
    expect(scheduler.scheduled, isEmpty);
  });

  test('repeated reconciliation remains duplicate-free', () async {
    await state.enableTaskReminders();
    _addReminderTask(state);
    await state.reconcileTaskReminders();
    await state.reconcileTaskReminders();
    expect(scheduler.scheduled, hasLength(1));
  });

  test('notification payload requests Plan task navigation once', () async {
    scheduler.tap('task-42');
    expect(state.pendingTaskNavigationId, 'task-42');
    scheduler.tap('task-42');
    expect(state.pendingTaskNavigationId, 'task-42');
    state.consumePendingTaskNavigation();
    expect(state.pendingTaskNavigationId, isNull);
  });

  test('pending card payment reminder can be created and identifies the card',
      () async {
    await state.enableTaskReminders();
    state.addCreditCard(
      name: 'Tarjeta dorada',
      creditLimit: 56200,
      usedBalance: 56093.41,
      statementCutDay: 19,
    );
    final cardId = state.creditCards.single.id;
    final taskId = state.cardPaymentTaskId(cardId);

    expect(
      await state.configureCardPaymentReminder(cardId, enabled: true),
      isTrue,
    );
    await state.reconcileTaskReminders();

    final reminder = state.taskReminderFor(taskId);
    expect(reminder, isNotNull);
    expect(scheduler.scheduled, hasLength(1));
    final scheduled = scheduler.scheduled[reminder!.notificationId]!;
    expect(scheduled.payload, 'task:$taskId');
    expect(scheduled.title, 'Agrega el pago de Tarjeta dorada');
    expect(scheduled.body, contains('Tarjeta dorada'));
  });

  test('capturing or confirming card payment cancels its pending reminder',
      () async {
    await state.enableTaskReminders();
    state.addCreditCard(
      name: 'Tarjeta dorada',
      creditLimit: 56200,
      usedBalance: 56093.41,
      statementCutDay: 19,
    );
    final cardId = state.creditCards.single.id;
    final taskId = state.cardPaymentTaskId(cardId);
    await state.configureCardPaymentReminder(cardId, enabled: true);
    await state.reconcileTaskReminders();

    final notificationId = state.taskReminderFor(taskId)!.notificationId;
    state.updateCardMonthlyPayment(
      cardId,
      10000,
      source: CreditCardPaymentSource.confirmed,
    );
    await state.reconcileTaskReminders();

    expect(state.taskReminderFor(taskId), isNull);
    expect(scheduler.cancelled, contains(notificationId));
    expect(scheduler.scheduled, isEmpty);
  });

  test('card payment notification payload requests card payment navigation',
      () async {
    state.addCreditCard(
      name: 'Tarjeta dorada',
      creditLimit: 56200,
      usedBalance: 56093.41,
      statementCutDay: 19,
    );
    final cardId = state.creditCards.single.id;

    scheduler.tap(state.cardPaymentTaskId(cardId));
    expect(state.pendingCardPaymentNavigationId, cardId);
    scheduler.tap(state.cardPaymentTaskId(cardId));
    expect(state.pendingCardPaymentNavigationId, cardId);
    state.consumePendingCardPaymentNavigation();
    expect(state.pendingCardPaymentNavigationId, isNull);
  });
}

String _addReminderTask(FinanceState state) {
  final taskId = state.addManualFinancialTask(
    title: 'Pagar pendiente',
    amount: 0,
    dueDate: DateTime.now().add(const Duration(days: 3)),
  )!;
  state.updateTaskReminder(taskId, enabled: true);
  return taskId;
}
