import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/state/finance_state.dart';
import '../../../core/state/finance_state_provider.dart';
import '../../../core/utils/currency_converter.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../shared/presentation/app_design.dart';
import '../../cards/domain/credit_card.dart';
import '../../cards/domain/credit_card_monthly_payment.dart';
import '../domain/surplus_plan.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    required this.onViewPlan,
    super.key,
  });

  final VoidCallback onViewPlan;

  static const _green = AppColors.primary;
  static const _card = AppColors.surface;
  static const _cardAlt = AppColors.surfaceElevated;
  static const _debtColor = AppColors.debt;
  static const _apartadoColor = AppColors.apartado;
  static const _savingColor = AppColors.saving;
  static const _freeColor = AppColors.freeUse;
  static const _expenseColor = AppColors.pending;

  void _showEditIncomeDialog(BuildContext context, FinanceState state) {
    final controller = TextEditingController(
      text: state.monthlyIncome.toStringAsFixed(0),
    );
    final formKey = GlobalKey<FormState>();
    var selectedCurrency = AppConstants.defaultCurrency;

    showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final parsedAmount = double.tryParse(controller.text.trim());
            final convertedIncome =
                selectedCurrency == AppConstants.usdCurrency &&
                        parsedAmount != null
                    ? CurrencyConverter.usdToMxn(parsedAmount)
                    : null;

            return AlertDialog(
              title: const Text('Editar ingreso del mes'),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(
                          value: AppConstants.defaultCurrency,
                          label: Text('MXN'),
                        ),
                        ButtonSegment(
                          value: AppConstants.usdCurrency,
                          label: Text('USD'),
                        ),
                      ],
                      selected: {selectedCurrency},
                      onSelectionChanged: (selection) {
                        setDialogState(() {
                          selectedCurrency = selection.first;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: controller,
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setDialogState(() {}),
                      decoration: InputDecoration(
                        labelText: selectedCurrency == AppConstants.usdCurrency
                            ? 'Monto mensual (USD)'
                            : 'Monto mensual (MXN)',
                        prefixText: r'$ ',
                        suffixText: selectedCurrency,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Por favor ingresa un monto';
                        }

                        final number = double.tryParse(value);
                        if (number == null || number <= 0) {
                          return 'Por favor ingresa un numero positivo valido';
                        }

                        return null;
                      },
                    ),
                    if (selectedCurrency == AppConstants.usdCurrency) ...[
                      const SizedBox(height: 12),
                      Text(
                        convertedIncome == null
                            ? 'Tipo de cambio: 1 USD = ${AppConstants.usdToMxnRate.toStringAsFixed(3)} MXN.'
                            : 'Equivale a ${CurrencyFormatter.format(convertedIncome)}.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Referencia ${AppConstants.usdToMxnRateDate}.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      final amount = double.parse(controller.text.trim());
                      final newIncome =
                          selectedCurrency == AppConstants.usdCurrency
                              ? CurrencyConverter.usdToMxn(amount)
                              : amount;
                      state.updateMonthlyIncome(newIncome);
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Nomina actualizada a ${CurrencyFormatter.format(newIncome)}',
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditCardPaymentDialog(
    BuildContext context,
    FinanceState state,
    CreditCard card,
  ) {
    final currentAmount = state.cardMonthlyPaymentAmount(card.id);
    final controller = TextEditingController(
      text: currentAmount.toStringAsFixed(2),
    );
    final formKey = GlobalKey<FormState>();
    var selectedSource = state.cardMonthlyPaymentSource(card.id);

    showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final estimated = state.estimatedCardMonthlyPayment(card.id);

            return AlertDialog(
              title: Text('Pago de ${card.name}'),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SegmentedButton<CreditCardPaymentSource>(
                      selected: {selectedSource},
                      onSelectionChanged: (selection) {
                        setDialogState(() {
                          selectedSource = selection.first;
                          if (selectedSource ==
                              CreditCardPaymentSource.estimated) {
                            controller.text = estimated.toStringAsFixed(2);
                          }
                        });
                      },
                      segments: const [
                        ButtonSegment(
                          value: CreditCardPaymentSource.manual,
                          label: Text('Manual'),
                        ),
                        ButtonSegment(
                          value: CreditCardPaymentSource.confirmed,
                          label: Text('Confirmado'),
                        ),
                        ButtonSegment(
                          value: CreditCardPaymentSource.estimated,
                          label: Text('Estimado'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: controller,
                      enabled:
                          selectedSource != CreditCardPaymentSource.estimated,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Monto a pagar este mes',
                        prefixText: r'$ ',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final number = double.tryParse(value?.trim() ?? '');
                        if (number == null || number < 0) {
                          return 'Ingresa un monto valido';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Estimado actual: ${CurrencyFormatter.format(estimated)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      final amount =
                          selectedSource == CreditCardPaymentSource.estimated
                              ? estimated
                              : double.parse(controller.text.trim());
                      state.updateCardMonthlyPayment(
                        card.id,
                        amount,
                        source: selectedSource,
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = FinanceStateProvider.of(context);
    final dashboard = DashboardOverview.fromState(state);
    final taskProgress = state.financialTaskProgress;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF07110F),
            Color(0xFF0A1411),
            Color(0xFF07110F),
          ],
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Resumen financiero',
                  style: textTheme.headlineSmall?.copyWith(
                    color: const Color(0xFFF1F5F3),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Una vista clara de tu dinero este mes.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFFAAB7B0),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          IncomeHeroCard(
            amount: dashboard.monthlyIncome,
            availableAmount: dashboard.realAvailableToSpend,
            monthLabel: dashboard.monthLabel,
            breakdown: dashboard.incomeBreakdown,
            onEdit: () => _showEditIncomeDialog(context, state),
          ),
          const SizedBox(height: 14),
          SalaryDistributionChart(
            slices: dashboard.distribution,
            monthlyIncome: dashboard.monthlyIncome,
          ),
          const SizedBox(height: 14),
          _DashboardCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Asi va tu plan este mes',
                  style: textTheme.titleMedium?.copyWith(
                    color: const Color(0xFFF1F5F3),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 14),
                StackedProgressBar(slices: dashboard.distribution),
                const SizedBox(height: 12),
                Text(
                  'Vas en camino. Has usado ${dashboard.spentPercentLabel} de tu ingreso.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFFAAB7B0),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _SummaryMetricGrid(metrics: dashboard.metrics),
          const SizedBox(height: 14),
          SurplusPlanCard(
            allocation: dashboard.surplusPlanItems,
            planLabel: _surplusPlanLabel(state.surplusPlan.type),
            onViewPlan: onViewPlan,
          ),
          const SizedBox(height: 14),
          ChecklistSummaryCard(
            completed: taskProgress.completed,
            total: taskProgress.total,
            percent: taskProgress.percent,
            progress: taskProgress.ratio,
            onViewTasks: onViewPlan,
          ),
          const SizedBox(height: 14),
          DebtsAndApartadosList(
            items: dashboard.debtAndApartadoItems,
            onEditFirstCard: () {
              if (state.creditCards.isNotEmpty) {
                _showEditCardPaymentDialog(context, state, state.creditCards.first);
              }
            },
          ),
        ],
      ),
    );
  }

  static String _surplusPlanLabel(SurplusPlanType plan) {
    return switch (plan) {
      SurplusPlanType.conservative => 'Conservador',
      SurplusPlanType.balanced => 'Balanceado',
      SurplusPlanType.investment => 'Inversion',
      SurplusPlanType.custom => 'Personalizado',
    };
  }
}

class DashboardOverview {
  const DashboardOverview({
    required this.monthlyIncome,
    required this.realAvailableToSpend,
    required this.monthLabel,
    required this.incomeBreakdown,
    required this.distribution,
    required this.metrics,
    required this.surplusPlanItems,
    required this.debtAndApartadoItems,
    required this.spentPercentLabel,
  });

  final double monthlyIncome;
  final double realAvailableToSpend;
  final String monthLabel;
  final List<IncomeBreakdownItem> incomeBreakdown;
  final List<DistributionSlice> distribution;
  final List<SummaryMetric> metrics;
  final List<SurplusPlanItem> surplusPlanItems;
  final List<DebtApartadoItem> debtAndApartadoItems;
  final String spentPercentLabel;

  factory DashboardOverview.fromState(FinanceState state) {
    final monthlyIncome = state.monthlyIncome;
    const debts = 17098.25;
    const apartados = 7649.22;
    const saving = 8999.08;
    const free = 11248.84;
    final plannedSurplus = state.availableAfterMonthlyPlan;
    final allocation = state.surplusPlan.allocation(plannedSurplus);

    return DashboardOverview(
      monthlyIncome: monthlyIncome,
      realAvailableToSpend: free,
      monthLabel: _monthLabel(DateTime.now()),
      incomeBreakdown: const [
        IncomeBreakdownItem(
          label: 'Deudas',
          amount: debts,
          percent: 38,
          color: DashboardScreen._debtColor,
          icon: Icons.account_balance_wallet_outlined,
        ),
        IncomeBreakdownItem(
          label: 'Apartados',
          amount: apartados,
          percent: 17,
          color: DashboardScreen._apartadoColor,
          icon: Icons.inventory_2_outlined,
        ),
        IncomeBreakdownItem(
          label: 'Ahorro / inversion',
          amount: saving,
          percent: 20,
          color: DashboardScreen._savingColor,
          icon: Icons.trending_up,
        ),
      ],
      distribution: [
        DistributionSlice(
          label: 'Deudas',
          amount: debts,
          color: DashboardScreen._debtColor,
          icon: Icons.credit_card_outlined,
          percent: _percent(debts, monthlyIncome),
        ),
        DistributionSlice(
          label: 'Apartados',
          amount: apartados,
          color: DashboardScreen._apartadoColor,
          icon: Icons.inventory_2_outlined,
          percent: _percent(apartados, monthlyIncome),
        ),
        DistributionSlice(
          label: 'Ahorro',
          amount: saving,
          color: DashboardScreen._savingColor,
          icon: Icons.savings_outlined,
          percent: _percent(saving, monthlyIncome),
        ),
        DistributionSlice(
          label: 'Te queda libre',
          amount: free,
          color: DashboardScreen._freeColor,
          icon: Icons.wallet_outlined,
          percent: _percent(free, monthlyIncome),
        ),
      ],
      metrics: [
        SummaryMetric(
          title: 'Total presupuestado',
          amount: state.totalAllocated,
          percent: _percent(state.totalAllocated, monthlyIncome),
          color: DashboardScreen._apartadoColor,
          icon: Icons.pie_chart_outline,
        ),
        SummaryMetric(
          title: 'Planeado del mes',
          amount: state.totalPlannedExpenses,
          percent: _percent(state.totalPlannedExpenses, monthlyIncome),
          color: DashboardScreen._green,
          icon: Icons.event_note_outlined,
        ),
        SummaryMetric(
          title: 'Gastado este mes',
          amount: state.totalSpent,
          percent: _percent(state.totalSpent, monthlyIncome),
          color: DashboardScreen._expenseColor,
          icon: Icons.trending_down,
        ),
        SummaryMetric(
          title: 'Sobrante planeado',
          amount: plannedSurplus,
          percent: _percent(plannedSurplus, monthlyIncome),
          color: DashboardScreen._freeColor,
          icon: Icons.account_balance_wallet_outlined,
        ),
      ],
      surplusPlanItems: [
        SurplusPlanItem(
          label: 'Colchon',
          amount: allocation.safetyNet,
          percent: 40,
          color: DashboardScreen._green,
          icon: Icons.health_and_safety_outlined,
        ),
        SurplusPlanItem(
          label: 'CETES / inversion',
          amount: allocation.investment,
          percent: 40,
          color: DashboardScreen._savingColor,
          icon: Icons.show_chart,
        ),
        SurplusPlanItem(
          label: 'Uso libre',
          amount: allocation.freeUse,
          percent: 20,
          color: DashboardScreen._freeColor,
          icon: Icons.local_atm_outlined,
        ),
      ],
      debtAndApartadoItems: const [
        DebtApartadoItem(
          title: 'Tarjeta Azul',
          type: 'Credito',
          amount: 4905,
          status: '61% usado',
          progress: 0.61,
          color: DashboardScreen._debtColor,
          icon: Icons.credit_card_outlined,
        ),
        DebtApartadoItem(
          title: 'Tarjeta Dorada',
          type: 'Credito',
          amount: 1800,
          status: '90% usado',
          progress: 0.90,
          color: DashboardScreen._expenseColor,
          icon: Icons.credit_score_outlined,
        ),
        DebtApartadoItem(
          title: 'Asbel',
          type: 'Apartado',
          amount: 2000,
          status: 'A tiempo',
          color: DashboardScreen._apartadoColor,
          icon: Icons.person_outline,
        ),
        DebtApartadoItem(
          title: 'Carmen',
          type: 'Apartado',
          amount: 600,
          status: 'A tiempo',
          color: DashboardScreen._apartadoColor,
          icon: Icons.person_outline,
        ),
      ],
      spentPercentLabel:
          '${_percent(state.totalSpent, monthlyIncome).toStringAsFixed(1)}%',
    );
  }

  static double _percent(double value, double total) {
    if (total <= 0) {
      return 0;
    }

    return value / total * 100;
  }

  static String _monthLabel(DateTime date) {
    const months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];

    return '${months[date.month - 1]} ${date.year}';
  }
}

class DistributionSlice {
  const DistributionSlice({
    required this.label,
    required this.amount,
    required this.percent,
    required this.color,
    required this.icon,
  });

  final String label;
  final double amount;
  final double percent;
  final Color color;
  final IconData icon;
}

class IncomeBreakdownItem {
  const IncomeBreakdownItem({
    required this.label,
    required this.amount,
    required this.percent,
    required this.color,
    required this.icon,
  });

  final String label;
  final double amount;
  final int percent;
  final Color color;
  final IconData icon;
}

class SummaryMetric {
  const SummaryMetric({
    required this.title,
    required this.amount,
    required this.percent,
    required this.color,
    required this.icon,
  });

  final String title;
  final double amount;
  final double percent;
  final Color color;
  final IconData icon;
}

class SurplusPlanItem {
  const SurplusPlanItem({
    required this.label,
    required this.amount,
    required this.percent,
    required this.color,
    required this.icon,
  });

  final String label;
  final double amount;
  final double percent;
  final Color color;
  final IconData icon;
}

class DebtApartadoItem {
  const DebtApartadoItem({
    required this.title,
    required this.type,
    required this.amount,
    required this.status,
    required this.color,
    required this.icon,
    this.progress,
  });

  final String title;
  final String type;
  final double amount;
  final String status;
  final Color color;
  final IconData icon;
  final double? progress;
}

class IncomeHeroCard extends StatelessWidget {
  const IncomeHeroCard({
    required this.amount,
    required this.availableAmount,
    required this.monthLabel,
    required this.breakdown,
    required this.onEdit,
    super.key,
  });

  final double amount;
  final double availableAmount;
  final String monthLabel;
  final List<IncomeBreakdownItem> breakdown;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.primary.withAlpha(105), width: 1.3),
        gradient: const RadialGradient(
          center: Alignment.topLeft,
          radius: 1.35,
          colors: [
            Color(0xFF145F38),
            Color(0xFF0E211A),
            Color(0xFF07110F),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: DashboardScreen._green.withAlpha(28),
            blurRadius: 34,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Spacer(),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onEdit,
                  borderRadius: BorderRadius.circular(AppRadii.pill),
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 44),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(22),
                      borderRadius: BorderRadius.circular(AppRadii.pill),
                      border: Border.all(
                        color: AppColors.primary.withAlpha(80),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          monthLabel,
                          style: textTheme.labelLarge?.copyWith(
                            color: const Color(0xFFD8F6E5),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.calendar_month_outlined,
                          color: AppColors.textSecondary,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'INGRESO DEL MES',
            style: textTheme.labelMedium?.copyWith(
              color: const Color(0xFFC1F1D5),
              fontWeight: FontWeight.w800,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 18),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              CurrencyFormatter.format(amount),
              style: textTheme.headlineMedium?.copyWith(
                color: const Color(0xFFF1F5F3),
                fontSize: 52,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 28),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 26),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 560;
              final info = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        'Te queda libre este mes',
                        style: textTheme.titleLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      StatusPill(
                        label: 'Libre para gastar',
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      CurrencyFormatter.format(availableAmount),
                      style: textTheme.headlineMedium?.copyWith(
                        color: AppColors.primary,
                        fontSize: 46,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '25% de tu ingreso',
                    style: textTheme.titleMedium?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              );
              final ring = SizedBox(
                width: 150,
                height: 150,
                child: CustomPaint(
                  painter: _AvailableRingPainter(0.25),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '25%',
                          style: textTheme.headlineSmall?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          'LIBRE',
                          style: textTheme.labelLarge?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );

              if (isWide) {
                return Row(
                  children: [
                    Expanded(child: info),
                    const SizedBox(width: 20),
                    ring,
                  ],
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  info,
                  const SizedBox(height: 20),
                  Align(alignment: Alignment.center, child: ring),
                ],
              );
            },
          ),
          const SizedBox(height: 28),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 26),
          Text(
            'Ya separado de tu ingreso',
            style: textTheme.titleLarge?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: breakdown.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _IncomeBreakdownRow(item: item),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _IncomeBreakdownRow extends StatelessWidget {
  const _IncomeBreakdownRow({required this.item});

  final IncomeBreakdownItem item;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withAlpha(28)),
      ),
      child: Row(
        children: [
          AppIconBubble(icon: item.icon, color: item.color, size: 56),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  CurrencyFormatter.format(item.amount),
                  style: textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.percent}% de tu ingreso',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textPrimary),
        ],
      ),
    );
  }
}

class _AvailableRingPainter extends CustomPainter {
  const _AvailableRingPainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 8;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final background = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..color = AppColors.surfaceSoft;
    final foreground = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..color = AppColors.primary;

    canvas.drawArc(rect, 0, math.pi * 2, false, background);
    canvas.drawArc(
      rect,
      -math.pi / 2,
      progress.clamp(0, 1) * math.pi * 2,
      false,
      foreground,
    );
  }

  @override
  bool shouldRepaint(covariant _AvailableRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class SalaryDistributionChart extends StatelessWidget {
  const SalaryDistributionChart({
    required this.slices,
    required this.monthlyIncome,
    super.key,
  });

  final List<DistributionSlice> slices;
  final double monthlyIncome;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return _DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Distribucion de tu salario',
            style: textTheme.titleMedium?.copyWith(
              color: const Color(0xFFF1F5F3),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 620;

              final chart = SizedBox(
                height: 210,
                child: CustomPaint(
                  painter: _DonutChartPainter(slices),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '100%',
                          style: textTheme.headlineSmall?.copyWith(
                            color: const Color(0xFFF1F5F3),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          'ingreso',
                          style: textTheme.labelMedium?.copyWith(
                            color: const Color(0xFFAAB7B0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );

              final legend = Column(
                children: slices
                    .map(
                      (slice) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _DistributionLegendItem(slice: slice),
                      ),
                    )
                    .toList(),
              );

              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: chart),
                    const SizedBox(width: 18),
                    Expanded(child: legend),
                  ],
                );
              }

              return Column(
                children: [
                  chart,
                  const SizedBox(height: 12),
                  legend,
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DistributionLegendItem extends StatelessWidget {
  const _DistributionLegendItem({required this.slice});

  final DistributionSlice slice;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withAlpha(18)),
      ),
      child: Row(
        children: [
          _IconBubble(icon: slice.icon, color: slice.color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  slice.label,
                  style: textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFFF1F5F3),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  CurrencyFormatter.format(slice.amount),
                  style: textTheme.bodySmall?.copyWith(
                    color: const Color(0xFFAAB7B0),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${slice.percent.round()}%',
            style: textTheme.titleMedium?.copyWith(
              color: slice.color,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class StackedProgressBar extends StatelessWidget {
  const StackedProgressBar({
    required this.slices,
    super.key,
  });

  final List<DistributionSlice> slices;

  @override
  Widget build(BuildContext context) {
    final total = slices.fold<double>(0, (sum, slice) => sum + slice.amount);

    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        height: 18,
        child: Row(
          children: slices.map((slice) {
            return Expanded(
              flex: total <= 0
                  ? 1
                  : math.max(1, (slice.amount / total * 1000).round()),
              child: ColoredBox(
                color: slice.color,
                child: const SizedBox.expand(),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _SummaryMetricGrid extends StatelessWidget {
  const _SummaryMetricGrid({required this.metrics});

  final List<SummaryMetric> metrics;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 720 ? 4 : 2;
        const gap = 12.0;
        final itemWidth = (constraints.maxWidth - gap * (columns - 1)) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: metrics
              .map(
                (metric) => SizedBox(
                  width: itemWidth,
                  child: SummaryMetricCard(metric: metric),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class SummaryMetricCard extends StatelessWidget {
  const SummaryMetricCard({
    required this.metric,
    super.key,
  });

  final SummaryMetric metric;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final progress = (metric.percent / 100).clamp(0.0, 1.0).toDouble();

    return Container(
      constraints: const BoxConstraints(minHeight: 166),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: DashboardScreen._card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withAlpha(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconBubble(icon: metric.icon, color: metric.color),
          const SizedBox(height: 12),
          Text(
            metric.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.labelLarge?.copyWith(
              color: const Color(0xFFAAB7B0),
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              CurrencyFormatter.format(metric.amount),
              style: textTheme.titleMedium?.copyWith(
                color: const Color(0xFFF1F5F3),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${metric.percent.round()}% del ingreso',
            style: textTheme.bodySmall?.copyWith(
              color: const Color(0xFFAAB7B0),
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.white.withAlpha(18),
              color: metric.color,
            ),
          ),
        ],
      ),
    );
  }
}

class SurplusPlanCard extends StatelessWidget {
  const SurplusPlanCard({
    required this.allocation,
    required this.planLabel,
    required this.onViewPlan,
    super.key,
  });

  final List<SurplusPlanItem> allocation;
  final String planLabel;
  final VoidCallback onViewPlan;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return _DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Plan sugerido para tu sobrante',
                      style: textTheme.titleMedium?.copyWith(
                        color: const Color(0xFFF1F5F3),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Distribucion recomendada de tu sobrante planeado.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFFAAB7B0),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              _PlanChip(label: planLabel),
            ],
          ),
          const SizedBox(height: 16),
          ...allocation.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _SurplusPlanRow(item: item),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton.icon(
              onPressed: onViewPlan,
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Ver plan'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SurplusPlanRow extends StatelessWidget {
  const _SurplusPlanRow({required this.item});

  final SurplusPlanItem item;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withAlpha(18)),
      ),
      child: Row(
        children: [
          _IconBubble(icon: item.icon, color: item.color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFFF1F5F3),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  CurrencyFormatter.format(item.amount),
                  style: textTheme.bodySmall?.copyWith(
                    color: const Color(0xFFAAB7B0),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${item.percent.round()}%',
            style: textTheme.titleMedium?.copyWith(
              color: item.color,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class DebtsAndApartadosList extends StatelessWidget {
  const DebtsAndApartadosList({
    required this.items,
    required this.onEditFirstCard,
    super.key,
  });

  final List<DebtApartadoItem> items;
  final VoidCallback onEditFirstCard;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return _DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Deudas y apartados',
            style: textTheme.titleMedium?.copyWith(
              color: const Color(0xFFF1F5F3),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          ...items.asMap().entries.map(
                (entry) => Padding(
                  padding: EdgeInsets.only(
                    bottom: entry.key == items.length - 1 ? 0 : 10,
                  ),
                  child: _DebtApartadoTile(
                    item: entry.value,
                    onTap: entry.key == 0 ? onEditFirstCard : null,
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

class ChecklistSummaryCard extends StatelessWidget {
  const ChecklistSummaryCard({
    required this.completed,
    required this.total,
    required this.percent,
    required this.progress,
    required this.onViewTasks,
    super.key,
  });

  final int completed;
  final int total;
  final int percent;
  final double progress;
  final VoidCallback onViewTasks;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return _DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _IconBubble(
                icon: Icons.task_alt,
                color: DashboardScreen._green,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Checklist financiero',
                      style: textTheme.titleMedium?.copyWith(
                        color: const Color(0xFFF1F5F3),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '$completed/$total completadas',
                      style: textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFFAAB7B0),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: onViewTasks,
                child: const Text('Ver tareas'),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white.withAlpha(18),
              color: DashboardScreen._green,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Has ejecutado el $percent% de tu plan financiero.',
            style: textTheme.bodySmall?.copyWith(
              color: const Color(0xFFAAB7B0),
            ),
          ),
        ],
      ),
    );
  }
}

class _DebtApartadoTile extends StatelessWidget {
  const _DebtApartadoTile({
    required this.item,
    this.onTap,
  });

  final DebtApartadoItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.white.withAlpha(10),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _IconBubble(icon: item.icon, color: item.color),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFFF1F5F3),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Text(
                          CurrencyFormatter.format(item.amount),
                          style: textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFFF1F5F3),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          item.type,
                          style: textTheme.bodySmall?.copyWith(
                            color: const Color(0xFFAAB7B0),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            item.status,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodySmall?.copyWith(
                              color: item.color,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (item.progress != null) ...[
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: item.progress,
                          minHeight: 5,
                          backgroundColor: Colors.white.withAlpha(18),
                          color: item.color,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right,
                color: Color(0xFFAAB7B0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DashboardScreen._cardAlt,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withAlpha(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(42),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble({
    required this.icon,
    required this.color,
  });

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withAlpha(32),
        border: Border.all(color: color.withAlpha(90)),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}

class _PlanChip extends StatelessWidget {
  const _PlanChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: DashboardScreen._green.withAlpha(28),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: DashboardScreen._green.withAlpha(80)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: DashboardScreen._green,
                fontWeight: FontWeight.w800,
              ),
        ),
      ),
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  const _DonutChartPainter(this.slices);

  final List<DistributionSlice> slices;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 8;
    final strokeWidth = math.max(22.0, radius * 0.22);
    final rect = Rect.fromCircle(center: center, radius: radius);
    final backgroundPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withAlpha(18);

    canvas.drawArc(rect, 0, math.pi * 2, false, backgroundPaint);

    final total = slices.fold<double>(0, (sum, slice) => sum + slice.amount);
    var startAngle = -math.pi / 2;

    for (final slice in slices) {
      final sweep = total <= 0 ? 0 : slice.amount / total * math.pi * 2;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..color = slice.color;

      canvas.drawArc(rect, startAngle, math.max(0, sweep - 0.035), false, paint);
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return oldDelegate.slices != slices;
  }
}
