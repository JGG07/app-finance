class CreditCardPurchase {
  const CreditCardPurchase({
    required this.id,
    required this.cardId,
    required this.title,
    required this.amount,
    required this.installments,
    required this.paidInstallments,
    required this.date,
  });

  final String id;
  final String cardId;
  final String title;
  final double amount;
  final int installments;
  final int paidInstallments;
  final DateTime date;

  bool get isInstallmentPurchase => installments > 1;
  int get remainingInstallments => installments - paidInstallments;
  double get monthlyPayment => amount / installments;

  int paidInstallmentsAsOf(
    DateTime asOf, {
    required int statementCutDay,
  }) {
    if (!isInstallmentPurchase || asOf.isBefore(date)) {
      return 0;
    }

    var countedInstallments = 0;
    final firstCountDate = _firstCountDate(statementCutDay);

    for (var index = 0; index < installments; index++) {
      final countDate = _addMonths(firstCountDate, index);
      if (asOf.isBefore(countDate)) {
        break;
      }

      countedInstallments++;
    }

    final calculatedPaidInstallments = paidInstallments + countedInstallments;
    return calculatedPaidInstallments.clamp(0, installments).toInt();
  }

  int remainingInstallmentsAsOf(
    DateTime asOf, {
    required int statementCutDay,
  }) {
    return installments -
        paidInstallmentsAsOf(asOf, statementCutDay: statementCutDay);
  }

  DateTime _firstCountDate(int statementCutDay) {
    final sameMonthCutDate = _cutDateFor(date.year, date.month, statementCutDay);
    final purchaseDate = DateTime(date.year, date.month, date.day);

    if (!purchaseDate.isAfter(sameMonthCutDate)) {
      return sameMonthCutDate.add(const Duration(days: 1));
    }

    final nextMonthDate = DateTime(date.year, date.month + 1);
    return _cutDateFor(
      nextMonthDate.year,
      nextMonthDate.month,
      statementCutDay,
    ).add(const Duration(days: 1));
  }

  DateTime _cutDateFor(int year, int month, int statementCutDay) {
    final lastDayOfMonth = DateTime(year, month + 1, 0).day;
    final safeCutDay = statementCutDay.clamp(1, lastDayOfMonth).toInt();
    return DateTime(year, month, safeCutDay);
  }

  DateTime _addMonths(DateTime value, int months) {
    final target = DateTime(value.year, value.month + months);
    final lastDayOfMonth = DateTime(target.year, target.month + 1, 0).day;
    final safeDay = value.day.clamp(1, lastDayOfMonth).toInt();
    return DateTime(target.year, target.month, safeDay);
  }
}
