class FinancePeriod {
  FinancePeriod({required this.year, required this.month}) {
    if (year < 1) {
      throw ArgumentError.value(year, 'year', 'Debe ser mayor que cero');
    }
    if (month < 1 || month > 12) {
      throw ArgumentError.value(month, 'month', 'Debe estar entre 1 y 12');
    }
  }

  factory FinancePeriod.current() {
    final now = DateTime.now();
    return FinancePeriod(year: now.year, month: now.month);
  }

  final int year;
  final int month;

  String get id => '$year-${month.toString().padLeft(2, '0')}';

  String get label => '${_monthNames[month - 1]} $year';

  bool contains(DateTime date) => date.year == year && date.month == month;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is FinancePeriod && other.year == year && other.month == month;
  }

  @override
  int get hashCode => Object.hash(year, month);

  static const _monthNames = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre',
  ];
}
