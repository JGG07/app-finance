import 'package:app_finance/src/core/domain/finance_period.dart';
import 'package:app_finance/src/core/state/finance_state.dart';
import 'package:app_finance/src/features/budgets/domain/budget_category.dart';
import 'package:app_finance/src/features/transactions/domain/transaction_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FinanceState state;
  late BudgetCategory food;
  final june = FinancePeriod(year: 2026, month: 6);
  final july = FinancePeriod(year: 2026, month: 7);

  setUp(() {
    state = FinanceState();
    state.selectPeriod(july);
    state.addCategory('Comida', 4000, Colors.green);
    food = _categoryNamed(state, 'Comida');
  });

  test('selected-period expense increases its category spending', () {
    _addMovement(
      state,
      category: ' comida ',
      amount: 1200,
      date: DateTime(2026, 7, 8),
      type: TransactionType.expense,
    );

    expect(state.spentForCategoryInSelectedPeriod(food), 1200);
  });

  test('expense from another period does not increase category spending', () {
    _addMovement(
      state,
      category: 'Comida',
      amount: 800,
      date: DateTime(2026, 6, 8),
      type: TransactionType.expense,
    );

    expect(state.spentForCategoryInSelectedPeriod(food), 0);
  });

  test('income with the category name is not budget spending', () {
    _addMovement(
      state,
      category: 'Comida',
      amount: 900,
      date: DateTime(2026, 7, 9),
      type: TransactionType.income,
    );

    expect(state.spentForCategoryInSelectedPeriod(food), 0);
    expect(state.totalBudgetSpentForSelectedPeriod, 0);
  });

  test('unbudgeted expense does not increase total budget spending', () {
    _addMovement(
      state,
      category: 'Cafeteria',
      amount: 150,
      date: DateTime(2026, 7, 10),
      type: TransactionType.expense,
    );

    expect(state.totalBudgetSpentForSelectedPeriod, 0);
  });

  test('available total is budgeted amount minus selected-period spending', () {
    state.addCategory('Psicologa', 2000, Colors.purple);
    _addMovement(
      state,
      category: 'Comida',
      amount: 1200,
      date: DateTime(2026, 7, 11),
      type: TransactionType.expense,
    );
    _addMovement(
      state,
      category: 'Psicologa',
      amount: 500,
      date: DateTime(2026, 7, 12),
      type: TransactionType.expense,
    );

    expect(state.totalBudgeted, 6000);
    expect(state.totalBudgetSpentForSelectedPeriod, 1700);
    expect(state.totalBudgetAvailableForSelectedPeriod, 4300);
  });

  test('category available amount can be negative when overspent', () {
    _addMovement(
      state,
      category: 'Comida',
      amount: 4500,
      date: DateTime(2026, 7, 13),
      type: TransactionType.expense,
    );

    expect(state.availableForCategoryInSelectedPeriod(food), -500);
    expect(state.totalBudgetAvailableForSelectedPeriod, -500);
  });

  test('changing period recalculates budget spending', () {
    _addMovement(
      state,
      category: 'Comida',
      amount: 1200,
      date: DateTime(2026, 7, 14),
      type: TransactionType.expense,
    );
    _addMovement(
      state,
      category: 'Comida',
      amount: 800,
      date: DateTime(2026, 6, 14),
      type: TransactionType.expense,
    );

    expect(state.totalBudgetSpentForSelectedPeriod, 1200);

    state.selectPeriod(june);

    expect(state.totalBudgetSpentForSelectedPeriod, 800);
  });

  test('categories expose selected-period spending and update by period', () {
    _addMovement(
      state,
      category: 'Comida',
      amount: 1200,
      date: DateTime(2026, 7, 14),
      type: TransactionType.expense,
    );
    _addMovement(
      state,
      category: 'Comida',
      amount: 800,
      date: DateTime(2026, 6, 14),
      type: TransactionType.expense,
    );

    expect(_categoryNamed(state, 'Comida').spent, 1200);

    state.selectPeriod(june);

    expect(_categoryNamed(state, 'Comida').spent, 800);
  });

  test('category without movements keeps its full limit available', () {
    expect(state.spentForCategoryInSelectedPeriod(food), 0);
    expect(state.availableForCategoryInSelectedPeriod(food), 4000);
  });

  test('historical budget movements remain stored', () {
    _addMovement(
      state,
      category: 'Comida',
      amount: 1200,
      date: DateTime(2026, 7, 15),
      type: TransactionType.expense,
    );
    _addMovement(
      state,
      category: 'Comida',
      amount: 800,
      date: DateTime(2026, 6, 15),
      type: TransactionType.expense,
    );

    expect(state.transactions, hasLength(2));
    expect(state.transactionsForSelectedPeriod, hasLength(1));
  });
}

BudgetCategory _categoryNamed(FinanceState state, String name) {
  return state.categories.singleWhere((category) => category.title == name);
}

void _addMovement(
  FinanceState state, {
  required String category,
  required double amount,
  required DateTime date,
  required TransactionType type,
}) {
  state.addTransaction(
    title: 'Movimiento',
    amount: amount,
    categoryTitle: category,
    type: type,
    date: date,
  );
}
