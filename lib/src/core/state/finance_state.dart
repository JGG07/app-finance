import 'package:flutter/material.dart';

import '../database/finance_snapshot.dart';
import '../database/repositories/finance_repository.dart';
import '../database/seed/initial_finance_seed.dart';
import '../domain/finance_period.dart';
import '../../features/budgets/domain/budget_category.dart';
import '../../features/budgets/domain/monthly_extra.dart';
import '../../features/cards/domain/credit_card.dart';
import '../../features/cards/domain/credit_card_monthly_payment.dart';
import '../../features/cards/domain/credit_card_purchase.dart';
import '../../features/dashboard/domain/surplus_plan.dart';
import '../../features/planning/domain/planned_expense.dart';
import '../../features/subscriptions/domain/subscription_entry.dart';
import '../../features/tasks/domain/financial_task.dart';
import '../../features/transactions/domain/transaction_entry.dart';

class FinanceState extends ChangeNotifier {
  FinanceState({FinanceStorage? repository})
      : _repository = repository,
        _isInitialized = repository == null {
    _applySnapshot(initialFinanceSeed());
  }

  final FinanceStorage? _repository;

  late double _monthlyIncome;
  late List<BudgetCategory> _categories;
  late List<TransactionEntry> _transactions;
  late List<PlannedExpense> _plannedExpenses;
  late List<CreditCard> _creditCards;
  late List<CreditCardPurchase> _creditCardPurchases;
  late List<SubscriptionEntry> _subscriptions;
  late List<CreditCardMonthlyPayment> _cardMonthlyPayments;
  late List<MonthlyExtra> _monthlyExtras;
  late SurplusPlan _surplusPlan;
  late List<FinancialTask> _manualTasks;
  late Map<String, FinancialTaskOverride> _taskOverrides;
  Future<void>? _initialization;
  Future<void> _pendingSave = Future.value();
  bool _isLoading = false;
  bool _isInitialized;
  bool _isRetryingSave = false;
  bool _isDisposed = false;
  String? _loadError;
  String? _saveError;
  FinancePeriod _selectedPeriod = FinancePeriod.current();

  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  bool get isRetryingSave => _isRetryingSave;
  String? get loadError => _loadError;
  String? get saveError => _saveError;
  double get monthlyIncome => _monthlyIncome;
  FinancePeriod get selectedPeriod => _selectedPeriod;
  List<BudgetCategory> get categories => List.unmodifiable(
        _categories.map((category) {
          if (category.isProtected) {
            return category.copyWith(
              limit: antExpenseLimit,
              spent: antExpenseSpent,
            );
          }
          final categoryTitle = _normalizeCategoryName(category.title);
          final utilized = _transactions.where((transaction) {
            return transaction.type == TransactionType.expense &&
                _normalizeCategoryName(transaction.category) == categoryTitle;
          }).fold(0.0, (sum, transaction) => sum + transaction.amount);
          return category.copyWith(spent: utilized);
        }),
      );
  List<TransactionEntry> get transactions => List.unmodifiable(_transactions);
  List<TransactionEntry> get transactionsForSelectedPeriod => List.unmodifiable(
        _transactions.where(
          (transaction) => _selectedPeriod.contains(transaction.date),
        ),
      );
  List<PlannedExpense> get plannedExpenses =>
      List.unmodifiable(_plannedExpenses);
  List<CreditCard> get creditCards => List.unmodifiable(_creditCards);
  List<CreditCardPurchase> get creditCardPurchases =>
      List.unmodifiable(_creditCardPurchases);
  List<SubscriptionEntry> get subscriptions =>
      List.unmodifiable(_subscriptions);
  List<CreditCardMonthlyPayment> get cardMonthlyPayments =>
      List.unmodifiable(_cardMonthlyPayments);
  List<MonthlyExtra> get monthlyExtras => List.unmodifiable(_monthlyExtras);
  SurplusPlan get surplusPlan => _surplusPlan;
  List<FinancialTask> get manualTasks => List.unmodifiable(_manualTasks);

  Future<void> initialize() {
    final repository = _repository;
    if (repository == null) {
      return Future.value();
    }
    if (_isLoading) {
      return _initialization ?? Future.value();
    }

    _isLoading = true;
    _loadError = null;
    _notifyIfActive();

    final initialization = _loadSnapshot(repository);
    _initialization = initialization;
    return initialization;
  }

  Future<void> _loadSnapshot(FinanceStorage repository) async {
    try {
      final snapshot = await repository.loadSnapshot();
      _applySnapshot(snapshot);
      _isInitialized = true;
      _loadError = null;
    } catch (error) {
      _loadError = error.toString();
    } finally {
      _isLoading = false;
      _notifyIfActive();
    }
  }

  Future<void> flushPendingSaves() async {
    final initialization = _initialization;
    if (initialization != null) {
      await initialization;
    }
    while (true) {
      final pendingSave = _pendingSave;
      await pendingSave;
      if (identical(pendingSave, _pendingSave)) {
        return;
      }
    }
  }

  Future<void> retrySave() async {
    final repository = _repository;
    if (repository == null || _isRetryingSave) {
      return;
    }

    _isRetryingSave = true;
    _notifyIfActive();

    try {
      await _enqueueSave(repository, _snapshot());
    } finally {
      _isRetryingSave = false;
      _notifyIfActive();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  List<FinancialTask> get monthlyFinancialTasks {
    final generated = _generatedFinancialTasks.map((task) {
      return _taskOverrides[task.id]?.applyTo(task) ?? task;
    });

    return [
      ...generated,
      ..._manualTasks,
    ];
  }

  FinancialTaskProgress get financialTaskProgress {
    final tasks = monthlyFinancialTasks;
    final completed = tasks.where((task) {
      return task.status == FinancialTaskStatus.done;
    }).length;

    return FinancialTaskProgress(
      total: tasks.length,
      completed: completed,
    );
  }

  double get totalAllocated {
    return _categories.where((category) => !category.isProtected).fold(
          0,
          (sum, category) => sum + category.limit,
        );
  }

  /// Temporary classification: selected-period expenses whose normalized
  /// category name does not match any budgeted category.
  double get antExpensesForSelectedPeriod {
    return transactionsForSelectedPeriod.where(_isAntExpense).fold(
          0,
          (sum, transaction) => sum + transaction.amount,
        );
  }

  double get antExpenseSpent => antExpensesForSelectedPeriod;

  double get freeMoneyBeforeAntExpenses {
    final free = surplusPlanAllocation.freeUse;
    return free > 0 ? free : 0;
  }

  double get freeMoneyAfterAntExpenses {
    return freeMoneyBeforeAntExpenses - antExpensesForSelectedPeriod;
  }

  double get antExpensesPercentOfFreeMoney {
    return _safePercentage(
      antExpensesForSelectedPeriod,
      freeMoneyBeforeAntExpenses,
    );
  }

  double get antExpenseLimit => freeMoneyBeforeAntExpenses;

  double get freeUseAvailable => freeMoneyAfterAntExpenses;

  double get totalBudgeted => totalAllocated;

  double spentForCategoryInSelectedPeriod(BudgetCategory category) {
    if (category.isProtected) {
      return 0;
    }

    final categoryName = _normalizeCategoryName(category.title);
    return transactionsForSelectedPeriod.where((transaction) {
      return transaction.type == TransactionType.expense &&
          _normalizeCategoryName(transaction.category) == categoryName;
    }).fold(0, (sum, transaction) => sum + transaction.amount);
  }

  double availableForCategoryInSelectedPeriod(BudgetCategory category) {
    return category.limit - spentForCategoryInSelectedPeriod(category);
  }

  double get totalBudgetSpentForSelectedPeriod {
    return transactionsForSelectedPeriod.where(_isBudgetedExpense).fold(
          0,
          (sum, transaction) => sum + transaction.amount,
        );
  }

  double get totalBudgetAvailableForSelectedPeriod {
    return totalBudgeted - totalBudgetSpentForSelectedPeriod;
  }

  double get totalBudgetUtilized => totalBudgetSpentForSelectedPeriod;

  double get totalFree => freeMoneyAfterAntExpenses;

  double get antExpensePercentOfFree => antExpensesPercentOfFreeMoney;

  double get budgetUtilizationPercent {
    return _safePercentage(totalBudgetUtilized, totalBudgeted);
  }

  double get debtPaymentPercentOfIncome {
    return _safePercentage(totalMonthlyCardPayments, totalMonthlyIncome);
  }

  double get savingPercentOfSurplus {
    final allocation = surplusPlanAllocation;
    return _safePercentage(
      allocation.safetyNet + allocation.investment,
      realEstimatedSurplus,
    );
  }

  double get availableIncome => _monthlyIncome - totalAllocated;

  double get totalPlannedExpenses {
    return totalAllocated + totalMonthlyExtras + totalMonthlyCardPayments;
  }

  double get totalPendingPlannedExpenses {
    return _plannedExpenses
        .where((expense) => expense.affectsAvailableCash)
        .fold(0, (sum, expense) => sum + expense.amount);
  }

  double get availableAfterMonthlyPlan {
    return totalMonthlyIncome - totalPlannedExpenses;
  }

  double get totalMonthlyIncome {
    return _monthlyIncome + additionalIncludedIncome;
  }

  double get additionalIncludedIncome {
    return transactionsForSelectedPeriod
        .where((transaction) => transaction.type == TransactionType.income)
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }

  double get unplannedRegisteredExpenses {
    return antExpensesForSelectedPeriod;
  }

  double get realEstimatedSurplus {
    return totalMonthlyIncome -
        totalPlannedExpenses -
        unplannedRegisteredExpenses;
  }

  SurplusPlanAllocation get surplusPlanAllocation {
    return _surplusPlan.allocation(availableAfterMonthlyPlan);
  }

  double get totalMonthlyCardPayments {
    return _creditCards.fold(0, (sum, card) {
      return sum + cardMonthlyPaymentAmount(card.id);
    });
  }

  double get totalMonthlyExtras {
    return _monthlyExtras
        .where((extra) => extra.includedInPlan)
        .fold(0, (sum, extra) => sum + extra.amount);
  }

  double get totalSpent {
    return transactionsForSelectedPeriod
        .where((transaction) => transaction.type == TransactionType.expense)
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }

  double get totalExpenses => totalSpent;

  void selectPeriod(FinancePeriod period) {
    if (_selectedPeriod == period) {
      return;
    }

    _selectedPeriod = period;
    _notifyIfActive();
  }

  bool _isBudgetedExpense(TransactionEntry transaction) {
    if (transaction.type != TransactionType.expense) {
      return false;
    }

    final transactionCategory = _normalizeCategoryName(transaction.category);
    return _categories.any((category) {
      return !category.isProtected &&
          _normalizeCategoryName(category.title) == transactionCategory;
    });
  }

  bool _isAntExpense(TransactionEntry transaction) {
    return transaction.type == TransactionType.expense &&
        !_isBudgetedExpense(transaction);
  }

  // BudgetCategory.spent is retained for database compatibility, but monthly
  // budget figures are derived from transactionsForSelectedPeriod instead.
  String _normalizeCategoryName(String name) => name.trim().toLowerCase();

  double _safePercentage(double value, double total) {
    if (!value.isFinite || !total.isFinite || value <= 0 || total <= 0) {
      return 0;
    }
    return value / total * 100;
  }

  double get totalCreditCardDebt {
    return _creditCards.fold(0, (sum, card) => sum + card.usedBalance);
  }

  double get totalAvailableCredit {
    return _creditCards.fold(0, (sum, card) => sum + card.availableCredit);
  }

  double get totalMonthlyInstallmentPayments {
    return _creditCardPurchases.where((purchase) {
      return purchase.isInstallmentPurchase && !purchase.isCompleted;
    }).fold(0, (sum, purchase) => sum + purchase.monthlyPayment);
  }

  double get totalRemainingInstallmentAmount {
    return _creditCardPurchases
        .where((purchase) => purchase.isInstallmentPurchase)
        .fold(0, (sum, purchase) => sum + purchase.remainingAmount);
  }

  int get activeInstallmentPurchaseCount {
    return _creditCardPurchases.where((purchase) {
      return purchase.isInstallmentPurchase && !purchase.isCompleted;
    }).length;
  }

  double get totalMonthlySubscriptions {
    return _subscriptions.fold(0, (sum, subscription) {
      return sum + subscription.amount;
    });
  }

  List<FinancialTask> get _generatedFinancialTasks {
    final now = DateTime.now();
    final createdAt = DateTime(now.year, now.month);
    final dueDate = DateTime(now.year, now.month + 1, 0);
    final allocation = surplusPlanAllocation;

    return [
      ..._creditCards.map((card) {
        return FinancialTask(
          id: 'card-payment-${card.id}',
          title: 'Pagar ${_friendlyCardName(card.name)}',
          amount: cardMonthlyPaymentAmount(card.id),
          type: FinancialTaskType.cardPayment,
          status: FinancialTaskStatus.pending,
          dueDate: dueDate,
          sourceId: card.id,
          sourceType: FinancialTaskSourceType.card,
          createdAt: createdAt,
        );
      }),
      ..._monthlyExtras.where((extra) => extra.includedInPlan).map((extra) {
        return FinancialTask(
          id: 'apartado-${extra.id}',
          title: _extraTaskTitle(extra),
          amount: extra.amount,
          type: FinancialTaskType.apartado,
          status: extra.status == MonthlyExtraStatus.delivered ||
                  extra.status == MonthlyExtraStatus.paid
              ? FinancialTaskStatus.done
              : FinancialTaskStatus.pending,
          dueDate: dueDate,
          sourceId: extra.id,
          sourceType: FinancialTaskSourceType.apartado,
          notes: extra.notes,
          completedAt: extra.status == MonthlyExtraStatus.delivered ||
                  extra.status == MonthlyExtraStatus.paid
              ? now
              : null,
          createdAt: createdAt,
        );
      }),
      if (_surplusPlan.type != SurplusPlanType.none &&
          _surplusPlan.type != SurplusPlanType.unconfigured) ...[
        FinancialTask(
          id: 'surplus-safety-net',
          title: 'Guardar en colchon',
          amount: allocation.safetyNet,
          type: FinancialTaskType.saving,
          status: FinancialTaskStatus.pending,
          dueDate: dueDate,
          sourceId: 'safety-net',
          sourceType: FinancialTaskSourceType.surplusPlan,
          createdAt: createdAt,
        ),
        FinancialTask(
          id: 'surplus-investment',
          title: 'Invertir en CETES',
          amount: allocation.investment,
          type: FinancialTaskType.investment,
          status: FinancialTaskStatus.pending,
          dueDate: dueDate,
          sourceId: 'investment',
          sourceType: FinancialTaskSourceType.surplusPlan,
          createdAt: createdAt,
        ),
        FinancialTask(
          id: 'surplus-free-use',
          title: 'Separar uso libre',
          amount: allocation.freeUse,
          type: FinancialTaskType.freeUse,
          status: FinancialTaskStatus.pending,
          dueDate: dueDate,
          sourceId: 'free-use',
          sourceType: FinancialTaskSourceType.surplusPlan,
          createdAt: createdAt,
        ),
      ],
    ].where((task) => task.amount > 0).toList(growable: false);
  }

  List<CreditCardPurchase> purchasesForCard(String cardId) {
    return _creditCardPurchases
        .where((purchase) => purchase.cardId == cardId)
        .toList(growable: false);
  }

  List<CreditCardPurchase> installmentPurchasesForCard(String cardId) {
    return _creditCardPurchases.where((purchase) {
      return purchase.cardId == cardId && purchase.isInstallmentPurchase;
    }).toList(growable: false);
  }

  List<CreditCardPurchase> activeInstallmentPurchasesForCard(String cardId) {
    return _creditCardPurchases.where((purchase) {
      return purchase.cardId == cardId &&
          purchase.isInstallmentPurchase &&
          !purchase.isCompleted;
    }).toList(growable: false);
  }

  List<CreditCardPurchase> get activeInstallmentPurchases {
    return _creditCardPurchases.where((purchase) {
      return purchase.isInstallmentPurchase && !purchase.isCompleted;
    }).toList(growable: false);
  }

  List<CreditCardPurchase> get completedInstallmentPurchases {
    return _creditCardPurchases.where((purchase) {
      return purchase.isInstallmentPurchase && purchase.isCompleted;
    }).toList(growable: false);
  }

  List<SubscriptionEntry> subscriptionsForCard(String cardId) {
    return _subscriptions
        .where((subscription) => subscription.cardId == cardId)
        .toList(growable: false);
  }

  String creditCardName(String cardId) {
    for (final card in _creditCards) {
      if (card.id == cardId) {
        return card.name;
      }
    }

    return 'Sin tarjeta';
  }

  CreditCard? creditCardById(String cardId) {
    for (final card in _creditCards) {
      if (card.id == cardId) {
        return card;
      }
    }

    return null;
  }

  MonthlyExtra? monthlyExtraById(String id) {
    for (final extra in _monthlyExtras) {
      if (extra.id == id) {
        return extra;
      }
    }

    return null;
  }

  double estimatedCardMonthlyPayment(String cardId) {
    final usedBalance = creditCardById(cardId)?.usedBalance ?? 0;
    final installmentBalance = remainingInstallmentAmountForCard(cardId);

    return (usedBalance - installmentBalance)
        .clamp(0, double.infinity)
        .toDouble();
  }

  CreditCardMonthlyPayment cardMonthlyPaymentFor(String cardId) {
    for (final payment in _cardMonthlyPayments) {
      if (payment.cardId == cardId) {
        return payment;
      }
    }

    return CreditCardMonthlyPayment(cardId: cardId);
  }

  double cardMonthlyPaymentAmount(String cardId) {
    return baseCardMonthlyPaymentAmount(cardId) +
        monthlyInstallmentPaymentForCard(cardId);
  }

  double baseCardMonthlyPaymentAmount(String cardId) {
    final estimatedAmount = estimatedCardMonthlyPayment(cardId);
    return cardMonthlyPaymentFor(cardId).amount(estimatedAmount);
  }

  CreditCardPaymentSource cardMonthlyPaymentSource(String cardId) {
    final estimatedAmount = estimatedCardMonthlyPayment(cardId);
    return cardMonthlyPaymentFor(cardId).source(estimatedAmount);
  }

  double monthlyInstallmentPaymentForCard(String cardId) {
    return _creditCardPurchases.where((purchase) {
      return purchase.cardId == cardId &&
          purchase.isInstallmentPurchase &&
          !purchase.isCompleted;
    }).fold(0, (sum, purchase) => sum + purchase.monthlyPayment);
  }

  double remainingInstallmentAmountForCard(String cardId) {
    return _creditCardPurchases.where((purchase) {
      return purchase.cardId == cardId && purchase.isInstallmentPurchase;
    }).fold(0, (sum, purchase) => sum + purchase.remainingAmount);
  }

  void updateMonthlyIncome(double amount) {
    if (amount < 0) {
      return;
    }

    _monthlyIncome = amount;
    _persistAndNotify();
  }

  void updateSurplusPlan(SurplusPlanType type) {
    _surplusPlan = _surplusPlan.copyWith(
      type: type,
      clearManualAmounts: type != SurplusPlanType.custom,
    );
    _persistAndNotify();
  }

  void updateSurplusPlanAmounts({
    required double safetyNet,
    required double investment,
    required double freeUse,
  }) {
    if (safetyNet < 0 || investment < 0 || freeUse < 0) {
      return;
    }

    _surplusPlan = _surplusPlan.copyWith(
      type: SurplusPlanType.custom,
      manualSafetyNet: safetyNet,
      manualInvestment: investment,
      manualFreeUse: freeUse,
    );
    _persistAndNotify();
  }

  void addManualFinancialTask({
    required String title,
    required double amount,
    String? notes,
    DateTime? dueDate,
    FinancialTaskStatus status = FinancialTaskStatus.pending,
    double? actualAmount,
  }) {
    if (title.trim().isEmpty || amount < 0) {
      return;
    }

    _manualTasks.add(
      FinancialTask(
        id: 'manual-task-${DateTime.now().microsecondsSinceEpoch}',
        title: title.trim(),
        amount: amount,
        type: FinancialTaskType.manual,
        status: status,
        actualAmount:
            status == FinancialTaskStatus.partial ? actualAmount : null,
        dueDate: dueDate,
        sourceId: 'manual',
        sourceType: FinancialTaskSourceType.manual,
        notes: _blankToNull(notes),
        completedAt: status == FinancialTaskStatus.done ? DateTime.now() : null,
        createdAt: DateTime.now(),
      ),
    );
    _persistAndNotify();
  }

  void updateFinancialTask(
    String id, {
    String? title,
    double? amount,
    FinancialTaskStatus? status,
    double? actualAmount,
    DateTime? dueDate,
    String? notes,
  }) {
    final manualIndex = _manualTasks.indexWhere((task) => task.id == id);
    final nextStatus = status;
    final completedAt =
        nextStatus == FinancialTaskStatus.done ? DateTime.now() : null;

    if (manualIndex != -1) {
      final current = _manualTasks[manualIndex];
      _manualTasks[manualIndex] = current.copyWith(
        title: title,
        amount: amount,
        status: status,
        actualAmount: actualAmount,
        dueDate: dueDate,
        notes: _blankToNull(notes),
        completedAt: completedAt,
        clearActualAmount: nextStatus != FinancialTaskStatus.partial,
        clearCompletedAt: nextStatus != FinancialTaskStatus.done,
      );
      _persistAndNotify();
      return;
    }

    final current = _taskOverrides[id] ?? const FinancialTaskOverride();
    _taskOverrides[id] = current.copyWith(
      title: title,
      amount: amount,
      status: status,
      actualAmount: actualAmount,
      dueDate: dueDate,
      notes: _blankToNull(notes),
      completedAt: completedAt,
      clearActualAmount: nextStatus != FinancialTaskStatus.partial,
      clearNotes: notes != null && _blankToNull(notes) == null,
      clearCompletedAt: nextStatus != FinancialTaskStatus.done,
    );
    _persistAndNotify();
  }

  void updateFinancialTaskStatus(
    String id,
    FinancialTaskStatus status, {
    double? actualAmount,
  }) {
    updateFinancialTask(
      id,
      status: status,
      actualAmount: actualAmount,
    );
  }

  void deleteManualFinancialTask(String id) {
    _manualTasks.removeWhere((task) => task.id == id);
    _persistAndNotify();
  }

  void addCategory(String title, double limit, Color color) {
    final newCategory = BudgetCategory(
      id: 'cat-${DateTime.now().microsecondsSinceEpoch}',
      title: title,
      limit: limit,
      color: color,
    );

    _categories.add(newCategory);
    _persistAndNotify();
  }

  void addMonthlyExtra({
    required String name,
    required double amount,
    required MonthlyExtraStatus status,
    required bool includedInPlan,
    String? person,
    String? notes,
  }) {
    if (name.trim().isEmpty || amount <= 0) {
      return;
    }

    _monthlyExtras.add(
      MonthlyExtra(
        id: 'extra-${DateTime.now().microsecondsSinceEpoch}',
        name: name.trim(),
        amount: amount,
        status: status,
        includedInPlan: includedInPlan,
        person: _blankToNull(person),
        notes: _blankToNull(notes),
      ),
    );
    _persistAndNotify();
  }

  void updateMonthlyExtra(
    String id, {
    String? name,
    double? amount,
    MonthlyExtraStatus? status,
    bool? includedInPlan,
    String? person,
    String? notes,
  }) {
    final index = _monthlyExtras.indexWhere((extra) => extra.id == id);

    if (index == -1) {
      return;
    }

    final current = _monthlyExtras[index];
    _monthlyExtras[index] = MonthlyExtra(
      id: current.id,
      name: name ?? current.name,
      amount: amount ?? current.amount,
      status: status ?? current.status,
      includedInPlan: includedInPlan ?? current.includedInPlan,
      person: person == null ? current.person : _blankToNull(person),
      notes: notes == null ? current.notes : _blankToNull(notes),
    );
    _persistAndNotify();
  }

  void markMonthlyExtraDelivered(String id) {
    updateMonthlyExtra(id, status: MonthlyExtraStatus.delivered);
  }

  void deleteMonthlyExtra(String id) {
    _monthlyExtras.removeWhere((extra) => extra.id == id);
    _persistAndNotify();
  }

  void updateCategory(
    String id, {
    String? title,
    double? limit,
    Color? color,
  }) {
    final index = _categories.indexWhere((category) => category.id == id);

    if (index == -1) {
      return;
    }

    if (_categories[index].isProtected) {
      return;
    }

    final previousTitle = _categories[index].title;
    final nextTitle = title?.trim();
    _categories[index] = _categories[index].copyWith(
      title: nextTitle,
      limit: limit,
      color: color,
    );

    if (nextTitle != null &&
        nextTitle.isNotEmpty &&
        nextTitle.toLowerCase() != previousTitle.toLowerCase()) {
      _transactions = _transactions.map((transaction) {
        if (transaction.category.toLowerCase() != previousTitle.toLowerCase()) {
          return transaction;
        }

        return TransactionEntry(
          id: transaction.id,
          title: transaction.title,
          amount: transaction.amount,
          category: nextTitle,
          date: transaction.date,
          type: transaction.type,
        );
      }).toList();
    }
    _persistAndNotify();
  }

  void deleteCategory(String id) {
    if (id == BudgetCategory.antExpenseId) {
      return;
    }
    _categories.removeWhere((category) => category.id == id);
    _persistAndNotify();
  }

  void addTransaction({
    required String title,
    required double amount,
    required String categoryTitle,
    required TransactionType type,
    required DateTime date,
  }) {
    final newTransaction = TransactionEntry(
      id: 'tx-${DateTime.now().microsecondsSinceEpoch}',
      title: title,
      amount: amount,
      category: categoryTitle,
      date: date,
      type: type,
    );

    _transactions.insert(0, newTransaction);

    if (type == TransactionType.expense) {
      _addSpentToCategory(categoryTitle, amount);
    }

    _persistAndNotify();
  }

  void updateCreditCard(
    String id, {
    String? name,
    double? creditLimit,
    double? usedBalance,
    int? statementCutDay,
  }) {
    final index = _creditCards.indexWhere((card) => card.id == id);

    if (index == -1) {
      return;
    }

    _creditCards[index] = _creditCards[index].copyWith(
      name: name,
      creditLimit: creditLimit,
      usedBalance: usedBalance,
      statementCutDay: statementCutDay,
    );
    _persistAndNotify();
  }

  void addCreditCard({
    required String name,
    required double creditLimit,
    required double usedBalance,
    required int statementCutDay,
  }) {
    final normalizedName = name.trim();
    if (normalizedName.isEmpty ||
        creditLimit <= 0 ||
        usedBalance < 0 ||
        statementCutDay < 1 ||
        statementCutDay > 31) {
      return;
    }

    _creditCards.add(
      CreditCard(
        id: 'card-${DateTime.now().microsecondsSinceEpoch}',
        name: normalizedName,
        creditLimit: creditLimit,
        usedBalance: usedBalance,
        statementCutDay: statementCutDay,
      ),
    );
    _persistAndNotify();
  }

  void updateCardMonthlyPayment(
    String cardId,
    double amount, {
    CreditCardPaymentSource source = CreditCardPaymentSource.manual,
  }) {
    if (amount < 0) {
      return;
    }

    final index = _cardMonthlyPayments.indexWhere((payment) {
      return payment.cardId == cardId;
    });
    final current = index == -1
        ? CreditCardMonthlyPayment(cardId: cardId)
        : _cardMonthlyPayments[index];

    if (source == CreditCardPaymentSource.estimated) {
      if (index != -1) {
        _cardMonthlyPayments.removeAt(index);
      }
      _persistAndNotify();
      return;
    }

    final next = source == CreditCardPaymentSource.manual
        ? current.copyWith(
            manualAmount: amount,
            clearConfirmedAmount: true,
          )
        : current.copyWith(
            confirmedAmount: amount,
            clearManualAmount: true,
          );

    if (index == -1) {
      _cardMonthlyPayments.add(next);
    } else {
      _cardMonthlyPayments[index] = next;
    }
    _persistAndNotify();
  }

  void addCreditCardPayment(String cardId, double amount) {
    if (amount <= 0) {
      return;
    }

    final index = _creditCards.indexWhere((card) => card.id == cardId);

    if (index == -1) {
      return;
    }

    final card = _creditCards[index];
    final nextBalance = (card.usedBalance - amount).clamp(0, double.infinity);
    _creditCards[index] = card.copyWith(usedBalance: nextBalance.toDouble());
    _persistAndNotify();
  }

  void addCreditCardPurchase({
    required String cardId,
    required String title,
    required double amount,
    required int installments,
    DateTime? date,
    int paidInstallments = 0,
    String? notes,
  }) {
    if (title.trim().isEmpty ||
        amount <= 0 ||
        installments <= 0 ||
        paidInstallments < 0 ||
        paidInstallments > installments) {
      return;
    }

    final index = _creditCards.indexWhere((card) => card.id == cardId);

    if (index == -1) {
      return;
    }

    final purchase = CreditCardPurchase(
      id: 'card-purchase-${DateTime.now().microsecondsSinceEpoch}',
      cardId: cardId,
      title: title.trim(),
      amount: amount,
      installments: installments,
      paidInstallments: paidInstallments,
      date: date,
      notes: _blankToNull(notes),
    );

    final card = _creditCards[index];
    _creditCards[index] = card.copyWith(
      usedBalance: card.usedBalance + _balanceAmountForPurchase(purchase),
    );
    _creditCardPurchases.insert(0, purchase);
    _persistAndNotify();
  }

  void updateCreditCardPurchase(
    String id, {
    String? cardId,
    String? title,
    double? amount,
    int? installments,
    int? paidInstallments,
    DateTime? date,
    String? notes,
  }) {
    final purchaseIndex = _creditCardPurchases.indexWhere((purchase) {
      return purchase.id == id;
    });

    if (purchaseIndex == -1) {
      return;
    }

    final current = _creditCardPurchases[purchaseIndex];
    final nextCardId = cardId ?? current.cardId;
    final nextTitle = title?.trim() ?? current.title;
    final nextAmount = amount ?? current.amount;
    final nextInstallments = installments ?? current.installments;
    final nextPaidInstallments = paidInstallments ?? current.paidInstallments;

    if (nextTitle.isEmpty ||
        nextAmount <= 0 ||
        nextInstallments <= 0 ||
        nextPaidInstallments < 0 ||
        nextPaidInstallments > nextInstallments) {
      return;
    }

    final oldCardIndex = _creditCards.indexWhere((card) {
      return card.id == current.cardId;
    });
    final newCardIndex = _creditCards.indexWhere((card) {
      return card.id == nextCardId;
    });

    if (newCardIndex == -1) {
      return;
    }

    final nextPurchase = current.copyWith(
      cardId: nextCardId,
      title: nextTitle,
      amount: nextAmount,
      installments: nextInstallments,
      paidInstallments: nextPaidInstallments,
      date: date,
      notes: notes == null ? current.notes : _blankToNull(notes),
      clearNotes: notes != null && _blankToNull(notes) == null,
    );

    if (oldCardIndex == newCardIndex) {
      final card = _creditCards[newCardIndex];
      _creditCards[newCardIndex] = card.copyWith(
        usedBalance: card.usedBalance -
            _balanceAmountForPurchase(current) +
            _balanceAmountForPurchase(nextPurchase),
      );
    } else {
      if (oldCardIndex != -1) {
        final oldCard = _creditCards[oldCardIndex];
        _creditCards[oldCardIndex] = oldCard.copyWith(
          usedBalance:
              (oldCard.usedBalance - _balanceAmountForPurchase(current))
                  .clamp(0, double.infinity)
                  .toDouble(),
        );
      }

      final newCard = _creditCards[newCardIndex];
      _creditCards[newCardIndex] = newCard.copyWith(
        usedBalance:
            newCard.usedBalance + _balanceAmountForPurchase(nextPurchase),
      );
    }

    _creditCardPurchases[purchaseIndex] = nextPurchase;
    _persistAndNotify();
  }

  void deleteCreditCardPurchase(String id) {
    final purchaseIndex = _creditCardPurchases.indexWhere((purchase) {
      return purchase.id == id;
    });

    if (purchaseIndex == -1) {
      return;
    }

    final purchase = _creditCardPurchases.removeAt(purchaseIndex);
    final cardIndex = _creditCards.indexWhere((card) {
      return card.id == purchase.cardId;
    });

    if (cardIndex != -1) {
      final card = _creditCards[cardIndex];
      _creditCards[cardIndex] = card.copyWith(
        usedBalance: (card.usedBalance - _balanceAmountForPurchase(purchase))
            .clamp(0, double.infinity)
            .toDouble(),
      );
    }

    _persistAndNotify();
  }

  void addSubscription({
    required String name,
    required double amount,
    required String cardId,
  }) {
    if (name.trim().isEmpty || amount <= 0) {
      return;
    }

    _subscriptions.add(
      SubscriptionEntry(
        id: 'sub-${DateTime.now().microsecondsSinceEpoch}',
        name: name.trim(),
        amount: amount,
        cardId: cardId,
      ),
    );
    _persistAndNotify();
  }

  void updateSubscription(
    String id, {
    String? name,
    double? amount,
    String? cardId,
  }) {
    final index = _subscriptions.indexWhere((subscription) {
      return subscription.id == id;
    });

    if (index == -1) {
      return;
    }

    _subscriptions[index] = _subscriptions[index].copyWith(
      name: name,
      amount: amount,
      cardId: cardId,
    );
    _persistAndNotify();
  }

  void deleteSubscription(String id) {
    _subscriptions.removeWhere((subscription) => subscription.id == id);
    _persistAndNotify();
  }

  void deleteTransaction(String id) {
    final index = _transactions.indexWhere((transaction) {
      return transaction.id == id;
    });

    if (index == -1) {
      return;
    }

    final transaction = _transactions.removeAt(index);

    if (transaction.type == TransactionType.expense) {
      _addSpentToCategory(transaction.category, -transaction.amount);
    }

    _persistAndNotify();
  }

  void _addSpentToCategory(String title, double amount) {
    final normalizedTitle = _normalizeCategoryName(title);
    final index = _categories.indexWhere((category) {
      return _normalizeCategoryName(category.title) == normalizedTitle;
    });

    if (index == -1) {
      return;
    }

    final category = _categories[index];
    final nextSpent = (category.spent + amount).clamp(0, double.infinity);
    _categories[index] = category.copyWith(spent: nextSpent.toDouble());
  }

  void _persistAndNotify() {
    _notifyIfActive();
    final repository = _repository;
    if (repository == null) {
      return;
    }

    final snapshot = _snapshot();
    _enqueueSave(repository, snapshot);
  }

  Future<void> _enqueueSave(
    FinanceStorage repository,
    FinanceSnapshot snapshot,
  ) {
    _pendingSave = _pendingSave
        .catchError((_) {})
        .then((_) => repository.saveSnapshot(snapshot))
        .then((_) {
      _saveError = null;
      _notifyIfActive();
    }).catchError((Object error) {
      _saveError = error.toString();
      _notifyIfActive();
    });
    return _pendingSave;
  }

  void _notifyIfActive() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  void _applySnapshot(FinanceSnapshot snapshot) {
    _monthlyIncome = snapshot.monthlyIncome;
    _categories = List.of(snapshot.categories);
    _ensureAntExpenseCategory();
    _transactions = List.of(snapshot.transactions);
    _plannedExpenses = List.of(snapshot.plannedExpenses);
    _creditCards = List.of(snapshot.creditCards);
    _creditCardPurchases = List.of(snapshot.creditCardPurchases);
    _subscriptions = List.of(snapshot.subscriptions);
    _cardMonthlyPayments = List.of(snapshot.cardMonthlyPayments);
    _monthlyExtras = List.of(snapshot.monthlyExtras);
    _surplusPlan = snapshot.surplusPlan;
    _manualTasks = List.of(snapshot.manualTasks);
    _taskOverrides = Map.of(snapshot.taskOverrides);
  }

  void _ensureAntExpenseCategory() {
    final index = _categories.indexWhere((category) {
      return category.id == BudgetCategory.antExpenseId ||
          _normalizeCategoryName(category.title) ==
              _normalizeCategoryName(BudgetCategory.antExpenseTitle);
    });

    if (index == -1) {
      _categories.add(
        const BudgetCategory(
          id: BudgetCategory.antExpenseId,
          title: BudgetCategory.antExpenseTitle,
          limit: 0,
          color: Color(0xFF1B7F5C),
        ),
      );
      return;
    }

    final existing = _categories[index];
    _categories[index] = BudgetCategory(
      id: BudgetCategory.antExpenseId,
      title: BudgetCategory.antExpenseTitle,
      limit: 0,
      spent: existing.spent,
      color: const Color(0xFF1B7F5C),
    );

    _categories.removeWhere((category) {
      return category.id != BudgetCategory.antExpenseId &&
          _normalizeCategoryName(category.title) ==
              _normalizeCategoryName(BudgetCategory.antExpenseTitle);
    });
  }

  FinanceSnapshot _snapshot() {
    return FinanceSnapshot(
      monthlyIncome: _monthlyIncome,
      categories: List.of(_categories),
      transactions: List.of(_transactions),
      plannedExpenses: List.of(_plannedExpenses),
      creditCards: List.of(_creditCards),
      creditCardPurchases: List.of(_creditCardPurchases),
      subscriptions: List.of(_subscriptions),
      cardMonthlyPayments: List.of(_cardMonthlyPayments),
      monthlyExtras: List.of(_monthlyExtras),
      surplusPlan: _surplusPlan,
      manualTasks: List.of(_manualTasks),
      taskOverrides: Map.of(_taskOverrides),
    );
  }

  double _balanceAmountForPurchase(CreditCardPurchase purchase) {
    if (purchase.isInstallmentPurchase) {
      return purchase.remainingAmount;
    }

    return purchase.amount;
  }

  String? _blankToNull(String? value) {
    final normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) {
      return null;
    }

    return normalized;
  }

  static String _friendlyCardName(String name) {
    if (name.toLowerCase().contains('azul')) {
      return 'Tarjeta Azul';
    }

    if (name.toLowerCase().contains('dorada')) {
      return 'Tarjeta Dorada';
    }

    return name;
  }

  static String _extraTaskTitle(MonthlyExtra extra) {
    return switch (extra.status) {
      MonthlyExtraStatus.toDeliver => 'Entregar dinero para ${extra.name}',
      _ => 'Apartar dinero para ${extra.name}',
    };
  }
}
