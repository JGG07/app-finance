import 'package:app_finance/src/app/app.dart';
import 'package:flutter/material.dart' show Size, TextFormField, ValueKey;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart'
    show FilledButton, PopupMenuButton, TextButton;

void main() {
  testWidgets('renders dashboard shell', (tester) async {
    await tester.pumpWidget(const AppFinance(enablePersistence: false));
    await _chooseNoSavingsPlan(tester);

    expect(find.text('Resumen financiero'), findsOneWidget);
    expect(find.text('INGRESO DEL MES'), findsOneWidget);
    expect(find.text('Movimientos'), findsWidgets);
    expect(find.text('Presupuesto'), findsWidgets);
    expect(
      find.textContaining('En gastos hormiga has gastado'),
      findsOneWidget,
    );
  });

  testWidgets('opens each section from the income breakdown', (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const AppFinance(enablePersistence: false));
    await _chooseNoSavingsPlan(tester);

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
    expect(find.text('Gasto Hormiga'), findsOneWidget);
    expect(find.text('Total presupuestado'), findsOneWidget);
    expect(find.text('Gastos'), findsOneWidget);
    expect(find.text('Disponible'), findsOneWidget);
    expect(find.text('Total utilizado'), findsNothing);

    await returnToDashboard();
    await openBreakdown('income-breakdown-savings');
    expect(
      find.text('Organiza tu sobrante y marca lo que ya hiciste este mes.'),
      findsOneWidget,
    );
    expect(find.text('0%'), findsAtLeastNWidgets(3));
  });

  testWidgets('creates a movement category without framework errors', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const AppFinance(enablePersistence: false));
    await _chooseNoSavingsPlan(tester);
    await tester.tap(find.text('Movimientos').last);
    await tester.pumpAndSettle();
    expect(find.text('Gastos'), findsWidgets);
    await tester.tap(find.byTooltip('Nuevo movimiento'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Nueva categoria'));
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

  testWidgets('shows tanda section and opens its validated form', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(900, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const AppFinance(enablePersistence: false));
    await _chooseNoSavingsPlan(tester);
    await tester.tap(find.text('Plan').last);
    await tester.pumpAndSettle();

    expect(find.text('Tandas'), findsOneWidget);
    expect(find.text('Aun no tienes tandas registradas.'), findsOneWidget);
    expect(
      find.textContaining('se agrega automaticamente'),
      findsOneWidget,
    );
    expect(
      find.textContaining(
        'todavia no se registra automaticamente como ingreso',
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('Nueva tanda'));
    await tester.pumpAndSettle();
    expect(find.text('Nueva tanda'), findsAtLeastNWidgets(1));

    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Revisa los campos numericos.'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nombre'),
      'Tanda oficina',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Monto por aportacion'),
      '1000',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Participantes'),
      '10',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Turno asignado'),
      '4',
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Recibiras aproximadamente'), findsOneWidget);
    expect(find.text('Total de aportaciones: 10'), findsOneWidget);

    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Ver aportaciones'), findsOneWidget);
    expect(find.text('Recepcion de la tanda'), findsOneWidget);
    expect(find.text('Recepcion pendiente'), findsOneWidget);
    expect(find.textContaining('Monto esperado:'), findsOneWidget);
    tester
        .widget<TextButton>(
          find.widgetWithText(TextButton, 'Ver aportaciones'),
        )
        .onPressed!();
    await tester.pumpAndSettle();
    expect(find.text('Aportacion 1 de 10'), findsOneWidget);
    expect(find.text('Siguiente aportacion'), findsOneWidget);
    expect(find.text('Pendiente'), findsAtLeastNWidgets(1));
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    tester
        .widget<FilledButton>(
          find.widgetWithText(FilledButton, 'Registrar aportacion'),
        )
        .onPressed!();
    await tester.pumpAndSettle();
    tester
        .widget<TextButton>(
          find.widgetWithText(TextButton, 'Ver aportaciones'),
        )
        .onPressed!();
    await tester.pumpAndSettle();
    expect(find.text('Movimiento registrado'), findsOneWidget);
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    tester
        .widget<PopupMenuButton<String>>(
          find.byType(PopupMenuButton<String>),
        )
        .onSelected!('delete');
    await tester.pumpAndSettle();
    expect(find.text('Eliminar todo'), findsOneWidget);
    expect(find.text('Eliminar y conservar movimientos'), findsOneWidget);
    expect(find.textContaining('ingreso de recepcion'), findsOneWidget);
  });
}

Future<void> _chooseNoSavingsPlan(WidgetTester tester) async {
  expect(find.text('Como quieres organizar tu dinero?'), findsOneWidget);
  await tester.tap(find.text('Prefiero continuar sin plan'));
  await tester.pumpAndSettle();
}
