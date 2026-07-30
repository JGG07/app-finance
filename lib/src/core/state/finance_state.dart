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
import '../../features/notifications/domain/notification_preferences.dart';
import '../../features/notifications/domain/task_reminder.dart';
import '../../features/notifications/services/task_notification_scheduler.dart';
import '../../features/subscriptions/domain/subscription_entry.dart';
import '../../features/tasks/domain/financial_task.dart';
import '../../features/transactions/domain/transaction_entry.dart';
import '../../features/tandas/domain/tanda.dart';
import '../../features/tandas/domain/tanda_contribution.dart';
import '../../features/tandas/domain/tanda_contribution_link.dart';
import '../../features/tandas/domain/tanda_receipt.dart';
import '../../features/tandas/domain/tanda_receipt_link.dart';

class FinanceState extends ChangeNotifier {
  static const String cardPaymentCategoryTitle = 'Pago a tarjeta';

  FinanceState({
    FinanceStorage? repository,
    TaskNotificationScheduler? notificationScheduler,
  })  : _notificationScheduler =
            notificationScheduler ?? const NoopTaskNotificationScheduler(),
        _repository = repository,
        _isInitialized = repository == null {
    _applySnapshot(initialFinanceSeed());
  }

  final FinanceStorage? _repository;
  final TaskNotificationScheduler _notificationScheduler;

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
  late NotificationPreferences _notificationPreferences;
  late List<TaskReminder> _taskReminders;
  late List<Tanda> _tandas;
  late List<TandaContribution> _tandaContributions;
  late List<TandaReceipt> _tandaReceipts;
  Future<void>? _initialization;
  Future<void> _pendingSave = Future.value();
  Future<void> _pendingNotificationWork = Future.value();
  bool _notificationSchedulerInitialized = false;
  NotificationPermissionStatus _notificationPermissionStatus =
      NotificationPermissionStatus.notConfigured;
  String? _notificationError;
  String? _pendingTaskNavigationId;
  String? _pendingCardPaymentNavigationId;
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
  NotificationPreferences get notificationPreferences =>
      _notificationPreferences;
  List<TaskReminder> get taskReminders => List.unmodifiable(_taskReminders);
  NotificationPermissionStatus get notificationPermissionStatus =>
      _notificationPermissionStatus;
  String? get notificationError => _notificationError;
  bool get notificationsAvailable =>
      _notificationPermissionStatus == NotificationPermissionStatus.granted;
  String? get pendingTaskNavigationId => _pendingTaskNavigationId;
  String? get pendingCardPaymentNavigationId => _pendingCardPaymentNavigationId;
  double get monthlyIncome => _monthlyIncome;
  FinancePeriod get selectedPeriod => _selectedPeriod;
  List<BudgetCategory> get categories => List.unmodifiable(
        _categories.map((category) {
          if (category.isProtected) {
            return category.copyWith(
              limit: antExpenseLimit,
              spent: antExpensesForSelectedPeriod,
            );
          }
          return category.copyWith(
            spent: spentForCategoryInSelectedPeriod(category),
          );
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
  List<Tanda> get tandas => List.unmodifiable(_tandas);
  List<Tanda> get activeTandas => List.unmodifiable(
        _tandas.where((tanda) => tanda.status == TandaStatus.active),
      );
  List<Tanda> get completedTandas => List.unmodifiable(
        _tandas.where((tanda) => tanda.status == TandaStatus.completed),
      );
  List<Tanda> get inactiveTandas => List.unmodifiable(
        _tandas.where((tanda) => tanda.status != TandaStatus.active),
      );
  List<TandaContribution> get tandaContributions =>
      List.unmodifiable(_tandaContributions);
  List<TandaReceipt> get tandaReceipts => List.unmodifiable(_tandaReceipts);

  String cardPaymentTaskId(String cardId) => 'card-payment-$cardId';

  TandaReceipt? receiptForTanda(String tandaId) {
    final matches = _tandaReceipts.where((item) => item.tandaId == tandaId);
    return matches.isEmpty ? null : matches.single;
  }

  TandaReceiptLinkStatus tandaReceiptLinkStatus(TandaReceipt receipt) {
    if (!receipt.isReceived) return TandaReceiptLinkStatus.notReceived;
    final linkedId = receipt.linkedTransactionId;
    if (linkedId == null) return TandaReceiptLinkStatus.unlinkedReceived;
    final linked = _transactions.where((item) => item.id == linkedId).toList();
    final shared = _tandaReceipts.any(
      (item) => item.id != receipt.id && item.linkedTransactionId == linkedId,
    );
    if (linked.length != 1 ||
        shared ||
        !isTransactionForTandaReceipt(linked.single, receipt)) {
      return TandaReceiptLinkStatus.missingTransaction;
    }
    return TandaReceiptLinkStatus.linked;
  }

  List<TandaContribution> contributionsForTanda(String tandaId) {
    final result = _tandaContributions
        .where((item) => item.tandaId == tandaId)
        .toList()
      ..sort((a, b) => a.sequenceNumber.compareTo(b.sequenceNumber));
    return List.unmodifiable(result);
  }

  List<TandaContribution> paidContributionsForTanda(String tandaId) =>
      List.unmodifiable(
        contributionsForTanda(tandaId).where((item) => item.isPaid),
      );

  List<TandaContribution> pendingContributionsForTanda(String tandaId) =>
      List.unmodifiable(
        contributionsForTanda(tandaId).where((item) => !item.isPaid),
      );

  TandaContribution? nextPendingContributionForTanda(String tandaId) {
    final pending = pendingContributionsForTanda(tandaId);
    return pending.isEmpty ? null : pending.first;
  }

  TandaContribution? lastPaidContributionForTanda(String tandaId) {
    final paid = paidContributionsForTanda(tandaId);
    return paid.isEmpty ? null : paid.last;
  }

  TandaContributionLinkStatus tandaContributionLinkStatus(
    TandaContribution contribution,
  ) {
    if (!contribution.isPaid) {
      return TandaContributionLinkStatus.notApplicable;
    }
    final linkedId = contribution.linkedTransactionId;
    if (linkedId == null) {
      return TandaContributionLinkStatus.unlinkedPaid;
    }
    final linked = _transactions.where((item) => item.id == linkedId).toList();
    final usedByOtherContribution = _tandaContributions.any(
      (item) =>
          item.id != contribution.id && item.linkedTransactionId == linkedId,
    );
    if (linked.length != 1 ||
        usedByOtherContribution ||
        !isTransactionForTandaContribution(linked.single, contribution)) {
      return TandaContributionLinkStatus.missingTransaction;
    }
    return TandaContributionLinkStatus.linked;
  }

  void addTanda({
    required String name,
    required double contributionAmount,
    required TandaFrequency frequency,
    required DateTime startDate,
    required int participantCount,
    required int assignedTurn,
    String? notes,
  }) {
    final now = DateTime.now();
    final tanda = Tanda(
      id: 'tanda-${now.microsecondsSinceEpoch}',
      name: name,
      contributionAmount: contributionAmount,
      frequency: frequency,
      startDate: startDate,
      participantCount: participantCount,
      assignedTurn: assignedTurn,
      completedContributions: 0,
      status: TandaStatus.active,
      notes: notes?.trim().isEmpty ?? true ? null : notes!.trim(),
      createdAt: now,
    );
    _tandas.add(tanda);
    _tandaContributions.addAll(_buildContributionSchedule(tanda));
    _tandaReceipts.add(_buildTandaReceipt(tanda));
    _persistAndNotify();
  }

  void updateTanda(
    String id, {
    required String name,
    required double contributionAmount,
    required TandaFrequency frequency,
    required DateTime startDate,
    required int participantCount,
    required int assignedTurn,
    String? notes,
  }) {
    final index = _tandas.indexWhere((tanda) => tanda.id == id);
    if (index == -1) return;
    final existing = _tandas[index];
    final hasPaid = paidContributionsForTanda(id).isNotEmpty;
    final receipt = receiptForTanda(id);
    final hasReceived = receipt?.isReceived ?? false;
    final structuralChange =
        contributionAmount != existing.contributionAmount ||
            frequency != existing.frequency ||
            startDate != existing.startDate ||
            participantCount != existing.participantCount ||
            assignedTurn != existing.assignedTurn;
    if (hasReceived && structuralChange) {
      throw StateError(
        'No puedes modificar el monto, calendario o turno porque la recepcion ya fue registrada.',
      );
    }
    if (hasPaid &&
        (contributionAmount != existing.contributionAmount ||
            frequency != existing.frequency ||
            startDate != existing.startDate ||
            participantCount != existing.participantCount)) {
      throw StateError(
        'No puedes modificar el calendario o el monto porque ya existen aportaciones registradas.',
      );
    }
    final updated = existing.copyWith(
      name: name,
      contributionAmount: contributionAmount,
      frequency: frequency,
      startDate: startDate,
      participantCount: participantCount,
      assignedTurn: assignedTurn,
      notes: notes?.trim(),
    );
    _tandas[index] = updated;
    if (!hasPaid) {
      _tandaContributions.removeWhere((item) => item.tandaId == id);
      _tandaContributions.addAll(_buildContributionSchedule(updated));
    }
    if (!hasReceived) {
      final receiptIndex =
          _tandaReceipts.indexWhere((item) => item.tandaId == id);
      final synchronized = _buildTandaReceipt(updated);
      if (receiptIndex == -1) {
        _tandaReceipts.add(synchronized);
      } else {
        _tandaReceipts[receiptIndex] = _tandaReceipts[receiptIndex].copyWith(
          amount: synchronized.amount,
          scheduledDate: synchronized.scheduledDate,
        );
      }
    }
    _persistAndNotify();
  }

  void deleteTanda(String id, {bool deleteLinkedTransactions = false}) {
    final linkedIds = _tandaContributions
        .where((item) => item.tandaId == id)
        .map((item) => item.linkedTransactionId)
        .whereType<String>()
        .toSet();
    final receipt = receiptForTanda(id);
    if (receipt?.linkedTransactionId != null) {
      linkedIds.add(receipt!.linkedTransactionId!);
    }
    if (deleteLinkedTransactions) {
      _transactions.removeWhere((transaction) {
        if (!linkedIds.contains(transaction.id)) return false;
        for (final contribution in _tandaContributions) {
          if (contribution.tandaId == id &&
              contribution.linkedTransactionId == transaction.id &&
              isTransactionForTandaContribution(transaction, contribution)) {
            return true;
          }
        }
        if (receipt != null &&
            receipt.linkedTransactionId == transaction.id &&
            isTransactionForTandaReceipt(transaction, receipt)) {
          return true;
        }
        return false;
      });
    }
    _tandas.removeWhere((tanda) => tanda.id == id);
    _tandaContributions.removeWhere((item) => item.tandaId == id);
    _tandaReceipts.removeWhere((item) => item.tandaId == id);
    _persistAndNotify();
  }

  void markTandaReceiptReceived({
    required String tandaId,
    required DateTime receivedAt,
  }) {
    final tanda = _tandas.where((item) => item.id == tandaId).firstOrNull;
    if (tanda == null) throw StateError('La tanda no existe.');
    if (tanda.status == TandaStatus.cancelled) {
      throw StateError('Una tanda cancelada no puede registrar recepcion.');
    }
    final receipt = receiptForTanda(tandaId);
    if (receipt == null) throw StateError('La recepcion esperada no existe.');
    if (tandaReceiptLinkStatus(receipt) == TandaReceiptLinkStatus.linked) {
      return;
    }
    _linkTandaReceipt(receipt, tanda, receipt.receivedAt ?? receivedAt);
  }

  void linkReceivedTandaReceiptToTransaction({
    required String receiptId,
    DateTime? receivedAt,
  }) {
    final receipt =
        _tandaReceipts.where((item) => item.id == receiptId).firstOrNull;
    if (receipt == null) throw StateError('La recepcion no existe.');
    if (tandaReceiptLinkStatus(receipt) == TandaReceiptLinkStatus.linked) {
      return;
    }
    final effectiveDate = receipt.receivedAt ?? receivedAt;
    if (effectiveDate == null) {
      throw StateError('Debes indicar la fecha real de recepcion.');
    }
    final tanda = _tandas.firstWhere(
      (item) => item.id == receipt.tandaId,
      orElse: () => throw StateError('La tanda no existe.'),
    );
    _linkTandaReceipt(receipt, tanda, effectiveDate);
  }

  void _linkTandaReceipt(
    TandaReceipt receipt,
    Tanda tanda,
    DateTime receivedAt,
  ) {
    final transactionId = transactionIdForTandaReceipt(receipt.id);
    final existing =
        _transactions.where((item) => item.id == transactionId).toList();
    if (existing.length > 1 ||
        (existing.isNotEmpty &&
            !isTransactionForTandaReceipt(existing.single, receipt))) {
      throw StateError(
        'El ingreso determinista existe pero es incompatible.',
      );
    }
    if (existing.isEmpty) {
      _addGeneratedTransaction(
        TransactionEntry(
          id: transactionId,
          title: 'Recepcion de ${tanda.name}',
          amount: receipt.amount,
          category: tandaReceiptTransactionCategory,
          date: receivedAt,
          type: TransactionType.income,
        ),
      );
    }
    final index = _tandaReceipts.indexWhere((item) => item.id == receipt.id);
    _tandaReceipts[index] = receipt.copyWith(
      status: TandaReceiptStatus.received,
      receivedAt: existing.isEmpty ? receivedAt : existing.single.date,
      linkedTransactionId: transactionId,
    );
    _persistAndNotify();
  }

  void undoTandaReceipt(String tandaId) {
    if (!_tandas.any((item) => item.id == tandaId)) {
      throw StateError('La tanda no existe.');
    }
    final receipt = receiptForTanda(tandaId);
    if (receipt == null || !receipt.isReceived) return;
    final linkedId = receipt.linkedTransactionId;
    if (linkedId != null) {
      final index = _transactions.indexWhere((item) => item.id == linkedId);
      if (index != -1 &&
          isTransactionForTandaReceipt(_transactions[index], receipt)) {
        _transactions.removeAt(index);
      }
    }
    final index = _tandaReceipts.indexWhere((item) => item.id == receipt.id);
    _tandaReceipts[index] = receipt.copyWith(
      status: TandaReceiptStatus.pending,
      clearReceivedAt: true,
      clearLinkedTransactionId: true,
    );
    _persistAndNotify();
  }

  void markNextTandaContributionPaid(String id) {
    final tandaIndex = _tandas.indexWhere((item) => item.id == id);
    if (tandaIndex == -1 || !_tandas[tandaIndex].isActive) return;
    final next = nextPendingContributionForTanda(id);
    if (next == null) return;
    final paidAt = DateTime.now();
    final transactionId = transactionIdForTandaContribution(next.id);
    final existing =
        _transactions.where((item) => item.id == transactionId).toList();
    if (existing.length > 1 ||
        (existing.isNotEmpty &&
            !isTransactionForTandaContribution(existing.single, next))) {
      throw StateError(
        'El movimiento determinista existe pero es incompatible.',
      );
    }
    if (existing.isEmpty) {
      _addGeneratedTransaction(
        TransactionEntry(
          id: transactionId,
          title: 'Aportacion a ${_tandas[tandaIndex].name}',
          amount: next.amount,
          category: tandaTransactionCategory,
          date: paidAt,
          type: TransactionType.expense,
        ),
      );
    }
    final index = _tandaContributions.indexWhere((item) => item.id == next.id);
    _tandaContributions[index] = next.copyWith(
      status: TandaContributionStatus.paid,
      paidAt: existing.isEmpty ? paidAt : existing.single.date,
      linkedTransactionId: transactionId,
    );
    _synchronizeTandaProgress(id);
    _persistAndNotify();
  }

  void undoLastTandaContribution(String id) {
    final tandaIndex = _tandas.indexWhere((item) => item.id == id);
    if (tandaIndex == -1 ||
        _tandas[tandaIndex].status == TandaStatus.cancelled) {
      return;
    }
    final last = lastPaidContributionForTanda(id);
    if (last == null) return;
    final index = _tandaContributions.indexWhere((item) => item.id == last.id);
    final linkedId = last.linkedTransactionId;
    if (linkedId != null) {
      final linkedIndex =
          _transactions.indexWhere((item) => item.id == linkedId);
      if (linkedIndex != -1 &&
          isTransactionForTandaContribution(_transactions[linkedIndex], last)) {
        _transactions.removeAt(linkedIndex);
      }
    }
    _tandaContributions[index] = last.copyWith(
      status: TandaContributionStatus.pending,
      clearPaidAt: true,
      clearLinkedTransactionId: true,
    );
    _synchronizeTandaProgress(id);
    _persistAndNotify();
  }

  void linkPaidTandaContributionToTransaction({
    required String contributionId,
    required DateTime paidAt,
  }) {
    final index = _tandaContributions.indexWhere(
      (item) => item.id == contributionId,
    );
    if (index == -1) throw StateError('La aportacion no existe.');
    final contribution = _tandaContributions[index];
    if (!contribution.isPaid) {
      throw StateError('Solo se puede vincular una aportacion pagada.');
    }
    final transactionId = transactionIdForTandaContribution(contribution.id);
    if (contribution.linkedTransactionId != null &&
        tandaContributionLinkStatus(contribution) ==
            TandaContributionLinkStatus.linked) {
      return;
    }
    final existing =
        _transactions.where((item) => item.id == transactionId).toList();
    if (existing.length > 1 ||
        (existing.isNotEmpty &&
            !isTransactionForTandaContribution(
              existing.single,
              contribution,
            ))) {
      throw StateError(
        'El movimiento determinista existe pero es incompatible.',
      );
    }
    final tanda = _tandas.firstWhere(
      (item) => item.id == contribution.tandaId,
      orElse: () => throw StateError('La tanda no existe.'),
    );
    final effectivePaidAt = contribution.paidAt ?? paidAt;
    if (existing.isEmpty) {
      _addGeneratedTransaction(
        TransactionEntry(
          id: transactionId,
          title: 'Aportacion a ${tanda.name}',
          amount: contribution.amount,
          category: tandaTransactionCategory,
          date: effectivePaidAt,
          type: TransactionType.expense,
        ),
      );
    }
    _tandaContributions[index] = contribution.copyWith(
      paidAt: effectivePaidAt,
      linkedTransactionId: transactionId,
    );
    _persistAndNotify();
  }

  void cancelTanda(String id) {
    final index = _tandas.indexWhere((tanda) => tanda.id == id);
    if (index == -1 || _tandas[index].status == TandaStatus.cancelled) return;
    _tandas[index] = _tandas[index].copyWith(status: TandaStatus.cancelled);
    _persistAndNotify();
  }

  Future<void> initialize() {
    final repository = _repository;
    if (repository == null) {
      if (_notificationSchedulerInitialized ||
          !_notificationScheduler.isSupported) {
        return Future.value();
      }
      return _initializeNotificationScheduler();
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
      await _initializeNotificationScheduler();
      _isInitialized = true;
      _loadError = null;
    } catch (error) {
      _loadError = error.toString();
    } finally {
      _isLoading = false;
      _notifyIfActive();
    }
  }

  Future<void> _initializeNotificationScheduler() async {
    if (!_notificationScheduler.isSupported) {
      _notificationPermissionStatus = NotificationPermissionStatus.unsupported;
      return;
    }
    try {
      final launchPayload = await _notificationScheduler.initialize(
        onPayload: _handleNotificationPayload,
      );
      _notificationSchedulerInitialized = true;
      if (launchPayload != null) _handleNotificationPayload(launchPayload);
      await refreshNotificationPermission(reconcile: true);
    } catch (error) {
      _notificationError = error.toString();
      _notificationPermissionStatus = NotificationPermissionStatus.unsupported;
    }
  }

  Future<bool> enableTaskReminders() async {
    if (!_notificationScheduler.isSupported) {
      _notificationPermissionStatus = NotificationPermissionStatus.unsupported;
      _notifyIfActive();
      return false;
    }
    try {
      if (!_notificationSchedulerInitialized) {
        await _initializeNotificationScheduler();
      }
      final granted = await _notificationScheduler.requestPermission();
      _notificationPermissionStatus = granted
          ? NotificationPermissionStatus.granted
          : NotificationPermissionStatus.denied;
      _notificationPreferences =
          _notificationPreferences.copyWith(enabled: granted);
      _notificationError = null;
      _persistAndNotify();
      await _pendingNotificationWork;
      return granted;
    } catch (error) {
      _notificationError = error.toString();
      _notifyIfActive();
      return false;
    }
  }

  Future<void> setTaskRemindersEnabled(bool enabled) async {
    if (enabled) {
      await enableTaskReminders();
      return;
    }
    _notificationPreferences =
        _notificationPreferences.copyWith(enabled: false);
    _persistAndNotify();
    await _pendingNotificationWork;
  }

  void updateDefaultTaskReminder({
    TaskReminderMode? mode,
    int? hour,
    int? minute,
  }) {
    _notificationPreferences = _notificationPreferences.copyWith(
      defaultReminderMode: mode,
      defaultHour: hour,
      defaultMinute: minute,
    );
    _persistAndNotify();
  }

  void dismissNotificationDiscoveryCard() {
    _notificationPreferences =
        _notificationPreferences.copyWith(discoveryCardDismissed: true);
    _persistAndNotify();
  }

  Future<void> refreshNotificationPermission({bool reconcile = true}) async {
    if (!_notificationScheduler.isSupported) {
      _notificationPermissionStatus = NotificationPermissionStatus.unsupported;
      _notifyIfActive();
      return;
    }
    try {
      final granted = await _notificationScheduler.areNotificationsEnabled();
      if (granted) {
        _notificationPermissionStatus = NotificationPermissionStatus.granted;
      } else if (_notificationPreferences.enabled) {
        _notificationPermissionStatus = NotificationPermissionStatus.blocked;
      } else if (_notificationPermissionStatus ==
          NotificationPermissionStatus.granted) {
        _notificationPermissionStatus = NotificationPermissionStatus.denied;
      }
      _notificationError = null;
      _notifyIfActive();
      if (reconcile) await _queueReminderReconciliation();
    } catch (error) {
      _notificationError = error.toString();
      _notifyIfActive();
    }
  }

  Future<void> showTestTaskNotification() async {
    if (!notificationsAvailable) return;
    try {
      await _notificationScheduler.showTestNotification();
      _notificationError = null;
    } catch (error) {
      _notificationError = error.toString();
      _notifyIfActive();
    }
  }

  Future<void> openNotificationSystemSettings() {
    return _notificationScheduler.openSystemSettings();
  }

  void consumePendingTaskNavigation() {
    if (_pendingTaskNavigationId == null) return;
    _pendingTaskNavigationId = null;
    _notifyIfActive();
  }

  void consumePendingCardPaymentNavigation() {
    if (_pendingCardPaymentNavigationId == null) return;
    _pendingCardPaymentNavigationId = null;
    _notifyIfActive();
  }

  TaskReminder? taskReminderFor(String taskId) {
    final matches = _taskReminders.where((item) => item.taskId == taskId);
    return matches.isEmpty ? null : matches.single;
  }

  FinancialTask? financialTaskById(String taskId) {
    for (final task in monthlyFinancialTasks) {
      if (task.id == taskId) {
        return task;
      }
    }

    return null;
  }

  DateTime? scheduledTaskReminderFor(FinancialTask task) {
    return taskReminderFor(task.id)?.scheduledAtFor(task.dueDate);
  }

  void updateTaskReminder(
    String taskId, {
    required bool enabled,
    TaskReminderMode? mode,
    int? hour,
    int? minute,
    DateTime? customScheduledAt,
  }) {
    final now = DateTime.now();
    final index = _taskReminders.indexWhere((item) => item.taskId == taskId);
    if (index == -1) {
      final usedIds = _taskReminders.map((item) => item.notificationId);
      var nextId = 1000;
      while (usedIds.contains(nextId)) {
        nextId++;
      }
      final selectedMode = mode ?? _notificationPreferences.defaultReminderMode;
      _taskReminders.add(
        TaskReminder(
          taskId: taskId,
          notificationId: nextId,
          enabled: enabled,
          mode: selectedMode,
          hour: hour ?? _notificationPreferences.defaultHour,
          minute: minute ?? _notificationPreferences.defaultMinute,
          customScheduledAt: selectedMode == TaskReminderMode.custom
              ? customScheduledAt
              : null,
          createdAt: now,
          updatedAt: now,
        ),
      );
    } else {
      _taskReminders[index] = _taskReminders[index].copyWith(
        enabled: enabled,
        mode: mode,
        hour: hour,
        minute: minute,
        customScheduledAt: customScheduledAt,
        updatedAt: now,
        clearCustomScheduledAt: mode != null && mode != TaskReminderMode.custom,
      );
    }
    _persistAndNotify();
  }

  Future<void> reconcileTaskReminders() => _queueReminderReconciliation();

  void _handleNotificationPayload(String payload) {
    if (!payload.startsWith('task:')) return;
    final taskId = payload.substring('task:'.length);
    if (taskId.isEmpty) return;
    if (taskId.startsWith('card-payment-')) {
      final cardId = taskId.substring('card-payment-'.length);
      if (cardId.isEmpty || cardId == _pendingCardPaymentNavigationId) return;
      _pendingCardPaymentNavigationId = cardId;
      _notifyIfActive();
      return;
    }
    if (taskId == _pendingTaskNavigationId) return;
    _pendingTaskNavigationId = taskId;
    _notifyIfActive();
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

  /// Ant expenses are selected-period expenses explicitly categorized with
  /// the protected `Gasto Hormiga` category.
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
      return _isConsumptionExpense(transaction) &&
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

  /// Unbudgeted expenses include every selected-period expense that does not
  /// match a budget category. Ant expenses are one explicit subset of these.
  double get unbudgetedExpensesForSelectedPeriod {
    return transactionsForSelectedPeriod.where(_isUnbudgetedExpense).fold(
          0,
          (sum, transaction) => sum + transaction.amount,
        );
  }

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
    return unbudgetedExpensesForSelectedPeriod;
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
        .where(_isConsumptionExpense)
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }

  double get totalExpenses => totalSpent;

  void selectPeriod(FinancePeriod period) {
    if (_selectedPeriod == period) {
      return;
    }

    _selectedPeriod = period;
    _notifyIfActive();
    _queueReminderReconciliation();
  }

  bool _isBudgetedExpense(TransactionEntry transaction) {
    if (!_isConsumptionExpense(transaction)) {
      return false;
    }

    final transactionCategory = _normalizeCategoryName(transaction.category);
    return _categories.any((category) {
      return !category.isProtected &&
          _normalizeCategoryName(category.title) == transactionCategory;
    });
  }

  bool _isAntExpense(TransactionEntry transaction) {
    return _isConsumptionExpense(transaction) &&
        _normalizeCategoryName(transaction.category) ==
            _normalizeCategoryName(BudgetCategory.antExpenseTitle);
  }

  bool _isUnbudgetedExpense(TransactionEntry transaction) {
    return _isConsumptionExpense(transaction) &&
        !_isBudgetedExpense(transaction);
  }

  bool _isConsumptionExpense(TransactionEntry transaction) {
    return transaction.type == TransactionType.expense;
  }

  // Budgeted expenses match a regular budget category, ant expenses match the
  // protected category explicitly, and all unmatched expenses are unbudgeted.
  // BudgetCategory.spent remains only for database compatibility; monthly
  // figures are derived from transactionsForSelectedPeriod.
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
        final cardPaymentAmount = cardMonthlyPaymentAmount(card.id);
        final dueDate = cardPaymentCaptureDueDate(card.id, now: now);
        final isPending = isCardPaymentPendingCapture(card.id);
        final isProvisional = isCardPaymentProvisional(card.id);
        return FinancialTask(
          id: 'card-payment-${card.id}',
          title: isPending
              ? 'Agregar pago de ${_friendlyCardName(card.name)}'
              : isProvisional
                  ? 'Capturar pago de ${_friendlyCardName(card.name)} (estimado)'
                  : 'Pagar ${_friendlyCardName(card.name)}',
          amount: cardPaymentAmount,
          type: FinancialTaskType.cardPayment,
          status: FinancialTaskStatus.pending,
          dueDate: dueDate,
          sourceId: card.id,
          sourceType: FinancialTaskSourceType.card,
          notes: isPending
              ? 'Pendiente de capturar.'
              : isProvisional
                  ? 'Solo incluye las mensualidades MSI registradas.'
                  : null,
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
    ].where((task) {
      return task.type == FinancialTaskType.cardPayment || task.amount > 0;
    }).toList(growable: false);
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
    return 0;
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
    final payment = cardMonthlyPaymentFor(cardId);
    final estimatedAmount = estimatedCardMonthlyPayment(cardId);
    final amount = payment.amount(estimatedAmount);
    final source = payment.source(estimatedAmount);

    if (source == CreditCardPaymentSource.estimated) {
      return amount + monthlyInstallmentPaymentForCard(cardId);
    }

    return amount;
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

  bool hasExplicitCardMonthlyPayment(String cardId) {
    final source = cardMonthlyPaymentSource(cardId);
    return source == CreditCardPaymentSource.manual ||
        source == CreditCardPaymentSource.confirmed;
  }

  bool isCardPaymentPendingCapture(String cardId) {
    return !hasExplicitCardMonthlyPayment(cardId) &&
        monthlyInstallmentPaymentForCard(cardId) == 0;
  }

  bool isCardPaymentProvisional(String cardId) {
    return !hasExplicitCardMonthlyPayment(cardId) &&
        monthlyInstallmentPaymentForCard(cardId) > 0;
  }

  DateTime cardPaymentCaptureDueDate(String cardId, {DateTime? now}) {
    final card = creditCardById(cardId);
    final reference = now ?? DateTime.now();
    if (card == null) {
      return DateTime(reference.year, reference.month, reference.day + 1);
    }

    DateTime nextFor(int year, int month) {
      final lastDay = DateTime(year, month + 1, 0).day;
      final cutDay = card.statementCutDay.clamp(1, lastDay);
      return DateTime(year, month, cutDay).add(const Duration(days: 1));
    }

    var candidate = nextFor(reference.year, reference.month);
    if (!candidate.isAfter(reference)) {
      candidate = nextFor(reference.year, reference.month + 1);
    }
    return candidate;
  }

  Future<bool> configureCardPaymentReminder(
    String cardId, {
    required bool enabled,
    TaskReminderMode? mode,
    int? hour,
    int? minute,
    DateTime? customScheduledAt,
  }) async {
    if (enabled && !_notificationPreferences.enabled) {
      final granted = await enableTaskReminders();
      if (!granted) return false;
    }

    updateTaskReminder(
      cardPaymentTaskId(cardId),
      enabled: enabled,
      mode: mode,
      hour: hour,
      minute: minute,
      customScheduledAt: customScheduledAt,
    );
    return true;
  }

  String cardPaymentReminderTitle(String cardId) {
    final cardName = creditCardById(cardId)?.name ?? 'tu tarjeta';
    return 'Agrega el pago de $cardName';
  }

  String cardPaymentReminderMessage(String cardId) {
    final cardName = creditCardById(cardId)?.name ?? 'tu tarjeta';
    return 'Tu corte ya paso. Captura el pago para no generar intereses de '
        '$cardName para mantener actualizado tu plan.';
  }

  void _removeTaskReminder(String taskId) {
    final reminder = taskReminderFor(taskId);
    if (reminder != null && _notificationSchedulerInitialized) {
      _pendingNotificationWork =
          _pendingNotificationWork.catchError((_) {}).then((_) {
        return _notificationScheduler
            .cancelTaskReminder(reminder.notificationId);
      });
    }
    _taskReminders.removeWhere((item) => item.taskId == taskId);
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

  String? addManualFinancialTask({
    required String title,
    required double amount,
    String? notes,
    DateTime? dueDate,
    FinancialTaskStatus status = FinancialTaskStatus.pending,
    double? actualAmount,
  }) {
    if (title.trim().isEmpty || amount < 0) {
      return null;
    }

    final id = 'manual-task-${DateTime.now().microsecondsSinceEpoch}';
    _manualTasks.add(
      FinancialTask(
        id: id,
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
    return id;
  }

  void updateFinancialTask(
    String id, {
    String? title,
    double? amount,
    FinancialTaskStatus? status,
    double? actualAmount,
    DateTime? dueDate,
    String? notes,
    bool clearDueDate = false,
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
        clearDueDate: clearDueDate,
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
      clearDueDate: clearDueDate,
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
    final reminder = taskReminderFor(id);
    if (reminder != null && _notificationSchedulerInitialized) {
      _pendingNotificationWork =
          _pendingNotificationWork.catchError((_) {}).then(
                (_) => _notificationScheduler.cancelTaskReminder(
                  reminder.notificationId,
                ),
              );
    }
    _taskReminders.removeWhere((item) => item.taskId == id);
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
          creditCardId: transaction.creditCardId,
          cardTransactionKind: transaction.cardTransactionKind,
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

  String? addTransaction({
    required String title,
    required double amount,
    required String categoryTitle,
    required TransactionType type,
    required DateTime date,
    String? creditCardId,
    CardTransactionKind? cardTransactionKind,
  }) {
    final newTransaction = _buildTransactionEntry(
      id: 'tx-${DateTime.now().microsecondsSinceEpoch}',
      title: title,
      amount: amount,
      categoryTitle: categoryTitle,
      type: type,
      date: date,
      creditCardId: creditCardId,
      cardTransactionKind: cardTransactionKind,
    );
    if (newTransaction == null) {
      return null;
    }

    final nextTransactions = List<TransactionEntry>.of(_transactions)
      ..add(newTransaction);
    _sortTransactionsByDateDesc(nextTransactions);
    final nextCreditCards = List<CreditCard>.of(_creditCards);
    final nextCategories = List<BudgetCategory>.of(_categories);

    if (!_applyTransactionCardEffect(nextCreditCards, newTransaction)) {
      return null;
    }
    _applyTransactionCategoryEffect(nextCategories, newTransaction);

    _transactions = nextTransactions;
    _creditCards = nextCreditCards;
    _categories = nextCategories;
    _persistAndNotify();
    return newTransaction.id;
  }

  void _addGeneratedTransaction(TransactionEntry transaction) {
    if (transaction.id.trim().isEmpty ||
        !transaction.amount.isFinite ||
        transaction.amount <= 0 ||
        transaction.category.trim().isEmpty ||
        transaction.date.year < 1 ||
        _transactions.any((item) => item.id == transaction.id)) {
      throw ArgumentError('Movimiento generado invalido o duplicado.');
    }
    _transactions.insert(0, transaction);
  }

  bool updateTransaction(
    String id, {
    required String title,
    required double amount,
    required String categoryTitle,
    required TransactionType type,
    required DateTime date,
    String? creditCardId,
    CardTransactionKind? cardTransactionKind,
  }) {
    final index =
        _transactions.indexWhere((transaction) => transaction.id == id);
    if (index == -1) {
      return false;
    }

    final current = _transactions[index];
    final nextTransaction = _buildTransactionEntry(
      id: current.id,
      title: title,
      amount: amount,
      categoryTitle: categoryTitle,
      type: type,
      date: date,
      creditCardId: creditCardId,
      cardTransactionKind: cardTransactionKind,
    );
    if (nextTransaction == null) {
      return false;
    }

    final nextTransactions = List<TransactionEntry>.of(_transactions);
    final nextCreditCards = List<CreditCard>.of(_creditCards);
    final nextCategories = List<BudgetCategory>.of(_categories);

    if (!_revertTransactionCardEffect(nextCreditCards, current)) {
      return false;
    }
    _applyTransactionCategoryEffect(
      nextCategories,
      current,
      revert: true,
    );
    if (!_applyTransactionCardEffect(nextCreditCards, nextTransaction)) {
      return false;
    }
    _applyTransactionCategoryEffect(nextCategories, nextTransaction);

    nextTransactions[index] = nextTransaction;
    _sortTransactionsByDateDesc(nextTransactions);
    _transactions = nextTransactions;
    _creditCards = nextCreditCards;
    _categories = nextCategories;
    _persistAndNotify();
    return true;
  }

  String? registerCreditCardPayment({
    required String cardId,
    required double amount,
    required DateTime date,
    String? title,
  }) {
    final card = creditCardById(cardId);
    if (card == null ||
        amount <= 0 ||
        !amount.isFinite ||
        amount > card.usedBalance) {
      return null;
    }

    final normalizedTitle = _blankToNull(title) ?? 'Pago a ${card.name}';
    return addTransaction(
      title: normalizedTitle,
      amount: amount,
      categoryTitle: cardPaymentCategoryTitle,
      type: TransactionType.cardPayment,
      date: date,
      creditCardId: cardId,
      cardTransactionKind: CardTransactionKind.payment,
    );
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
    double? paymentAmount,
    bool paymentConfirmed = false,
    bool remindAfterCut = false,
    TaskReminderMode? reminderMode,
    DateTime? reminderCustomScheduledAt,
  }) {
    final normalizedName = name.trim();
    if (normalizedName.isEmpty ||
        creditLimit <= 0 ||
        usedBalance < 0 ||
        statementCutDay < 1 ||
        statementCutDay > 31) {
      return;
    }

    final cardId = 'card-${DateTime.now().microsecondsSinceEpoch}';
    _creditCards.add(
      CreditCard(
        id: cardId,
        name: normalizedName,
        creditLimit: creditLimit,
        usedBalance: usedBalance,
        statementCutDay: statementCutDay,
      ),
    );
    if (paymentAmount != null) {
      _cardMonthlyPayments.add(
        paymentConfirmed
            ? CreditCardMonthlyPayment(
                cardId: cardId,
                confirmedAmount: paymentAmount,
              )
            : CreditCardMonthlyPayment(
                cardId: cardId,
                manualAmount: paymentAmount,
              ),
      );
    }
    if (remindAfterCut && paymentAmount == null) {
      final now = DateTime.now();
      final selectedMode = reminderMode ?? TaskReminderMode.sameDay;
      final dueDate = cardPaymentCaptureDueDate(cardId, now: now);
      final scheduledAt = selectedMode == TaskReminderMode.custom
          ? reminderCustomScheduledAt
          : null;
      final usedIds = _taskReminders.map((item) => item.notificationId).toSet();
      var nextId = 1000;
      while (usedIds.contains(nextId)) {
        nextId++;
      }
      _taskReminders.add(
        TaskReminder(
          taskId: cardPaymentTaskId(cardId),
          notificationId: nextId,
          enabled: true,
          mode: selectedMode,
          hour: now.hour,
          minute: now.minute,
          customScheduledAt:
              selectedMode == TaskReminderMode.custom ? scheduledAt : null,
          createdAt: now,
          updatedAt: now,
        ),
      );
      if (selectedMode != TaskReminderMode.custom) {
        _taskReminders[_taskReminders.length - 1] =
            _taskReminders.last.copyWith(
          hour: dueDate.hour,
          minute: dueDate.minute,
          updatedAt: now,
        );
      }
    }
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
    _removeTaskReminder(cardPaymentTaskId(cardId));
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

  bool hasLinkedTransactionsForCard(String cardId) {
    return _transactions
        .any((transaction) => transaction.creditCardId == cardId);
  }

  bool deleteCreditCard(String id) {
    if (hasLinkedTransactionsForCard(id)) {
      return false;
    }

    final cardIndex = _creditCards.indexWhere((card) => card.id == id);
    if (cardIndex == -1) {
      return false;
    }

    _creditCards.removeAt(cardIndex);
    _creditCardPurchases.removeWhere((purchase) => purchase.cardId == id);
    _subscriptions.removeWhere((subscription) => subscription.cardId == id);
    _cardMonthlyPayments.removeWhere((payment) => payment.cardId == id);
    _removeTaskReminder(cardPaymentTaskId(id));
    _persistAndNotify();
    return true;
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

  bool deleteTransaction(String id) {
    final index = _transactions.indexWhere((transaction) {
      return transaction.id == id;
    });

    if (index == -1) {
      return false;
    }

    final transaction = _transactions[index];
    final nextTransactions = List<TransactionEntry>.of(_transactions)
      ..removeAt(index);
    final nextCreditCards = List<CreditCard>.of(_creditCards);
    final nextCategories = List<BudgetCategory>.of(_categories);

    if (!_revertTransactionCardEffect(nextCreditCards, transaction)) {
      return false;
    }
    _applyTransactionCategoryEffect(nextCategories, transaction, revert: true);

    _transactions = nextTransactions;
    _creditCards = nextCreditCards;
    _categories = nextCategories;
    _persistAndNotify();
    return true;
  }

  TransactionEntry? _buildTransactionEntry({
    required String id,
    required String title,
    required double amount,
    required String categoryTitle,
    required TransactionType type,
    required DateTime date,
    String? creditCardId,
    CardTransactionKind? cardTransactionKind,
  }) {
    final normalizedTitle = title.trim();
    final normalizedCategory = categoryTitle.trim();
    if (normalizedTitle.isEmpty ||
        !amount.isFinite ||
        amount <= 0 ||
        date.year < 1) {
      return null;
    }

    final hasCardLink = creditCardId != null || cardTransactionKind != null;
    if (!hasCardLink) {
      if (normalizedCategory.isEmpty) {
        return null;
      }
      if (type == TransactionType.cardPayment) {
        return null;
      }
      return TransactionEntry(
        id: id,
        title: normalizedTitle,
        amount: amount,
        category: normalizedCategory,
        date: date,
        type: type,
      );
    }

    if (creditCardId == null ||
        cardTransactionKind == null ||
        creditCardById(creditCardId) == null) {
      return null;
    }

    if (cardTransactionKind == CardTransactionKind.purchase &&
        type != TransactionType.expense) {
      return null;
    }
    if (cardTransactionKind == CardTransactionKind.payment &&
        type != TransactionType.cardPayment) {
      return null;
    }

    final category = cardTransactionKind == CardTransactionKind.payment
        ? cardPaymentCategoryTitle
        : normalizedCategory;
    if (category.trim().isEmpty) {
      return null;
    }

    return TransactionEntry(
      id: id,
      title: normalizedTitle,
      amount: amount,
      category: category,
      date: date,
      type: type,
      creditCardId: creditCardId,
      cardTransactionKind: cardTransactionKind,
    );
  }

  bool _applyTransactionCardEffect(
    List<CreditCard> cards,
    TransactionEntry transaction,
  ) {
    final cardId = transaction.creditCardId;
    final kind = transaction.cardTransactionKind;
    if (cardId == null || kind == null) {
      return true;
    }

    final cardIndex = cards.indexWhere((card) => card.id == cardId);
    if (cardIndex == -1) {
      return false;
    }

    final card = cards[cardIndex];
    final delta = kind == CardTransactionKind.purchase
        ? transaction.amount
        : -transaction.amount;
    final nextBalance = card.usedBalance + delta;
    if (!nextBalance.isFinite || nextBalance < 0) {
      return false;
    }

    cards[cardIndex] = card.copyWith(usedBalance: nextBalance);
    return true;
  }

  bool _revertTransactionCardEffect(
    List<CreditCard> cards,
    TransactionEntry transaction,
  ) {
    final cardId = transaction.creditCardId;
    final kind = transaction.cardTransactionKind;
    if (cardId == null || kind == null) {
      return true;
    }

    final cardIndex = cards.indexWhere((card) => card.id == cardId);
    if (cardIndex == -1) {
      return false;
    }

    final card = cards[cardIndex];
    final delta = kind == CardTransactionKind.purchase
        ? -transaction.amount
        : transaction.amount;
    final nextBalance = card.usedBalance + delta;
    if (!nextBalance.isFinite || nextBalance < 0) {
      return false;
    }

    cards[cardIndex] = card.copyWith(usedBalance: nextBalance);
    return true;
  }

  void _applyTransactionCategoryEffect(
    List<BudgetCategory> categories,
    TransactionEntry transaction, {
    bool revert = false,
  }) {
    if (!_isConsumptionExpense(transaction)) {
      return;
    }

    final amount = revert ? -transaction.amount : transaction.amount;
    _addSpentToCategoryIn(categories, transaction.category, amount);
  }

  void _addSpentToCategoryIn(
    List<BudgetCategory> categories,
    String title,
    double amount,
  ) {
    final normalizedTitle = _normalizeCategoryName(title);
    final index = categories.indexWhere((category) {
      return _normalizeCategoryName(category.title) == normalizedTitle;
    });

    if (index == -1) {
      return;
    }

    final category = categories[index];
    final nextSpent = (category.spent + amount).clamp(0, double.infinity);
    categories[index] = category.copyWith(spent: nextSpent.toDouble());
  }

  void _sortTransactionsByDateDesc(List<TransactionEntry> transactions) {
    transactions.sort((a, b) => b.date.compareTo(a.date));
  }

  void _persistAndNotify() {
    _notifyIfActive();
    _queueReminderReconciliation();
    final repository = _repository;
    if (repository == null) {
      return;
    }

    final snapshot = _snapshot();
    _enqueueSave(repository, snapshot);
  }

  Future<void> _queueReminderReconciliation() {
    if (!_notificationSchedulerInitialized) return Future.value();
    _pendingNotificationWork = _pendingNotificationWork
        .catchError((_) {})
        .then((_) => _reconcileTaskReminders())
        .catchError((Object error) {
      _notificationError = error.toString();
      _notifyIfActive();
    });
    return _pendingNotificationWork;
  }

  Future<void> _reconcileTaskReminders() async {
    final tasksById = {
      for (final task in monthlyFinancialTasks) task.id: task,
    };
    final canScheduleGlobally = _notificationPreferences.enabled &&
        _notificationPermissionStatus == NotificationPermissionStatus.granted;
    final now = DateTime.now();
    final knownIds = _taskReminders.map((item) => item.notificationId).toSet();
    final pendingIds =
        await _notificationScheduler.pendingTaskNotificationIds();
    for (final pendingId in pendingIds) {
      if (pendingId >= 1000 && !knownIds.contains(pendingId)) {
        await _notificationScheduler.cancelTaskReminder(pendingId);
      }
    }

    for (final reminder in _taskReminders) {
      final task = tasksById[reminder.taskId];
      final scheduledAt =
          task == null ? null : reminder.scheduledAtFor(task.dueDate);
      final taskCanBeScheduled = task != null &&
          (task.status == FinancialTaskStatus.pending ||
              task.status == FinancialTaskStatus.partial) &&
          reminder.enabled &&
          scheduledAt != null &&
          scheduledAt.isAfter(now);

      await _notificationScheduler.cancelTaskReminder(
        reminder.notificationId,
      );
      if (!canScheduleGlobally || !taskCanBeScheduled) continue;

      final dueDate = task.dueDate!;
      final dueLabel = '${dueDate.day.toString().padLeft(2, '0')}/'
          '${dueDate.month.toString().padLeft(2, '0')}';
      final title = task.type == FinancialTaskType.cardPayment
          ? cardPaymentReminderTitle(task.sourceId ?? '')
          : 'App Finance';
      final body = task.type == FinancialTaskType.cardPayment
          ? cardPaymentReminderMessage(task.sourceId ?? '')
          : 'Tienes una tarea financiera pendiente para el $dueLabel.';
      await _notificationScheduler.scheduleTaskReminder(
        notificationId: reminder.notificationId,
        title: title,
        body: body,
        scheduledAt: scheduledAt,
        payload: 'task:${task.id}',
      );
    }
    _notificationError = null;
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
    _notificationPreferences = snapshot.notificationPreferences;
    _taskReminders = List.of(snapshot.taskReminders);
    _tandas = List.of(snapshot.tandas);
    _tandaContributions = List.of(snapshot.tandaContributions);
    _tandaReceipts = List.of(snapshot.tandaReceipts);
    for (final tanda in List<Tanda>.of(_tandas)) {
      _synchronizeTandaProgress(tanda.id);
    }
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
      notificationPreferences: _notificationPreferences,
      taskReminders: List.of(_taskReminders),
      tandas: List.of(_tandas),
      tandaContributions: List.of(_tandaContributions),
      tandaReceipts: List.of(_tandaReceipts),
    );
  }

  List<TandaContribution> _buildContributionSchedule(Tanda tanda) {
    return List.generate(
      tanda.participantCount,
      (index) {
        final sequence = index + 1;
        return TandaContribution(
          id: '${tanda.id}-contribution-$sequence',
          tandaId: tanda.id,
          sequenceNumber: sequence,
          amount: tanda.contributionAmount,
          scheduledDate: tanda.contributionDateForSequence(sequence),
          status: TandaContributionStatus.pending,
          paidAt: null,
          createdAt: tanda.createdAt,
        );
      },
      growable: false,
    );
  }

  TandaReceipt _buildTandaReceipt(Tanda tanda) {
    return TandaReceipt(
      id: receiptIdForTanda(tanda.id),
      tandaId: tanda.id,
      amount: tanda.totalExpectedAmount,
      scheduledDate: tanda.estimatedReceiveDate,
      status: TandaReceiptStatus.pending,
      receivedAt: null,
      createdAt: tanda.createdAt,
    );
  }

  void _synchronizeTandaProgress(String tandaId) {
    final index = _tandas.indexWhere((item) => item.id == tandaId);
    if (index == -1) return;
    final tanda = _tandas[index];
    final paid = _tandaContributions
        .where((item) => item.tandaId == tandaId && item.isPaid)
        .length;
    // El contador se conserva por compatibilidad con Drift v2, pero el
    // historial individual es la fuente de verdad funcional del progreso.
    final status = tanda.status == TandaStatus.cancelled
        ? TandaStatus.cancelled
        : paid == tanda.participantCount
            ? TandaStatus.completed
            : TandaStatus.active;
    _tandas[index] = tanda.copyWith(
      completedContributions: paid,
      status: status,
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
