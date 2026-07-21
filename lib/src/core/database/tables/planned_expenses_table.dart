import 'package:drift/drift.dart';

class PlannedExpenses extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  RealColumn get amount => real()();
  TextColumn get group => text()();
  TextColumn get status => text()();
  TextColumn get paymentSource => text().nullable()();
  TextColumn get note => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
