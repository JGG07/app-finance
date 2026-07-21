class SubscriptionEntry {
  const SubscriptionEntry({
    required this.id,
    required this.name,
    required this.amount,
    required this.cardId,
  });

  final String id;
  final String name;
  final double amount;
  final String cardId;

  SubscriptionEntry copyWith({
    String? name,
    double? amount,
    String? cardId,
  }) {
    return SubscriptionEntry(
      id: id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      cardId: cardId ?? this.cardId,
    );
  }
}
