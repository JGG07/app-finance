import 'package:app_finance/src/app/app.dart';
import 'package:app_finance/src/core/domain/finance_period.dart';
import 'package:app_finance/src/core/state/finance_state.dart';
import 'package:app_finance/src/features/budgets/domain/budget_category.dart';
import 'package:app_finance/src/features/dashboard/domain/surplus_plan.dart';
import 'package:app_finance/src/features/plan/domain/financial_advice.dart';
import 'package:app_finance/src/features/transactions/domain/transaction_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final july = FinancePeriod(year: 2026, month: 7);

  test('advice recommends configuring a missing income', () {
    final state = FinanceState()..selectPeriod(july);

    final advice = FinancialAdviceGenerator.fromState(state);

    expect(
      advice.map((item) => item.title),
      contains('Configura tu ingreso'),
    );
  });

  test('advice warns when ant expenses exceed twenty percent', () {
    final state = FinanceState()
      ..selectPeriod(july)
      ..updateMonthlyIncome(1000)
      ..updateSurplusPlan(SurplusPlanType.none)
      ..addTransaction(
        title: 'Cafe',
        amount: 250,
        categoryTitle: BudgetCategory.antExpenseTitle,
        type: TransactionType.expense,
        date: DateTime(2026, 7, 10),
      );

    final advice = FinancialAdviceGenerator.fromState(state);

    expect(
      advice.map((item) => item.title),
      contains('Reduce tus gastos hormiga'),
    );
  });

  test('advice is positive when no alerts are active', () {
    final state = FinanceState()
      ..selectPeriod(july)
      ..updateMonthlyIncome(10000)
      ..updateSurplusPlan(SurplusPlanType.balanced);

    final advice = FinancialAdviceGenerator.fromState(state);

    expect(advice, hasLength(1));
    expect(advice.single.title, 'Tu plan esta bajo control');
    expect(advice.single.level, FinancialAdviceLevel.positive);
  });

  testWidgets('advice and add-task buttons open separate interfaces', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(900, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const AppFinance(enablePersistence: false));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Prefiero continuar sin plan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Plan').last);
    await tester.pumpAndSettle();

    final adviceButton = find.text('Ver consejos');
    await tester.ensureVisible(adviceButton);
    await tester.tap(adviceButton);
    await tester.pumpAndSettle();

    expect(find.text('Consejos para este periodo'), findsOneWidget);
    expect(find.text('Configura tu ingreso'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);

    await tester.tap(find.byTooltip('Cerrar consejos'));
    await tester.pumpAndSettle();

    final addTaskButton = find.text('Agregar tarea');
    await tester.ensureVisible(addTaskButton);
    await tester.tap(addTaskButton);
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Agregar tarea'), findsAtLeastNWidgets(1));
  });
}
