import 'package:app_finance/src/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders dashboard shell', (tester) async {
    await tester.pumpWidget(const AppFinance());

    expect(find.text('Resumen financiero'), findsOneWidget);
    expect(find.text('INGRESO DEL MES'), findsOneWidget);
    expect(find.text('Movimientos'), findsWidgets);
    expect(find.text('Presupuesto'), findsWidgets);
  });
}
