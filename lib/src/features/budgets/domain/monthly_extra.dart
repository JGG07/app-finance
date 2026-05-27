enum MonthlyExtraStatus {
  reserved,
  toDeliver,
  delivered,
  paid,
}

class MonthlyExtra {
  const MonthlyExtra({
    required this.id,
    required this.name,
    required this.amount,
    required this.status,
    required this.includedInPlan,
    this.person,
    this.notes,
  });

  final String id;
  final String name;
  final double amount;
  final MonthlyExtraStatus status;
  final bool includedInPlan;
  final String? person;
  final String? notes;

  MonthlyExtra copyWith({
    String? name,
    double? amount,
    MonthlyExtraStatus? status,
    bool? includedInPlan,
    String? person,
    String? notes,
  }) {
    return MonthlyExtra(
      id: id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      includedInPlan: includedInPlan ?? this.includedInPlan,
      person: person ?? this.person,
      notes: notes ?? this.notes,
    );
  }
}
