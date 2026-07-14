import 'package:drift/drift.dart';

class CreditCardMonthlyPayments extends Table {
  TextColumn get cardId => text()();
  RealColumn get manualAmount => real().nullable()();
  RealColumn get confirmedAmount => real().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {cardId};
}
