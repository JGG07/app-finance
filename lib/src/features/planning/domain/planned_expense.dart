enum PlannedExpenseStatus {
  pending,
  paid,
  reserved,
}

class PlannedExpense {
  const PlannedExpense({
    required this.id,
    required this.title,
    required this.amount,
    required this.group,
    required this.status,
    this.paymentSource,
    this.note,
  });

  final String id;
  final String title;
  final double amount;
  final String group;
  final PlannedExpenseStatus status;
  final String? paymentSource;
  final String? note;

  bool get affectsAvailableCash {
    return status != PlannedExpenseStatus.paid;
  }
}
