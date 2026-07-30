import 'dart:io';

import 'package:app_finance/src/core/database/app_database.dart'
    show AppDatabase;
import 'package:app_finance/src/core/database/finance_snapshot.dart';
import 'package:app_finance/src/core/database/repositories/finance_repository.dart';
import 'package:app_finance/src/core/state/finance_state.dart';
import 'package:app_finance/src/features/budgets/domain/budget_category.dart';
import 'package:app_finance/src/features/budgets/domain/monthly_extra.dart';
import 'package:app_finance/src/features/cards/domain/credit_card.dart';
import 'package:app_finance/src/features/cards/domain/credit_card_monthly_payment.dart';
import 'package:app_finance/src/features/cards/domain/credit_card_purchase.dart';
import 'package:app_finance/src/features/dashboard/domain/surplus_plan.dart';
import 'package:app_finance/src/features/planning/domain/planned_expense.dart';
import 'package:app_finance/src/features/subscriptions/domain/subscription_entry.dart';
import 'package:app_finance/src/features/tasks/domain/financial_task.dart';
import 'package:app_finance/src/features/tandas/domain/tanda.dart';
import 'package:app_finance/src/features/tandas/domain/tanda_contribution.dart';
import 'package:app_finance/src/features/tandas/domain/tanda_receipt_link.dart';
import 'package:app_finance/src/features/tandas/domain/tanda_receipt.dart';
import 'package:app_finance/src/features/transactions/domain/transaction_entry.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('migrates v3 to v6 with one pending receipt and no income', () async {
    final directory = await Directory.systemTemp.createTemp('tanda_v3_');
    final file = File('${directory.path}/migration.sqlite');
    AppDatabase? database;
    try {
      database = AppDatabase.forTesting(
        NativeDatabase(
          file,
          setup: (sqlite) {
            if (sqlite.userVersion != 0) return;
            sqlite.execute('''
              CREATE TABLE tandas (
                id TEXT NOT NULL PRIMARY KEY,
                name TEXT NOT NULL,
                contribution_amount REAL NOT NULL,
                frequency TEXT NOT NULL,
                start_date INTEGER NOT NULL,
                participant_count INTEGER NOT NULL,
                assigned_turn INTEGER NOT NULL,
                completed_contributions INTEGER NOT NULL,
                status TEXT NOT NULL,
                notes TEXT NULL,
                created_at INTEGER NOT NULL
              )
            ''');
            sqlite.execute('''
              CREATE TABLE tanda_contributions (
                id TEXT NOT NULL PRIMARY KEY,
                tanda_id TEXT NOT NULL,
                sequence_number INTEGER NOT NULL,
                amount REAL NOT NULL,
                scheduled_date INTEGER NOT NULL,
                status TEXT NOT NULL,
                paid_at INTEGER NULL,
                created_at INTEGER NOT NULL,
                migrated_from_legacy_counter INTEGER NOT NULL DEFAULT 0,
                notes TEXT NULL,
                linked_transaction_id TEXT NULL,
                UNIQUE(tanda_id, sequence_number),
                FOREIGN KEY(tanda_id) REFERENCES tandas(id) ON DELETE CASCADE
              )
            ''');
            sqlite.execute('''
              INSERT INTO tandas VALUES (
                'legacy', 'Heredada', 1000, 'monthly',
                1785542400, 3, 2, 1, 'active', NULL, 1782864000
              )
            ''');
            sqlite.execute('''
              INSERT INTO tanda_contributions VALUES (
                'legacy-contribution-1', 'legacy', 1, 1000,
                1785542400, 'paid', 1785628800, 1782864000,
                0, NULL, 'existing-expense'
              )
            ''');
            sqlite.userVersion = 3;
          },
        ),
      );

      final receipts = await database.select(database.tandaReceipts).get();
      final contributions =
          await database.select(database.tandaContributions).get();
      expect(database.schemaVersion, 6);
      expect(receipts, hasLength(1));
      expect(receipts.single.id, receiptIdForTanda('legacy'));
      expect(receipts.single.amount, 3000);
      expect(receipts.single.status, 'pending');
      expect(receipts.single.receivedAt, isNull);
      expect(receipts.single.linkedTransactionId, isNull);
      expect(contributions.single.linkedTransactionId, 'existing-expense');
    } finally {
      await database?.close();
      await directory.delete(recursive: true);
    }
  });

  test('foreign keys are enabled and deleting tanda cascades receipt',
      () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    try {
      final state = FinanceState(repository: FinanceRepository(database));
      await state.initialize();
      state.addTanda(
        name: 'Cascada',
        contributionAmount: 500,
        frequency: TandaFrequency.monthly,
        startDate: DateTime(2026, 8, 1),
        participantCount: 2,
        assignedTurn: 1,
      );
      await state.flushPendingSaves();
      final pragma =
          await database.customSelect('PRAGMA foreign_keys').getSingle();
      expect(pragma.read<int>('foreign_keys'), 1);
      expect(await database.select(database.tandaReceipts).get(), hasLength(1));
      await database.delete(database.tandas).go();
      expect(await database.select(database.tandaReceipts).get(), isEmpty);
      expect(await database.select(database.tandaContributions).get(), isEmpty);
    } finally {
      await database.close();
    }
  });

  test('persists linked receipt income and undo after reopen', () async {
    final directory = await Directory.systemTemp.createTemp('receipt_link_');
    final file = File('${directory.path}/finance.sqlite');
    FinanceRepository? repository;
    try {
      repository = FinanceRepository(
        AppDatabase.forTesting(NativeDatabase(file)),
      );
      final state = FinanceState(repository: repository);
      await state.initialize();
      state.addTanda(
        name: 'Persistente',
        contributionAmount: 800,
        frequency: TandaFrequency.monthly,
        startDate: DateTime(2026, 8, 1),
        participantCount: 2,
        assignedTurn: 2,
      );
      final tandaId = state.tandas.single.id;
      state.markTandaReceiptReceived(
        tandaId: tandaId,
        receivedAt: DateTime(2026, 8, 20),
      );
      await state.flushPendingSaves();
      await repository.close();

      repository = FinanceRepository(
        AppDatabase.forTesting(NativeDatabase(file)),
      );
      final reopened = FinanceState(repository: repository);
      await reopened.initialize();
      final receipt = reopened.tandaReceipts.single;
      expect(receipt.isReceived, isTrue);
      expect(receipt.amount, 1600);
      expect(receipt.scheduledDate, DateTime(2026, 9, 1));
      expect(receipt.receivedAt, DateTime(2026, 8, 20));
      expect(receipt.linkedTransactionId, reopened.transactions.single.id);
      expect(reopened.transactions.single.type, TransactionType.income);
      reopened.undoTandaReceipt(tandaId);
      await reopened.flushPendingSaves();
      expect(reopened.transactions, isEmpty);
      expect(reopened.tandaReceipts.single.isReceived, isFalse);
    } finally {
      await repository?.close();
      await directory.delete(recursive: true);
    }
  });

  test('persists and undoes a linked tanda movement after reopen', () async {
    final directory = await Directory.systemTemp.createTemp('tanda_link_');
    final file = File('${directory.path}/finance.sqlite');
    FinanceRepository? repository;
    try {
      repository = FinanceRepository(
        AppDatabase.forTesting(NativeDatabase(file)),
      );
      final state = FinanceState(repository: repository);
      await state.initialize();
      state.addTanda(
        name: 'Familiar',
        contributionAmount: 900,
        frequency: TandaFrequency.monthly,
        startDate: DateTime(2026, 8, 10),
        participantCount: 2,
        assignedTurn: 1,
      );
      final tandaId = state.tandas.single.id;
      state.markNextTandaContributionPaid(tandaId);
      final expectedContribution = state.tandaContributions.first;
      final expectedTransaction = state.transactions.single;
      await state.flushPendingSaves();
      await repository.close();

      repository = FinanceRepository(
        AppDatabase.forTesting(NativeDatabase(file)),
      );
      final reopened = FinanceState(repository: repository);
      await reopened.initialize();
      final actualContribution = reopened.tandaContributions.first;
      final actualTransaction = reopened.transactions.single;
      expect(actualContribution.isPaid, isTrue);
      expect(
        actualContribution.paidAt,
        DateTime(
          expectedContribution.paidAt!.year,
          expectedContribution.paidAt!.month,
          expectedContribution.paidAt!.day,
          expectedContribution.paidAt!.hour,
          expectedContribution.paidAt!.minute,
          expectedContribution.paidAt!.second,
        ),
      );
      expect(
        actualContribution.linkedTransactionId,
        expectedTransaction.id,
      );
      expect(actualTransaction.id, expectedTransaction.id);
      expect(actualTransaction.amount, expectedTransaction.amount);
      expect(actualTransaction.date, actualContribution.paidAt);

      reopened.undoLastTandaContribution(tandaId);
      await reopened.flushPendingSaves();
      await repository.close();
      repository = FinanceRepository(
        AppDatabase.forTesting(NativeDatabase(file)),
      );
      final afterUndo = await repository.loadSnapshot();
      expect(afterUndo.transactions, isEmpty);
      expect(afterUndo.tandaContributions.first.isPaid, isFalse);
      expect(afterUndo.tandaContributions.first.paidAt, isNull);
      expect(afterUndo.tandaContributions.first.linkedTransactionId, isNull);
    } finally {
      await repository?.close();
      await directory.delete(recursive: true);
    }
  });

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

  test('migrates version 1 to version 6 without deleting legacy data',
      () async {
    final tempDirectory = await Directory.systemTemp.createTemp(
      'app_finance_migration_test_',
    );
    final databaseFile = File('${tempDirectory.path}/migration.sqlite');
    AppDatabase? database;

    try {
      database = AppDatabase.forTesting(
        NativeDatabase(
          databaseFile,
          setup: (sqlite) {
            if (sqlite.userVersion == 0) {
              sqlite.execute(
                'CREATE TABLE app_settings (key TEXT NOT NULL PRIMARY KEY, value TEXT NOT NULL)',
              );
              sqlite.execute(
                "INSERT INTO app_settings (key, value) VALUES ('legacy', 'preserved')",
              );
              sqlite.userVersion = 1;
            }
          },
        ),
      );

      final legacy = await database
          .customSelect(
            "SELECT value FROM app_settings WHERE key = 'legacy'",
          )
          .getSingle();
      final tandaRows = await database.select(database.tandas).get();

      expect(database.schemaVersion, 6);
      expect(legacy.read<String>('value'), 'preserved');
      expect(tandaRows, isEmpty);
    } finally {
      await database?.close();
      await tempDirectory.delete(recursive: true);
    }
  });

  test('migrates version 5 to 6 leaving card transaction columns in null',
      () async {
    final tempDirectory = await Directory.systemTemp.createTemp(
      'app_finance_migration_v5_test_',
    );
    final databaseFile = File('${tempDirectory.path}/migration.sqlite');
    AppDatabase? database;

    try {
      database = AppDatabase.forTesting(
        NativeDatabase(
          databaseFile,
          setup: (sqlite) {
            if (sqlite.userVersion != 0) return;
            sqlite.execute('''
              CREATE TABLE transactions (
                id TEXT NOT NULL PRIMARY KEY,
                title TEXT NOT NULL,
                amount REAL NOT NULL,
                category TEXT NOT NULL,
                date INTEGER NOT NULL,
                type TEXT NOT NULL
              )
            ''');
            sqlite.execute('''
              INSERT INTO transactions VALUES (
                'legacy-tx', 'Super', 250, 'Comida', 1783641600, 'expense'
              )
            ''');
            sqlite.userVersion = 5;
          },
        ),
      );

      final rows = await database.select(database.transactions).get();
      expect(database.schemaVersion, 6);
      expect(rows, hasLength(1));
      expect(rows.single.creditCardId, isNull);
      expect(rows.single.cardTransactionKind, isNull);
    } finally {
      await database?.close();
      await tempDirectory.delete(recursive: true);
    }
  });

  test('stores and reloads linked purchase and payment transactions', () async {
    final tempDirectory = await Directory.systemTemp.createTemp(
      'app_finance_card_tx_repository_test_',
    );
    final databaseFile = File('${tempDirectory.path}/app_finance.sqlite');
    FinanceRepository? repository;

    try {
      repository = FinanceRepository(
        AppDatabase.forTesting(NativeDatabase(databaseFile)),
      );
      final snapshot = FinanceSnapshot(
        monthlyIncome: 0,
        categories: const [
          BudgetCategory(
            id: 'cat-food',
            title: 'Comida',
            limit: 1000,
            spent: 200,
            color: Color(0xFF00AA00),
          ),
        ],
        transactions: [
          TransactionEntry(
            id: 'purchase-tx',
            title: 'Super',
            amount: 200,
            category: 'Comida',
            date: DateTime(2026, 7, 10),
            type: TransactionType.expense,
            creditCardId: 'card-primary',
            cardTransactionKind: CardTransactionKind.purchase,
          ),
          TransactionEntry(
            id: 'payment-tx',
            title: 'Pago a Tarjeta principal',
            amount: 150,
            category: FinanceState.cardPaymentCategoryTitle,
            date: DateTime(2026, 7, 11),
            type: TransactionType.cardPayment,
            creditCardId: 'card-primary',
            cardTransactionKind: CardTransactionKind.payment,
          ),
        ],
        plannedExpenses: const [],
        creditCards: const [
          CreditCard(
            id: 'card-primary',
            name: 'Tarjeta principal',
            creditLimit: 10000,
            usedBalance: 4050,
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

      await repository.saveSnapshot(snapshot);
      await repository.close();

      repository = FinanceRepository(
        AppDatabase.forTesting(NativeDatabase(databaseFile)),
      );
      final actual = await repository.loadSnapshot();
      expect(actual.transactions, hasLength(2));
      expect(actual.transactions.first.creditCardId, 'card-primary');
      expect(
        actual.transactions.first.cardTransactionKind,
        CardTransactionKind.payment,
      );
      expect(actual.transactions.last.creditCardId, 'card-primary');
      expect(
        actual.transactions.last.cardTransactionKind,
        CardTransactionKind.purchase,
      );
    } finally {
      await repository?.close();
      await tempDirectory.delete(recursive: true);
    }
  });

  test('reopening state does not reapply linked transactions to used balance',
      () async {
    final tempDirectory = await Directory.systemTemp.createTemp(
      'app_finance_card_tx_reopen_test_',
    );
    final databaseFile = File('${tempDirectory.path}/app_finance.sqlite');
    FinanceRepository? repository;

    try {
      repository = FinanceRepository(
        AppDatabase.forTesting(NativeDatabase(databaseFile)),
      );
      final snapshot = FinanceSnapshot(
        monthlyIncome: 0,
        categories: const [
          BudgetCategory(
            id: 'cat-food',
            title: 'Comida',
            limit: 1000,
            spent: 200,
            color: Color(0xFF00AA00),
          ),
        ],
        transactions: [
          TransactionEntry(
            id: 'purchase-tx',
            title: 'Super',
            amount: 200,
            category: 'Comida',
            date: DateTime(2026, 7, 10),
            type: TransactionType.expense,
            creditCardId: 'card-primary',
            cardTransactionKind: CardTransactionKind.purchase,
          ),
        ],
        plannedExpenses: const [],
        creditCards: const [
          CreditCard(
            id: 'card-primary',
            name: 'Tarjeta principal',
            creditLimit: 10000,
            usedBalance: 5000,
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

      await repository.saveSnapshot(snapshot);
      await repository.close();

      repository = FinanceRepository(
        AppDatabase.forTesting(NativeDatabase(databaseFile)),
      );
      final reopened = FinanceState(repository: repository);
      await reopened.initialize();
      expect(reopened.creditCards.single.usedBalance, 5000);
      expect(reopened.transactions.single.creditCardId, 'card-primary');
      reopened.dispose();
    } finally {
      await repository?.close();
      await tempDirectory.delete(recursive: true);
    }
  });

  test('migrates version 2 counter into individual contributions', () async {
    final directory = await Directory.systemTemp.createTemp('tanda_v2_');
    final file = File('${directory.path}/migration.sqlite');
    AppDatabase? database;
    try {
      database = AppDatabase.forTesting(
        NativeDatabase(
          file,
          setup: (sqlite) {
            if (sqlite.userVersion != 0) return;
            sqlite.execute('''
              CREATE TABLE tandas (
                id TEXT NOT NULL PRIMARY KEY,
                name TEXT NOT NULL,
                contribution_amount REAL NOT NULL,
                frequency TEXT NOT NULL,
                start_date INTEGER NOT NULL,
                participant_count INTEGER NOT NULL,
                assigned_turn INTEGER NOT NULL,
                completed_contributions INTEGER NOT NULL,
                status TEXT NOT NULL,
                notes TEXT NULL,
                created_at INTEGER NOT NULL
              )
            ''');
            sqlite.execute('''
              INSERT INTO tandas VALUES (
                'legacy-tanda', 'Legada', 1000, 'monthly',
                1769835600, 4, 2, 2, 'active', NULL, 1752987600
              )
            ''');
            sqlite.userVersion = 2;
          },
        ),
      );
      final contributions = await (database.select(database.tandaContributions)
            ..orderBy([(table) => OrderingTerm.asc(table.sequenceNumber)]))
          .get();
      expect(contributions, hasLength(4));
      expect(
        contributions.take(2).every((item) => item.status == 'paid'),
        isTrue,
      );
      expect(
        contributions.take(2).every(
              (item) => item.migratedFromLegacyCounter && item.paidAt == null,
            ),
        isTrue,
      );
      expect(
        contributions.skip(2).every((item) => item.status == 'pending'),
        isTrue,
      );
      expect(
        contributions.map((item) => item.sequenceNumber).toSet(),
        hasLength(4),
      );
    } finally {
      await database?.close();
      await directory.delete(recursive: true);
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
    tandas: [
      Tanda(
        id: 'tanda-office',
        name: 'Oficina',
        contributionAmount: 1000,
        frequency: TandaFrequency.biweekly,
        startDate: DateTime(2026, 8, 1),
        participantCount: 10,
        assignedTurn: 4,
        completedContributions: 3,
        status: TandaStatus.active,
        notes: 'Cada quincena',
        createdAt: DateTime(2026, 7, 20),
      ),
    ],
    tandaContributions: List.generate(10, (index) {
      final sequence = index + 1;
      final paid = sequence <= 3;
      return TandaContribution(
        id: 'tanda-office-contribution-$sequence',
        tandaId: 'tanda-office',
        sequenceNumber: sequence,
        amount: 1000,
        scheduledDate: DateTime(2026, 8, 1 + (index * 15)),
        status: paid
            ? TandaContributionStatus.paid
            : TandaContributionStatus.pending,
        paidAt: paid ? DateTime(2026, 8, 2 + index) : null,
        createdAt: DateTime(2026, 7, 20),
      );
    }),
    tandaReceipts: [
      TandaReceipt(
        id: receiptIdForTanda('tanda-office'),
        tandaId: 'tanda-office',
        amount: 10000,
        scheduledDate: DateTime(2026, 9, 15),
        status: TandaReceiptStatus.pending,
        receivedAt: null,
        createdAt: DateTime(2026, 7, 20),
      ),
    ],
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

  expect(actual.tandas, hasLength(1));
  final tanda = actual.tandas.single;
  expect(tanda.id, 'tanda-office');
  expect(tanda.name, 'Oficina');
  expect(tanda.contributionAmount, 1000);
  expect(tanda.frequency, TandaFrequency.biweekly);
  expect(tanda.startDate, DateTime(2026, 8, 1));
  expect(tanda.participantCount, 10);
  expect(tanda.assignedTurn, 4);
  expect(tanda.completedContributions, 3);
  expect(tanda.status, TandaStatus.active);
  expect(tanda.notes, 'Cada quincena');
  expect(tanda.createdAt, DateTime(2026, 7, 20));
  expect(tanda.totalExpectedAmount, 10000);
  expect(actual.tandaContributions, hasLength(10));
  final paid = actual.tandaContributions.where((item) => item.isPaid).toList();
  expect(paid, hasLength(3));
  expect(paid.first.paidAt, DateTime(2026, 8, 2));
  expect(actual.tandaContributions.first.amount, 1000);
  expect(actual.tandaContributions.first.sequenceNumber, 1);
  expect(
    actual.tandaContributions.every((item) => item.linkedTransactionId == null),
    isTrue,
  );
  expect(actual.tandaReceipts, hasLength(1));
  expect(actual.tandaReceipts.single.amount, 10000);
  expect(actual.tandaReceipts.single.status, TandaReceiptStatus.pending);
}
