import 'package:app_finance/src/core/domain/finance_period.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('validates year and month', () {
    expect(
      () => FinancePeriod(year: 0, month: 1),
      throwsArgumentError,
    );
    expect(
      () => FinancePeriod(year: 2026, month: 13),
      throwsArgumentError,
    );
  });

  test('provides stable identity, equality, label and date membership', () {
    final period = FinancePeriod(year: 2026, month: 7);
    final samePeriod = FinancePeriod(year: 2026, month: 7);

    expect(period.id, '2026-07');
    expect(period.label, 'Julio 2026');
    expect(period, samePeriod);
    expect(period.hashCode, samePeriod.hashCode);
    expect(period.contains(DateTime(2026, 7, 31, 23, 59)), isTrue);
    expect(period.contains(DateTime(2026, 8)), isFalse);
  });
}
