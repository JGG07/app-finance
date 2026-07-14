import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/app_settings_table.dart';
import 'tables/budget_categories_table.dart';
import 'tables/credit_card_monthly_payments_table.dart';
import 'tables/credit_card_purchases_table.dart';
import 'tables/credit_cards_table.dart';
import 'tables/financial_task_overrides_table.dart';
import 'tables/financial_tasks_table.dart';
import 'tables/monthly_extras_table.dart';
import 'tables/planned_expenses_table.dart';
import 'tables/subscriptions_table.dart';
import 'tables/surplus_plan_table.dart';
import 'tables/transactions_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    AppSettings,
    BudgetCategories,
    Transactions,
    PlannedExpenses,
    CreditCards,
    CreditCardPurchases,
    Subscriptions,
    CreditCardMonthlyPayments,
    MonthlyExtras,
    SurplusPlans,
    FinancialTasks,
    FinancialTaskOverrides,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(
          driftDatabase(
            name: 'app_finance',
            web: DriftWebOptions(
              sqlite3Wasm: Uri.parse('sqlite3.wasm'),
              driftWorker: Uri.parse('drift_worker.dart.js'),
            ),
          ),
        );

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;
}
