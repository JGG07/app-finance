enum SurplusPlanType {
  conservative,
  balanced,
  investment,
  custom,
}

class SurplusPlanAllocation {
  const SurplusPlanAllocation({
    required this.safetyNet,
    required this.investment,
    required this.freeUse,
  });

  final double safetyNet;
  final double investment;
  final double freeUse;

  double get total => safetyNet + investment + freeUse;
}

class SurplusPlan {
  const SurplusPlan({
    required this.type,
    this.manualSafetyNet,
    this.manualInvestment,
    this.manualFreeUse,
  });

  final SurplusPlanType type;
  final double? manualSafetyNet;
  final double? manualInvestment;
  final double? manualFreeUse;

  bool get hasManualAmounts {
    return manualSafetyNet != null ||
        manualInvestment != null ||
        manualFreeUse != null;
  }

  SurplusPlanAllocation allocation(double surplus) {
    if (hasManualAmounts || type == SurplusPlanType.custom) {
      return SurplusPlanAllocation(
        safetyNet: manualSafetyNet ?? 0,
        investment: manualInvestment ?? 0,
        freeUse: manualFreeUse ?? 0,
      );
    }

    final percentages = switch (type) {
      SurplusPlanType.conservative => (0.60, 0.25, 0.15),
      SurplusPlanType.balanced => (0.40, 0.40, 0.20),
      SurplusPlanType.investment => (0.20, 0.65, 0.15),
      SurplusPlanType.custom => (0.0, 0.0, 0.0),
    };

    final usableSurplus = surplus < 0 ? 0 : surplus;
    return SurplusPlanAllocation(
      safetyNet: usableSurplus * percentages.$1,
      investment: usableSurplus * percentages.$2,
      freeUse: usableSurplus * percentages.$3,
    );
  }

  SurplusPlan copyWith({
    SurplusPlanType? type,
    double? manualSafetyNet,
    double? manualInvestment,
    double? manualFreeUse,
    bool clearManualAmounts = false,
  }) {
    return SurplusPlan(
      type: type ?? this.type,
      manualSafetyNet:
          clearManualAmounts ? null : manualSafetyNet ?? this.manualSafetyNet,
      manualInvestment:
          clearManualAmounts ? null : manualInvestment ?? this.manualInvestment,
      manualFreeUse: clearManualAmounts ? null : manualFreeUse ?? this.manualFreeUse,
    );
  }
}
