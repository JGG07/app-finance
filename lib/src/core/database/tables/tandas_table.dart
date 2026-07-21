import 'package:drift/drift.dart';

class Tandas extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  RealColumn get contributionAmount => real()();
  TextColumn get frequency => text()();
  DateTimeColumn get startDate => dateTime()();
  IntColumn get participantCount => integer()();
  IntColumn get assignedTurn => integer()();
  IntColumn get completedContributions => integer()();
  TextColumn get status => text()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
