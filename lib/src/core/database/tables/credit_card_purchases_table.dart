import 'package:drift/drift.dart';

class CreditCardPurchases extends Table {
  TextColumn get id => text()();
  TextColumn get cardId => text()();
  TextColumn get title => text()();
  RealColumn get amount => real()();
  IntColumn get installments => integer()();
  IntColumn get paidInstallments => integer()();
  DateTimeColumn get date => dateTime().nullable()();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
