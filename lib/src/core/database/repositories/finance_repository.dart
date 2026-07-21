import 'package:drift/drift.dart';
import 'package:flutter/material.dart' hide Table;

import '../../../features/budgets/domain/budget_category.dart' as domain;
import '../../../features/budgets/domain/monthly_extra.dart' as domain;
import '../../../features/cards/domain/credit_card.dart' as domain;
import '../../../features/cards/domain/credit_card_monthly_payment.dart'
    as domain;
import '../../../features/cards/domain/credit_card_purchase.dart' as domain;
import '../../../features/dashboard/domain/surplus_plan.dart' as domain;
import '../../../features/planning/domain/planned_expense.dart' as domain;
import '../../../features/subscriptions/domain/subscription_entry.dart'
    as domain;
import '../../../features/tasks/domain/financial_task.dart' as domain;
import '../../../features/transactions/domain/transaction_entry.dart' as domain;
import '../../../features/tandas/domain/tanda.dart' as domain;
import '../../../features/tandas/domain/tanda_contribution.dart' as domain;
import '../../../features/tandas/domain/tanda_receipt.dart' as domain;
import '../app_database.dart' as db;
import '../finance_snapshot.dart';
import '../seed/initial_finance_seed.dart';

abstract interface class FinanceStorage {
  Future<FinanceSnapshot> loadSnapshot();

  Future<void> saveSnapshot(FinanceSnapshot snapshot);
}

class FinanceRepository implements FinanceStorage {
  FinanceRepository(this._db);

  final db.AppDatabase _db;

  static const _monthlyIncomeKey = 'monthly_income';
  static const _seededKey = 'seeded';
  static const _surplusPlanId = 'current';

  @override
  Future<FinanceSnapshot> loadSnapshot() async {
    final seeded = await (_db.select(_db.appSettings)
          ..where((setting) => setting.key.equals(_seededKey)))
        .getSingleOrNull();

    if (seeded == null) {
      final seed = initialFinanceSeed();
      await saveSnapshot(seed);
      return seed;
    }

    final settings = await _db.select(_db.appSettings).get();
    final settingsByKey = {
      for (final setting in settings) setting.key: setting,
    };
    final monthlyIncome = double.tryParse(
          settingsByKey[_monthlyIncomeKey]?.value ?? '',
        ) ??
        initialFinanceSeed().monthlyIncome;
    final surplusPlanRow = await (_db.select(_db.surplusPlans)
          ..where((plan) => plan.id.equals(_surplusPlanId)))
        .getSingleOrNull();

    final overrides = await _db.select(_db.financialTaskOverrides).get();

    return FinanceSnapshot(
      monthlyIncome: monthlyIncome,
      categories: (await _db.select(_db.budgetCategories).get())
          .map(_categoryFromRow)
          .toList(),
      transactions: (await (_db.select(_db.transactions)
                ..orderBy([
                  (table) => OrderingTerm(
                        expression: table.date,
                        mode: OrderingMode.desc,
                      ),
                ]))
              .get())
          .map(_transactionFromRow)
          .toList(),
      plannedExpenses: (await _db.select(_db.plannedExpenses).get())
          .map(_plannedExpenseFromRow)
          .toList(),
      creditCards:
          (await _db.select(_db.creditCards).get()).map(_cardFromRow).toList(),
      creditCardPurchases: (await (_db.select(_db.creditCardPurchases)
                ..orderBy([
                  (table) => OrderingTerm(
                        expression: table.date,
                        mode: OrderingMode.desc,
                      ),
                ]))
              .get())
          .map(_purchaseFromRow)
          .toList(),
      subscriptions: (await _db.select(_db.subscriptions).get())
          .map(_subscriptionFromRow)
          .toList(),
      cardMonthlyPayments:
          (await _db.select(_db.creditCardMonthlyPayments).get())
              .map(_cardMonthlyPaymentFromRow)
              .toList(),
      monthlyExtras: (await _db.select(_db.monthlyExtras).get())
          .map(_monthlyExtraFromRow)
          .toList(),
      surplusPlan: surplusPlanRow == null
          ? const domain.SurplusPlan(type: domain.SurplusPlanType.balanced)
          : _surplusPlanFromRow(surplusPlanRow),
      manualTasks: (await _db.select(_db.financialTasks).get())
          .map(_financialTaskFromRow)
          .toList(),
      taskOverrides: {
        for (final override in overrides)
          override.taskId: _financialTaskOverrideFromRow(override),
      },
      tandas: (await _db.select(_db.tandas).get()).map(_tandaFromRow).toList(),
      tandaContributions: (await (_db.select(_db.tandaContributions)
                ..orderBy([
                  (table) => OrderingTerm(expression: table.tandaId),
                  (table) => OrderingTerm(expression: table.sequenceNumber),
                ]))
              .get())
          .map(_tandaContributionFromRow)
          .toList(),
      tandaReceipts: (await _db.select(_db.tandaReceipts).get())
          .map(_tandaReceiptFromRow)
          .toList(),
    );
  }

  @override
  Future<void> saveSnapshot(FinanceSnapshot snapshot) {
    _validateTandaConsistency(snapshot);
    return _db.transaction(() async {
      await _db.batch((batch) {
        batch.deleteAll(_db.appSettings);
        batch.deleteAll(_db.budgetCategories);
        batch.deleteAll(_db.transactions);
        batch.deleteAll(_db.plannedExpenses);
        batch.deleteAll(_db.creditCards);
        batch.deleteAll(_db.creditCardPurchases);
        batch.deleteAll(_db.subscriptions);
        batch.deleteAll(_db.creditCardMonthlyPayments);
        batch.deleteAll(_db.monthlyExtras);
        batch.deleteAll(_db.surplusPlans);
        batch.deleteAll(_db.financialTasks);
        batch.deleteAll(_db.financialTaskOverrides);
        batch.deleteAll(_db.tandaContributions);
        batch.deleteAll(_db.tandaReceipts);
        batch.deleteAll(_db.tandas);
        batch.insertAll(_db.appSettings, [
          db.AppSettingsCompanion.insert(
            key: _monthlyIncomeKey,
            value: snapshot.monthlyIncome.toString(),
          ),
          db.AppSettingsCompanion.insert(key: _seededKey, value: 'true'),
        ]);
        batch.insertAll(
          _db.budgetCategories,
          snapshot.categories.map(_categoryToCompanion),
        );
        batch.insertAll(
          _db.transactions,
          snapshot.transactions.map(_transactionToCompanion),
        );
        batch.insertAll(
          _db.plannedExpenses,
          snapshot.plannedExpenses.map(_plannedExpenseToCompanion),
        );
        batch.insertAll(
          _db.creditCards,
          snapshot.creditCards.map(_cardToCompanion),
        );
        batch.insertAll(
          _db.creditCardPurchases,
          snapshot.creditCardPurchases.map(_purchaseToCompanion),
        );
        batch.insertAll(
          _db.subscriptions,
          snapshot.subscriptions.map(_subscriptionToCompanion),
        );
        batch.insertAll(
          _db.creditCardMonthlyPayments,
          snapshot.cardMonthlyPayments.map(_cardMonthlyPaymentToCompanion),
        );
        batch.insertAll(
          _db.monthlyExtras,
          snapshot.monthlyExtras.map(_monthlyExtraToCompanion),
        );
        batch.insert(
          _db.surplusPlans,
          _surplusPlanToCompanion(snapshot.surplusPlan),
        );
        batch.insertAll(
          _db.financialTasks,
          snapshot.manualTasks.map(_financialTaskToCompanion),
        );
        batch.insertAll(
          _db.financialTaskOverrides,
          snapshot.taskOverrides.entries.map((entry) {
            return _financialTaskOverrideToCompanion(entry.key, entry.value);
          }),
        );
        batch.insertAll(_db.tandas, snapshot.tandas.map(_tandaToCompanion));
        batch.insertAll(
          _db.tandaContributions,
          snapshot.tandaContributions.map(_tandaContributionToCompanion),
        );
        batch.insertAll(
          _db.tandaReceipts,
          snapshot.tandaReceipts.map(_tandaReceiptToCompanion),
        );
      });
    });
  }

  Future<void> saveMonthlyIncome(double amount) async {
    await _db.into(_db.appSettings).insertOnConflictUpdate(
          db.AppSettingsCompanion.insert(
            key: _monthlyIncomeKey,
            value: amount.toString(),
          ),
        );
    await _markSeeded();
  }

  Future<void> saveCategory(domain.BudgetCategory category) =>
      _upsert(_db.budgetCategories, _categoryToCompanion(category));

  Future<void> updateCategory(domain.BudgetCategory category) =>
      saveCategory(category);

  Future<void> deleteCategory(String id) {
    return (_db.delete(_db.budgetCategories)
          ..where((category) => category.id.equals(id)))
        .go();
  }

  Future<void> saveTransaction(domain.TransactionEntry transaction) =>
      _upsert(_db.transactions, _transactionToCompanion(transaction));

  Future<void> deleteTransaction(String id) {
    return (_db.delete(_db.transactions)
          ..where((transaction) => transaction.id.equals(id)))
        .go();
  }

  Future<void> saveCreditCard(domain.CreditCard card) =>
      _upsert(_db.creditCards, _cardToCompanion(card));

  Future<void> updateCreditCard(domain.CreditCard card) => saveCreditCard(card);

  Future<void> saveCreditCardPurchase(domain.CreditCardPurchase purchase) =>
      _upsert(_db.creditCardPurchases, _purchaseToCompanion(purchase));

  Future<void> updateCreditCardPurchase(domain.CreditCardPurchase purchase) =>
      saveCreditCardPurchase(purchase);

  Future<void> deleteCreditCardPurchase(String id) {
    return (_db.delete(_db.creditCardPurchases)
          ..where((purchase) => purchase.id.equals(id)))
        .go();
  }

  Future<void> saveSubscription(domain.SubscriptionEntry subscription) =>
      _upsert(_db.subscriptions, _subscriptionToCompanion(subscription));

  Future<void> updateSubscription(domain.SubscriptionEntry subscription) =>
      saveSubscription(subscription);

  Future<void> deleteSubscription(String id) {
    return (_db.delete(_db.subscriptions)
          ..where((subscription) => subscription.id.equals(id)))
        .go();
  }

  Future<void> saveMonthlyExtra(domain.MonthlyExtra extra) =>
      _upsert(_db.monthlyExtras, _monthlyExtraToCompanion(extra));

  Future<void> updateMonthlyExtra(domain.MonthlyExtra extra) =>
      saveMonthlyExtra(extra);

  Future<void> deleteMonthlyExtra(String id) {
    return (_db.delete(_db.monthlyExtras)
          ..where((extra) => extra.id.equals(id)))
        .go();
  }

  Future<void> saveSurplusPlan(domain.SurplusPlan surplusPlan) =>
      _upsert(_db.surplusPlans, _surplusPlanToCompanion(surplusPlan));

  Future<void> saveManualTask(domain.FinancialTask task) =>
      _upsert(_db.financialTasks, _financialTaskToCompanion(task));

  Future<void> updateManualTask(domain.FinancialTask task) =>
      saveManualTask(task);

  Future<void> deleteManualTask(String id) {
    return (_db.delete(_db.financialTasks)..where((task) => task.id.equals(id)))
        .go();
  }

  Future<void> saveTaskOverride(
    String id,
    domain.FinancialTaskOverride override,
  ) {
    return _upsert(
      _db.financialTaskOverrides,
      _financialTaskOverrideToCompanion(id, override),
    );
  }

  Future<void> saveCardMonthlyPayment(
    domain.CreditCardMonthlyPayment payment,
  ) =>
      _upsert(
        _db.creditCardMonthlyPayments,
        _cardMonthlyPaymentToCompanion(payment),
      );

  Future<void> deleteCardMonthlyPayment(String cardId) {
    return (_db.delete(_db.creditCardMonthlyPayments)
          ..where((payment) => payment.cardId.equals(cardId)))
        .go();
  }

  Future<void> close() => _db.close();

  Future<void> _markSeeded() {
    return _db.into(_db.appSettings).insertOnConflictUpdate(
          db.AppSettingsCompanion.insert(key: _seededKey, value: 'true'),
        );
  }

  Future<void> _upsert<T extends Table, D>(
    TableInfo<T, D> table,
    Insertable<D> companion,
  ) {
    return _db.into(table).insertOnConflictUpdate(companion);
  }

  db.BudgetCategoriesCompanion _categoryToCompanion(
    domain.BudgetCategory category,
  ) {
    return db.BudgetCategoriesCompanion.insert(
      id: category.id,
      title: category.title,
      limit: category.limit,
      spent: category.spent,
      colorValue: category.color.toARGB32(),
    );
  }

  domain.BudgetCategory _categoryFromRow(db.BudgetCategory row) {
    return domain.BudgetCategory(
      id: row.id,
      title: row.title,
      limit: row.limit,
      spent: row.spent,
      color: Color(row.colorValue),
    );
  }

  db.TransactionsCompanion _transactionToCompanion(
    domain.TransactionEntry transaction,
  ) {
    return db.TransactionsCompanion.insert(
      id: transaction.id,
      title: transaction.title,
      amount: transaction.amount,
      category: transaction.category,
      date: transaction.date,
      type: transaction.type.name,
    );
  }

  domain.TransactionEntry _transactionFromRow(db.Transaction row) {
    return domain.TransactionEntry(
      id: row.id,
      title: row.title,
      amount: row.amount,
      category: row.category,
      date: row.date,
      type: _enumValue(domain.TransactionType.values, row.type),
    );
  }

  db.PlannedExpensesCompanion _plannedExpenseToCompanion(
    domain.PlannedExpense expense,
  ) {
    return db.PlannedExpensesCompanion.insert(
      id: expense.id,
      title: expense.title,
      amount: expense.amount,
      group: expense.group,
      status: expense.status.name,
      paymentSource: Value(expense.paymentSource),
      note: Value(expense.note),
    );
  }

  domain.PlannedExpense _plannedExpenseFromRow(db.PlannedExpense row) {
    return domain.PlannedExpense(
      id: row.id,
      title: row.title,
      amount: row.amount,
      group: row.group,
      status: _enumValue(domain.PlannedExpenseStatus.values, row.status),
      paymentSource: row.paymentSource,
      note: row.note,
    );
  }

  db.CreditCardsCompanion _cardToCompanion(domain.CreditCard card) {
    return db.CreditCardsCompanion.insert(
      id: card.id,
      name: card.name,
      creditLimit: card.creditLimit,
      usedBalance: card.usedBalance,
      statementCutDay: card.statementCutDay,
    );
  }

  domain.CreditCard _cardFromRow(db.CreditCard row) {
    return domain.CreditCard(
      id: row.id,
      name: row.name,
      creditLimit: row.creditLimit,
      usedBalance: row.usedBalance,
      statementCutDay: row.statementCutDay,
    );
  }

  db.CreditCardPurchasesCompanion _purchaseToCompanion(
    domain.CreditCardPurchase purchase,
  ) {
    return db.CreditCardPurchasesCompanion.insert(
      id: purchase.id,
      cardId: purchase.cardId,
      title: purchase.title,
      amount: purchase.amount,
      installments: purchase.installments,
      paidInstallments: purchase.paidInstallments,
      date: Value(purchase.date),
      notes: Value(purchase.notes),
    );
  }

  domain.CreditCardPurchase _purchaseFromRow(db.CreditCardPurchase row) {
    return domain.CreditCardPurchase(
      id: row.id,
      cardId: row.cardId,
      title: row.title,
      amount: row.amount,
      installments: row.installments,
      paidInstallments: row.paidInstallments,
      date: row.date,
      notes: row.notes,
    );
  }

  db.SubscriptionsCompanion _subscriptionToCompanion(
    domain.SubscriptionEntry subscription,
  ) {
    return db.SubscriptionsCompanion.insert(
      id: subscription.id,
      name: subscription.name,
      amount: subscription.amount,
      cardId: subscription.cardId,
    );
  }

  domain.SubscriptionEntry _subscriptionFromRow(db.Subscription row) {
    return domain.SubscriptionEntry(
      id: row.id,
      name: row.name,
      amount: row.amount,
      cardId: row.cardId,
    );
  }

  db.CreditCardMonthlyPaymentsCompanion _cardMonthlyPaymentToCompanion(
    domain.CreditCardMonthlyPayment payment,
  ) {
    return db.CreditCardMonthlyPaymentsCompanion.insert(
      cardId: payment.cardId,
      manualAmount: Value(payment.manualAmount),
      confirmedAmount: Value(payment.confirmedAmount),
    );
  }

  domain.CreditCardMonthlyPayment _cardMonthlyPaymentFromRow(
    db.CreditCardMonthlyPayment row,
  ) {
    return domain.CreditCardMonthlyPayment(
      cardId: row.cardId,
      manualAmount: row.manualAmount,
      confirmedAmount: row.confirmedAmount,
    );
  }

  db.MonthlyExtrasCompanion _monthlyExtraToCompanion(
    domain.MonthlyExtra extra,
  ) {
    return db.MonthlyExtrasCompanion.insert(
      id: extra.id,
      name: extra.name,
      amount: extra.amount,
      status: extra.status.name,
      includedInPlan: extra.includedInPlan,
      person: Value(extra.person),
      notes: Value(extra.notes),
    );
  }

  domain.MonthlyExtra _monthlyExtraFromRow(db.MonthlyExtra row) {
    return domain.MonthlyExtra(
      id: row.id,
      name: row.name,
      amount: row.amount,
      status: _enumValue(domain.MonthlyExtraStatus.values, row.status),
      includedInPlan: row.includedInPlan,
      person: row.person,
      notes: row.notes,
    );
  }

  db.SurplusPlansCompanion _surplusPlanToCompanion(
    domain.SurplusPlan surplusPlan,
  ) {
    return db.SurplusPlansCompanion.insert(
      id: _surplusPlanId,
      type: surplusPlan.type.name,
      manualSafetyNet: Value(surplusPlan.manualSafetyNet),
      manualInvestment: Value(surplusPlan.manualInvestment),
      manualFreeUse: Value(surplusPlan.manualFreeUse),
    );
  }

  domain.SurplusPlan _surplusPlanFromRow(db.SurplusPlan row) {
    return domain.SurplusPlan(
      type: _enumValue(domain.SurplusPlanType.values, row.type),
      manualSafetyNet: row.manualSafetyNet,
      manualInvestment: row.manualInvestment,
      manualFreeUse: row.manualFreeUse,
    );
  }

  db.FinancialTasksCompanion _financialTaskToCompanion(
    domain.FinancialTask task,
  ) {
    return db.FinancialTasksCompanion.insert(
      id: task.id,
      title: task.title,
      amount: task.amount,
      type: task.type.name,
      status: task.status.name,
      createdAt: task.createdAt,
      actualAmount: Value(task.actualAmount),
      dueDate: Value(task.dueDate),
      sourceId: Value(task.sourceId),
      sourceType: Value(task.sourceType?.name),
      notes: Value(task.notes),
      completedAt: Value(task.completedAt),
    );
  }

  domain.FinancialTask _financialTaskFromRow(db.FinancialTask row) {
    return domain.FinancialTask(
      id: row.id,
      title: row.title,
      amount: row.amount,
      type: _enumValue(domain.FinancialTaskType.values, row.type),
      status: _enumValue(domain.FinancialTaskStatus.values, row.status),
      createdAt: row.createdAt,
      actualAmount: row.actualAmount,
      dueDate: row.dueDate,
      sourceId: row.sourceId,
      sourceType: row.sourceType == null
          ? null
          : _enumValue(domain.FinancialTaskSourceType.values, row.sourceType!),
      notes: row.notes,
      completedAt: row.completedAt,
    );
  }

  db.FinancialTaskOverridesCompanion _financialTaskOverrideToCompanion(
    String id,
    domain.FinancialTaskOverride override,
  ) {
    return db.FinancialTaskOverridesCompanion.insert(
      taskId: id,
      title: Value(override.title),
      amount: Value(override.amount),
      status: Value(override.status?.name),
      actualAmount: Value(override.actualAmount),
      dueDate: Value(override.dueDate),
      notes: Value(override.notes),
      completedAt: Value(override.completedAt),
    );
  }

  domain.FinancialTaskOverride _financialTaskOverrideFromRow(
    db.FinancialTaskOverride row,
  ) {
    return domain.FinancialTaskOverride(
      title: row.title,
      amount: row.amount,
      status: row.status == null
          ? null
          : _enumValue(domain.FinancialTaskStatus.values, row.status!),
      actualAmount: row.actualAmount,
      dueDate: row.dueDate,
      notes: row.notes,
      completedAt: row.completedAt,
    );
  }

  db.TandasCompanion _tandaToCompanion(domain.Tanda tanda) {
    return db.TandasCompanion.insert(
      id: tanda.id,
      name: tanda.name,
      contributionAmount: tanda.contributionAmount,
      frequency: tanda.frequency.name,
      startDate: tanda.startDate,
      participantCount: tanda.participantCount,
      assignedTurn: tanda.assignedTurn,
      completedContributions: tanda.completedContributions,
      status: tanda.status.name,
      notes: Value(tanda.notes),
      createdAt: tanda.createdAt,
    );
  }

  domain.Tanda _tandaFromRow(db.Tanda row) {
    return domain.Tanda(
      id: row.id,
      name: row.name,
      contributionAmount: row.contributionAmount,
      frequency: _enumValue(domain.TandaFrequency.values, row.frequency),
      startDate: row.startDate,
      participantCount: row.participantCount,
      assignedTurn: row.assignedTurn,
      completedContributions: row.completedContributions,
      status: _enumValue(domain.TandaStatus.values, row.status),
      notes: row.notes,
      createdAt: row.createdAt,
    );
  }

  db.TandaContributionsCompanion _tandaContributionToCompanion(
    domain.TandaContribution contribution,
  ) {
    return db.TandaContributionsCompanion.insert(
      id: contribution.id,
      tandaId: contribution.tandaId,
      sequenceNumber: contribution.sequenceNumber,
      amount: contribution.amount,
      scheduledDate: contribution.scheduledDate,
      status: contribution.status.name,
      paidAt: Value(contribution.paidAt),
      createdAt: contribution.createdAt,
      migratedFromLegacyCounter: Value(contribution.migratedFromLegacyCounter),
      notes: Value(contribution.notes),
      linkedTransactionId: Value(contribution.linkedTransactionId),
    );
  }

  domain.TandaContribution _tandaContributionFromRow(
    db.TandaContribution row,
  ) {
    return domain.TandaContribution(
      id: row.id,
      tandaId: row.tandaId,
      sequenceNumber: row.sequenceNumber,
      amount: row.amount,
      scheduledDate: row.scheduledDate,
      status: _enumValue(
        domain.TandaContributionStatus.values,
        row.status,
      ),
      paidAt: row.paidAt,
      createdAt: row.createdAt,
      migratedFromLegacyCounter: row.migratedFromLegacyCounter,
      notes: row.notes,
      linkedTransactionId: row.linkedTransactionId,
    );
  }

  db.TandaReceiptsCompanion _tandaReceiptToCompanion(
    domain.TandaReceipt receipt,
  ) {
    return db.TandaReceiptsCompanion.insert(
      id: receipt.id,
      tandaId: receipt.tandaId,
      amount: receipt.amount,
      scheduledDate: receipt.scheduledDate,
      status: receipt.status.name,
      receivedAt: Value(receipt.receivedAt),
      linkedTransactionId: Value(receipt.linkedTransactionId),
      createdAt: receipt.createdAt,
      notes: Value(receipt.notes),
    );
  }

  domain.TandaReceipt _tandaReceiptFromRow(db.TandaReceipt row) {
    return domain.TandaReceipt(
      id: row.id,
      tandaId: row.tandaId,
      amount: row.amount,
      scheduledDate: row.scheduledDate,
      status: _enumValue(domain.TandaReceiptStatus.values, row.status),
      receivedAt: row.receivedAt,
      linkedTransactionId: row.linkedTransactionId,
      createdAt: row.createdAt,
      notes: row.notes,
    );
  }

  void _validateTandaConsistency(FinanceSnapshot snapshot) {
    final tandaIds = snapshot.tandas.map((item) => item.id).toSet();
    for (final contribution in snapshot.tandaContributions) {
      if (!tandaIds.contains(contribution.tandaId)) {
        throw StateError('Una aportacion no puede quedar sin tanda.');
      }
    }
    final receiptTandaIds = <String>{};
    for (final receipt in snapshot.tandaReceipts) {
      if (!tandaIds.contains(receipt.tandaId)) {
        throw StateError('Una recepcion no puede quedar sin tanda.');
      }
      if (!receiptTandaIds.add(receipt.tandaId)) {
        throw StateError('Solo puede existir una recepcion por tanda.');
      }
    }
    if (receiptTandaIds.length != tandaIds.length) {
      throw StateError('Cada tanda debe tener exactamente una recepcion.');
    }
    for (final tanda in snapshot.tandas) {
      final contributions = snapshot.tandaContributions
          .where((item) => item.tandaId == tanda.id)
          .toList();
      final paid = contributions.where((item) => item.isPaid).length;
      if (contributions.length != tanda.participantCount ||
          paid != tanda.completedContributions) {
        throw StateError('El progreso de la tanda no esta sincronizado.');
      }
    }
  }

  T _enumValue<T extends Enum>(List<T> values, String name) {
    return values.firstWhere((value) => value.name == name);
  }
}
