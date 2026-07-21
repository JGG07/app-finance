enum TandaReceiptStatus { pending, received }

class TandaReceipt {
  TandaReceipt({
    required this.id,
    required this.tandaId,
    required this.amount,
    required this.scheduledDate,
    required this.status,
    required this.receivedAt,
    required this.createdAt,
    this.linkedTransactionId,
    this.notes,
  }) {
    if (id.trim().isEmpty || tandaId.trim().isEmpty) {
      throw ArgumentError('Los identificadores son obligatorios.');
    }
    if (!amount.isFinite || amount <= 0) {
      throw ArgumentError('El monto esperado debe ser positivo.');
    }
    if (scheduledDate.year < 1) {
      throw ArgumentError('La fecha programada no es valida.');
    }
    if (status == TandaReceiptStatus.pending && receivedAt != null) {
      throw ArgumentError('Una recepcion pendiente no puede tener fecha real.');
    }
    if (status == TandaReceiptStatus.received && receivedAt == null) {
      throw ArgumentError('Una recepcion registrada requiere fecha real.');
    }
  }

  final String id;
  final String tandaId;
  final double amount;
  final DateTime scheduledDate;
  final TandaReceiptStatus status;
  final DateTime? receivedAt;
  final String? linkedTransactionId;
  final DateTime createdAt;
  final String? notes;

  bool get isReceived => status == TandaReceiptStatus.received;

  TandaReceipt copyWith({
    double? amount,
    DateTime? scheduledDate,
    TandaReceiptStatus? status,
    DateTime? receivedAt,
    bool clearReceivedAt = false,
    String? linkedTransactionId,
    bool clearLinkedTransactionId = false,
    String? notes,
  }) {
    return TandaReceipt(
      id: id,
      tandaId: tandaId,
      amount: amount ?? this.amount,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      status: status ?? this.status,
      receivedAt: clearReceivedAt ? null : receivedAt ?? this.receivedAt,
      linkedTransactionId: clearLinkedTransactionId
          ? null
          : linkedTransactionId ?? this.linkedTransactionId,
      createdAt: createdAt,
      notes: notes ?? this.notes,
    );
  }
}
