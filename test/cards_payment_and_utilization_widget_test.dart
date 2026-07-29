import 'package:app_finance/src/core/state/finance_state.dart';
import 'package:app_finance/src/core/state/finance_state_provider.dart';
import 'package:app_finance/src/core/utils/currency_formatter.dart';
import 'package:app_finance/src/features/cards/presentation/cards_screen.dart';
import 'package:app_finance/src/features/dashboard/presentation/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_app.dart';

void main() {
  testWidgets('editing card payment from Cards updates shared monthly payment',
      (tester) async {
    tester.view.physicalSize = const Size(900, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final state = FinanceState();
    state.addCreditCard(
      name: 'Tarjeta principal',
      creditLimit: 30000,
      usedBalance: 4000,
      statementCutDay: 10,
    );
    final cardId = state.creditCards.single.id;
    state.addCreditCardPurchase(
      cardId: cardId,
      title: 'Laptop',
      amount: 6000,
      installments: 6,
      date: DateTime(2026, 6, 1),
    );

    await tester.pumpWidget(
      _buildStateApp(
        state: state,
        child: const CardsScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Pago para no generar intereses'), findsOneWidget);
    expect(find.text(CurrencyFormatter.format(5000)), findsOneWidget);

    await scrollToAndTap(
      tester,
      find.text('Editar'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirmado'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Total del estado de cuenta'),
      '10000',
    );
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(state.cardMonthlyPaymentAmount(cardId), 10000);
    expect(state.totalMonthlyCardPayments, 10000);
    expect(find.text(CurrencyFormatter.format(10000)), findsAtLeastNWidgets(1));
    expect(find.text('Confirmado'), findsOneWidget);

    await tester.pumpWidget(
      _buildStateApp(
        state: state,
        child: DashboardScreen(
          onViewDebts: () {},
          onViewApartados: () {},
          onViewPlan: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(CurrencyFormatter.format(10000)), findsAtLeastNWidgets(1));
  });

  testWidgets(
      'dashboard keeps real utilization text while clamping progress to 1.0',
      (tester) async {
    tester.view.physicalSize = const Size(900, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final state = FinanceState();
    state.addCreditCard(
      name: 'Tarjeta dorada',
      creditLimit: 30000,
      usedBalance: 31500,
      statementCutDay: 10,
    );
    final cardId = state.creditCards.single.id;

    await tester.pumpWidget(
      _buildStateApp(
        state: state,
        child: DashboardScreen(
          onViewDebts: () {},
          onViewApartados: () {},
          onViewPlan: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    final scrollable = find.byType(Scrollable).first;
    await tester.dragUntilVisible(
      find.text('105% usado'),
      scrollable,
      const Offset(0, -300),
    );
    await tester.pumpAndSettle();

    expect(find.text('105% usado'), findsOneWidget);
    final indicator = tester.widget<LinearProgressIndicator>(
      find.byKey(ValueKey('debt-apartado-progress-$cardId')),
    );
    expect(indicator.value, 1.0);
  });
}

Widget _buildStateApp({
  required FinanceState state,
  required Widget child,
}) {
  return buildTestApp(
    scaffold: false,
    child: FinanceStateProvider(
      notifier: state,
      child: child,
    ),
  );
}
