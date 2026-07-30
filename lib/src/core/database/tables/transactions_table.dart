import 'package:drift/drift.dart';

class Transactions extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  RealColumn get amount => real()();
  TextColumn get category => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get type => text()();
  TextColumn get creditCardId => text().nullable()();
  TextColumn get cardTransactionKind => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
