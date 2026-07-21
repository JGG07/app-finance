import 'package:app_finance/src/core/utils/chart_value_normalizer.dart';
import 'package:app_finance/src/core/utils/currency_formatter.dart';
import 'package:app_finance/src/features/dashboard/presentation/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('chart values ignore negatives and never exceed a full fraction', () {
    expect(ChartValueNormalizer.positive(-50), 0);
    expect(ChartValueNormalizer.positiveTotal([100, 150, -50]), 250);
    expect(ChartValueNormalizer.fraction(-50, 250), 0);
    expect(ChartValueNormalizer.fraction(150, 100), 1);
    expect(ChartValueNormalizer.fraction(50, 0), 0);
  });

  testWidgets('dashboard charts render negative free money as zero visually', (
    tester,
  ) async {
    const slices = [
      DistributionSlice(
        label: 'Ingreso usado',
        amount: 100,
        percent: 100,
        color: Colors.blue,
        icon: Icons.payments_outlined,
      ),
      DistributionSlice(
        label: 'Gasto Hormiga',
        amount: 150,
        percent: 150,
        color: Colors.orange,
        icon: Icons.pest_control_outlined,
      ),
      DistributionSlice(
        label: 'Te queda libre',
        amount: -50,
        percent: 0,
        color: Colors.green,
        icon: Icons.wallet_outlined,
      ),
    ];

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                SalaryDistributionChart(
                  slices: slices,
                  monthlyIncome: 100,
                ),
                StackedProgressBar(slices: slices),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text(CurrencyFormatter.format(-50)), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
