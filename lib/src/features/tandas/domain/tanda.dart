enum TandaFrequency { weekly, biweekly, monthly }

enum TandaStatus { active, completed, cancelled }

DateTime tandaDateAtInterval(
  DateTime startDate,
  TandaFrequency frequency,
  int intervals,
) {
  return switch (frequency) {
    TandaFrequency.weekly => startDate.add(Duration(days: intervals * 7)),
    TandaFrequency.biweekly => startDate.add(Duration(days: intervals * 15)),
    TandaFrequency.monthly => _addCalendarMonths(startDate, intervals),
  };
}

DateTime _addCalendarMonths(DateTime date, int months) {
  final monthIndex = date.month - 1 + months;
  final year = date.year + monthIndex ~/ 12;
  final month = monthIndex % 12 + 1;
  final lastDay = DateTime(year, month + 1, 0).day;
  final day = date.day > lastDay ? lastDay : date.day;
  return DateTime(year, month, day, date.hour, date.minute, date.second);
}

class Tanda {
  Tanda({
    required this.id,
    required String name,
    required this.contributionAmount,
    required this.frequency,
    required this.startDate,
    required this.participantCount,
    required this.assignedTurn,
    required this.completedContributions,
    required this.status,
    this.notes,
    required this.createdAt,
  }) : name = name.trim() {
    validate();
  }

  final String id;
  final String name;
  final double contributionAmount;
  final TandaFrequency frequency;
  final DateTime startDate;
  final int participantCount;
  final int assignedTurn;
  final int completedContributions;
  final TandaStatus status;
  final String? notes;
  final DateTime createdAt;

  double get totalExpectedAmount => contributionAmount * participantCount;
  double get totalContributed => contributionAmount * completedContributions;
  double get remainingToContribute => totalExpectedAmount - totalContributed;
  int get remainingContributions => participantCount - completedContributions;
  double get progressRatio => completedContributions / participantCount;
  DateTime get estimatedReceiveDate => _dateAtInterval(assignedTurn - 1);
  DateTime? get nextContributionDate =>
      !isActive ? null : _dateAtInterval(completedContributions);
  bool get isActive => status == TandaStatus.active;
  bool get isCompleted => status == TandaStatus.completed;

  DateTime contributionDateForSequence(int sequenceNumber) {
    if (sequenceNumber < 1 || sequenceNumber > participantCount) {
      throw ArgumentError('La secuencia no pertenece a esta tanda.');
    }
    return _dateAtInterval(sequenceNumber - 1);
  }

  void validate() {
    if (name.isEmpty) throw ArgumentError('El nombre es obligatorio.');
    if (!contributionAmount.isFinite || contributionAmount <= 0) {
      throw ArgumentError('La aportacion debe ser mayor que cero.');
    }
    if (participantCount <= 1) {
      throw ArgumentError('Debe haber al menos dos participantes.');
    }
    if (assignedTurn < 1 || assignedTurn > participantCount) {
      throw ArgumentError('El turno debe estar dentro de los participantes.');
    }
    if (completedContributions < 0 ||
        completedContributions > participantCount) {
      throw ArgumentError('El progreso de aportaciones no es valido.');
    }
  }

  Tanda copyWith({
    String? name,
    double? contributionAmount,
    TandaFrequency? frequency,
    DateTime? startDate,
    int? participantCount,
    int? assignedTurn,
    int? completedContributions,
    TandaStatus? status,
    String? notes,
  }) {
    return Tanda(
      id: id,
      name: name ?? this.name,
      contributionAmount: contributionAmount ?? this.contributionAmount,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      participantCount: participantCount ?? this.participantCount,
      assignedTurn: assignedTurn ?? this.assignedTurn,
      completedContributions:
          completedContributions ?? this.completedContributions,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt,
    );
  }

  DateTime _dateAtInterval(int intervals) {
    return tandaDateAtInterval(startDate, frequency, intervals);
  }
}
