import 'package:drift/drift.dart';

class MonthlyExtras extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  RealColumn get amount => real()();
  TextColumn get status => text()();
  BoolColumn get includedInPlan => boolean()();
  TextColumn get person => text().nullable()();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
