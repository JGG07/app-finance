import '../constants/app_constants.dart';

class CurrencyConverter {
  const CurrencyConverter._();

  static double usdToMxn(
    num amount, {
    double rate = AppConstants.usdToMxnRate,
  }) {
    return amount * rate;
  }
}
