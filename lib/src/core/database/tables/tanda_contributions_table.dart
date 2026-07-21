import 'package:drift/drift.dart';

import 'tandas_table.dart';

class TandaContributions extends Table {
  TextColumn get id => text()();
  TextColumn get tandaId =>
      text().references(Tandas, #id, onDelete: KeyAction.cascade)();
  IntColumn get sequenceNumber => integer()();
  RealColumn get amount => real()();
  DateTimeColumn get scheduledDate => dateTime()();
  TextColumn get status => text()();
  DateTimeColumn get paidAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get migratedFromLegacyCounter =>
      boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().nullable()();
  TextColumn get linkedTransactionId => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
        {tandaId, sequenceNumber},
      ];
}
