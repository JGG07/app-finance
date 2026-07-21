import 'package:app_finance/src/features/tandas/domain/tanda.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Tanda make({
    TandaFrequency frequency = TandaFrequency.weekly,
    DateTime? start,
    int participants = 10,
    int turn = 4,
    int completed = 0,
    double amount = 1000,
  }) =>
      Tanda(
        id: 't1',
        name: 'Familia',
        contributionAmount: amount,
        frequency: frequency,
        startDate: start ?? DateTime(2026, 1, 1),
        participantCount: participants,
        assignedTurn: turn,
        completedContributions: completed,
        status: completed == participants
            ? TandaStatus.completed
            : TandaStatus.active,
        createdAt: DateTime(2025),
      );

  test('calculates amounts, remaining contributions and progress', () {
    final tanda = make(completed: 3);
    expect(tanda.totalExpectedAmount, 10000);
    expect(tanda.totalContributed, 3000);
    expect(tanda.remainingToContribute, 7000);
    expect(tanda.remainingContributions, 7);
    expect(tanda.progressRatio, 0.3);
  });

  test('calculates weekly and biweekly receive dates', () {
    expect(make().estimatedReceiveDate, DateTime(2026, 1, 22));
    expect(
      make(frequency: TandaFrequency.biweekly).estimatedReceiveDate,
      DateTime(2026, 2, 15),
    );
  });

  test('exposes validated contribution dates by sequence', () {
    expect(make().contributionDateForSequence(1), DateTime(2026, 1, 1));
    expect(make().contributionDateForSequence(2), DateTime(2026, 1, 8));
    expect(
      make(frequency: TandaFrequency.biweekly).contributionDateForSequence(2),
      DateTime(2026, 1, 16),
    );
    expect(() => make().contributionDateForSequence(0), throwsArgumentError);
    expect(() => make().contributionDateForSequence(11), throwsArgumentError);
  });

  test('monthly dates preserve calendar day and adjust month end', () {
    expect(
      make(
        frequency: TandaFrequency.monthly,
        start: DateTime(2026, 1, 15),
      ).estimatedReceiveDate,
      DateTime(2026, 4, 15),
    );
    expect(
      make(
        frequency: TandaFrequency.monthly,
        start: DateTime(2025, 1, 31),
        turn: 2,
      ).estimatedReceiveDate,
      DateTime(2025, 2, 28),
    );
    expect(
      make(
        frequency: TandaFrequency.monthly,
        start: DateTime(2024, 1, 31),
        turn: 2,
      ).estimatedReceiveDate,
      DateTime(2024, 2, 29),
    );
  });

  test('calculates next contribution and null after completion', () {
    expect(make().nextContributionDate, DateTime(2026, 1, 1));
    expect(make(completed: 3).nextContributionDate, DateTime(2026, 1, 22));
    expect(make(completed: 10).nextContributionDate, isNull);
  });

  test('rejects invalid turn, participants, amount and progress', () {
    expect(() => make(turn: 11), throwsArgumentError);
    expect(() => make(participants: 1, turn: 1), throwsArgumentError);
    expect(() => make(amount: 0), throwsArgumentError);
    expect(() => make(amount: double.nan), throwsArgumentError);
    expect(() => make(completed: 11), throwsArgumentError);
  });
}
