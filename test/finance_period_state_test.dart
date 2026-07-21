import 'package:app_finance/src/core/domain/finance_period.dart';
import 'package:app_finance/src/core/state/finance_state.dart';
import 'package:app_finance/src/features/dashboard/presentation/dashboard_screen.dart';
import 'package:app_finance/src/features/transactions/domain/transaction_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FinanceState state;
  final july = FinancePeriod(year: 2026, month: 7);
  final august = FinancePeriod(year: 2026, month: 8);

  setUp(() {
    state = FinanceState();
    state.selectPeriod(july);
  });

  test('totalSpent only sums expenses from the selected period', () {
    _addExpense(state, amount: 120, date: DateTime(2026, 7, 4));
    _addExpense(state, amount: 80, date: DateTime(2026, 8, 4));

    expect(state.totalSpent, 120);
  });

  test('additional income from another month is excluded', () {
    _addIncome(state, amount: 500, date: DateTime(2026, 7, 10));
    _addIncome(state, amount: 700, date: DateTime(2026, 8, 10));

    expect(state.additionalIncludedIncome, 500);
  });

  test('unplanned expenses are filtered by selected period', () {
    _addExpense(state, amount: 45, date: DateTime(2026, 7, 12));
    _addExpense(state, amount: 60, date: DateTime(2026, 8, 12));

    expect(state.unplannedRegisteredExpenses, 45);
  });

  test('changing selectedPeriod notifies and updates monthly results', () {
    _addExpense(state, amount: 100, date: DateTime(2026, 7, 15));
    _addExpense(state, amount: 250, date: DateTime(2026, 8, 15));
    var notifications = 0;
    state.addListener(() => notifications++);

    state.selectPeriod(august);

    expect(state.selectedPeriod, august);
    expect(state.totalSpent, 250);
    expect(notifications, 1);
  });

  test('dashboard label comes from selectedPeriod', () {
    state.selectPeriod(FinancePeriod(year: 2031, month: 2));

    final dashboard = DashboardOverview.fromState(state);

    expect(dashboard.monthLabel, 'Febrero 2031');
  });

  test('dashboard uses selected-period additional income consistently', () {
    state.updateMonthlyIncome(10000);
    state.addCategory('Comida', 6000, Colors.green);
    _addIncome(state, amount: 2000, date: DateTime(2026, 7, 10));
    _addIncome(state, amount: 3000, date: DateTime(2026, 8, 10));

    var dashboard = DashboardOverview.fromState(state);
    final budgetMetric = dashboard.metrics.singleWhere(
      (metric) => metric.title == 'Total presupuestado',
    );

    expect(dashboard.monthlyIncome, 12000);
    expect(budgetMetric.percent, 50);

    state.selectPeriod(august);
    dashboard = DashboardOverview.fromState(state);

    expect(dashboard.monthlyIncome, 13000);
  });

  test('historical transactions remain stored outside selected period', () {
    _addExpense(state, amount: 100, date: DateTime(2026, 7, 20));
    _addExpense(state, amount: 250, date: DateTime(2026, 8, 20));

    expect(state.transactions, hasLength(2));
    expect(state.transactionsForSelectedPeriod, hasLength(1));
    expect(
      () => state.transactionsForSelectedPeriod.add(state.transactions.first),
      throwsUnsupportedError,
    );
  });
}

void _addExpense(
  FinanceState state, {
  required double amount,
  required DateTime date,
}) {
  state.addTransaction(
    title: 'Gasto',
    amount: amount,
    categoryTitle: 'Sin presupuesto',
    type: TransactionType.expense,
    date: date,
  );
}

void _addIncome(
  FinanceState state, {
  required double amount,
  required DateTime date,
}) {
  state.addTransaction(
    title: 'Ingreso adicional',
    amount: amount,
    categoryTitle: 'Ingreso',
    type: TransactionType.income,
    date: date,
  );
}
