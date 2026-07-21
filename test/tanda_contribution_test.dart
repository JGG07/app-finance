import 'package:app_finance/src/features/tandas/domain/tanda_contribution.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TandaContribution contribution({
    TandaContributionStatus status = TandaContributionStatus.pending,
    DateTime? paidAt,
    bool migrated = false,
  }) {
    return TandaContribution(
      id: 'c-1',
      tandaId: 't-1',
      sequenceNumber: 1,
      amount: 500,
      scheduledDate: DateTime(2026, 8, 1),
      status: status,
      paidAt: paidAt,
      createdAt: DateTime(2026, 7, 20),
      migratedFromLegacyCounter: migrated,
    );
  }

  test('validates identifiers, sequence and finite positive amount', () {
    expect(
      () => TandaContribution(
        id: '',
        tandaId: 't',
        sequenceNumber: 1,
        amount: 1,
        scheduledDate: DateTime(2026),
        status: TandaContributionStatus.pending,
        paidAt: null,
        createdAt: DateTime(2026),
      ),
      throwsArgumentError,
    );
    expect(
      () => TandaContribution(
        id: 'c',
        tandaId: 't',
        sequenceNumber: 0,
        amount: double.infinity,
        scheduledDate: DateTime(2026),
        status: TandaContributionStatus.pending,
        paidAt: null,
        createdAt: DateTime(2026),
      ),
      throwsArgumentError,
    );
  });

  test('enforces paidAt rules and permits honest legacy migration', () {
    expect(contribution().paidAt, isNull);
    expect(
      () => contribution(
        status: TandaContributionStatus.pending,
        paidAt: DateTime(2026),
      ),
      throwsArgumentError,
    );
    expect(
      contribution(
        status: TandaContributionStatus.paid,
        paidAt: DateTime(2026),
      ).isPaid,
      isTrue,
    );
    expect(
      contribution(
        status: TandaContributionStatus.paid,
        migrated: true,
      ).paidAt,
      isNull,
    );
  });

  test('copyWith changes state and linked transaction remains null', () {
    final paid = contribution().copyWith(
      status: TandaContributionStatus.paid,
      paidAt: DateTime(2026, 8, 2),
    );
    final pending = paid.copyWith(
      status: TandaContributionStatus.pending,
      clearPaidAt: true,
    );
    expect(paid.linkedTransactionId, isNull);
    expect(pending.paidAt, isNull);
  });
}
