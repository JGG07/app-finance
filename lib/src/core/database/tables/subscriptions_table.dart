import 'package:drift/drift.dart';

class Subscriptions extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  RealColumn get amount => real()();
  TextColumn get cardId => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
