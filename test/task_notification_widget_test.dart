import 'package:app_finance/src/core/state/finance_state.dart';
import 'package:app_finance/src/core/state/finance_state_provider.dart';
import 'package:app_finance/src/features/plan/presentation/plan_screen.dart';
import 'package:app_finance/src/features/settings/presentation/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/fake_task_notification_scheduler.dart';
import 'helpers/test_app.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('settings shows notification controls without auto-request',
      (tester) async {
    final scheduler = FakeTaskNotificationScheduler();
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final state = FinanceState(notificationScheduler: scheduler);
    await state.initialize();
    await tester.pumpWidget(
      buildTestApp(
        child: FinanceStateProvider(
          notifier: state,
          child: const SettingsScreen(),
        ),
      ),
    );
    expect(find.text('Notificaciones y recordatorios'), findsOneWidget);
    expect(find.text('Estado del permiso: Sin configurar'), findsOneWidget);
    expect(scheduler.permissionRequestCalls, 0);
    await tester.tap(find.text('Recordatorios de tareas'));
    await tester.pumpAndSettle();
    expect(scheduler.permissionRequestCalls, 1);
    state.dispose();
  });

  testWidgets('discovery card appears and Ahora no persists dismissal',
      (tester) async {
    final state = FinanceState(
      notificationScheduler: FakeTaskNotificationScheduler(),
    );
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await state.initialize();
    state.addManualFinancialTask(title: 'Pendiente', amount: 0);
    await tester.pumpWidget(
      buildTestApp(
        child: FinanceStateProvider(
          notifier: state,
          child: const PlanScreen(),
        ),
      ),
    );
    expect(find.text('No olvides tus pendientes'), findsOneWidget);
    await tester.ensureVisible(find.text('Ahora no'));
    await tester.tap(find.text('Ahora no'));
    await tester.pump();
    expect(find.text('No olvides tus pendientes'), findsNothing);
    expect(state.notificationPreferences.discoveryCardDismissed, isTrue);
    state.dispose();
  });

  testWidgets('task form exposes due date and disables reminder without it',
      (tester) async {
    final state = FinanceState(
      notificationScheduler: FakeTaskNotificationScheduler(),
    );
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await state.initialize();
    await tester.pumpWidget(
      buildTestApp(
        child: FinanceStateProvider(
          notifier: state,
          child: const PlanScreen(),
        ),
      ),
    );
    await tester.ensureVisible(find.text('Agregar tarea'));
    await tester.tap(find.text('Agregar tarea'));
    await tester.pumpAndSettle();
    expect(find.text('Fecha límite'), findsOneWidget);
    expect(find.text('Sin fecha límite'), findsOneWidget);
    final reminderSwitch = tester.widget<SwitchListTile>(
      find.widgetWithText(SwitchListTile, 'Recordarme'),
    );
    expect(reminderSwitch.onChanged, isNull);
    state.dispose();
  });

  testWidgets('blocked permission shows system settings action',
      (tester) async {
    final scheduler = FakeTaskNotificationScheduler();
    final state = FinanceState(notificationScheduler: scheduler);
    await state.initialize();
    await state.enableTaskReminders();
    scheduler.permissionGranted = false;
    await state.refreshNotificationPermission(reconcile: false);
    state.addManualFinancialTask(title: 'Pendiente', amount: 0);
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      buildTestApp(
        child: FinanceStateProvider(
          notifier: state,
          child: const PlanScreen(),
        ),
      ),
    );
    expect(find.text('Las notificaciones están bloqueadas'), findsOneWidget);
    await tester.ensureVisible(find.text('Abrir ajustes'));
    await tester.tap(find.text('Abrir ajustes'));
    await tester.pump();
    expect(scheduler.openSettingsCalls, 1);
    state.dispose();
  });

  testWidgets('test notification button follows real permission state',
      (tester) async {
    final scheduler = FakeTaskNotificationScheduler();
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final state = FinanceState(notificationScheduler: scheduler);
    await state.initialize();
    await tester.pumpWidget(
      buildTestApp(
        child: FinanceStateProvider(
          notifier: state,
          child: const SettingsScreen(),
        ),
      ),
    );
    var button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Enviar notificación de prueba'),
    );
    expect(button.onPressed, isNull);
    await tester.tap(find.text('Recordatorios de tareas'));
    await tester.pumpAndSettle();
    button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Enviar notificación de prueba'),
    );
    expect(button.onPressed, isNotNull);
    state.dispose();
  });
}
