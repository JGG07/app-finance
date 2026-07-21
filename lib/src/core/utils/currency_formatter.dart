import '../constants/app_constants.dart';

class CurrencyFormatter {
  const CurrencyFormatter._();

  static String format(
    num amount, {
    String currency = AppConstants.defaultCurrency,
  }) {
    final normalized = amount.toStringAsFixed(2);
    final parts = normalized.split('.');
    final integer = parts.first;
    final cents = parts.last;
    final buffer = StringBuffer();

    for (var index = 0; index < integer.length; index++) {
      final remaining = integer.length - index;
      buffer.write(integer[index]);

      if (remaining > 1 && remaining % 3 == 1) {
        buffer.write(',');
      }
    }

    return '$currency \$${buffer.toString()}.$cents';
  }
}
