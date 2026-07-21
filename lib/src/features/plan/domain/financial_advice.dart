import 'package:flutter/material.dart';

import '../../../core/state/finance_state.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../dashboard/domain/surplus_plan.dart';

enum FinancialAdviceLevel { positive, suggestion, warning }

class FinancialAdvice {
  const FinancialAdvice({
    required this.title,
    required this.description,
    required this.icon,
    required this.level,
  });

  final String title;
  final String description;
  final IconData icon;
  final FinancialAdviceLevel level;
}

class FinancialAdviceGenerator {
  const FinancialAdviceGenerator._();

  static const antExpenseWarningPercent = 20.0;
  static const budgetWarningPercent = 80.0;
  static const debtWarningPercent = 30.0;

  static List<FinancialAdvice> fromState(FinanceState state) {
    final advice = <FinancialAdvice>[];

    if (state.monthlyIncome <= 0) {
      advice.add(
        const FinancialAdvice(
          title: 'Configura tu ingreso',
          description:
              'Registra tu ingreso mensual para obtener un plan financiero util.',
          icon: Icons.payments_outlined,
          level: FinancialAdviceLevel.suggestion,
        ),
      );
    }

    if (state.surplusPlan.type == SurplusPlanType.unconfigured) {
      advice.add(
        const FinancialAdvice(
          title: 'Selecciona un plan financiero',
          description:
              'Elige como distribuir tu sobrante entre ahorro, inversion y uso libre.',
          icon: Icons.tune,
          level: FinancialAdviceLevel.suggestion,
        ),
      );
    }

    final antPercent = state.antExpensesPercentOfFreeMoney;
    if (antPercent > antExpenseWarningPercent) {
      advice.add(
        FinancialAdvice(
          title: 'Reduce tus gastos hormiga',
          description: 'Llevas '
              '${CurrencyFormatter.format(state.antExpensesForSelectedPeriod)} '
              '(${antPercent.toStringAsFixed(1)}% de tu dinero libre). '
              'Revisa cuales puedes evitar este periodo.',
          icon: Icons.pest_control_outlined,
          level: FinancialAdviceLevel.warning,
        ),
      );
    }

    final budgetPercent = state.budgetUtilizationPercent;
    final budgetAvailable = state.totalBudgetAvailableForSelectedPeriod;
    if (budgetAvailable < 0) {
      advice.add(
        FinancialAdvice(
          title: 'Tu presupuesto esta excedido',
          description: 'Has superado el presupuesto por '
              '${CurrencyFormatter.format(-budgetAvailable)}. '
              'Ajusta los gastos restantes del periodo.',
          icon: Icons.warning_amber_rounded,
          level: FinancialAdviceLevel.warning,
        ),
      );
    } else if (budgetPercent > budgetWarningPercent) {
      advice.add(
        FinancialAdvice(
          title: 'Tu presupuesto esta cerca del limite',
          description: 'Ya utilizaste ${budgetPercent.toStringAsFixed(1)}%. '
              'Revisa el disponible antes de registrar nuevos gastos.',
          icon: Icons.pie_chart_outline,
          level: FinancialAdviceLevel.warning,
        ),
      );
    }

    final debtPercent = state.debtPaymentPercentOfIncome;
    if (debtPercent > debtWarningPercent) {
      advice.add(
        FinancialAdvice(
          title: 'Prioriza reducir tus deudas',
          description: 'Los pagos mensuales representan '
              '${debtPercent.toStringAsFixed(1)}% de tus ingresos. '
              'Evita asumir nuevas obligaciones mientras reduces ese nivel.',
          icon: Icons.credit_card_off_outlined,
          level: FinancialAdviceLevel.warning,
        ),
      );
    }

    final allocation = state.surplusPlanAllocation;
    final assignedToSaving = allocation.safetyNet + allocation.investment;
    if (state.availableAfterMonthlyPlan > 0 && assignedToSaving <= 0) {
      advice.add(
        const FinancialAdvice(
          title: 'Asigna una cantidad al ahorro',
          description:
              'Tienes capacidad disponible. Define una cantidad acorde con tus objetivos y liquidez.',
          icon: Icons.savings_outlined,
          level: FinancialAdviceLevel.suggestion,
        ),
      );
    }

    if (advice.isEmpty) {
      advice.add(
        const FinancialAdvice(
          title: 'Tu plan esta bajo control',
          description:
              'No detectamos alertas en este periodo. Continua registrando tus movimientos.',
          icon: Icons.check_circle_outline,
          level: FinancialAdviceLevel.positive,
        ),
      );
    }

    return List.unmodifiable(advice);
  }
}
