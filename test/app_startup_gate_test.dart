import 'dart:async';

import 'package:app_finance/src/app/app_startup_gate.dart';
import 'package:app_finance/src/core/database/finance_snapshot.dart';
import 'package:app_finance/src/core/database/repositories/finance_repository.dart';
import 'package:app_finance/src/core/database/seed/initial_finance_seed.dart';
import 'package:app_finance/src/core/state/finance_state.dart';
import 'package:app_finance/src/core/theme/app_theme.dart';
import 'package:app_finance/src/features/dashboard/domain/surplus_plan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('waits for an enqueued save before completing a flush', () async {
    final saveStarted = Completer<void>();
    final saveFinished = Completer<void>();
    FinanceSnapshot? savedSnapshot;
    final state = FinanceState(
      repository: _FakeFinanceStorage(
        () async => initialFinanceSeed(),
        onSave: (snapshot) {
          savedSnapshot = snapshot;
          saveStarted.complete();
          return saveFinished.future;
        },
      ),
    );

    state.updateMonthlyIncome(25000);
    final flush = state.flushPendingSaves();
    var flushCompleted = false;
    unawaited(flush.then((_) => flushCompleted = true));

    await saveStarted.future;
    expect(flushCompleted, isFalse);
    expect(savedSnapshot?.monthlyIncome, 25000);

    saveFinished.complete();
    await flush;

    expect(flushCompleted, isTrue);
  });

  testWidgets('blocks the app while persisted data is loading', (tester) async {
    final load = Completer<FinanceSnapshot>();
    final state = FinanceState(
      repository: _FakeFinanceStorage(() => load.future),
    );

    unawaited(state.initialize());
    await tester.pumpWidget(_TestApp(state: state));

    expect(find.text('Cargando tus finanzas'), findsOneWidget);
    expect(find.text('Contenido principal'), findsNothing);

    load.complete(
      initialFinanceSeed(planType: SurplusPlanType.none),
    );
    await tester.pumpAndSettle();

    expect(find.text('Cargando tus finanzas'), findsNothing);
    expect(find.text('Contenido principal'), findsOneWidget);
  });

  testWidgets('shows a load error and retries without exposing the app', (
    tester,
  ) async {
    final retry = Completer<FinanceSnapshot>();
    var attempts = 0;
    final state = FinanceState(
      repository: _FakeFinanceStorage(() {
        attempts++;
        if (attempts == 1) {
          return Future.error(StateError('database unavailable'));
        }
        return retry.future;
      }),
    );

    unawaited(state.initialize());
    await tester.pumpWidget(_TestApp(state: state));
    await tester.pumpAndSettle();

    expect(find.text('No pudimos cargar tus datos'), findsOneWidget);
    expect(find.textContaining('database unavailable'), findsOneWidget);
    expect(find.text('Contenido principal'), findsNothing);

    await tester.tap(find.text('Reintentar'));
    await tester.pump();

    expect(attempts, 2);
    expect(find.text('Cargando tus finanzas'), findsOneWidget);
    expect(find.text('Contenido principal'), findsNothing);

    retry.complete(
      initialFinanceSeed(planType: SurplusPlanType.none),
    );
    await tester.pumpAndSettle();

    expect(find.text('Contenido principal'), findsOneWidget);
  });

  testWidgets('shows a save error and retries the current snapshot', (
    tester,
  ) async {
    var saveAttempts = 0;
    final savedSnapshots = <FinanceSnapshot>[];
    final state = FinanceState(
      repository: _FakeFinanceStorage(
        () async => initialFinanceSeed(planType: SurplusPlanType.none),
        onSave: (snapshot) async {
          saveAttempts++;
          if (saveAttempts == 1) {
            throw StateError('disk unavailable');
          }
          savedSnapshots.add(snapshot);
        },
      ),
    );

    await state.initialize();
    await tester.pumpWidget(_TestApp(state: state));

    state.updateMonthlyIncome(25000);
    await state.flushPendingSaves();
    await tester.pump();

    expect(find.text('No pudimos guardar tus cambios'), findsOneWidget);
    expect(find.textContaining('disk unavailable'), findsOneWidget);
    expect(find.text('Contenido principal'), findsOneWidget);
    expect(state.saveError, isNotNull);

    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();

    expect(saveAttempts, 2);
    expect(savedSnapshots.single.monthlyIncome, 25000);
    expect(state.saveError, isNull);
    expect(find.text('No pudimos guardar tus cambios'), findsNothing);
    expect(find.text('Contenido principal'), findsOneWidget);
  });

  testWidgets('asks for a savings plan on first launch and saves the choice', (
    tester,
  ) async {
    final state = FinanceState();

    await tester.pumpWidget(_TestApp(state: state));

    expect(find.text('Como quieres organizar tu dinero?'), findsOneWidget);
    expect(find.text('Contenido principal'), findsNothing);

    await tester.tap(find.text('Prefiero continuar sin plan'));
    await tester.pumpAndSettle();

    expect(state.surplusPlan.type, SurplusPlanType.none);
    expect(find.text('Contenido principal'), findsOneWidget);
  });
}

class _TestApp extends StatelessWidget {
  const _TestApp({required this.state});

  final FinanceState state;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.dark,
      home: AppStartupGate(
        financeState: state,
        child: const Scaffold(
          body: Center(child: Text('Contenido principal')),
        ),
      ),
    );
  }
}

class _FakeFinanceStorage implements FinanceStorage {
  _FakeFinanceStorage(
    this._load, {
    this.onSave,
  });

  final Future<FinanceSnapshot> Function() _load;
  final Future<void> Function(FinanceSnapshot snapshot)? onSave;

  @override
  Future<FinanceSnapshot> loadSnapshot() => _load();

  @override
  Future<void> saveSnapshot(FinanceSnapshot snapshot) async {
    await onSave?.call(snapshot);
  }
}
