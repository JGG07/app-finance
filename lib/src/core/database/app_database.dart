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
import 'tables/tandas_table.dart';
import 'tables/tanda_contributions_table.dart';
import 'tables/tanda_receipts_table.dart';
import 'tables/task_reminders_table.dart';
import '../../features/tandas/domain/tanda.dart'
    show TandaFrequency, tandaDateAtInterval;

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
    Tandas,
    TandaContributions,
    TandaReceipts,
    TaskReminders,
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
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (migrator) => migrator.createAll(),
        onUpgrade: (migrator, from, to) async {
          if (from < 2) {
            await migrator.createTable(tandas);
          }
          if (from < 3) {
            await migrator.createTable(tandaContributions);
            final legacyTandas = await select(tandas).get();
            for (final row in legacyTandas) {
              for (var sequence = 1;
                  sequence <= row.participantCount;
                  sequence++) {
                final paid = sequence <= row.completedContributions;
                await into(tandaContributions).insert(
                  TandaContributionsCompanion.insert(
                    id: '${row.id}-contribution-$sequence',
                    tandaId: row.id,
                    sequenceNumber: sequence,
                    amount: row.contributionAmount,
                    scheduledDate: tandaDateAtInterval(
                      row.startDate,
                      TandaFrequency.values.byName(row.frequency),
                      sequence - 1,
                    ),
                    status: paid ? 'paid' : 'pending',
                    createdAt: row.createdAt,
                    migratedFromLegacyCounter: Value(paid),
                  ),
                  mode: InsertMode.insertOrIgnore,
                );
              }
            }
          }
          if (from < 4) {
            await migrator.createTable(tandaReceipts);
            final existingTandas = await select(tandas).get();
            for (final row in existingTandas) {
              await into(tandaReceipts).insert(
                TandaReceiptsCompanion.insert(
                  id: 'tanda-receipt-${row.id}',
                  tandaId: row.id,
                  amount: row.contributionAmount * row.participantCount,
                  scheduledDate: tandaDateAtInterval(
                    row.startDate,
                    TandaFrequency.values.byName(row.frequency),
                    row.assignedTurn - 1,
                  ),
                  status: 'pending',
                  createdAt: row.createdAt,
                ),
                mode: InsertMode.insertOrIgnore,
              );
            }
          }
          if (from < 5) {
            await migrator.createTable(taskReminders);
          }
          if (from < 6) {
            final transactionsTableExists = await customSelect(
              """
              SELECT 1 AS value
              FROM sqlite_master
              WHERE type = 'table' AND name = 'transactions'
              """,
            ).getSingleOrNull();
            if (transactionsTableExists == null) {
              await migrator.createTable(transactions);
            } else {
              final transactionColumns = (await customSelect(
                "PRAGMA table_info('transactions')",
              ).get())
                  .map((row) => row.read<String>('name'))
                  .toSet();
              if (!transactionColumns.contains('credit_card_id')) {
                await migrator.addColumn(
                  transactions,
                  transactions.creditCardId,
                );
              }
              if (!transactionColumns.contains('card_transaction_kind')) {
                await migrator.addColumn(
                  transactions,
                  transactions.cardTransactionKind,
                );
              }
            }
          }
        },
        beforeOpen: (_) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}
