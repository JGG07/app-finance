import 'package:app_finance/src/app/app.dart';
import 'package:flutter/material.dart' show Size, TextFormField, ValueKey;
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders dashboard shell', (tester) async {
    await tester.pumpWidget(const AppFinance(enablePersistence: false));

    expect(find.text('Resumen financiero'), findsOneWidget);
    expect(find.text('INGRESO DEL MES'), findsOneWidget);
    expect(find.text('Movimientos'), findsWidgets);
    expect(find.text('Presupuesto'), findsWidgets);
  });

  testWidgets('opens each section from the income breakdown', (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const AppFinance(enablePersistence: false));

    Future<void> openBreakdown(String key) async {
      final target = find.byKey(ValueKey(key));
      await tester.ensureVisible(target);
      await tester.tap(target);
      await tester.pumpAndSettle();
    }

    Future<void> returnToDashboard() async {
      await tester.tap(find.text('Resumen'));
      await tester.pumpAndSettle();
    }

    await openBreakdown('income-breakdown-debts');
    expect(
      find.text(
        'Agrega una tarjeta para registrar compras, pagos y suscripciones.',
      ),
      findsOneWidget,
    );

    await returnToDashboard();
    await openBreakdown('income-breakdown-apartados');
    expect(find.text('No tienes secciones de gastos creadas'), findsOneWidget);

    await returnToDashboard();
    await openBreakdown('income-breakdown-savings');
    expect(
      find.text('Organiza tu sobrante y marca lo que ya hiciste este mes.'),
      findsOneWidget,
    );
  });

  testWidgets('creates the first movement category without framework errors', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const AppFinance(enablePersistence: false));
    await tester.tap(find.text('Movimientos').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Nuevo movimiento'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Crear categoria'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(
        TextFormField,
        'Nombre de la categoria',
      ),
      'Comida',
    );
    await tester.enterText(
      find.widgetWithText(
        TextFormField,
        'Presupuesto mensual (opcional)',
      ),
      '2500',
    );
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(find.text('Comida'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
