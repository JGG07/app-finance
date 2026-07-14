import 'package:drift/drift.dart';

class SurplusPlans extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()();
  RealColumn get manualSafetyNet => real().nullable()();
  RealColumn get manualInvestment => real().nullable()();
  RealColumn get manualFreeUse => real().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
