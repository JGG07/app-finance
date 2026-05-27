import 'package:app_finance/src/core/state/finance_state.dart';
import 'package:app_finance/src/core/utils/currency_converter.dart';
import 'package:app_finance/src/features/budgets/domain/monthly_extra.dart';
import 'package:app_finance/src/features/dashboard/domain/surplus_plan.dart';
import 'package:app_finance/src/features/transactions/domain/transaction_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('calculates available income from payroll and budget sections', () {
    final state = FinanceState();

    expect(state.monthlyIncome, 44995.39);
    expect(state.totalAllocated, 7800);
    expect(state.availableIncome, closeTo(37195.39, 0.001));

    state.updateMonthlyIncome(25000);

    expect(state.availableIncome, 17200);
  });

  test('calculates monthly plan from fixed budget and card payments', () {
    final state = FinanceState();

    expect(state.totalAllocated, 7800);
    expect(state.totalMonthlyExtras, 3800);
    expect(state.totalMonthlyCardPayments, closeTo(16339.42, 0.001));
    expect(state.totalPlannedExpenses, closeTo(27939.42, 0.001));
    expect(state.totalPendingPlannedExpenses, closeTo(26139.42, 0.001));
    expect(state.availableAfterMonthlyPlan, closeTo(17055.97, 0.001));

    state.updateMonthlyIncome(86938.27);

    expect(state.availableAfterMonthlyPlan, closeTo(58998.85, 0.001));
  });

  test('manual card payment overrides confirmed and estimated amounts', () {
    final state = FinanceState();

    expect(state.cardMonthlyPaymentAmount('card-dorada'), 14578.60);

    state.updateCardMonthlyPayment('card-dorada', 11406.42);

    expect(state.cardMonthlyPaymentAmount('card-dorada'), 11406.42);
    expect(state.totalMonthlyCardPayments, closeTo(13167.24, 0.001));
    expect(state.totalPlannedExpenses, closeTo(24767.24, 0.001));
  });

  test('monthly extras are included in plan without affecting categories', () {
    final state = FinanceState();

    state.addMonthlyExtra(
      name: 'Regalo',
      amount: 500,
      status: MonthlyExtraStatus.reserved,
      includedInPlan: true,
    );

    expect(state.totalAllocated, 7800);
    expect(state.totalMonthlyExtras, 4300);
    expect(state.totalPlannedExpenses, closeTo(28439.42, 0.001));
  });

  test('calculates real estimated surplus and balanced distribution', () {
    final state = FinanceState();

    expect(state.realEstimatedSurplus, closeTo(17055.97, 0.001));

    state.updateMonthlyIncome(40000);

    expect(state.realEstimatedSurplus, closeTo(12060.58, 0.001));
    expect(state.surplusPlan.type, SurplusPlanType.balanced);
    expect(state.surplusPlanAllocation.safetyNet, closeTo(4824.232, 0.001));
    expect(state.surplusPlanAllocation.investment, closeTo(4824.232, 0.001));
    expect(state.surplusPlanAllocation.freeUse, closeTo(2412.116, 0.001));
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
    final card = state.creditCards.first;
    final initialBalance = card.usedBalance;

    state.addCreditCardPayment(card.id, 1000);

    expect(state.creditCards.first.usedBalance, closeTo(initialBalance - 1000, 0.001));

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

    state.addCreditCardPurchase(
      cardId: 'card-dorada',
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

  test('adding and deleting expense updates category spent amount', () {
    final state = FinanceState();

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
    expect(state.totalSpent, 1844);

    state.deleteTransaction(state.transactions.first.id);

    final updatedCategory = state.categories.firstWhere((category) {
      return category.title == 'Psicologa';
    });

    expect(updatedCategory.spent, 0);
  });
}
