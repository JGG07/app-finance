import 'package:app_finance/src/core/database/finance_snapshot.dart';
import 'package:app_finance/src/core/database/repositories/finance_repository.dart';
import 'package:app_finance/src/core/database/seed/initial_finance_seed.dart';
import 'package:app_finance/src/core/domain/finance_period.dart';
import 'package:app_finance/src/core/state/finance_state.dart';
import 'package:app_finance/src/features/tandas/domain/tanda.dart';
import 'package:app_finance/src/features/tandas/domain/tanda_receipt.dart';
import 'package:app_finance/src/features/tandas/domain/tanda_receipt_link.dart';
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
      name: 'Familia',
      contributionAmount: 1000,
      frequency: TandaFrequency.monthly,
      startDate: DateTime(2026, 7, 10),
      participantCount: 4,
      assignedTurn: 3,
    );
  });

  test('creating tanda creates exactly one expected pending receipt', () {
    final tanda = state.tandas.single;
    final receipt = state.tandaReceipts.single;
    expect(receipt.id, receiptIdForTanda(tanda.id));
    expect(receipt.tandaId, tanda.id);
    expect(receipt.amount, tanda.totalExpectedAmount);
    expect(receipt.scheduledDate, tanda.estimatedReceiveDate);
    expect(receipt.status, TandaReceiptStatus.pending);
    expect(
      state.tandaReceiptLinkStatus(receipt),
      TandaReceiptLinkStatus.notReceived,
    );
  });

  test('registering creates one dated income and only natural effects', () {
    final tanda = state.tandas.single;
    final contributionsBefore = List.of(state.tandaContributions);
    final receivedAt = DateTime(2026, 8, 15);
    state.selectPeriod(FinancePeriod(year: 2026, month: 8));

    state.markTandaReceiptReceived(tandaId: tanda.id, receivedAt: receivedAt);

    final receipt = state.tandaReceipts.single;
    final income = state.transactions.single;
    expect(income.id, transactionIdForTandaReceipt(receipt.id));
    expect(income.title, 'Recepcion de Familia');
    expect(income.type, TransactionType.income);
    expect(income.category, tandaReceiptTransactionCategory);
    expect(income.amount, 4000);
    expect(income.date, receivedAt);
    expect(state.transactionsForSelectedPeriod, hasLength(1));
    expect(state.additionalIncludedIncome, 4000);
    expect(state.totalMonthlyIncome, 4000);
    expect(state.totalSpent, 0);
    expect(state.antExpensesForSelectedPeriod, 0);
    expect(state.tandaContributions, contributionsBefore);
  });

  test('registering twice is idempotent', () {
    final tandaId = state.tandas.single.id;
    state.markTandaReceiptReceived(
      tandaId: tandaId,
      receivedAt: DateTime(2026, 8, 15),
    );
    state.markTandaReceiptReceived(
      tandaId: tandaId,
      receivedAt: DateTime(2026, 9, 1),
    );
    expect(state.transactions, hasLength(1));
    expect(state.tandaReceipts.single.receivedAt, DateTime(2026, 8, 15));
  });

  test('undo removes only receipt income and preserves contribution expense',
      () {
    final tandaId = state.tandas.single.id;
    state.markNextTandaContributionPaid(tandaId);
    final expenseId = state.transactions.single.id;
    state.markTandaReceiptReceived(
      tandaId: tandaId,
      receivedAt: DateTime(2026, 8, 15),
    );
    state.addTransaction(
      title: 'Recepcion de Familia',
      amount: 4000,
      categoryTitle: tandaReceiptTransactionCategory,
      type: TransactionType.income,
      date: DateTime(2026, 8, 15),
    );
    final manualId = state.transactions.first.id;

    state.undoTandaReceipt(tandaId);

    expect(
      state.transactions.map((item) => item.id),
      containsAll([expenseId, manualId]),
    );
    expect(state.transactions, hasLength(2));
    expect(state.tandaReceipts.single.isReceived, isFalse);
    expect(state.paidContributionsForTanda(tandaId), hasLength(1));
  });

  test('cancellation blocks new receipt but preserves an existing one', () {
    final tandaId = state.tandas.single.id;
    state.cancelTanda(tandaId);
    expect(
      () => state.markTandaReceiptReceived(
        tandaId: tandaId,
        receivedAt: DateTime(2026, 8, 15),
      ),
      throwsStateError,
    );
    expect(state.transactions, isEmpty);

    final other = FinanceState();
    other.addTanda(
      name: 'Otra',
      contributionAmount: 500,
      frequency: TandaFrequency.monthly,
      startDate: DateTime(2026, 7, 1),
      participantCount: 2,
      assignedTurn: 1,
    );
    final otherId = other.tandas.single.id;
    other.markTandaReceiptReceived(
      tandaId: otherId,
      receivedAt: DateTime(2026, 7, 2),
    );
    other.cancelTanda(otherId);
    expect(other.transactions, hasLength(1));
    expect(other.tandaReceipts.single.isReceived, isTrue);
  });

  test('pending edit synchronizes receipt and received edit blocks structure',
      () {
    final id = state.tandas.single.id;
    state.updateTanda(
      id,
      name: 'Familia',
      contributionAmount: 1200,
      frequency: TandaFrequency.biweekly,
      startDate: DateTime(2026, 7, 5),
      participantCount: 5,
      assignedTurn: 4,
    );
    expect(state.tandaReceipts.single.amount, 6000);
    expect(
      state.tandaReceipts.single.scheduledDate,
      state.tandas.single.estimatedReceiveDate,
    );
    state.markTandaReceiptReceived(
      tandaId: id,
      receivedAt: DateTime(2026, 8, 20),
    );
    expect(
      () => state.updateTanda(
        id,
        name: 'Familia',
        contributionAmount: 1200,
        frequency: TandaFrequency.biweekly,
        startDate: DateTime(2026, 7, 5),
        participantCount: 5,
        assignedTurn: 2,
      ),
      throwsStateError,
    );
  });

  test('deletion preserves or removes only verified generated movements', () {
    final id = state.tandas.single.id;
    state.markNextTandaContributionPaid(id);
    state.markTandaReceiptReceived(
      tandaId: id,
      receivedAt: DateTime(2026, 8, 15),
    );
    state.addTransaction(
      title: 'Recepcion de Familia',
      amount: 4000,
      categoryTitle: tandaReceiptTransactionCategory,
      type: TransactionType.income,
      date: DateTime(2026, 8, 15),
    );
    final manualId = state.transactions.first.id;
    state.deleteTanda(id, deleteLinkedTransactions: true);
    expect(state.transactions.single.id, manualId);
    expect(state.tandaReceipts, isEmpty);

    final conservative = FinanceState();
    conservative.addTanda(
      name: 'Conservar',
      contributionAmount: 500,
      frequency: TandaFrequency.monthly,
      startDate: DateTime(2026, 8, 1),
      participantCount: 2,
      assignedTurn: 1,
    );
    final conservativeId = conservative.tandas.single.id;
    conservative.markTandaReceiptReceived(
      tandaId: conservativeId,
      receivedAt: DateTime(2026, 8, 2),
    );
    conservative.deleteTanda(conservativeId);
    expect(conservative.transactions, hasLength(1));
  });

  testWidgets('receipt UI registers, displays and undoes linked income',
      (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        child: AnimatedBuilder(
          animation: state,
          builder: (context, _) => SingleChildScrollView(
            child: TandasSection(state: state),
          ),
        ),
      ),
    );
    expect(find.text('Recepcion de la tanda'), findsOneWidget);
    expect(find.text('Recepcion pendiente'), findsOneWidget);
    expect(find.textContaining('Monto esperado:'), findsOneWidget);
    await tester.tap(find.text('Registrar recepcion'));
    await tester.pumpAndSettle();
    expect(find.text('Fecha real'), findsOneWidget);
    expect(
      find.text('La fecha seleccionada es anterior a tu turno estimado.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Confirmar recepcion'));
    await tester.pumpAndSettle();
    expect(find.text('Recepcion registrada'), findsOneWidget);
    expect(find.text('Ingreso agregado a Movimientos'), findsOneWidget);
    expect(find.text('Deshacer recepcion'), findsOneWidget);
    expect(
      find.textContaining('tanda-receipt-income-'),
      findsNothing,
    );
    await tester.tap(find.text('Deshacer recepcion'));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Las aportaciones permaneceran intactas'),
      findsOneWidget,
    );
    await tester.tap(find.text('Deshacer recepcion').last);
    await tester.pumpAndSettle();
    expect(find.text('Recepcion pendiente'), findsOneWidget);
    expect(state.transactions, isEmpty);
  });

  group('repair', () {
    test('derives unlinked and missing states and requires a real date',
        () async {
      final unlinked = await _loadedState(_receiptFixture());
      expect(
        unlinked.tandaReceiptLinkStatus(unlinked.tandaReceipts.single),
        TandaReceiptLinkStatus.unlinkedReceived,
      );
      final pending = await _loadedState(_receiptFixture(pending: true));
      expect(
        pending.tandaReceiptLinkStatus(pending.tandaReceipts.single),
        TandaReceiptLinkStatus.notReceived,
      );
      expect(
        () => pending.linkReceivedTandaReceiptToTransaction(
          receiptId: pending.tandaReceipts.single.id,
        ),
        throwsStateError,
      );
      final missing = await _loadedState(_receiptFixture(linkedId: 'missing'));
      expect(
        missing.tandaReceiptLinkStatus(missing.tandaReceipts.single),
        TandaReceiptLinkStatus.missingTransaction,
      );
    });

    test('recreates same ID idempotently and rejects incompatible movement',
        () async {
      final missing = await _loadedState(_receiptFixture(linkedId: 'missing'));
      final receipt = missing.tandaReceipts.single;
      missing.linkReceivedTandaReceiptToTransaction(receiptId: receipt.id);
      missing.linkReceivedTandaReceiptToTransaction(receiptId: receipt.id);
      expect(
        missing.transactions.single.id,
        transactionIdForTandaReceipt(receipt.id),
      );
      expect(
        missing.tandaReceiptLinkStatus(missing.tandaReceipts.single),
        TandaReceiptLinkStatus.linked,
      );

      final incompatible = await _loadedState(
        _receiptFixture(
          transactions: [
            TransactionEntry(
              id: transactionIdForTandaReceipt(receipt.id),
              title: 'Manual',
              amount: receipt.amount,
              category: tandaReceiptTransactionCategory,
              date: DateTime(2026, 8, 15),
              type: TransactionType.expense,
            ),
          ],
        ),
      );
      expect(
        () => incompatible.linkReceivedTandaReceiptToTransaction(
          receiptId: receipt.id,
        ),
        throwsStateError,
      );
      expect(incompatible.transactions.single.title, 'Manual');
    });
  });
}

Future<FinanceState> _loadedState(FinanceSnapshot snapshot) async {
  final state = FinanceState(repository: _MemoryStorage(snapshot));
  await state.initialize();
  return state;
}

FinanceSnapshot _receiptFixture({
  bool pending = false,
  String? linkedId,
  List<TransactionEntry> transactions = const [],
}) {
  final seed = initialFinanceSeed();
  final tanda = Tanda(
    id: 'tanda-fixture',
    name: 'Fixture',
    contributionAmount: 1000,
    frequency: TandaFrequency.monthly,
    startDate: DateTime(2026, 7, 1),
    participantCount: 2,
    assignedTurn: 1,
    completedContributions: 0,
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
    tandaContributions: const [],
    tandaReceipts: [
      TandaReceipt(
        id: receiptIdForTanda(tanda.id),
        tandaId: tanda.id,
        amount: tanda.totalExpectedAmount,
        scheduledDate: tanda.estimatedReceiveDate,
        status:
            pending ? TandaReceiptStatus.pending : TandaReceiptStatus.received,
        receivedAt: pending ? null : DateTime(2026, 8, 15),
        linkedTransactionId: linkedId,
        createdAt: tanda.createdAt,
      ),
    ],
  );
}

class _MemoryStorage implements FinanceStorage {
  _MemoryStorage(this.snapshot);
  FinanceSnapshot snapshot;

  @override
  Future<FinanceSnapshot> loadSnapshot() async => snapshot;

  @override
  Future<void> saveSnapshot(FinanceSnapshot snapshot) async {
    this.snapshot = snapshot;
  }
}
