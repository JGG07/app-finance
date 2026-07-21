import '../../transactions/domain/transaction_entry.dart';
import 'tanda_receipt.dart';

const tandaReceiptTransactionCategory = 'Tanda recibida';

enum TandaReceiptLinkStatus {
  notReceived,
  linked,
  missingTransaction,
  unlinkedReceived,
}

String receiptIdForTanda(String tandaId) {
  final id = tandaId.trim();
  if (id.isEmpty) {
    throw ArgumentError('El identificador de tanda es obligatorio.');
  }
  return 'tanda-receipt-$id';
}

String transactionIdForTandaReceipt(String receiptId) {
  final id = receiptId.trim();
  if (id.isEmpty) {
    throw ArgumentError('El identificador de recepcion es obligatorio.');
  }
  return 'tanda-receipt-income-$id';
}

bool isTransactionForTandaReceipt(
  TransactionEntry transaction,
  TandaReceipt receipt,
) {
  return transaction.id == transactionIdForTandaReceipt(receipt.id) &&
      transaction.type == TransactionType.income &&
      transaction.amount == receipt.amount &&
      transaction.category.trim().toLowerCase() ==
          tandaReceiptTransactionCategory.toLowerCase();
}
