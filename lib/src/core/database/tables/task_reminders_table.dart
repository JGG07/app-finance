import 'package:drift/drift.dart';

class TaskReminders extends Table {
  TextColumn get taskId => text()();
  IntColumn get notificationId => integer().unique()();
  BoolColumn get enabled => boolean()();
  TextColumn get mode => text()();
  IntColumn get hour => integer()();
  IntColumn get minute => integer()();
  DateTimeColumn get customScheduledAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {taskId};
}
