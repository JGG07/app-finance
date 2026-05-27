enum CreditCardPaymentSource {
  estimated,
  confirmed,
  manual,
}

class CreditCardMonthlyPayment {
  const CreditCardMonthlyPayment({
    required this.cardId,
    this.manualAmount,
    this.confirmedAmount,
  });

  final String cardId;
  final double? manualAmount;
  final double? confirmedAmount;

  CreditCardPaymentSource source(double estimatedAmount) {
    if (manualAmount != null) {
      return CreditCardPaymentSource.manual;
    }

    if (confirmedAmount != null) {
      return CreditCardPaymentSource.confirmed;
    }

    return CreditCardPaymentSource.estimated;
  }

  double amount(double estimatedAmount) {
    return manualAmount ?? confirmedAmount ?? estimatedAmount;
  }

  CreditCardMonthlyPayment copyWith({
    double? manualAmount,
    double? confirmedAmount,
    bool clearManualAmount = false,
    bool clearConfirmedAmount = false,
  }) {
    return CreditCardMonthlyPayment(
      cardId: cardId,
      manualAmount: clearManualAmount ? null : manualAmount ?? this.manualAmount,
      confirmedAmount: clearConfirmedAmount
          ? null
          : confirmedAmount ?? this.confirmedAmount,
    );
  }
}
