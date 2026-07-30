enum TransactionType {
  income,
  expense,
  cardPayment,
}

enum CardTransactionKind {
  purchase,
  payment,
}

class TransactionEntry {
  const TransactionEntry({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.type,
    this.creditCardId,
    this.cardTransactionKind,
  });

  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final TransactionType type;
  final String? creditCardId;
  final CardTransactionKind? cardTransactionKind;

  bool get isCreditCardTransaction =>
      creditCardId != null && cardTransactionKind != null;

  bool get isCreditCardPurchase =>
      creditCardId != null &&
      cardTransactionKind == CardTransactionKind.purchase;

  bool get isCreditCardPayment =>
      creditCardId != null &&
      cardTransactionKind == CardTransactionKind.payment;

  TransactionEntry copyWith({
    String? title,
    double? amount,
    String? category,
    DateTime? date,
    TransactionType? type,
    String? creditCardId,
    bool clearCreditCardId = false,
    CardTransactionKind? cardTransactionKind,
    bool clearCardTransactionKind = false,
  }) {
    return TransactionEntry(
      id: id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      type: type ?? this.type,
      creditCardId:
          clearCreditCardId ? null : creditCardId ?? this.creditCardId,
      cardTransactionKind: clearCardTransactionKind
          ? null
          : cardTransactionKind ?? this.cardTransactionKind,
    );
  }
}
