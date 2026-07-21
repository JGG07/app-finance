import 'package:drift/drift.dart';

import 'tandas_table.dart';

class TandaReceipts extends Table {
  TextColumn get id => text()();
  TextColumn get tandaId =>
      text().unique().references(Tandas, #id, onDelete: KeyAction.cascade)();
  RealColumn get amount => real()();
  DateTimeColumn get scheduledDate => dateTime()();
  TextColumn get status => text()();
  DateTimeColumn get receivedAt => dateTime().nullable()();
  TextColumn get linkedTransactionId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
