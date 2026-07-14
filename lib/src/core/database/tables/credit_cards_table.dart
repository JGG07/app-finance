import 'package:drift/drift.dart';

class CreditCards extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  RealColumn get creditLimit => real()();
  RealColumn get usedBalance => real()();
  IntColumn get statementCutDay => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
