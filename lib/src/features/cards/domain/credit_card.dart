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
