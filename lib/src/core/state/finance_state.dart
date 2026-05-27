import 'package:flutter/material.dart';

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
  FinanceState() {
    _monthlyIncome = 44995.39;
    _categories = [
      const BudgetCategory(
        id: 'cat-1',
        title: 'Comida',
        limit: 5000,
        spent: 95,
        color: Color(0xFF1B7F5C),
      ),
      const BudgetCategory(
        id: 'cat-2',
        title: 'Suscripciones',
        limit: 1000,
        spent: 249,
        color: Color(0xFF0288D1),
      ),
      const BudgetCategory(
        id: 'cat-3',
        title: 'Transporte',
        limit: 1800,
        color: Color(0xFFE53935),
      ),
    ];

    _transactions = [
      TransactionEntry(
        id: 'tx-1',
        title: 'Cafe y pan',
        amount: 95,
        category: 'Comida',
        date: DateTime.now().subtract(const Duration(days: 1)),
        type: TransactionType.expense,
      ),
      TransactionEntry(
        id: 'tx-2',
        title: 'Streaming',
        amount: 249,
        category: 'Suscripciones',
        date: DateTime.now().subtract(const Duration(days: 3)),
        type: TransactionType.expense,
      ),
    ];

    _plannedExpenses = [
      const PlannedExpense(
        id: 'plan-coppel-abono',
        title: 'Coppel - abono minimo',
        amount: 1567,
        group: 'Coppel',
        status: PlannedExpenseStatus.paid,
      ),
      const PlannedExpense(
        id: 'plan-bbva-azul',
        title: 'BBVA Azul',
        amount: 1760.82,
        group: 'Tarjetas',
        status: PlannedExpenseStatus.pending,
        paymentSource: 'BBVA Azul',
      ),
      const PlannedExpense(
        id: 'plan-bbva-dorada',
        title: 'BBVA Dorada',
        amount: 14578.60,
        group: 'Tarjetas',
        status: PlannedExpenseStatus.pending,
        paymentSource: 'BBVA Dorada',
      ),
      const PlannedExpense(
        id: 'plan-cass',
        title: 'Cass - tanda faltante',
        amount: 6000,
        group: 'Deudas',
        status: PlannedExpenseStatus.pending,
        note: 'Falta de la tanda de mayo',
      ),
      const PlannedExpense(
        id: 'plan-asbel',
        title: 'Asbel',
        amount: 2000,
        group: 'Extras',
        status: PlannedExpenseStatus.reserved,
      ),
      const PlannedExpense(
        id: 'plan-carmen',
        title: 'Carmen',
        amount: 600,
        group: 'Extras',
        status: PlannedExpenseStatus.reserved,
      ),
      const PlannedExpense(
        id: 'plan-comida',
        title: 'Comida',
        amount: 1000,
        group: 'Efectivo',
        status: PlannedExpenseStatus.pending,
        note: 'Darselo a Alan',
      ),
      const PlannedExpense(
        id: 'plan-lavadora',
        title: 'Lavadora',
        amount: 200,
        group: 'Extras',
        status: PlannedExpenseStatus.pending,
        note: 'Darselo a Erick',
      ),
    ];

    _creditCards = [
      const CreditCard(
        id: 'card-azul',
        name: 'BBVA Azul',
        creditLimit: 25000,
        usedBalance: 1760.82,
        statementCutDay: 10,
      ),
      const CreditCard(
        id: 'card-dorada',
        name: 'BBVA Dorada',
        creditLimit: 50000,
        usedBalance: 14578.60,
        statementCutDay: 19,
      ),
    ];

    _creditCardPurchases = [
      CreditCardPurchase(
        id: 'card-purchase-1',
        cardId: 'card-dorada',
        title: 'Mensualidades raras',
        amount: 1367,
        installments: 1,
        paidInstallments: 0,
        date: DateTime(2026, 4, 19),
      ),
      CreditCardPurchase(
        id: 'card-purchase-2',
        cardId: 'card-azul',
        title: 'Dulces',
        amount: 821,
        installments: 1,
        paidInstallments: 0,
        date: DateTime(2026, 5, 10),
      ),
    ];

    _subscriptions = [
      const SubscriptionEntry(
        id: 'sub-chatgpt',
        name: 'ChatGPT',
        amount: 346.16,
        cardId: 'card-dorada',
      ),
      const SubscriptionEntry(
        id: 'sub-icloud',
        name: 'iCloud+',
        amount: 179,
        cardId: 'card-dorada',
      ),
      const SubscriptionEntry(
        id: 'sub-movistar',
        name: 'Movistar',
        amount: 349,
        cardId: 'card-dorada',
      ),
      const SubscriptionEntry(
        id: 'sub-spotify',
        name: 'Spotify',
        amount: 186,
        cardId: 'card-dorada',
      ),
      const SubscriptionEntry(
        id: 'sub-playstation-plus',
        name: 'PlayStation Plus',
        amount: 245.26,
        cardId: 'card-azul',
      ),
    ];

    _cardMonthlyPayments = [
      const CreditCardMonthlyPayment(cardId: 'card-azul'),
      const CreditCardMonthlyPayment(
        cardId: 'card-dorada',
        confirmedAmount: 14578.60,
      ),
    ];

    _monthlyExtras = [
      const MonthlyExtra(
        id: 'extra-asbel',
        name: 'Asbel',
        amount: 2000,
        status: MonthlyExtraStatus.reserved,
        includedInPlan: true,
      ),
      const MonthlyExtra(
        id: 'extra-carmen',
        name: 'Carmen',
        amount: 600,
        status: MonthlyExtraStatus.reserved,
        includedInPlan: true,
      ),
      const MonthlyExtra(
        id: 'extra-comida',
        name: 'Comida',
        amount: 1000,
        status: MonthlyExtraStatus.toDeliver,
        person: 'Alan',
        includedInPlan: true,
      ),
      const MonthlyExtra(
        id: 'extra-lavadora',
        name: 'Lavadora',
        amount: 200,
        status: MonthlyExtraStatus.toDeliver,
        person: 'Erick',
        includedInPlan: true,
      ),
    ];

    _surplusPlan = const SurplusPlan(type: SurplusPlanType.balanced);
    _manualTasks = [];
    _taskOverrides = {};
  }

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

  double get monthlyIncome => _monthlyIncome;
  List<BudgetCategory> get categories => List.unmodifiable(_categories);
  List<TransactionEntry> get transactions => List.unmodifiable(_transactions);
  List<PlannedExpense> get plannedExpenses =>
      List.unmodifiable(_plannedExpenses);
  List<CreditCard> get creditCards => List.unmodifiable(_creditCards);
  List<CreditCardPurchase> get creditCardPurchases =>
      List.unmodifiable(_creditCardPurchases);
  List<SubscriptionEntry> get subscriptions => List.unmodifiable(_subscriptions);
  List<CreditCardMonthlyPayment> get cardMonthlyPayments =>
      List.unmodifiable(_cardMonthlyPayments);
  List<MonthlyExtra> get monthlyExtras => List.unmodifiable(_monthlyExtras);
  SurplusPlan get surplusPlan => _surplusPlan;
  List<FinancialTask> get manualTasks => List.unmodifiable(_manualTasks);

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
    return _categories.fold(0, (sum, category) => sum + category.limit);
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
    return _transactions
        .where((transaction) => transaction.type == TransactionType.income)
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }

  double get unplannedRegisteredExpenses {
    final categoryTitles = _categories.map((category) {
      return category.title.toLowerCase();
    }).toSet();

    return _transactions
        .where((transaction) {
          return transaction.type == TransactionType.expense &&
              !categoryTitles.contains(transaction.category.toLowerCase());
        })
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }

  double get realEstimatedSurplus {
    return totalMonthlyIncome - totalPlannedExpenses - unplannedRegisteredExpenses;
  }

  SurplusPlanAllocation get surplusPlanAllocation {
    return _surplusPlan.allocation(realEstimatedSurplus);
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
    return _transactions
        .where((transaction) => transaction.type == TransactionType.expense)
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }

  double get totalCreditCardDebt {
    return _creditCards.fold(0, (sum, card) => sum + card.usedBalance);
  }

  double get totalAvailableCredit {
    return _creditCards.fold(0, (sum, card) => sum + card.availableCredit);
  }

  double get totalMonthlyInstallmentPayments {
    final today = DateTime.now();

    return _creditCardPurchases
        .where((purchase) {
          final card = _cardForPurchase(purchase);

          return purchase.isInstallmentPurchase &&
              card != null &&
              purchase.remainingInstallmentsAsOf(
                    today,
                    statementCutDay: card.statementCutDay,
                  ) >
                  0;
        })
        .fold(0, (sum, purchase) => sum + purchase.monthlyPayment);
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
      ..._monthlyExtras
          .where((extra) => extra.includedInPlan)
          .map((extra) {
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
    ].where((task) => task.amount > 0).toList(growable: false);
  }

  List<CreditCardPurchase> purchasesForCard(String cardId) {
    return _creditCardPurchases
        .where((purchase) => purchase.cardId == cardId)
        .toList(growable: false);
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

  double estimatedCardMonthlyPayment(String cardId) {
    return creditCardById(cardId)?.usedBalance ?? 0;
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
    final estimatedAmount = estimatedCardMonthlyPayment(cardId);
    return cardMonthlyPaymentFor(cardId).amount(estimatedAmount);
  }

  CreditCardPaymentSource cardMonthlyPaymentSource(String cardId) {
    final estimatedAmount = estimatedCardMonthlyPayment(cardId);
    return cardMonthlyPaymentFor(cardId).source(estimatedAmount);
  }

  void updateMonthlyIncome(double amount) {
    if (amount < 0) {
      return;
    }

    _monthlyIncome = amount;
    notifyListeners();
  }

  void updateSurplusPlan(SurplusPlanType type) {
    _surplusPlan = _surplusPlan.copyWith(
      type: type,
      clearManualAmounts: type != SurplusPlanType.custom,
    );
    notifyListeners();
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
    notifyListeners();
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
        actualAmount: status == FinancialTaskStatus.partial
            ? actualAmount
            : null,
        dueDate: dueDate,
        sourceId: 'manual',
        sourceType: FinancialTaskSourceType.manual,
        notes: _blankToNull(notes),
        completedAt: status == FinancialTaskStatus.done
            ? DateTime.now()
            : null,
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
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
    final completedAt = nextStatus == FinancialTaskStatus.done
        ? DateTime.now()
        : null;

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
      notifyListeners();
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
    notifyListeners();
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
    notifyListeners();
  }

  void addCategory(String title, double limit, Color color) {
    final newCategory = BudgetCategory(
      id: 'cat-${DateTime.now().microsecondsSinceEpoch}',
      title: title,
      limit: limit,
      color: color,
    );

    _categories.add(newCategory);
    notifyListeners();
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
    notifyListeners();
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
    notifyListeners();
  }

  void markMonthlyExtraDelivered(String id) {
    updateMonthlyExtra(id, status: MonthlyExtraStatus.delivered);
  }

  void deleteMonthlyExtra(String id) {
    _monthlyExtras.removeWhere((extra) => extra.id == id);
    notifyListeners();
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

    _categories[index] = _categories[index].copyWith(
      title: title,
      limit: limit,
      color: color,
    );
    notifyListeners();
  }

  void deleteCategory(String id) {
    _categories.removeWhere((category) => category.id == id);
    notifyListeners();
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

    notifyListeners();
  }

  void updateCreditCard(
    String id, {
    double? creditLimit,
    double? usedBalance,
    int? statementCutDay,
  }) {
    final index = _creditCards.indexWhere((card) => card.id == id);

    if (index == -1) {
      return;
    }

    _creditCards[index] = _creditCards[index].copyWith(
      creditLimit: creditLimit,
      usedBalance: usedBalance,
      statementCutDay: statementCutDay,
    );
    notifyListeners();
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
      notifyListeners();
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
    notifyListeners();
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
    notifyListeners();
  }

  void addCreditCardPurchase({
    required String cardId,
    required String title,
    required double amount,
    required int installments,
    required DateTime date,
  }) {
    if (amount <= 0 || installments <= 0) {
      return;
    }

    final index = _creditCards.indexWhere((card) => card.id == cardId);

    if (index == -1) {
      return;
    }

    final purchase = CreditCardPurchase(
      id: 'card-purchase-${DateTime.now().microsecondsSinceEpoch}',
      cardId: cardId,
      title: title,
      amount: amount,
      installments: installments,
      paidInstallments: 0,
      date: date,
    );

    final card = _creditCards[index];
    _creditCards[index] = card.copyWith(
      usedBalance: card.usedBalance + amount,
    );
    _creditCardPurchases.insert(0, purchase);
    notifyListeners();
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
    notifyListeners();
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
    notifyListeners();
  }

  void deleteSubscription(String id) {
    _subscriptions.removeWhere((subscription) => subscription.id == id);
    notifyListeners();
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

    notifyListeners();
  }

  void _addSpentToCategory(String title, double amount) {
    final index = _categories.indexWhere((category) {
      return category.title.toLowerCase() == title.toLowerCase();
    });

    if (index == -1) {
      return;
    }

    final category = _categories[index];
    final nextSpent = (category.spent + amount).clamp(0, double.infinity);
    _categories[index] = category.copyWith(spent: nextSpent.toDouble());
  }

  CreditCard? _cardForPurchase(CreditCardPurchase purchase) {
    for (final card in _creditCards) {
      if (card.id == purchase.cardId) {
        return card;
      }
    }

    return null;
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
