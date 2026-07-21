import 'package:app_finance/src/core/state/finance_state.dart';
import 'package:app_finance/src/features/tandas/domain/tanda.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FinanceState state;
  setUp(() => state = FinanceState());

  void add({int participants = 3}) => state.addTanda(
        name: 'Oficina',
        contributionAmount: 500,
        frequency: TandaFrequency.biweekly,
        startDate: DateTime(2026, 8, 1),
        participantCount: participants,
        assignedTurn: 2,
        notes: 'Prueba',
      );

  test('creates schedule and blocks structural edits after progress', () {
    add();
    expect(state.tandas.single.name, 'Oficina');
    expect(
      () => state.addTanda(
        name: '',
        contributionAmount: 0,
        frequency: TandaFrequency.weekly,
        startDate: DateTime(2026),
        participantCount: 1,
        assignedTurn: 2,
      ),
      throwsArgumentError,
    );
    state.markNextTandaContributionPaid(state.tandas.single.id);
    final id = state.tandas.single.id;
    expect(state.contributionsForTanda(id), hasLength(3));
    expect(
      () => state.updateTanda(
        id,
        name: 'Editada',
        contributionAmount: 600,
        frequency: TandaFrequency.monthly,
        startDate: DateTime(2026, 8, 2),
        participantCount: 4,
        assignedTurn: 3,
      ),
      throwsStateError,
    );
    expect(state.tandas.single.completedContributions, 1);
    state.deleteTanda(id);
    expect(state.tandas, isEmpty);
    expect(state.tandaContributions, isEmpty);
  });

  test('registers, completes, undoes and reactivates contributions', () {
    add(participants: 2);
    final id = state.tandas.single.id;
    state.markNextTandaContributionPaid(id);
    state.markNextTandaContributionPaid(id);
    expect(state.tandas.single.status, TandaStatus.completed);
    expect(state.paidContributionsForTanda(id), hasLength(2));
    expect(state.completedTandas, hasLength(1));
    state.undoLastTandaContribution(id);
    expect(state.tandas.single.status, TandaStatus.active);
    expect(state.tandas.single.completedContributions, 1);
    expect(state.nextPendingContributionForTanda(id)?.sequenceNumber, 2);
  });

  test('cancel preserves progress and blocks register and undo', () {
    add();
    final id = state.tandas.single.id;
    state.markNextTandaContributionPaid(id);
    state.cancelTanda(id);
    state.markNextTandaContributionPaid(id);
    state.undoLastTandaContribution(id);
    expect(state.tandas.single.status, TandaStatus.cancelled);
    expect(state.tandas.single.completedContributions, 1);
    expect(state.transactions, hasLength(1));
  });

  test('lists are immutable and tandas do not affect financial totals', () {
    final before = [
      state.totalSpent,
      state.totalMonthlyIncome,
      state.totalPlannedExpenses,
      state.realEstimatedSurplus,
    ];
    add();
    expect(() => state.tandas.add(state.tandas.single), throwsUnsupportedError);
    expect(
      () => state.tandaContributions.add(state.tandaContributions.first),
      throwsUnsupportedError,
    );
    expect(state.activeTandas, hasLength(1));
    expect(
      [
        state.totalSpent,
        state.totalMonthlyIncome,
        state.totalPlannedExpenses,
        state.realEstimatedSurplus,
      ],
      before,
    );
  });

  test('editing before payments regenerates schedule', () {
    add();
    final id = state.tandas.single.id;
    state.updateTanda(
      id,
      name: 'Editada',
      contributionAmount: 600,
      frequency: TandaFrequency.monthly,
      startDate: DateTime(2026, 8, 2),
      participantCount: 4,
      assignedTurn: 3,
    );
    final contributions = state.contributionsForTanda(id);
    expect(contributions, hasLength(4));
    expect(contributions.first.amount, 600);
    expect(contributions.first.scheduledDate, DateTime(2026, 8, 2));
    expect(
      contributions.every((item) => item.linkedTransactionId == null),
      isTrue,
    );
  });
}
