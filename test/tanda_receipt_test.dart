import 'package:app_finance/src/features/tandas/domain/tanda_receipt.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TandaReceipt receipt({
    TandaReceiptStatus status = TandaReceiptStatus.pending,
    DateTime? receivedAt,
    double amount = 5000,
    String id = 'receipt-1',
    String tandaId = 'tanda-1',
  }) {
    return TandaReceipt(
      id: id,
      tandaId: tandaId,
      amount: amount,
      scheduledDate: DateTime(2026, 9, 15),
      status: status,
      receivedAt: receivedAt,
      createdAt: DateTime(2026, 7, 1),
    );
  }

  test('accepts valid pending and received receipts', () {
    expect(receipt().isReceived, isFalse);
    expect(
      receipt(
        status: TandaReceiptStatus.received,
        receivedAt: DateTime(2026, 9, 20),
      ).isReceived,
      isTrue,
    );
  });

  test('rejects invalid state, amount and identifiers', () {
    expect(
      () => receipt(receivedAt: DateTime(2026, 9, 20)),
      throwsArgumentError,
    );
    expect(() => receipt(amount: double.nan), throwsArgumentError);
    expect(() => receipt(amount: 0), throwsArgumentError);
    expect(() => receipt(id: ' '), throwsArgumentError);
    expect(() => receipt(tandaId: ''), throwsArgumentError);
  });

  test('copyWith preserves fields and explicitly clears link data', () {
    final original = receipt(
      status: TandaReceiptStatus.received,
      receivedAt: DateTime(2026, 9, 20),
    ).copyWith(linkedTransactionId: 'income-1');
    final pending = original.copyWith(
      status: TandaReceiptStatus.pending,
      clearReceivedAt: true,
      clearLinkedTransactionId: true,
    );
    expect(original.amount, 5000);
    expect(original.linkedTransactionId, 'income-1');
    expect(pending.receivedAt, isNull);
    expect(pending.linkedTransactionId, isNull);
  });
}
