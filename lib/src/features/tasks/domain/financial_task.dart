enum FinancialTaskType {
  cardPayment,
  apartado,
  saving,
  investment,
  freeUse,
  manual,
}

enum FinancialTaskStatus {
  pending,
  done,
  partial,
  skipped,
}

enum FinancialTaskSourceType {
  card,
  apartado,
  surplusPlan,
  extraIncome,
  manual,
}

class FinancialTask {
  const FinancialTask({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.status,
    required this.createdAt,
    this.actualAmount,
    this.dueDate,
    this.sourceId,
    this.sourceType,
    this.notes,
    this.completedAt,
  });

  final String id;
  final String title;
  final double amount;
  final FinancialTaskType type;
  final FinancialTaskStatus status;
  final DateTime createdAt;
  final double? actualAmount;
  final DateTime? dueDate;
  final String? sourceId;
  final FinancialTaskSourceType? sourceType;
  final String? notes;
  final DateTime? completedAt;

  FinancialTask copyWith({
    String? title,
    double? amount,
    FinancialTaskType? type,
    FinancialTaskStatus? status,
    DateTime? createdAt,
    double? actualAmount,
    DateTime? dueDate,
    String? sourceId,
    FinancialTaskSourceType? sourceType,
    String? notes,
    DateTime? completedAt,
    bool clearActualAmount = false,
    bool clearDueDate = false,
    bool clearNotes = false,
    bool clearCompletedAt = false,
  }) {
    return FinancialTask(
      id: id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      actualAmount:
          clearActualAmount ? null : actualAmount ?? this.actualAmount,
      dueDate: clearDueDate ? null : dueDate ?? this.dueDate,
      sourceId: sourceId ?? this.sourceId,
      sourceType: sourceType ?? this.sourceType,
      notes: clearNotes ? null : notes ?? this.notes,
      completedAt: clearCompletedAt ? null : completedAt ?? this.completedAt,
    );
  }
}

class FinancialTaskOverride {
  const FinancialTaskOverride({
    this.title,
    this.amount,
    this.status,
    this.actualAmount,
    this.dueDate,
    this.notes,
    this.completedAt,
  });

  final String? title;
  final double? amount;
  final FinancialTaskStatus? status;
  final double? actualAmount;
  final DateTime? dueDate;
  final String? notes;
  final DateTime? completedAt;

  FinancialTask applyTo(FinancialTask task) {
    return task.copyWith(
      title: title,
      amount: amount,
      status: status,
      actualAmount: actualAmount,
      dueDate: dueDate,
      notes: notes,
      completedAt: completedAt,
      clearActualAmount:
          actualAmount == null && status != FinancialTaskStatus.partial,
      clearCompletedAt:
          completedAt == null && status != FinancialTaskStatus.done,
    );
  }

  FinancialTaskOverride copyWith({
    String? title,
    double? amount,
    FinancialTaskStatus? status,
    double? actualAmount,
    DateTime? dueDate,
    String? notes,
    DateTime? completedAt,
    bool clearActualAmount = false,
    bool clearDueDate = false,
    bool clearNotes = false,
    bool clearCompletedAt = false,
  }) {
    return FinancialTaskOverride(
      title: title ?? this.title,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      actualAmount:
          clearActualAmount ? null : actualAmount ?? this.actualAmount,
      dueDate: clearDueDate ? null : dueDate ?? this.dueDate,
      notes: clearNotes ? null : notes ?? this.notes,
      completedAt: clearCompletedAt ? null : completedAt ?? this.completedAt,
    );
  }
}

class FinancialTaskProgress {
  const FinancialTaskProgress({
    required this.total,
    required this.completed,
  });

  final int total;
  final int completed;

  double get ratio {
    if (total == 0) {
      return 0;
    }

    return completed / total;
  }

  int get percent => (ratio * 100).round();
}
