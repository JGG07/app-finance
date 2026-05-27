enum TransactionType {
  income,
  expense,
}

class TransactionEntry {
  const TransactionEntry({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.type,
  });

  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final TransactionType type;
}
