import '../../transactions/domain/transaction_entry.dart';
import 'tanda_contribution.dart';

const tandaTransactionCategory = 'Tanda';

enum TandaContributionLinkStatus {
  notApplicable,
  linked,
  missingTransaction,
  unlinkedPaid,
}

String transactionIdForTandaContribution(String contributionId) {
  final normalizedId = contributionId.trim();
  if (normalizedId.isEmpty) {
    throw ArgumentError('El identificador de la aportacion es obligatorio.');
  }
  return 'tanda-contribution-$normalizedId';
}

bool isTransactionForTandaContribution(
  TransactionEntry transaction,
  TandaContribution contribution,
) {
  return transaction.id == transactionIdForTandaContribution(contribution.id) &&
      transaction.type == TransactionType.expense &&
      transaction.amount == contribution.amount &&
      transaction.category.trim().toLowerCase() ==
          tandaTransactionCategory.toLowerCase();
}
