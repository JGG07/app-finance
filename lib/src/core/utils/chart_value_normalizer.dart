class ChartValueNormalizer {
  const ChartValueNormalizer._();

  static double positive(double value) {
    return value.isFinite && value > 0 ? value : 0;
  }

  static double positiveTotal(Iterable<double> values) {
    return values.fold(0, (sum, value) => sum + positive(value));
  }

  static double fraction(double value, double total) {
    final safeTotal = positive(total);
    if (safeTotal == 0) {
      return 0;
    }

    return (positive(value) / safeTotal).clamp(0.0, 1.0).toDouble();
  }
}
