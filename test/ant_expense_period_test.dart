import 'package:app_finance/src/core/domain/finance_period.dart';
import 'package:app_finance/src/core/state/finance_state.dart';
import 'package:app_finance/src/core/utils/currency_formatter.dart';
import 'package:app_finance/src/features/budgets/domain/budget_category.dart';
import 'package:app_finance/src/features/dashboard/domain/surplus_plan.dart';
import 'package:app_finance/src/features/dashboard/presentation/dashboard_screen.dart';
import 'package:app_finance/src/features/transactions/domain/transaction_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'helpers/test_app.dart';

void main() {
  final july = FinancePeriod(year: 2026, month: 7);
  final august = FinancePeriod(year: 2026, month: 8);
  late FinanceState state;

  setUp(() {
    state = FinanceState();
    state.selectPeriod(july);
    state.updateSurplusPlan(SurplusPlanType.none);
  });

  test('explicit selected-period ant category counts as an ant expense', () {
    _addMovement(
      state,
      BudgetCategory.antExpenseTitle,
      100,
      DateTime(2026, 7, 3),
    );

    expect(state.antExpensesForSelectedPeriod, 100);
    expect(state.unplannedRegisteredExpenses, 100);
  });

  test('Emergencia and Tanda are unbudgeted but not ant expenses', () {
    _addMovement(state, 'Emergencia', 300, DateTime(2026, 7, 3));
    _addMovement(state, 'Tanda', 500, DateTime(2026, 7, 3));

    expect(state.antExpensesForSelectedPeriod, 0);
    expect(state.unbudgetedExpensesForSelectedPeriod, 800);
    expect(state.unplannedRegisteredExpenses, 800);
  });

  test('budgeted expense does not count as an ant expense', () {
    state.addCategory('Comida', 4000, Colors.green);
    _addMovement(state, 'Comida', 500, DateTime(2026, 7, 4));

    expect(state.antExpensesForSelectedPeriod, 0);
  });

  test('income does not count as an ant expense', () {
    _addMovement(
      state,
      'Venta',
      500,
      DateTime(2026, 7, 5),
      type: TransactionType.income,
    );

    expect(state.antExpensesForSelectedPeriod, 0);
  });

  test('unbudgeted expense from another period is excluded', () {
    _addMovement(
      state,
      BudgetCategory.antExpenseTitle,
      100,
      DateTime(2026, 8, 6),
    );

    expect(state.antExpensesForSelectedPeriod, 0);
  });

  test('changing period recalculates ant expenses', () {
    _addMovement(
      state,
      BudgetCategory.antExpenseTitle,
      100,
      DateTime(2026, 7, 7),
    );
    _addMovement(
      state,
      BudgetCategory.antExpenseTitle,
      250,
      DateTime(2026, 8, 7),
    );

    expect(state.antExpensesForSelectedPeriod, 100);

    state.selectPeriod(august);

    expect(state.antExpensesForSelectedPeriod, 250);
  });

  test('percentage uses free money before ant expenses', () {
    state.updateMonthlyIncome(10000);
    state.addCategory('Comida', 4000, Colors.green);
    _addMovement(
      state,
      BudgetCategory.antExpenseTitle,
      750,
      DateTime(2026, 7, 8),
    );

    expect(state.freeMoneyBeforeAntExpenses, 6000);
    expect(state.antExpensesPercentOfFreeMoney, 12.5);
    expect(state.freeMoneyAfterAntExpenses, 5250);
  });

  test('percentage can exceed one hundred percent', () {
    state.updateMonthlyIncome(100);
    _addMovement(
      state,
      BudgetCategory.antExpenseTitle,
      150,
      DateTime(2026, 7, 9),
    );

    expect(state.antExpensesPercentOfFreeMoney, 150);
  });

  test('percentage is safe when free money is zero', () {
    _addMovement(
      state,
      BudgetCategory.antExpenseTitle,
      100,
      DateTime(2026, 7, 10),
    );

    expect(state.freeMoneyBeforeAntExpenses, 0);
    expect(state.antExpensesPercentOfFreeMoney, 0);
  });

  test('free money after ant expenses can be negative', () {
    state.updateMonthlyIncome(100);
    _addMovement(
      state,
      BudgetCategory.antExpenseTitle,
      150,
      DateTime(2026, 7, 11),
    );

    expect(state.freeMoneyAfterAntExpenses, -50);
  });

  test('ant expenses are deducted exactly once', () {
    state.updateMonthlyIncome(10000);
    state.addCategory('Comida', 4000, Colors.green);
    _addMovement(
      state,
      BudgetCategory.antExpenseTitle,
      1000,
      DateTime(2026, 7, 12),
    );

    expect(state.surplusPlanAllocation.freeUse, 6000);
    expect(state.freeMoneyBeforeAntExpenses, 6000);
    expect(state.freeMoneyAfterAntExpenses, 5000);
    expect(state.realEstimatedSurplus, 5000);
  });

  test('real surplus deducts every unbudgeted expense exactly once', () {
    state.updateMonthlyIncome(10000);
    state.addCategory('Comida', 4000, Colors.green);
    _addMovement(state, 'Emergencia', 1000, DateTime(2026, 7, 12));

    expect(state.antExpensesForSelectedPeriod, 0);
    expect(state.unbudgetedExpensesForSelectedPeriod, 1000);
    expect(state.realEstimatedSurplus, 5000);
  });

  test('dashboard exposes monthly ant amount, percentage and zero state', () {
    state.updateMonthlyIncome(10000);
    state.addCategory('Comida', 4000, Colors.green);
    _addMovement(
      state,
      BudgetCategory.antExpenseTitle,
      750,
      DateTime(2026, 7, 13),
    );

    var dashboard = DashboardOverview.fromState(state);
    expect(dashboard.antExpenseAmount, 750);
    expect(dashboard.antExpensePercent, 12.5);
    expect(dashboard.realAvailableToSpend, 5250);

    state.selectPeriod(august);
    dashboard = DashboardOverview.fromState(state);
    expect(dashboard.antExpenseAmount, 0);
    expect(dashboard.antExpensePercent, 0);
  });

  testWidgets('ant expense block appears below free money with formatted data',
      (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      buildTestApp(
        child: SingleChildScrollView(
          child: IncomeHeroCard(
            amount: 10000,
            availableAmount: 5150,
            antExpenseAmount: 850,
            antExpensePercent: 12.5,
            monthLabel: 'Julio 2026',
            breakdown: const [],
            onEdit: () {},
            onBreakdownTap: (_) {},
          ),
        ),
      ),
    );

    final freeLabel = find.text('Te queda libre este mes');
    final amountLabel = find.text(
      'En gastos hormiga has gastado ${CurrencyFormatter.format(850)}',
    );
    final percentLabel = find.text(
      'Representa el 12.5% de tu dinero libre',
    );

    expect(amountLabel, findsOneWidget);
    expect(percentLabel, findsOneWidget);
    expect(
      tester.getTopLeft(amountLabel).dy,
      greaterThan(tester.getTopLeft(freeLabel).dy),
    );
  });
}

void _addMovement(
  FinanceState state,
  String category,
  double amount,
  DateTime date, {
  TransactionType type = TransactionType.expense,
}) {
  state.addTransaction(
    title: 'Movimiento',
    amount: amount,
    categoryTitle: category,
    type: type,
    date: date,
  );
}
