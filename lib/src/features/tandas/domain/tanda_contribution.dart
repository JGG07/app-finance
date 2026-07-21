enum TandaContributionStatus { pending, paid }

class TandaContribution {
  TandaContribution({
    required this.id,
    required this.tandaId,
    required this.sequenceNumber,
    required this.amount,
    required this.scheduledDate,
    required this.status,
    required this.paidAt,
    required this.createdAt,
    this.migratedFromLegacyCounter = false,
    this.notes,
    this.linkedTransactionId,
  }) {
    if (id.trim().isEmpty || tandaId.trim().isEmpty) {
      throw ArgumentError('Los identificadores son obligatorios.');
    }
    if (sequenceNumber <= 0) throw ArgumentError('Secuencia invalida.');
    if (!amount.isFinite || amount <= 0) throw ArgumentError('Monto invalido.');
    if (status == TandaContributionStatus.pending && paidAt != null) {
      throw ArgumentError(
        'Una aportacion pendiente no puede tener fecha de pago.',
      );
    }
    if (status == TandaContributionStatus.paid &&
        paidAt == null &&
        !migratedFromLegacyCounter) {
      throw ArgumentError('Una aportacion pagada requiere fecha real.');
    }
  }

  final String id;
  final String tandaId;
  final int sequenceNumber;
  final double amount;
  final DateTime scheduledDate;
  final TandaContributionStatus status;
  final DateTime? paidAt;
  final DateTime createdAt;
  final bool migratedFromLegacyCounter;
  final String? notes;
  final String? linkedTransactionId;

  bool get isPaid => status == TandaContributionStatus.paid;

  TandaContribution copyWith({
    TandaContributionStatus? status,
    DateTime? paidAt,
    bool clearPaidAt = false,
    String? notes,
    String? linkedTransactionId,
    bool clearLinkedTransactionId = false,
  }) =>
      TandaContribution(
        id: id,
        tandaId: tandaId,
        sequenceNumber: sequenceNumber,
        amount: amount,
        scheduledDate: scheduledDate,
        status: status ?? this.status,
        paidAt: clearPaidAt ? null : paidAt ?? this.paidAt,
        createdAt: createdAt,
        migratedFromLegacyCounter: migratedFromLegacyCounter,
        notes: notes ?? this.notes,
        linkedTransactionId: clearLinkedTransactionId
            ? null
            : linkedTransactionId ?? this.linkedTransactionId,
      );
}
