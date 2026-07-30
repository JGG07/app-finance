import 'package:app_finance/src/core/domain/finance_period.dart';
import 'package:app_finance/src/core/database/finance_snapshot.dart';
import 'package:app_finance/src/core/database/repositories/finance_repository.dart';
import 'package:app_finance/src/core/state/finance_state.dart';
import 'package:app_finance/src/core/utils/currency_converter.dart';
import 'package:app_finance/src/features/budgets/domain/monthly_extra.dart';
import 'package:app_finance/src/features/budgets/domain/budget_category.dart';
import 'package:app_finance/src/features/cards/domain/credit_card.dart';
import 'package:app_finance/src/features/cards/domain/credit_card_monthly_payment.dart';
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

  test('treats legacy unmatched expenses as unbudgeted, never ant or income',
      () {
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
    expect(state.antExpenseSpent, 0);
    expect(state.unbudgetedExpensesForSelectedPeriod, 125);
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

  test('creating a card with manual payment stores CreditCardMonthlyPayment',
      () {
    final state = FinanceState();

    state.addCreditCard(
      name: 'Tarjeta principal',
      creditLimit: 25000,
      usedBalance: 1500,
      statementCutDay: 12,
      paymentAmount: 4321.50,
    );

    final cardId = state.creditCards.single.id;
    final payment = state.cardMonthlyPaymentFor(cardId);
    expect(payment.manualAmount, 4321.50);
    expect(payment.confirmedAmount, isNull);
    expect(
      state.cardMonthlyPaymentSource(cardId),
      CreditCardPaymentSource.manual,
    );
    expect(state.cardMonthlyPaymentAmount(cardId), 4321.50);
  });

  test('creating a card with confirmed payment stores confirmed source', () {
    final state = FinanceState();

    state.addCreditCard(
      name: 'Tarjeta principal',
      creditLimit: 25000,
      usedBalance: 1500,
      statementCutDay: 12,
      paymentAmount: 4321.50,
      paymentConfirmed: true,
    );

    final cardId = state.creditCards.single.id;
    final payment = state.cardMonthlyPaymentFor(cardId);
    expect(payment.confirmedAmount, 4321.50);
    expect(payment.manualAmount, isNull);
    expect(
      state.cardMonthlyPaymentSource(cardId),
      CreditCardPaymentSource.confirmed,
    );
    expect(state.cardMonthlyPaymentAmount(cardId), 4321.50);
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
    expect(state.totalMonthlyCardPayments, 0);
    expect(state.totalPlannedExpenses, 11600);
    expect(state.availableAfterMonthlyPlan, 28400);
    expect(state.totalFree, 28400);

    state.updateSurplusPlan(SurplusPlanType.balanced);

    expect(state.surplusPlanAllocation.safetyNet, 11360);
    expect(state.surplusPlanAllocation.investment, 11360);
    expect(state.surplusPlanAllocation.freeUse, 5680);
    expect(state.totalFree, 5680);
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

    expect(state.cardMonthlyPaymentAmount(cardId), 0);

    state.updateCardMonthlyPayment(cardId, 3000);

    expect(state.cardMonthlyPaymentAmount(cardId), 3000);
    expect(state.totalMonthlyCardPayments, 3000);
  });

  test('estimated card payment includes active MSI monthly installments', () {
    final state = FinanceState();
    state.addCreditCard(
      name: 'Tarjeta principal',
      creditLimit: 30000,
      usedBalance: 4000,
      statementCutDay: 10,
    );
    final cardId = state.creditCards.single.id;

    state.addCreditCardPurchase(
      cardId: cardId,
      title: 'Laptop',
      amount: 6000,
      installments: 6,
      date: DateTime(2026, 6, 1),
    );

    expect(state.estimatedCardMonthlyPayment(cardId), 0);
    expect(state.monthlyInstallmentPaymentForCard(cardId), 1000);
    expect(
      state.cardMonthlyPaymentSource(cardId),
      CreditCardPaymentSource.estimated,
    );
    expect(state.cardMonthlyPaymentAmount(cardId), 1000);
  });

  test('manual card payment with MSI does not add installments twice', () {
    final state = FinanceState();
    state.addCreditCard(
      name: 'Tarjeta principal',
      creditLimit: 30000,
      usedBalance: 4000,
      statementCutDay: 10,
    );
    final cardId = state.creditCards.single.id;

    state.addCreditCardPurchase(
      cardId: cardId,
      title: 'Laptop',
      amount: 6000,
      installments: 6,
      date: DateTime(2026, 6, 1),
    );
    state.updateCardMonthlyPayment(cardId, 10000);

    expect(
      state.cardMonthlyPaymentSource(cardId),
      CreditCardPaymentSource.manual,
    );
    expect(state.cardMonthlyPaymentAmount(cardId), 10000);
    expect(state.totalMonthlyCardPayments, 10000);
  });

  test('confirmed card payment with MSI does not add installments twice', () {
    final state = FinanceState();
    state.addCreditCard(
      name: 'Tarjeta principal',
      creditLimit: 30000,
      usedBalance: 4000,
      statementCutDay: 10,
    );
    final cardId = state.creditCards.single.id;

    state.addCreditCardPurchase(
      cardId: cardId,
      title: 'Laptop',
      amount: 6000,
      installments: 6,
      date: DateTime(2026, 6, 1),
    );
    state.updateCardMonthlyPayment(
      cardId,
      10000,
      source: CreditCardPaymentSource.confirmed,
    );

    expect(
      state.cardMonthlyPaymentSource(cardId),
      CreditCardPaymentSource.confirmed,
    );
    expect(state.cardMonthlyPaymentAmount(cardId), 10000);
    expect(state.totalMonthlyCardPayments, 10000);
  });

  test('returning card payment to estimated restores MSI in total', () {
    final state = FinanceState();
    state.addCreditCard(
      name: 'Tarjeta principal',
      creditLimit: 30000,
      usedBalance: 4000,
      statementCutDay: 10,
    );
    final cardId = state.creditCards.single.id;

    state.addCreditCardPurchase(
      cardId: cardId,
      title: 'Laptop',
      amount: 6000,
      installments: 6,
      date: DateTime(2026, 6, 1),
    );
    state.updateCardMonthlyPayment(cardId, 10000);

    expect(state.cardMonthlyPaymentAmount(cardId), 10000);

    state.updateCardMonthlyPayment(
      cardId,
      0,
      source: CreditCardPaymentSource.estimated,
    );

    expect(
      state.cardMonthlyPaymentSource(cardId),
      CreditCardPaymentSource.estimated,
    );
    expect(state.cardMonthlyPaymentAmount(cardId), 1000);
    expect(state.totalMonthlyCardPayments, 1000);
  });

  test('total monthly card payments uses corrected per-card amounts', () {
    final state = FinanceState();
    state.addCreditCard(
      name: 'Manual',
      creditLimit: 30000,
      usedBalance: 4000,
      statementCutDay: 10,
    );
    state.addCreditCard(
      name: 'Estimada',
      creditLimit: 25000,
      usedBalance: 5600,
      statementCutDay: 5,
    );
    final manualCardId = state.creditCards.first.id;
    final estimatedCardId = state.creditCards.last.id;

    state.addCreditCardPurchase(
      cardId: manualCardId,
      title: 'Laptop',
      amount: 6000,
      installments: 6,
      date: DateTime(2026, 6, 1),
    );
    state.addCreditCardPurchase(
      cardId: estimatedCardId,
      title: 'Telefono',
      amount: 2400,
      installments: 4,
      date: DateTime(2026, 6, 1),
    );
    state.updateCardMonthlyPayment(manualCardId, 10000);

    expect(state.cardMonthlyPaymentAmount(manualCardId), 10000);
    expect(state.cardMonthlyPaymentAmount(estimatedCardId), 600);
    expect(state.totalMonthlyCardPayments, 10600);
  });

  test('creating a card without payment does not use used balance as payment',
      () {
    final state = FinanceState();

    state.addCreditCard(
      name: 'Tarjeta dorada',
      creditLimit: 56200,
      usedBalance: 56093.41,
      statementCutDay: 19,
    );

    final cardId = state.creditCards.single.id;
    expect(
      state.cardMonthlyPaymentSource(cardId),
      CreditCardPaymentSource.estimated,
    );
    expect(state.cardMonthlyPaymentAmount(cardId), 0);
    expect(state.isCardPaymentPendingCapture(cardId), isTrue);
  });

  test('card without payment and without MSI returns zero', () {
    final state = FinanceState();

    state.addCreditCard(
      name: 'Tarjeta dorada',
      creditLimit: 56200,
      usedBalance: 56093.41,
      statementCutDay: 19,
    );

    final cardId = state.creditCards.single.id;
    expect(state.monthlyInstallmentPaymentForCard(cardId), 0);
    expect(state.cardMonthlyPaymentAmount(cardId), 0);
  });

  test('existing cards without payment stay pending until captured', () {
    final state = FinanceState();

    state.addCreditCard(
      name: 'Tarjeta dorada',
      creditLimit: 56200,
      usedBalance: 56093.41,
      statementCutDay: 19,
    );

    final cardId = state.creditCards.single.id;
    expect(state.hasExplicitCardMonthlyPayment(cardId), isFalse);
    expect(state.isCardPaymentPendingCapture(cardId), isTrue);
    expect(state.cardMonthlyPaymentAmount(cardId), 0);
  });

  test('plan does not sum used balance as monthly debt when payment is pending',
      () {
    final state = FinanceState();
    state.updateMonthlyIncome(40000);
    state.addCreditCard(
      name: 'Tarjeta dorada',
      creditLimit: 56200,
      usedBalance: 56093.41,
      statementCutDay: 19,
    );

    final task = state.monthlyFinancialTasks.singleWhere(
      (item) => item.type.name == 'cardPayment',
    );
    expect(task.amount, 0);
    expect(state.totalMonthlyCardPayments, 0);
    expect(state.totalPlannedExpenses, 0);
  });

  test('changing payment does not modify card utilization percent', () {
    final state = FinanceState();
    state.addCreditCard(
      name: 'Tarjeta principal',
      creditLimit: 40000,
      usedBalance: 20000,
      statementCutDay: 10,
    );
    final cardId = state.creditCards.single.id;

    expect(state.creditCards.single.utilizationPercent, 50);

    state.updateCardMonthlyPayment(
      cardId,
      10000,
      source: CreditCardPaymentSource.confirmed,
    );

    expect(state.cardMonthlyPaymentAmount(cardId), 10000);
    expect(state.creditCards.single.utilizationPercent, 50);
    expect(state.creditCards.single.utilizationProgress, 0.5);
  });

  test('changing used balance modifies utilization percent but not payment',
      () {
    final state = FinanceState();
    state.addCreditCard(
      name: 'Tarjeta principal',
      creditLimit: 40000,
      usedBalance: 20000,
      statementCutDay: 10,
    );
    final cardId = state.creditCards.single.id;
    state.updateCardMonthlyPayment(
      cardId,
      10000,
      source: CreditCardPaymentSource.confirmed,
    );

    state.updateCreditCard(cardId, usedBalance: 30000);

    expect(state.creditCards.single.utilizationPercent, 75);
    expect(state.creditCards.single.utilizationProgress, 0.75);
    expect(state.cardMonthlyPaymentAmount(cardId), 10000);
  });

  test('credit card utilization percent can exceed 100 but progress is clamped',
      () {
    const card = CreditCard(
      id: 'card-1',
      name: 'Tarjeta dorada',
      creditLimit: 30000,
      usedBalance: 31500,
      statementCutDay: 10,
    );

    expect(card.utilizationPercent, 105);
    expect(card.utilizationProgress, 1.0);
  });

  test('credit card utilization percent returns zero for invalid limit', () {
    const card = CreditCard(
      id: 'card-1',
      name: 'Tarjeta dorada',
      creditLimit: 0,
      usedBalance: 1000,
      statementCutDay: 10,
    );

    expect(card.utilizationPercent, 0);
    expect(card.utilizationProgress, 0);
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

  test('expense without card does not modify used balance', () {
    final state = FinanceState();
    state.addCategory('Comida', 1000, Colors.green);
    state.addCreditCard(
      name: 'Tarjeta',
      creditLimit: 10000,
      usedBalance: 2500,
      statementCutDay: 10,
    );

    state.addTransaction(
      title: 'Super',
      amount: 200,
      categoryTitle: 'Comida',
      type: TransactionType.expense,
      date: DateTime(2026, 7, 10),
    );

    expect(state.creditCards.single.usedBalance, 2500);
  });

  test('card purchase increments used balance and counts as expense', () {
    final state = FinanceState();
    state.addCategory('Comida', 1000, Colors.green);
    state.addCreditCard(
      name: 'Tarjeta',
      creditLimit: 10000,
      usedBalance: 2500,
      statementCutDay: 10,
    );
    final cardId = state.creditCards.single.id;

    state.addTransaction(
      title: 'Super',
      amount: 200,
      categoryTitle: 'Comida',
      type: TransactionType.expense,
      date: DateTime(2026, 7, 10),
      creditCardId: cardId,
      cardTransactionKind: CardTransactionKind.purchase,
    );

    expect(state.creditCards.single.usedBalance, 2700);
    expect(state.totalExpenses, 200);
    expect(state.totalBudgetUtilized, 200);
    expect(state.creditCardPurchases, isEmpty);
  });

  test('card payment decreases used balance and does not count as expense', () {
    final state = FinanceState();
    state.addCategory('Comida', 1000, Colors.green);
    state.addCreditCard(
      name: 'Tarjeta',
      creditLimit: 10000,
      usedBalance: 2500,
      statementCutDay: 10,
    );
    final cardId = state.creditCards.single.id;

    final transactionId = state.registerCreditCardPayment(
      cardId: cardId,
      amount: 300,
      date: DateTime(2026, 7, 10),
    );

    expect(transactionId, isNotNull);
    expect(state.creditCards.single.usedBalance, 2200);
    expect(state.transactions.single.type, TransactionType.cardPayment);
    expect(
      state.transactions.single.cardTransactionKind,
      CardTransactionKind.payment,
    );
    expect(state.totalExpenses, 0);
    expect(state.totalBudgetUtilized, 0);
    expect(state.antExpenseSpent, 0);
    expect(state.cardMonthlyPaymentAmount(cardId), 0);
  });

  test('card payment does not allow negative used balance', () {
    final state = FinanceState();
    state.addCreditCard(
      name: 'Tarjeta',
      creditLimit: 10000,
      usedBalance: 250,
      statementCutDay: 10,
    );
    final cardId = state.creditCards.single.id;

    final transactionId = state.registerCreditCardPayment(
      cardId: cardId,
      amount: 300,
      date: DateTime(2026, 7, 10),
    );

    expect(transactionId, isNull);
    expect(state.creditCards.single.usedBalance, 250);
    expect(state.transactions, isEmpty);
  });

  test('card payment does not affect ant expense or budget metrics', () {
    final state = FinanceState();
    state.addCreditCard(
      name: 'Tarjeta',
      creditLimit: 10000,
      usedBalance: 2500,
      statementCutDay: 10,
    );
    final cardId = state.creditCards.single.id;

    state.addTransaction(
      title: 'Cafe',
      amount: 80,
      categoryTitle: BudgetCategory.antExpenseTitle,
      type: TransactionType.expense,
      date: DateTime(2026, 7, 10),
    );
    state.registerCreditCardPayment(
      cardId: cardId,
      amount: 300,
      date: DateTime(2026, 7, 11),
    );

    expect(state.antExpenseSpent, 80);
    expect(state.totalExpenses, 80);
    expect(state.unbudgetedExpensesForSelectedPeriod, 80);
  });

  test('editing card purchase amount applies only the difference', () {
    final state = FinanceState();
    state.addCategory('Comida', 1000, Colors.green);
    state.addCreditCard(
      name: 'Tarjeta',
      creditLimit: 10000,
      usedBalance: 1000,
      statementCutDay: 10,
    );
    final cardId = state.creditCards.single.id;
    final transactionId = state.addTransaction(
      title: 'Super',
      amount: 1000,
      categoryTitle: 'Comida',
      type: TransactionType.expense,
      date: DateTime(2026, 7, 10),
      creditCardId: cardId,
      cardTransactionKind: CardTransactionKind.purchase,
    )!;

    final updated = state.updateTransaction(
      transactionId,
      title: 'Super',
      amount: 1300,
      categoryTitle: 'Comida',
      type: TransactionType.expense,
      date: DateTime(2026, 7, 10),
      creditCardId: cardId,
      cardTransactionKind: CardTransactionKind.purchase,
    );

    expect(updated, isTrue);
    expect(state.creditCards.single.usedBalance, 2300);
  });

  test('editing card payment amount applies only the difference', () {
    final state = FinanceState();
    state.addCreditCard(
      name: 'Tarjeta',
      creditLimit: 10000,
      usedBalance: 2500,
      statementCutDay: 10,
    );
    final cardId = state.creditCards.single.id;
    final transactionId = state.registerCreditCardPayment(
      cardId: cardId,
      amount: 500,
      date: DateTime(2026, 7, 10),
    )!;

    final updated = state.updateTransaction(
      transactionId,
      title: 'Pago a Tarjeta',
      amount: 800,
      categoryTitle: FinanceState.cardPaymentCategoryTitle,
      type: TransactionType.cardPayment,
      date: DateTime(2026, 7, 10),
      creditCardId: cardId,
      cardTransactionKind: CardTransactionKind.payment,
    );

    expect(updated, isTrue);
    expect(state.creditCards.single.usedBalance, 1700);
  });

  test('moving a card purchase from card A to B reverts and reapplies', () {
    final state = FinanceState();
    state.addCategory('Comida', 1000, Colors.green);
    state.addCreditCard(
      name: 'A',
      creditLimit: 10000,
      usedBalance: 1000,
      statementCutDay: 10,
    );
    state.addCreditCard(
      name: 'B',
      creditLimit: 10000,
      usedBalance: 500,
      statementCutDay: 10,
    );
    final cardA = state.creditCards.first.id;
    final cardB = state.creditCards.last.id;
    final transactionId = state.addTransaction(
      title: 'Super',
      amount: 1000,
      categoryTitle: 'Comida',
      type: TransactionType.expense,
      date: DateTime(2026, 7, 10),
      creditCardId: cardA,
      cardTransactionKind: CardTransactionKind.purchase,
    )!;

    final updated = state.updateTransaction(
      transactionId,
      title: 'Super',
      amount: 1000,
      categoryTitle: 'Comida',
      type: TransactionType.expense,
      date: DateTime(2026, 7, 10),
      creditCardId: cardB,
      cardTransactionKind: CardTransactionKind.purchase,
    );

    expect(updated, isTrue);
    expect(state.creditCardById(cardA)!.usedBalance, 1000);
    expect(state.creditCardById(cardB)!.usedBalance, 1500);
  });

  test('unlinking a card purchase reverts used balance', () {
    final state = FinanceState();
    state.addCategory('Comida', 1000, Colors.green);
    state.addCreditCard(
      name: 'Tarjeta',
      creditLimit: 10000,
      usedBalance: 1000,
      statementCutDay: 10,
    );
    final cardId = state.creditCards.single.id;
    final transactionId = state.addTransaction(
      title: 'Super',
      amount: 1000,
      categoryTitle: 'Comida',
      type: TransactionType.expense,
      date: DateTime(2026, 7, 10),
      creditCardId: cardId,
      cardTransactionKind: CardTransactionKind.purchase,
    )!;

    final updated = state.updateTransaction(
      transactionId,
      title: 'Super',
      amount: 1000,
      categoryTitle: 'Comida',
      type: TransactionType.expense,
      date: DateTime(2026, 7, 10),
    );

    expect(updated, isTrue);
    expect(state.creditCards.single.usedBalance, 1000);
  });

  test('linking an existing expense to a card increments used balance', () {
    final state = FinanceState();
    state.addCategory('Comida', 1000, Colors.green);
    state.addCreditCard(
      name: 'Tarjeta',
      creditLimit: 10000,
      usedBalance: 1000,
      statementCutDay: 10,
    );
    final cardId = state.creditCards.single.id;
    final transactionId = state.addTransaction(
      title: 'Super',
      amount: 1000,
      categoryTitle: 'Comida',
      type: TransactionType.expense,
      date: DateTime(2026, 7, 10),
    )!;

    final updated = state.updateTransaction(
      transactionId,
      title: 'Super',
      amount: 1000,
      categoryTitle: 'Comida',
      type: TransactionType.expense,
      date: DateTime(2026, 7, 10),
      creditCardId: cardId,
      cardTransactionKind: CardTransactionKind.purchase,
    );

    expect(updated, isTrue);
    expect(state.creditCards.single.usedBalance, 2000);
  });

  test('deleting linked purchase and payment reverts used balance once', () {
    final state = FinanceState();
    state.addCategory('Comida', 1000, Colors.green);
    state.addCreditCard(
      name: 'Tarjeta',
      creditLimit: 10000,
      usedBalance: 1000,
      statementCutDay: 10,
    );
    final cardId = state.creditCards.single.id;
    final purchaseId = state.addTransaction(
      title: 'Super',
      amount: 1000,
      categoryTitle: 'Comida',
      type: TransactionType.expense,
      date: DateTime(2026, 7, 10),
      creditCardId: cardId,
      cardTransactionKind: CardTransactionKind.purchase,
    )!;
    final paymentId = state.registerCreditCardPayment(
      cardId: cardId,
      amount: 300,
      date: DateTime(2026, 7, 11),
    )!;

    expect(state.creditCards.single.usedBalance, 1700);
    expect(state.deleteTransaction(purchaseId), isTrue);
    expect(state.creditCards.single.usedBalance, 700);
    expect(state.deleteTransaction(paymentId), isTrue);
    expect(state.creditCards.single.usedBalance, 1000);
  });

  test('changing title or date of linked movement does not modify balance', () {
    final state = FinanceState();
    state.addCategory('Comida', 1000, Colors.green);
    state.addCreditCard(
      name: 'Tarjeta',
      creditLimit: 10000,
      usedBalance: 1000,
      statementCutDay: 10,
    );
    final cardId = state.creditCards.single.id;
    final transactionId = state.addTransaction(
      title: 'Super',
      amount: 500,
      categoryTitle: 'Comida',
      type: TransactionType.expense,
      date: DateTime(2026, 7, 10),
      creditCardId: cardId,
      cardTransactionKind: CardTransactionKind.purchase,
    )!;

    final updated = state.updateTransaction(
      transactionId,
      title: 'Super mercado',
      amount: 500,
      categoryTitle: 'Comida',
      type: TransactionType.expense,
      date: DateTime(2026, 7, 11),
      creditCardId: cardId,
      cardTransactionKind: CardTransactionKind.purchase,
    );

    expect(updated, isTrue);
    expect(state.creditCards.single.usedBalance, 1500);
  });

  test('movement balance sync does not modify manual or confirmed card payment',
      () {
    final state = FinanceState();
    state.addCategory('Comida', 1000, Colors.green);
    state.addCreditCard(
      name: 'Tarjeta',
      creditLimit: 10000,
      usedBalance: 1000,
      statementCutDay: 10,
      paymentAmount: 5000,
      paymentConfirmed: true,
    );
    final cardId = state.creditCards.single.id;

    state.addTransaction(
      title: 'Super',
      amount: 500,
      categoryTitle: 'Comida',
      type: TransactionType.expense,
      date: DateTime(2026, 7, 10),
      creditCardId: cardId,
      cardTransactionKind: CardTransactionKind.purchase,
    );

    expect(state.creditCards.single.usedBalance, 1500);
    expect(state.cardMonthlyPaymentAmount(cardId), 5000);
    expect(
      state.cardMonthlyPaymentSource(cardId),
      CreditCardPaymentSource.confirmed,
    );
  });

  test('registering payment from cards creates exactly one linked movement',
      () {
    final state = FinanceState();
    state.addCreditCard(
      name: 'Tarjeta',
      creditLimit: 10000,
      usedBalance: 1000,
      statementCutDay: 10,
    );
    final cardId = state.creditCards.single.id;

    final transactionId = state.registerCreditCardPayment(
      cardId: cardId,
      amount: 300,
      date: DateTime(2026, 7, 10),
    );

    expect(transactionId, isNotNull);
    expect(state.transactions, hasLength(1));
    expect(state.transactions.single.creditCardId, cardId);
    expect(state.creditCards.single.usedBalance, 700);
  });

  test('cannot associate a movement with a non-existent card', () {
    final state = FinanceState();
    state.addCategory('Comida', 1000, Colors.green);

    final transactionId = state.addTransaction(
      title: 'Super',
      amount: 200,
      categoryTitle: 'Comida',
      type: TransactionType.expense,
      date: DateTime(2026, 7, 10),
      creditCardId: 'missing-card',
      cardTransactionKind: CardTransactionKind.purchase,
    );

    expect(transactionId, isNull);
    expect(state.transactions, isEmpty);
  });

  test('cannot delete a card with linked movements', () {
    final state = FinanceState();
    state.addCategory('Comida', 1000, Colors.green);
    state.addCreditCard(
      name: 'Tarjeta',
      creditLimit: 10000,
      usedBalance: 1000,
      statementCutDay: 10,
    );
    final cardId = state.creditCards.single.id;
    state.addTransaction(
      title: 'Super',
      amount: 200,
      categoryTitle: 'Comida',
      type: TransactionType.expense,
      date: DateTime(2026, 7, 10),
      creditCardId: cardId,
      cardTransactionKind: CardTransactionKind.purchase,
    );

    expect(state.deleteCreditCard(cardId), isFalse);
    expect(state.creditCards, hasLength(1));
  });

  test('legacy movements without relation do not modify cards on load',
      () async {
    final snapshot = FinanceSnapshot(
      monthlyIncome: 0,
      categories: const [
        BudgetCategory(
          id: BudgetCategory.antExpenseId,
          title: BudgetCategory.antExpenseTitle,
          limit: 0,
          color: Color(0xFF1B7F5C),
        ),
      ],
      transactions: [
        TransactionEntry(
          id: 'tx-1',
          title: 'Legacy expense',
          amount: 400,
          category: 'Comida',
          date: DateTime(2026, 7, 10),
          type: TransactionType.expense,
        ),
      ],
      plannedExpenses: const [],
      creditCards: const [
        CreditCard(
          id: 'card-1',
          name: 'Tarjeta',
          creditLimit: 10000,
          usedBalance: 1234,
          statementCutDay: 10,
        ),
      ],
      creditCardPurchases: const [],
      subscriptions: const [],
      cardMonthlyPayments: const [],
      monthlyExtras: const [],
      surplusPlan: const SurplusPlan(type: SurplusPlanType.unconfigured),
      manualTasks: const [],
      taskOverrides: const {},
      tandas: const [],
      tandaContributions: const [],
      tandaReceipts: const [],
    );
    final state = FinanceState(
      repository: _MemoryRepository(snapshot),
    );

    await state.initialize();

    expect(state.creditCards.single.usedBalance, 1234);
  });
}

class _MemoryRepository implements FinanceStorage {
  _MemoryRepository(this.snapshot);

  final FinanceSnapshot snapshot;

  @override
  Future<FinanceSnapshot> loadSnapshot() async => snapshot;

  @override
  Future<void> saveSnapshot(FinanceSnapshot snapshot) async {}
}
