import 'package:drift/drift.dart';

class BudgetCategories extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  RealColumn get limit => real()();
  RealColumn get spent => real()();
  IntColumn get colorValue => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
