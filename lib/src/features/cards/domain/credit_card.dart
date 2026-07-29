class CreditCard {
  const CreditCard({
    required this.id,
    required this.name,
    required this.creditLimit,
    required this.usedBalance,
    required this.statementCutDay,
  });

  final String id;
  final String name;
  final double creditLimit;
  final double usedBalance;
  final int statementCutDay;

  double get availableCredit => creditLimit - usedBalance;

  double get utilizationPercent {
    if (!creditLimit.isFinite ||
        !usedBalance.isFinite ||
        creditLimit <= 0 ||
        usedBalance <= 0) {
      return 0;
    }

    return usedBalance / creditLimit * 100;
  }

  double get utilizationProgress {
    return (utilizationPercent.clamp(0, 100) / 100).toDouble();
  }

  CreditCard copyWith({
    String? name,
    double? creditLimit,
    double? usedBalance,
    int? statementCutDay,
  }) {
    return CreditCard(
      id: id,
      name: name ?? this.name,
      creditLimit: creditLimit ?? this.creditLimit,
      usedBalance: usedBalance ?? this.usedBalance,
      statementCutDay: statementCutDay ?? this.statementCutDay,
    );
  }
}
