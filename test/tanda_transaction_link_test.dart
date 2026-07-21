import 'package:app_finance/src/core/database/finance_snapshot.dart';
import 'package:app_finance/src/core/database/repositories/finance_repository.dart';
import 'package:app_finance/src/core/database/seed/initial_finance_seed.dart';
import 'package:app_finance/src/core/domain/finance_period.dart';
import 'package:app_finance/src/core/state/finance_state.dart';
import 'package:app_finance/src/features/tandas/domain/tanda.dart';
import 'package:app_finance/src/features/tandas/domain/tanda_contribution.dart';
import 'package:app_finance/src/features/tandas/domain/tanda_contribution_link.dart';
import 'package:app_finance/src/features/tandas/presentation/tandas_section.dart';
import 'package:app_finance/src/features/transactions/domain/transaction_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'helpers/test_app.dart';

void main() {
  late FinanceState state;

  setUp(() {
    state = FinanceState();
    state.addTanda(
      name: 'Familiar',
      contributionAmount: 750,
      frequency: TandaFrequency.biweekly,
      startDate: DateTime(2025, 1, 10),
      participantCount: 2,
      assignedTurn: 1,
    );
  });

  test('register creates one deterministic expense with the real payment date',
      () {
    final before = DateTime.now();
    final tandaId = state.tandas.single.id;
    final contribution = state.tandaContributions.first;

    state.markNextTandaContributionPaid(tandaId);

    final paid = state.tandaContributions.first;
    final transaction = state.transactions.single;
    expect(transaction.id, transactionIdForTandaContribution(contribution.id));
    expect(transaction.title, 'Aportacion a Familiar');
    expect(transaction.amount, 750);
    expect(transaction.category, tandaTransactionCategory);
    expect(transaction.type, TransactionType.expense);
    expect(transaction.date, paid.paidAt);
    expect(transaction.date.isBefore(before), isFalse);
    expect(paid.linkedTransactionId, transaction.id);
    expect(
      state.tandaContributionLinkStatus(paid),
      TandaContributionLinkStatus.linked,
    );
  });

  test('expense affects its real period and totals but is not ant expense', () {
    state.markNextTandaContributionPaid(state.tandas.single.id);
    final paidAt = state.tandaContributions.first.paidAt!;
    state.selectPeriod(FinancePeriod(year: paidAt.year, month: paidAt.month));

    expect(state.totalSpent, 750);
    expect(state.transactionsForSelectedPeriod, hasLength(1));
    expect(state.antExpensesForSelectedPeriod, 0);
  });

  test('different contributions have different IDs and no duplicates', () {
    final tandaId = state.tandas.single.id;
    state.markNextTandaContributionPaid(tandaId);
    state.markNextTandaContributionPaid(tandaId);

    expect(state.transactions, hasLength(2));
    expect(state.transactions.map((item) => item.id).toSet(), hasLength(2));
    expect(state.tandas.single.completedContributions, 2);
  });

  test('undo removes only linked generated movement and reactivates tanda', () {
    final tandaId = state.tandas.single.id;
    state.markNextTandaContributionPaid(tandaId);
    state.markNextTandaContributionPaid(tandaId);
    state.addTransaction(
      title: 'Aportacion a Familiar',
      amount: 750,
      categoryTitle: tandaTransactionCategory,
      type: TransactionType.expense,
      date: DateTime.now(),
    );

    final manualId = state.transactions.first.id;
    final spentBeforeUndo = state.totalSpent;
    state.undoLastTandaContribution(tandaId);

    expect(state.transactions.any((item) => item.id == manualId), isTrue);
    expect(state.transactions, hasLength(2));
    final undone = state.tandaContributions[1];
    expect(undone.isPaid, isFalse);
    expect(undone.paidAt, isNull);
    expect(undone.linkedTransactionId, isNull);
    expect(state.tandas.single.status, TandaStatus.active);
    expect(state.tandas.single.completedContributions, 1);
    expect(state.totalSpent, spentBeforeUndo - 750);
  });

  test('deleting can preserve or exclusively remove linked movements', () {
    final tandaId = state.tandas.single.id;
    state.markNextTandaContributionPaid(tandaId);
    state.addTransaction(
      title: 'Aportacion a Familiar',
      amount: 750,
      categoryTitle: tandaTransactionCategory,
      type: TransactionType.expense,
      date: DateTime.now(),
    );
    final manualId = state.transactions.first.id;
    state.deleteTanda(tandaId, deleteLinkedTransactions: true);

    expect(state.tandas, isEmpty);
    expect(state.tandaContributions, isEmpty);
    expect(state.transactions.single.id, manualId);
  });

  test('deleting conservatively preserves generated movements', () {
    final tandaId = state.tandas.single.id;
    state.markNextTandaContributionPaid(tandaId);
    final transactionId = state.transactions.single.id;
    state.deleteTanda(tandaId);
    expect(state.transactions.single.id, transactionId);
  });

  group('legacy and repair', () {
    test('load does not create movements and exposes unlinked paid', () async {
      final fixture = _legacyFixture();
      final storage = _MemoryStorage(fixture);
      final loaded = FinanceState(repository: storage);
      await loaded.initialize();

      expect(loaded.transactions, isEmpty);
      expect(loaded.tandaContributions.first.isPaid, isTrue);
      expect(
        loaded.tandaContributionLinkStatus(loaded.tandaContributions.first),
        TandaContributionLinkStatus.unlinkedPaid,
      );
      expect(storage.saveCount, 0);
    });

    test('linking legacy record is idempotent and persists once', () async {
      final storage = _MemoryStorage(_legacyFixture());
      final loaded = FinanceState(repository: storage);
      await loaded.initialize();
      final contribution = loaded.tandaContributions.first;
      final paidAt = DateTime(2026, 8, 15);

      loaded.linkPaidTandaContributionToTransaction(
        contributionId: contribution.id,
        paidAt: paidAt,
      );
      await loaded.flushPendingSaves();
      loaded.linkPaidTandaContributionToTransaction(
        contributionId: contribution.id,
        paidAt: DateTime(2026, 9, 1),
      );

      expect(loaded.transactions, hasLength(1));
      expect(loaded.transactions.single.date, paidAt);
      expect(loaded.tandaContributions.first.migratedFromLegacyCounter, isTrue);
      expect(storage.saveCount, 1);
    });

    test('broken and incompatible links are visible and not auto-reused',
        () async {
      final fixture = _legacyFixture(
        linkedTransactionId: 'missing',
        paidAt: DateTime(2026, 8, 15),
      );
      final loaded = FinanceState(repository: _MemoryStorage(fixture));
      await loaded.initialize();
      expect(
        loaded.tandaContributionLinkStatus(loaded.tandaContributions.first),
        TandaContributionLinkStatus.missingTransaction,
      );

      final incompatible = _legacyFixture(
        transactions: [
          TransactionEntry(
            id: transactionIdForTandaContribution('legacy-contribution'),
            title: 'Otro',
            amount: 750,
            category: tandaTransactionCategory,
            date: DateTime(2026, 8, 15),
            type: TransactionType.income,
          ),
        ],
      );
      final invalidState =
          FinanceState(repository: _MemoryStorage(incompatible));
      await invalidState.initialize();
      expect(
        () => invalidState.linkPaidTandaContributionToTransaction(
          contributionId: 'legacy-contribution',
          paidAt: DateTime(2026, 8, 15),
        ),
        throwsStateError,
      );
      expect(invalidState.transactions, hasLength(1));
    });

    testWidgets('legacy UI offers registration and requests missing date',
        (tester) async {
      final loaded = FinanceState(repository: _MemoryStorage(_legacyFixture()));
      await loaded.initialize();
      await tester.pumpWidget(
        buildTestApp(
          child: SingleChildScrollView(child: TandasSection(state: loaded)),
        ),
      );
      await tester.tap(find.text('Ver aportaciones'));
      await tester.pumpAndSettle();
      expect(find.text('Registro migrado'), findsOneWidget);
      expect(find.text('Sin movimiento asociado'), findsOneWidget);
      expect(find.text('Registrar como movimiento'), findsOneWidget);
      await tester.tap(find.text('Registrar como movimiento'));
      await tester.pumpAndSettle();
      expect(find.text('Fecha real del pago'), findsOneWidget);
    });

    testWidgets('broken link UI offers recreation', (tester) async {
      final loaded = FinanceState(
        repository: _MemoryStorage(
          _legacyFixture(
            linkedTransactionId: 'missing',
            paidAt: DateTime(2026, 8, 15),
          ),
        ),
      );
      await loaded.initialize();
      await tester.pumpWidget(
        buildTestApp(
          child: SingleChildScrollView(child: TandasSection(state: loaded)),
        ),
      );
      await tester.tap(find.text('Ver aportaciones'));
      await tester.pumpAndSettle();
      expect(find.text('Movimiento faltante'), findsOneWidget);
      expect(find.text('Recrear movimiento'), findsOneWidget);
    });
  });
}

FinanceSnapshot _legacyFixture({
  String? linkedTransactionId,
  DateTime? paidAt,
  List<TransactionEntry> transactions = const [],
}) {
  final seed = initialFinanceSeed();
  final tanda = Tanda(
    id: 'legacy-tanda',
    name: 'Heredada',
    contributionAmount: 750,
    frequency: TandaFrequency.monthly,
    startDate: DateTime(2026, 7, 1),
    participantCount: 2,
    assignedTurn: 1,
    completedContributions: 1,
    status: TandaStatus.active,
    createdAt: DateTime(2026, 7, 1),
  );
  return FinanceSnapshot(
    monthlyIncome: seed.monthlyIncome,
    categories: seed.categories,
    transactions: transactions,
    plannedExpenses: seed.plannedExpenses,
    creditCards: seed.creditCards,
    creditCardPurchases: seed.creditCardPurchases,
    subscriptions: seed.subscriptions,
    cardMonthlyPayments: seed.cardMonthlyPayments,
    monthlyExtras: seed.monthlyExtras,
    surplusPlan: seed.surplusPlan,
    manualTasks: seed.manualTasks,
    taskOverrides: seed.taskOverrides,
    tandas: [tanda],
    tandaContributions: [
      TandaContribution(
        id: 'legacy-contribution',
        tandaId: tanda.id,
        sequenceNumber: 1,
        amount: 750,
        scheduledDate: DateTime(2026, 7, 1),
        status: TandaContributionStatus.paid,
        paidAt: paidAt,
        createdAt: DateTime(2026, 7, 1),
        migratedFromLegacyCounter: true,
        linkedTransactionId: linkedTransactionId,
      ),
      TandaContribution(
        id: 'legacy-contribution-2',
        tandaId: tanda.id,
        sequenceNumber: 2,
        amount: 750,
        scheduledDate: DateTime(2026, 8, 1),
        status: TandaContributionStatus.pending,
        paidAt: null,
        createdAt: DateTime(2026, 7, 1),
      ),
    ],
    tandaReceipts: const [],
  );
}

class _MemoryStorage implements FinanceStorage {
  _MemoryStorage(this.snapshot);

  FinanceSnapshot snapshot;
  int saveCount = 0;

  @override
  Future<FinanceSnapshot> loadSnapshot() async => snapshot;

  @override
  Future<void> saveSnapshot(FinanceSnapshot snapshot) async {
    saveCount += 1;
    this.snapshot = snapshot;
  }
}
