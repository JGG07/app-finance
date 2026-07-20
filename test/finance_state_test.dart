import 'package:app_finance/src/core/domain/finance_period.dart';
import 'package:app_finance/src/core/state/finance_state.dart';
import 'package:app_finance/src/core/utils/currency_converter.dart';
import 'package:app_finance/src/features/budgets/domain/monthly_extra.dart';
import 'package:app_finance/src/features/budgets/domain/budget_category.dart';
import 'package:app_finance/src/features/dashboard/domain/surplus_plan.dart';
import 'package:app_finance/src/features/dashboard/presentation/dashboard_screen.dart';
import 'package:app_finance/src/features/transactions/domain/transaction_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('starts without personal finance data', () {
    final state = FinanceState();

    expect(state.monthlyIncome, 0);
    expect(state.categories, hasLength(1));
    expect(state.categories.single.title, BudgetCategory.antExpenseTitle);
    expect(state.categories.single.isProtected, isTrue);
    expect(state.transactions, isEmpty);
    expect(state.creditCards, isEmpty);
    expect(state.monthlyExtras, isEmpty);
    expect(state.monthlyFinancialTasks, isEmpty);
    expect(state.surplusPlan.type, SurplusPlanType.unconfigured);
  });

  test('dashboard summary starts with every amount at zero', () {
    final dashboard = DashboardOverview.fromState(FinanceState());

    expect(dashboard.monthlyIncome, 0);
    expect(dashboard.realAvailableToSpend, 0);
    expect(dashboard.antExpenseAmount, 0);
    expect(dashboard.antExpensePercent, 0);
    expect(
      dashboard.incomeBreakdown.map((item) => item.amount),
      everyElement(0),
    );
    expect(
      dashboard.distribution.map((slice) => slice.amount),
      everyElement(0),
    );
    final state = FinanceState();
    expect(state.totalBudgeted, 0);
    expect(state.totalBudgetUtilized, 0);
    expect(state.totalFree, 0);
    expect(state.antExpenseSpent, 0);
    expect(state.totalExpenses, 0);
    expect(state.budgetUtilizationPercent, 0);
    expect(state.debtPaymentPercentOfIncome, 0);
    expect(state.savingPercentOfSurplus, 0);
  });

  test('calculates available income from user data', () {
    final state = FinanceState();

    state.updateMonthlyIncome(25000);
    state.addCategory('Comida', 5000, Colors.green);
    state.addCategory('Transporte', 2800, Colors.red);

    expect(state.availableIncome, 17200);
  });

  test('separates budgeted expenses, ant expenses, free money and totals', () {
    final state = FinanceState();
    state.selectPeriod(FinancePeriod(year: 2026, month: 7));
    state.updateMonthlyIncome(10000);
    state.addCategory('Psicologa', 2000, Colors.purple);

    expect(state.totalBudgeted, 2000);
    expect(state.totalBudgetUtilized, 0);
    expect(state.totalFree, 8000);
    expect(state.antExpenseSpent, 0);
    expect(state.totalExpenses, 0);

    state.addTransaction(
      title: 'Consulta',
      amount: 500,
      categoryTitle: 'Psicologa',
      type: TransactionType.expense,
      date: DateTime(2026, 7, 20),
    );
    expect(state.totalBudgetUtilized, 500);

    state.addTransaction(
      title: 'Cafe',
      amount: 100,
      categoryTitle: BudgetCategory.antExpenseTitle,
      type: TransactionType.expense,
      date: DateTime(2026, 7, 20),
    );

    expect(state.totalBudgeted, 2000);
    expect(state.totalBudgetUtilized, 500);
    expect(state.totalFree, 7900);
    expect(state.antExpenseSpent, 100);
    expect(state.totalExpenses, 600);
    expect(
      state.totalExpenses,
      state.totalBudgetUtilized + state.antExpenseSpent,
    );
    expect(state.antExpensePercentOfFree, 1.25);
  });

  test('treats legacy unmatched expenses as ant expenses, never income', () {
    final state = FinanceState();
    state.selectPeriod(FinancePeriod(year: 2026, month: 7));
    state.updateMonthlyIncome(10000);
    state.addCategory('Internet', 500, Colors.blue);

    state.addTransaction(
      title: 'Compra antigua',
      amount: 125,
      categoryTitle: 'Categoria eliminada',
      type: TransactionType.expense,
      date: DateTime(2026, 7, 20),
    );
    state.addTransaction(
      title: 'Venta',
      amount: 300,
      categoryTitle: 'Sin categoria',
      type: TransactionType.income,
      date: DateTime(2026, 7, 20),
    );

    expect(state.totalBudgetUtilized, 0);
    expect(state.antExpenseSpent, 125);
    expect(state.totalExpenses, 125);
  });

  test('returns zero ant percentage when free money is zero', () {
    final state = FinanceState();
    state.selectPeriod(FinancePeriod(year: 2026, month: 7));
    state.addTransaction(
      title: 'Cafe',
      amount: 100,
      categoryTitle: BudgetCategory.antExpenseTitle,
      type: TransactionType.expense,
      date: DateTime(2026, 7, 20),
    );

    expect(state.totalFree, -100);
    expect(state.antExpenseSpent, 100);
    expect(state.antExpensePercentOfFree, 0);
  });

  test('keeps the ant expense category protected', () {
    final state = FinanceState();

    state.updateCategory(
      BudgetCategory.antExpenseId,
      title: 'Otro nombre',
      limit: 999,
      color: Colors.black,
    );
    state.deleteCategory(BudgetCategory.antExpenseId);

    expect(state.categories.single.title, BudgetCategory.antExpenseTitle);
    expect(state.categories.single.limit, 0);
  });

  test('dashboard includes ant expenses and total free money', () {
    final state = FinanceState();
    state.selectPeriod(FinancePeriod(year: 2026, month: 7));
    state.updateMonthlyIncome(10000);
    state.addCategory('Psicologa', 2000, Colors.purple);
    state.addTransaction(
      title: 'Snack',
      amount: 100,
      categoryTitle: BudgetCategory.antExpenseTitle,
      type: TransactionType.expense,
      date: DateTime(2026, 7, 20),
    );

    final dashboard = DashboardOverview.fromState(state);
    final antMetric = dashboard.metrics.singleWhere(
      (metric) => metric.title == BudgetCategory.antExpenseTitle,
    );

    expect(antMetric.amount, 100);
    expect(dashboard.realAvailableToSpend, 7900);
    expect(dashboard.antExpenseAmount, 100);
    expect(dashboard.antExpensePercent, 1.25);
  });

  test('adds the first credit card from user data', () {
    final state = FinanceState();

    state.addCreditCard(
      name: 'Tarjeta principal',
      creditLimit: 25000,
      usedBalance: 1500,
      statementCutDay: 12,
    );

    expect(state.creditCards, hasLength(1));
    expect(state.creditCards.single.name, 'Tarjeta principal');
    expect(state.creditCards.single.creditLimit, 25000);
    expect(state.creditCards.single.usedBalance, 1500);
    expect(state.creditCards.single.statementCutDay, 12);
  });

  test('calculates monthly plan from fixed budget and card payments', () {
    final state = FinanceState();
    state.updateMonthlyIncome(40000);
    state.addCategory('Comida', 5000, Colors.green);
    state.addCategory('Transporte', 2800, Colors.red);
    state.addMonthlyExtra(
      name: 'Apartado',
      amount: 3800,
      status: MonthlyExtraStatus.reserved,
      includedInPlan: true,
    );
    state.addCreditCard(
      name: 'Tarjeta principal',
      creditLimit: 20000,
      usedBalance: 5000,
      statementCutDay: 10,
    );

    expect(state.totalAllocated, 7800);
    expect(state.totalMonthlyExtras, 3800);
    expect(state.totalMonthlyCardPayments, 5000);
    expect(state.totalPlannedExpenses, 16600);
    expect(state.availableAfterMonthlyPlan, 23400);
    expect(state.totalFree, 23400);

    state.updateSurplusPlan(SurplusPlanType.balanced);

    expect(state.surplusPlanAllocation.safetyNet, 9360);
    expect(state.surplusPlanAllocation.investment, 9360);
    expect(state.surplusPlanAllocation.freeUse, 4680);
    expect(state.totalFree, 4680);
  });

  test('manual card payment overrides confirmed and estimated amounts', () {
    final state = FinanceState();
    state.addCreditCard(
      name: 'Tarjeta principal',
      creditLimit: 20000,
      usedBalance: 5000,
      statementCutDay: 10,
    );
    final cardId = state.creditCards.single.id;

    expect(state.cardMonthlyPaymentAmount(cardId), 5000);

    state.updateCardMonthlyPayment(cardId, 3000);

    expect(state.cardMonthlyPaymentAmount(cardId), 3000);
    expect(state.totalMonthlyCardPayments, 3000);
  });

  test('monthly extras are included in plan without affecting categories', () {
    final state = FinanceState();

    state.addMonthlyExtra(
      name: 'Regalo',
      amount: 500,
      status: MonthlyExtraStatus.reserved,
      includedInPlan: true,
    );

    expect(state.totalAllocated, 0);
    expect(state.totalMonthlyExtras, 500);
    expect(state.totalPlannedExpenses, 500);
  });

  test('calculates real estimated surplus and balanced distribution', () {
    final state = FinanceState();

    state.updateMonthlyIncome(40000);
    state.updateSurplusPlan(SurplusPlanType.balanced);

    expect(state.realEstimatedSurplus, 40000);
    expect(state.surplusPlan.type, SurplusPlanType.balanced);
    expect(state.surplusPlanAllocation.safetyNet, 16000);
    expect(state.surplusPlanAllocation.investment, 16000);
    expect(state.surplusPlanAllocation.freeUse, 8000);
  });

  test('manual surplus plan amounts override automatic distribution', () {
    final state = FinanceState();

    state.updateMonthlyIncome(40000);
    state.updateSurplusPlan(SurplusPlanType.investment);
    state.updateSurplusPlanAmounts(
      safetyNet: 3000,
      investment: 7000,
      freeUse: 1000,
    );

    expect(state.surplusPlan.type, SurplusPlanType.custom);
    expect(state.surplusPlanAllocation.safetyNet, 3000);
    expect(state.surplusPlanAllocation.investment, 7000);
    expect(state.surplusPlanAllocation.freeUse, 1000);
  });

  test('converts monthly salary from USD to MXN', () {
    expect(CurrencyConverter.usdToMxn(1000), closeTo(17305.918, 0.001));
  });

  test('tracks credit card payments and installment purchases', () {
    final state = FinanceState();
    state.addCreditCard(
      name: 'Tarjeta principal',
      creditLimit: 25000,
      usedBalance: 5000,
      statementCutDay: 10,
    );
    final card = state.creditCards.first;
    final initialBalance = card.usedBalance;

    state.addCreditCardPayment(card.id, 1000);

    expect(
      state.creditCards.first.usedBalance,
      closeTo(initialBalance - 1000, 0.001),
    );

    state.addCreditCardPurchase(
      cardId: card.id,
      title: 'Amazon',
      amount: 5235,
      installments: 15,
      date: DateTime(2026, 5, 26),
    );

    expect(
      state.creditCards.first.usedBalance,
      closeTo(initialBalance - 1000 + 5235, 0.001),
    );
    expect(state.creditCardPurchases.first.monthlyPayment, closeTo(349, 0.001));
    expect(
      state.creditCardPurchases.first.remainingInstallmentsAsOf(
        DateTime(2026, 5, 26),
        statementCutDay: 10,
      ),
      15,
    );
    expect(
      state.creditCardPurchases.first.paidInstallmentsAsOf(
        DateTime(2026, 8, 26),
        statementCutDay: 10,
      ),
      3,
    );
  });

  test('uses card statement cut day to count paid installments', () {
    final state = FinanceState();
    state.addCreditCard(
      name: 'Tarjeta principal',
      creditLimit: 25000,
      usedBalance: 0,
      statementCutDay: 19,
    );
    final cardId = state.creditCards.single.id;

    state.addCreditCardPurchase(
      cardId: cardId,
      title: 'Amazon',
      amount: 7200,
      installments: 12,
      date: DateTime(2026, 2, 15),
    );

    final purchase = state.creditCardPurchases.first;

    expect(
      purchase.paidInstallmentsAsOf(
        DateTime(2026, 2, 19),
        statementCutDay: 19,
      ),
      0,
    );
    expect(
      purchase.paidInstallmentsAsOf(
        DateTime(2026, 2, 20),
        statementCutDay: 19,
      ),
      1,
    );
    expect(
      purchase.remainingInstallmentsAsOf(
        DateTime(2026, 5, 20),
        statementCutDay: 19,
      ),
      8,
    );
  });

  test('validates installment purchases and separates completed purchases', () {
    final state = FinanceState();
    state.addCreditCard(
      name: 'Tarjeta principal',
      creditLimit: 25000,
      usedBalance: 0,
      statementCutDay: 10,
    );
    final card = state.creditCards.first;
    final initialPurchaseCount = state.creditCardPurchases.length;
    final initialCardPayment = state.cardMonthlyPaymentAmount(card.id);

    state.addCreditCardPurchase(
      cardId: card.id,
      title: 'Amazon',
      amount: 8000,
      installments: 12,
      paidInstallments: 7,
      date: DateTime(2026, 5, 26),
    );

    final purchase = state.creditCardPurchases.first;

    expect(purchase.monthlyPayment, closeTo(666.666, 0.001));
    expect(purchase.remainingInstallments, 5);
    expect(purchase.remainingAmount, closeTo(3333.333, 0.001));
    expect(purchase.status, 'active');
    expect(state.activeInstallmentPurchaseCount, 1);
    expect(
      state.cardMonthlyPaymentAmount(card.id),
      closeTo(initialCardPayment + purchase.monthlyPayment, 0.001),
    );

    state.addCreditCardPurchase(
      cardId: card.id,
      title: 'No valida',
      amount: 1000,
      installments: 6,
      paidInstallments: 7,
      date: DateTime(2026, 5, 26),
    );

    expect(state.creditCardPurchases.length, initialPurchaseCount + 1);

    state.updateCreditCardPurchase(
      purchase.id,
      paidInstallments: 12,
    );

    expect(state.creditCardPurchases.first.status, 'completed');
    expect(state.activeInstallmentPurchaseCount, 0);
  });

  test('adding and deleting expense updates category spent amount', () {
    final state = FinanceState();
    state.selectPeriod(FinancePeriod(year: 2026, month: 5));

    state.addCategory('Psicologa', 3000, Colors.purple);
    state.addTransaction(
      title: 'Consulta',
      amount: 1500,
      categoryTitle: 'Psicologa',
      type: TransactionType.expense,
      date: DateTime(2026, 5, 25),
    );

    final category = state.categories.firstWhere((category) {
      return category.title == 'Psicologa';
    });

    expect(category.spent, 1500);
    expect(state.totalSpent, 1500);

    state.deleteTransaction(state.transactions.first.id);

    final updatedCategory = state.categories.firstWhere((category) {
      return category.title == 'Psicologa';
    });

    expect(updatedCategory.spent, 0);
  });

  test('renaming a category updates its existing movement labels', () {
    final state = FinanceState();

    state.addCategory('Comida', 3000, Colors.green);
    final category = state.categories.singleWhere(
      (category) => !category.isProtected,
    );
    state.addTransaction(
      title: 'Supermercado',
      amount: 800,
      categoryTitle: category.title,
      type: TransactionType.expense,
      date: DateTime(2026, 7, 14),
    );

    state.updateCategory(category.id, title: 'Despensa');

    expect(
      state.categories.singleWhere((category) => !category.isProtected).title,
      'Despensa',
    );
    expect(state.transactions.single.category, 'Despensa');
    expect(
      state.categories.singleWhere((category) => !category.isProtected).spent,
      800,
    );
  });

  test('deleting a category preserves existing movements', () {
    final state = FinanceState();
    state.selectPeriod(FinancePeriod(year: 2026, month: 7));

    state.addCategory('Transporte', 1000, Colors.blue);
    final category = state.categories.singleWhere(
      (category) => !category.isProtected,
    );
    state.addTransaction(
      title: 'Taxi',
      amount: 250,
      categoryTitle: category.title,
      type: TransactionType.expense,
      date: DateTime(2026, 7, 14),
    );

    state.deleteCategory(category.id);

    expect(state.categories, hasLength(1));
    expect(state.categories.single.isProtected, isTrue);
    expect(state.transactions.single.category, 'Transporte');
    expect(state.totalSpent, 250);
  });
}
