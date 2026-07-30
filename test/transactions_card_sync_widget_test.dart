import 'package:app_finance/src/core/state/finance_state.dart';
import 'package:app_finance/src/core/state/finance_state_provider.dart';
import 'package:app_finance/src/core/utils/currency_formatter.dart';
import 'package:app_finance/src/features/cards/presentation/cards_screen.dart';
import 'package:app_finance/src/features/transactions/domain/transaction_entry.dart';
import 'package:app_finance/src/features/transactions/presentation/transactions_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_app.dart';

Finder _categoryFieldFinder() {
  return find.byWidgetPredicate((widget) {
    return widget is DropdownButtonFormField<String> &&
        widget.decoration?.labelText == 'Seccion / categoria';
  });
}

void main() {
  testWidgets('expense form allows selecting a credit card and updates balance',
      (tester) async {
    _setLargeSurface(tester);
    final state = FinanceState();
    state.addCategory('Comida', 1000, Colors.green);
    state.addCreditCard(
      name: 'Tarjeta azul',
      creditLimit: 10000,
      usedBalance: 500,
      statementCutDay: 10,
    );
    final cardId = state.creditCards.single.id;

    await tester.pumpWidget(
      _buildStateApp(
        state: state,
        child: const TransactionsScreen(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Nuevo movimiento'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Concepto / titulo'),
      'Super',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Monto de dinero'),
      '250',
    );
    final categoryField = _categoryFieldFinder();
    await tester.ensureVisible(categoryField);
    await tester.tap(categoryField);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Comida').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Compra con tarjeta de credito'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Registrar'));
    await tester.pumpAndSettle();

    expect(state.transactions.single.creditCardId, cardId);
    expect(
      state.transactions.single.cardTransactionKind,
      CardTransactionKind.purchase,
    );
    expect(state.creditCards.single.usedBalance, 750);
    expect(find.text('Super'), findsOneWidget);
  });

  testWidgets('without cards the payment form shows an appropriate message',
      (tester) async {
    _setLargeSurface(tester);
    final state = FinanceState();
    state.addCategory('Comida', 1000, Colors.green);

    await tester.pumpWidget(
      _buildStateApp(
        state: state,
        child: const TransactionsScreen(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Nuevo movimiento'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pago a tarjeta'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('No hay tarjetas registradas'),
      findsOneWidget,
    );
  });

  testWidgets('payment from cards creates a visible linked movement',
      (tester) async {
    _setLargeSurface(tester);
    final state = FinanceState();
    state.addCreditCard(
      name: 'Tarjeta principal',
      creditLimit: 10000,
      usedBalance: 1000,
      statementCutDay: 10,
    );

    await tester.pumpWidget(
      _buildStateApp(
        state: state,
        child: const CardsScreen(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Registrar pago').first);
    await tester.tap(find.text('Registrar pago').first);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Monto pagado'),
      '300',
    );
    await tester.tap(find.text('Registrar pago').last);
    await tester.pumpAndSettle();

    expect(state.transactions, hasLength(1));
    expect(state.transactions.single.isCreditCardPayment, isTrue);
    expect(state.creditCards.single.usedBalance, 700);

    await tester.pumpWidget(
      _buildStateApp(
        state: state,
        child: const TransactionsScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Pago a Tarjeta principal'), findsOneWidget);
  });

  testWidgets('editing a linked movement preserves the selected card',
      (tester) async {
    _setLargeSurface(tester);
    final state = FinanceState();
    state.addCategory('Comida', 1000, Colors.green);
    state.addCreditCard(
      name: 'Tarjeta principal',
      creditLimit: 10000,
      usedBalance: 1000,
      statementCutDay: 10,
    );
    final cardId = state.creditCards.single.id;
    state.addTransaction(
      title: 'Super',
      amount: 200,
      categoryTitle: 'Comida',
      type: TransactionType.expense,
      date: DateTime(2026, 7, 10),
      creditCardId: cardId,
      cardTransactionKind: CardTransactionKind.purchase,
    );

    await tester.pumpWidget(
      _buildStateApp(
        state: state,
        child: const TransactionsScreen(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Editar').first);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Concepto / titulo'),
      'Super editado',
    );
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(state.transactions.single.creditCardId, cardId);
    expect(state.transactions.single.title, 'Super editado');
  });

  testWidgets('deleting a linked purchase shows the card balance warning',
      (tester) async {
    _setLargeSurface(tester);
    final state = FinanceState();
    state.addCategory('Comida', 1000, Colors.green);
    state.addCreditCard(
      name: 'Tarjeta principal',
      creditLimit: 10000,
      usedBalance: 1000,
      statementCutDay: 10,
    );
    final cardId = state.creditCards.single.id;
    state.addTransaction(
      title: 'Super',
      amount: 200,
      categoryTitle: 'Comida',
      type: TransactionType.expense,
      date: DateTime(2026, 7, 10),
      creditCardId: cardId,
      cardTransactionKind: CardTransactionKind.purchase,
    );

    await tester.pumpWidget(
      _buildStateApp(
        state: state,
        child: const TransactionsScreen(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Eliminar').first);
    await tester.pumpAndSettle();

    expect(
      find.textContaining(
        'Tambien se descontara este importe del saldo utilizado de la tarjeta.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('card payment does not appear as expense in transaction summary',
      (tester) async {
    _setLargeSurface(tester);
    final state = FinanceState();
    state.addCreditCard(
      name: 'Tarjeta principal',
      creditLimit: 10000,
      usedBalance: 1000,
      statementCutDay: 10,
    );
    state.registerCreditCardPayment(
      cardId: state.creditCards.single.id,
      amount: 300,
      date: DateTime(2026, 7, 10),
    );

    await tester.pumpWidget(
      _buildStateApp(
        state: state,
        child: const TransactionsScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(state.totalExpenses, 0);
    expect(
      find.text(CurrencyFormatter.format(0)),
      findsAtLeastNWidgets(1),
    );
  });
}

void _setLargeSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(900, 1800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Widget _buildStateApp({
  required FinanceState state,
  required Widget child,
}) {
  return buildTestApp(
    child: FinanceStateProvider(
      notifier: state,
      child: child,
    ),
  );
}
