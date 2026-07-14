import 'package:drift/drift.dart';

class FinancialTasks extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  RealColumn get amount => real()();
  TextColumn get type => text()();
  TextColumn get status => text()();
  DateTimeColumn get createdAt => dateTime()();
  RealColumn get actualAmount => real().nullable()();
  DateTimeColumn get dueDate => dateTime().nullable()();
  TextColumn get sourceId => text().nullable()();
  TextColumn get sourceType => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
