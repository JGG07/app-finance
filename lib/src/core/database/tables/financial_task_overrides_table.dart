import 'package:drift/drift.dart';

class FinancialTaskOverrides extends Table {
  TextColumn get taskId => text()();
  TextColumn get title => text().nullable()();
  RealColumn get amount => real().nullable()();
  TextColumn get status => text().nullable()();
  RealColumn get actualAmount => real().nullable()();
  DateTimeColumn get dueDate => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {taskId};
}
