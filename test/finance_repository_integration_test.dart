import 'dart:io';

import 'package:app_finance/src/core/database/app_database.dart' show AppDatabase;
import 'package:app_finance/src/core/database/finance_snapshot.dart';
import 'package:app_finance/src/core/database/repositories/finance_repository.dart';
import 'package:app_finance/src/features/budgets/domain/budget_category.dart';
import 'package:app_finance/src/features/budgets/domain/monthly_extra.dart';
import 'package:app_finance/src/features/cards/domain/credit_card.dart';
import 'package:app_finance/src/features/cards/domain/credit_card_monthly_payment.dart';
import 'package:app_finance/src/features/cards/domain/credit_card_purchase.dart';
import 'package:app_finance/src/features/dashboard/domain/surplus_plan.dart';
import 'package:app_finance/src/features/planning/domain/planned_expense.dart';
import 'package:app_finance/src/features/subscriptions/domain/subscription_entry.dart';
import 'package:app_finance/src/features/tasks/domain/financial_task.dart';
import 'package:app_finance/src/features/transactions/domain/transaction_entry.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('persists a complete snapshot after close and reopen', () async {
    final tempDirectory = await Directory.systemTemp.createTemp(
      'app_finance_repository_test_',
    );
    final databaseFile = File('${tempDirectory.path}/app_finance.sqlite');
    FinanceRepository? repository;

    try {
      final expected = _completeSnapshot();
      repository = FinanceRepository(
        AppDatabase.forTesting(NativeDatabase(databaseFile)),
      );

      await repository.saveSnapshot(expected);
      await repository.close();
      repository = null;

      repository = FinanceRepository(
        AppDatabase.forTesting(NativeDatabase(databaseFile)),
      );
      final actual = await repository.loadSnapshot();

      _expectCompleteSnapshot(actual);
    } finally {
      await repository?.close();
      await tempDirectory.delete(recursive: true);
    }
  });
}

FinanceSnapshot _completeSnapshot() {
  return FinanceSnapshot(
    monthlyIncome: 32500.75,
    categories: const [
      BudgetCategory(
        id: 'category-food',
        title: 'Comida',
        limit: 4500,
        spent: 812.35,
        color: Color(0xFF123456),
      ),
    ],
    transactions: [
      TransactionEntry(
        id: 'transaction-market',
        title: 'Supermercado',
        amount: 812.35,
        category: 'Comida',
        date: DateTime(2026, 7, 12, 18, 30),
        type: TransactionType.expense,
      ),
    ],
    plannedExpenses: const [
      PlannedExpense(
        id: 'planned-rent',
        title: 'Renta',
        amount: 7800,
        group: 'Vivienda',
        status: PlannedExpenseStatus.reserved,
        paymentSource: 'Transferencia',
        note: 'Pagar antes del dia 5',
      ),
    ],
    creditCards: const [
      CreditCard(
        id: 'card-primary',
        name: 'Tarjeta principal',
        creditLimit: 40000,
        usedBalance: 6250,
        statementCutDay: 19,
      ),
    ],
    creditCardPurchases: [
      CreditCardPurchase(
        id: 'purchase-laptop',
        cardId: 'card-primary',
        title: 'Laptop',
        amount: 12000,
        installments: 12,
        paidInstallments: 3,
        date: DateTime(2026, 4, 18, 12),
        notes: 'Compra a meses',
      ),
    ],
    subscriptions: const [
      SubscriptionEntry(
        id: 'subscription-music',
        name: 'Musica',
        amount: 199,
        cardId: 'card-primary',
      ),
    ],
    cardMonthlyPayments: const [
      CreditCardMonthlyPayment(
        cardId: 'card-primary',
        manualAmount: 2200,
        confirmedAmount: 2100,
      ),
    ],
    monthlyExtras: const [
      MonthlyExtra(
        id: 'extra-family',
        name: 'Apoyo familiar',
        amount: 1500,
        status: MonthlyExtraStatus.toDeliver,
        includedInPlan: true,
        person: 'Familiar',
        notes: 'Entregar en efectivo',
      ),
    ],
    surplusPlan: const SurplusPlan(
      type: SurplusPlanType.custom,
      manualSafetyNet: 1000,
      manualInvestment: 2000,
      manualFreeUse: 500,
    ),
    manualTasks: [
      FinancialTask(
        id: 'task-tax',
        title: 'Pagar impuesto',
        amount: 950,
        type: FinancialTaskType.manual,
        status: FinancialTaskStatus.partial,
        createdAt: DateTime(2026, 7, 1, 9),
        actualAmount: 400,
        dueDate: DateTime(2026, 7, 20),
        sourceId: 'manual',
        sourceType: FinancialTaskSourceType.manual,
        notes: 'Completar este mes',
        completedAt: DateTime(2026, 7, 13, 10),
      ),
    ],
    taskOverrides: {
      'card-payment-card-primary': FinancialTaskOverride(
        title: 'Pago ajustado',
        amount: 2050,
        status: FinancialTaskStatus.done,
        actualAmount: 2050,
        dueDate: DateTime(2026, 7, 19),
        notes: 'Confirmado por el banco',
        completedAt: DateTime(2026, 7, 13, 11),
      ),
    },
  );
}

void _expectCompleteSnapshot(FinanceSnapshot actual) {
  expect(actual.monthlyIncome, 32500.75);

  expect(actual.categories, hasLength(1));
  final category = actual.categories.single;
  expect(category.id, 'category-food');
  expect(category.title, 'Comida');
  expect(category.limit, 4500);
  expect(category.spent, 812.35);
  expect(category.color.toARGB32(), 0xFF123456);

  expect(actual.transactions, hasLength(1));
  final transaction = actual.transactions.single;
  expect(transaction.id, 'transaction-market');
  expect(transaction.title, 'Supermercado');
  expect(transaction.amount, 812.35);
  expect(transaction.category, 'Comida');
  expect(transaction.date, DateTime(2026, 7, 12, 18, 30));
  expect(transaction.type, TransactionType.expense);

  expect(actual.plannedExpenses, hasLength(1));
  final plannedExpense = actual.plannedExpenses.single;
  expect(plannedExpense.id, 'planned-rent');
  expect(plannedExpense.title, 'Renta');
  expect(plannedExpense.amount, 7800);
  expect(plannedExpense.group, 'Vivienda');
  expect(plannedExpense.status, PlannedExpenseStatus.reserved);
  expect(plannedExpense.paymentSource, 'Transferencia');
  expect(plannedExpense.note, 'Pagar antes del dia 5');

  expect(actual.creditCards, hasLength(1));
  final card = actual.creditCards.single;
  expect(card.id, 'card-primary');
  expect(card.name, 'Tarjeta principal');
  expect(card.creditLimit, 40000);
  expect(card.usedBalance, 6250);
  expect(card.statementCutDay, 19);

  expect(actual.creditCardPurchases, hasLength(1));
  final purchase = actual.creditCardPurchases.single;
  expect(purchase.id, 'purchase-laptop');
  expect(purchase.cardId, 'card-primary');
  expect(purchase.title, 'Laptop');
  expect(purchase.amount, 12000);
  expect(purchase.installments, 12);
  expect(purchase.paidInstallments, 3);
  expect(purchase.date, DateTime(2026, 4, 18, 12));
  expect(purchase.notes, 'Compra a meses');

  expect(actual.subscriptions, hasLength(1));
  final subscription = actual.subscriptions.single;
  expect(subscription.id, 'subscription-music');
  expect(subscription.name, 'Musica');
  expect(subscription.amount, 199);
  expect(subscription.cardId, 'card-primary');

  expect(actual.cardMonthlyPayments, hasLength(1));
  final cardPayment = actual.cardMonthlyPayments.single;
  expect(cardPayment.cardId, 'card-primary');
  expect(cardPayment.manualAmount, 2200);
  expect(cardPayment.confirmedAmount, 2100);

  expect(actual.monthlyExtras, hasLength(1));
  final extra = actual.monthlyExtras.single;
  expect(extra.id, 'extra-family');
  expect(extra.name, 'Apoyo familiar');
  expect(extra.amount, 1500);
  expect(extra.status, MonthlyExtraStatus.toDeliver);
  expect(extra.includedInPlan, isTrue);
  expect(extra.person, 'Familiar');
  expect(extra.notes, 'Entregar en efectivo');

  expect(actual.surplusPlan.type, SurplusPlanType.custom);
  expect(actual.surplusPlan.manualSafetyNet, 1000);
  expect(actual.surplusPlan.manualInvestment, 2000);
  expect(actual.surplusPlan.manualFreeUse, 500);

  expect(actual.manualTasks, hasLength(1));
  final task = actual.manualTasks.single;
  expect(task.id, 'task-tax');
  expect(task.title, 'Pagar impuesto');
  expect(task.amount, 950);
  expect(task.type, FinancialTaskType.manual);
  expect(task.status, FinancialTaskStatus.partial);
  expect(task.createdAt, DateTime(2026, 7, 1, 9));
  expect(task.actualAmount, 400);
  expect(task.dueDate, DateTime(2026, 7, 20));
  expect(task.sourceId, 'manual');
  expect(task.sourceType, FinancialTaskSourceType.manual);
  expect(task.notes, 'Completar este mes');
  expect(task.completedAt, DateTime(2026, 7, 13, 10));

  expect(actual.taskOverrides, hasLength(1));
  final override = actual.taskOverrides['card-payment-card-primary'];
  expect(override, isNotNull);
  expect(override!.title, 'Pago ajustado');
  expect(override.amount, 2050);
  expect(override.status, FinancialTaskStatus.done);
  expect(override.actualAmount, 2050);
  expect(override.dueDate, DateTime(2026, 7, 19));
  expect(override.notes, 'Confirmado por el banco');
  expect(override.completedAt, DateTime(2026, 7, 13, 11));
}
