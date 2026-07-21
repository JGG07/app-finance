import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/state/finance_state.dart';
import '../../../core/state/finance_state_provider.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../shared/presentation/app_design.dart';
import '../../dashboard/domain/surplus_plan.dart';
import '../../tasks/domain/financial_task.dart';
import '../../tandas/presentation/tandas_section.dart';
import '../domain/financial_advice.dart';

class PlanScreen extends StatelessWidget {
  const PlanScreen({super.key});

  void _showChangePlanDialog(BuildContext context, FinanceState state) {
    var selectedPlan = state.surplusPlan.type;

    showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Cambiar plan'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: SurplusPlanType.values
                    .where((plan) => plan != SurplusPlanType.unconfigured)
                    .map((plan) {
                  return RadioListTile<SurplusPlanType>(
                    contentPadding: EdgeInsets.zero,
                    title: Text(_planLabel(plan)),
                    subtitle: Text(_planDescription(plan)),
                    value: plan,
                    groupValue: selectedPlan,
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() => selectedPlan = value);
                      }
                    },
                  );
                }).toList(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () {
                    state.updateSurplusPlan(selectedPlan);
                    Navigator.of(context).pop();
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

  void _showEditAmountsDialog(BuildContext context, FinanceState state) {
    final allocation = state.surplusPlanAllocation;
    final safetyController = TextEditingController(
      text: allocation.safetyNet.toStringAsFixed(2),
    );
    final investmentController = TextEditingController(
      text: allocation.investment.toStringAsFixed(2),
    );
    final freeUseController = TextEditingController(
      text: allocation.freeUse.toStringAsFixed(2),
    );
    final formKey = GlobalKey<FormState>();

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar sobrante'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _MoneyField(controller: safetyController, label: 'Colchon'),
                const SizedBox(height: 12),
                _MoneyField(
                  controller: investmentController,
                  label: 'CETES / inversion',
                ),
                const SizedBox(height: 12),
                _MoneyField(controller: freeUseController, label: 'Uso libre'),
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
                  state.updateSurplusPlanAmounts(
                    safetyNet: double.parse(safetyController.text.trim()),
                    investment: double.parse(investmentController.text.trim()),
                    freeUse: double.parse(freeUseController.text.trim()),
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
  }

  void _showTaskDialog(
    BuildContext context,
    FinanceState state, {
    FinancialTask? task,
  }) {
    final titleController = TextEditingController(text: task?.title ?? '');
    final amountController = TextEditingController(
      text: task?.amount.toStringAsFixed(2) ?? '',
    );
    final actualAmountController = TextEditingController(
      text: task?.actualAmount?.toStringAsFixed(2) ?? '',
    );
    final notesController = TextEditingController(text: task?.notes ?? '');
    final formKey = GlobalKey<FormState>();
    var selectedStatus = task?.status ?? FinancialTaskStatus.pending;

    showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(task == null ? 'Agregar tarea' : 'Editar tarea'),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Ingresa un nombre';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      _MoneyField(controller: amountController, label: 'Monto'),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<FinancialTaskStatus>(
                        value: selectedStatus,
                        decoration: const InputDecoration(
                          labelText: 'Estado',
                          border: OutlineInputBorder(),
                        ),
                        items: FinancialTaskStatus.values.map((status) {
                          return DropdownMenuItem(
                            value: status,
                            child: Text(_taskStatusLabel(status)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setDialogState(() => selectedStatus = value);
                          }
                        },
                      ),
                      if (selectedStatus == FinancialTaskStatus.partial) ...[
                        const SizedBox(height: 12),
                        _MoneyField(
                          controller: actualAmountController,
                          label: 'Monto realizado',
                        ),
                      ],
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: notesController,
                        minLines: 2,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Notas',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
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
                      final amount = double.parse(amountController.text.trim());
                      final actualAmount =
                          selectedStatus == FinancialTaskStatus.partial
                              ? double.parse(actualAmountController.text.trim())
                              : null;

                      if (task == null) {
                        state.addManualFinancialTask(
                          title: titleController.text,
                          amount: amount,
                          notes: notesController.text,
                          status: selectedStatus,
                          actualAmount: actualAmount,
                        );
                      } else {
                        state.updateFinancialTask(
                          task.id,
                          title: titleController.text.trim(),
                          amount: amount,
                          status: selectedStatus,
                          actualAmount: actualAmount,
                          notes: notesController.text,
                        );
                      }
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

  void _showAdviceSheet(BuildContext context, FinanceState state) {
    final advice = FinancialAdviceGenerator.fromState(state);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      builder: (context) {
        return SafeArea(
          child: FractionallySizedBox(
            heightFactor: 0.78,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const AppIconBubble(
                        icon: Icons.lightbulb_outline,
                        color: AppColors.pending,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Consejos para este periodo',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w900,
                                  ),
                            ),
                            Text(
                              state.selectedPeriod.label,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Cerrar consejos',
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: ListView.separated(
                      itemCount: advice.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) {
                        return _FinancialAdviceCard(advice: advice[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = FinanceStateProvider.of(context);
    final textTheme = Theme.of(context).textTheme;
    final allocation = state.surplusPlanAllocation;
    final surplus = state.realEstimatedSurplus;
    final tasks = state.monthlyFinancialTasks;
    final taskProgress = state.financialTaskProgress;
    final isPhoneWidth = MediaQuery.sizeOf(context).width <= 430;

    return AppScreen(
      padding: EdgeInsets.fromLTRB(
        isPhoneWidth ? 8 : 18,
        24,
        isPhoneWidth ? 8 : 18,
        24,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 46),
          child: Row(
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: 'Plan financiero ',
                    style: textTheme.headlineMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0,
                    ),
                    children: const [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          Icons.eco_outlined,
                          color: AppColors.primary,
                          size: 25,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Padding(
          padding: const EdgeInsets.only(right: 46),
          child: Text(
            'Organiza tu sobrante y marca lo que ya hiciste este mes.',
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary.withAlpha(218),
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        _PlanHeroCard(
          surplus: surplus,
          planLabel: _planLabel(state.surplusPlan.type),
          allocation: allocation,
        ),
        const SizedBox(height: AppSpacing.lg),
        _PlanProgressCard(progress: taskProgress),
        const SizedBox(height: AppSpacing.lg),
        FinancialTasksSection(
          tasks: tasks,
          progress: taskProgress,
          onAddTask: () => _showTaskDialog(context, state),
          onViewAdvice: () => _showAdviceSheet(context, state),
          onEditTask: (task) => _showTaskDialog(context, state, task: task),
          onToggleTask: (task, isDone) {
            state.updateFinancialTaskStatus(
              task.id,
              isDone ? FinancialTaskStatus.done : FinancialTaskStatus.pending,
            );
          },
          onStatusSelected: (task, status) {
            if (status == FinancialTaskStatus.partial) {
              _showTaskDialog(context, state, task: task);
              return;
            }

            state.updateFinancialTaskStatus(task.id, status);
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        TandasSection(state: state),
        const SizedBox(height: AppSpacing.lg),
        _PlanQuickSummary(
          debtPercent: state.debtPaymentPercentOfIncome.round(),
          apartadoPercent: state.budgetUtilizationPercent.round(),
          savingPercent: state.savingPercentOfSurplus.round(),
        ),
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton.icon(
              onPressed: () => _showChangePlanDialog(context, state),
              icon: const Icon(Icons.tune, size: 18),
              label: const Text('Cambiar plan'),
            ),
            FilledButton.icon(
              onPressed: () => _showEditAmountsDialog(context, state),
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text('Editar montos'),
            ),
          ],
        ),
      ],
    );
  }

  static String _planLabel(SurplusPlanType plan) {
    return switch (plan) {
      SurplusPlanType.unconfigured => 'Sin configurar',
      SurplusPlanType.none => 'Sin plan',
      SurplusPlanType.conservative => 'Conservador',
      SurplusPlanType.balanced => 'Balanceado',
      SurplusPlanType.investment => 'Inversion',
      SurplusPlanType.custom => 'Personalizado',
    };
  }

  static String _planDescription(SurplusPlanType plan) {
    return switch (plan) {
      SurplusPlanType.unconfigured => 'Elige como organizar tu sobrante',
      SurplusPlanType.none => 'Todo el sobrante permanece como dinero libre',
      SurplusPlanType.conservative => '60% colchon, 25% inversion, 15% libre',
      SurplusPlanType.balanced => '40% colchon, 40% inversion, 20% libre',
      SurplusPlanType.investment => '20% colchon, 65% inversion, 15% libre',
      SurplusPlanType.custom => 'Montos definidos manualmente',
    };
  }

  static String _taskStatusLabel(FinancialTaskStatus status) {
    return switch (status) {
      FinancialTaskStatus.pending => 'Pendiente',
      FinancialTaskStatus.done => 'Hecha',
      FinancialTaskStatus.partial => 'Parcial',
      FinancialTaskStatus.skipped => 'Omitida',
    };
  }
}

class _FinancialAdviceCard extends StatelessWidget {
  const _FinancialAdviceCard({required this.advice});

  final FinancialAdvice advice;

  @override
  Widget build(BuildContext context) {
    final color = switch (advice.level) {
      FinancialAdviceLevel.positive => AppColors.primary,
      FinancialAdviceLevel.suggestion => AppColors.freeUse,
      FinancialAdviceLevel.warning => AppColors.pending,
    };

    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIconBubble(icon: advice.icon, color: color),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  advice.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  advice.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanHeroCard extends StatelessWidget {
  const _PlanHeroCard({
    required this.surplus,
    required this.planLabel,
    required this.allocation,
  });

  final double surplus;
  final String planLabel;
  final SurplusPlanAllocation allocation;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.primary.withAlpha(42)),
        gradient: const RadialGradient(
          center: Alignment.topLeft,
          radius: 1.35,
          colors: [
            Color(0xFF145F38),
            AppColors.surfaceElevated,
            Color(0xFF081713),
          ],
        ),
        boxShadow: AppShadows.glow,
      ),
      child: Stack(
        children: [
          Positioned(
            top: -60,
            right: -28,
            child: CustomPaint(
              size: const Size(230, 190),
              painter: _PlanLinePatternPainter(),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Sobrante disponible',
                              style: textTheme.titleMedium?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.info_outline,
                              color: AppColors.primary.withAlpha(190),
                              size: 18,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            CurrencyFormatter.format(surplus),
                            style: textTheme.headlineLarge?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        StatusPill(
                          label: 'Plan ${planLabel.toLowerCase()}',
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(22),
                      borderRadius: BorderRadius.circular(22),
                      border:
                          Border.all(color: AppColors.primary.withAlpha(45)),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_outlined,
                      color: AppColors.primary,
                      size: 34,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadii.pill),
                child: const SizedBox(
                  height: 26,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 40,
                        child: ColoredBox(
                          color: AppColors.saving,
                          child: Center(child: Text('40%')),
                        ),
                      ),
                      Expanded(
                        flex: 40,
                        child: ColoredBox(
                          color: AppColors.apartado,
                          child: Center(child: Text('40%')),
                        ),
                      ),
                      Expanded(
                        flex: 20,
                        child: ColoredBox(
                          color: AppColors.freeUse,
                          child: Center(child: Text('20%')),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 22),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 620;
                  final items = [
                    _HeroAllocationItem(
                      icon: Icons.shield_outlined,
                      title: 'Colchon',
                      amount: allocation.safetyNet,
                      percent: '40%',
                      color: AppColors.saving,
                    ),
                    _HeroAllocationItem(
                      icon: Icons.trending_up,
                      title: 'CETES / inversion',
                      amount: allocation.investment,
                      percent: '40%',
                      color: AppColors.apartado,
                    ),
                    _HeroAllocationItem(
                      icon: Icons.redeem_outlined,
                      title: 'Uso libre',
                      amount: allocation.freeUse,
                      percent: '20%',
                      color: AppColors.freeUse,
                    ),
                  ];

                  if (isWide) {
                    return Row(
                      children: [
                        for (var index = 0; index < items.length; index++) ...[
                          if (index > 0)
                            Container(
                              width: 1,
                              height: 56,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              color: AppColors.border,
                            ),
                          Expanded(child: items[index]),
                        ],
                      ],
                    );
                  }

                  return Column(
                    children: [
                      for (var index = 0; index < items.length; index++) ...[
                        if (index > 0) const SizedBox(height: 14),
                        items[index],
                      ],
                    ],
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroAllocationItem extends StatelessWidget {
  const _HeroAllocationItem({
    required this.icon,
    required this.title,
    required this.amount,
    required this.percent,
    required this.color,
  });

  final IconData icon;
  final String title;
  final double amount;
  final String percent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        AppIconBubble(icon: icon, color: color, size: 44),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                CurrencyFormatter.format(amount),
                style: textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                percent,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlanProgressCard extends StatelessWidget {
  const _PlanProgressCard({required this.progress});

  final FinancialTaskProgress progress;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      padding: const EdgeInsets.all(22),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Progreso de tu plan',
                  style: textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${progress.completed} de ${progress.total} tareas completadas',
                  style: textTheme.titleMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadii.pill),
                  child: LinearProgressIndicator(
                    value: progress.ratio,
                    minHeight: 18,
                    color: AppColors.primary,
                    backgroundColor: AppColors.surfaceSoft,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  progress.percent >= 50
                      ? 'Vas muy bien. Ya ejecutaste gran parte de tu plan del mes.'
                      : 'Buen inicio. Marca tus tareas conforme avances este mes.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 18),
          SizedBox(
            width: 92,
            height: 92,
            child: CustomPaint(
              painter: _RingProgressPainter(progress.ratio),
              child: Center(
                child: Text(
                  '${progress.percent}%',
                  style: textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanQuickSummary extends StatelessWidget {
  const _PlanQuickSummary({
    required this.debtPercent,
    required this.apartadoPercent,
    required this.savingPercent,
  });

  final int debtPercent;
  final int apartadoPercent;
  final int savingPercent;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Resumen rapido',
                  style: textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                'Actualizado hoy',
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.sync,
                color: AppColors.primary,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final items = [
                _QuickSummaryTile(
                  label: 'Pagado en deudas',
                  percent: debtPercent,
                  color: AppColors.debt,
                ),
                _QuickSummaryTile(
                  label: 'Apartados',
                  percent: apartadoPercent,
                  color: AppColors.apartado,
                ),
                _QuickSummaryTile(
                  label: 'Ahorro',
                  percent: savingPercent,
                  color: AppColors.saving,
                ),
              ];

              if (constraints.maxWidth >= 620) {
                return Row(
                  children: [
                    for (var index = 0; index < items.length; index++) ...[
                      if (index > 0) const SizedBox(width: 14),
                      Expanded(child: items[index]),
                    ],
                  ],
                );
              }

              return Column(
                children: [
                  for (var index = 0; index < items.length; index++) ...[
                    if (index > 0) const SizedBox(height: 12),
                    items[index],
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _QuickSummaryTile extends StatelessWidget {
  const _QuickSummaryTile({
    required this.label,
    required this.percent,
    required this.color,
  });

  final String label;
  final int percent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      variant: AppCardVariant.compact,
      child: Row(
        children: [
          SizedBox(
            width: 46,
            height: 46,
            child: CustomPaint(
              painter: _MiniPiePainter(color: color, percent: percent),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '$percent%',
                  style: textTheme.headlineSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FinancialTasksSection extends StatelessWidget {
  const FinancialTasksSection({
    required this.tasks,
    required this.progress,
    required this.onAddTask,
    required this.onViewAdvice,
    required this.onEditTask,
    required this.onToggleTask,
    required this.onStatusSelected,
    super.key,
  });

  final List<FinancialTask> tasks;
  final FinancialTaskProgress progress;
  final VoidCallback onAddTask;
  final VoidCallback onViewAdvice;
  final ValueChanged<FinancialTask> onEditTask;
  final void Function(FinancialTask task, bool isDone) onToggleTask;
  final void Function(FinancialTask task, FinancialTaskStatus status)
      onStatusSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      padding: EdgeInsets.zero,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isPhoneWidth = constraints.maxWidth <= 430;

          return Padding(
            padding: EdgeInsets.all(isPhoneWidth ? 12 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Tareas del mes',
                        style: textTheme.titleLarge?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    AppButton(
                      label: isPhoneWidth ? 'Consejos' : 'Ver consejos',
                      icon: Icons.lightbulb_outline,
                      onPressed: onViewAdvice,
                      variant: AppButtonVariant.secondary,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface.withAlpha(130),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      for (var index = 0; index < tasks.length; index++)
                        FinancialTaskTile(
                          task: tasks[index],
                          isLast: index == tasks.length - 1,
                          onToggle: (isDone) {
                            onToggleTask(tasks[index], isDone);
                          },
                          onEdit: () => onEditTask(tasks[index]),
                          onStatusSelected: (status) {
                            onStatusSelected(tasks[index], status);
                          },
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Align(
                  alignment: Alignment.centerLeft,
                  child: AppButton(
                    label: 'Agregar tarea',
                    icon: Icons.add,
                    onPressed: onAddTask,
                    variant: AppButtonVariant.ghost,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class FinancialTaskTile extends StatelessWidget {
  const FinancialTaskTile({
    required this.task,
    required this.onToggle,
    required this.onEdit,
    required this.onStatusSelected,
    this.isLast = false,
    super.key,
  });

  final FinancialTask task;
  final ValueChanged<bool> onToggle;
  final VoidCallback onEdit;
  final ValueChanged<FinancialTaskStatus> onStatusSelected;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isDone = task.status == FinancialTaskStatus.done;
    final typeColor = _taskTypeColor(task.type, colorScheme);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isPhoneWidth = constraints.maxWidth <= 360;
        final checkboxSize = isPhoneWidth ? 18.0 : 24.0;
        final iconSize = isPhoneWidth ? 42.0 : 48.0;
        final typeLabel = _taskTypeLabel(task.type);
        final dueLabel = task.dueDate == null
            ? 'Sin limite'
            : 'Vence ${_shortDate(task.dueDate!)}';
        final statusLabel = _taskStatusLabel(task.status);
        final statusColor = _taskStatusColor(task.status, colorScheme);

        return DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              bottom: isLast
                  ? BorderSide.none
                  : const BorderSide(color: AppColors.border),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isPhoneWidth ? 2 : 6,
              vertical: 10,
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => onToggle(!isDone),
                  child: Container(
                    width: checkboxSize,
                    height: checkboxSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDone
                            ? AppColors.primary
                            : AppColors.textSecondary.withAlpha(170),
                        width: isPhoneWidth ? 1.4 : 1.7,
                      ),
                      color: isDone
                          ? AppColors.primary.withAlpha(20)
                          : Colors.transparent,
                    ),
                    child: isDone
                        ? Icon(
                            Icons.check,
                            color: AppColors.primary,
                            size: isPhoneWidth ? 13 : 16,
                          )
                        : null,
                  ),
                ),
                SizedBox(width: isPhoneWidth ? 9 : 10),
                Container(
                  width: iconSize,
                  height: iconSize,
                  decoration: BoxDecoration(
                    color: typeColor.withAlpha(42),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    _taskTypeIcon(task.type),
                    color: typeColor,
                    size: isPhoneWidth ? 22 : 25,
                  ),
                ),
                SizedBox(width: isPhoneWidth ? 12 : 14),
                Expanded(
                  child: isPhoneWidth
                      ? _CompactTaskInfo(
                          task: task,
                          isDone: isDone,
                          textTheme: textTheme,
                          typeLabel: typeLabel,
                          dueLabel: dueLabel,
                          statusLabel: statusLabel,
                          statusColor: statusColor,
                          onStatusSelected: onStatusSelected,
                        )
                      : _RegularTaskInfo(
                          task: task,
                          isDone: isDone,
                          textTheme: textTheme,
                          typeLabel: typeLabel,
                          dueLabel: dueLabel,
                          statusLabel: statusLabel,
                          statusColor: statusColor,
                          onStatusSelected: onStatusSelected,
                        ),
                ),
                SizedBox(
                  width: isPhoneWidth ? 20 : 40,
                  child: IconButton(
                    tooltip: 'Editar tarea',
                    onPressed: onEdit,
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(
                      minWidth: isPhoneWidth ? 20 : 40,
                      minHeight: 40,
                    ),
                    icon: const Icon(Icons.chevron_right),
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget statusMenu({
    required String label,
    required Color color,
    required ValueChanged<FinancialTaskStatus> onSelected,
  }) {
    return PopupMenuButton<FinancialTaskStatus>(
      tooltip: 'Cambiar estado',
      onSelected: onSelected,
      itemBuilder: (context) {
        return FinancialTaskStatus.values.map((status) {
          return PopupMenuItem(
            value: status,
            child: Text(_taskStatusLabel(status)),
          );
        }).toList();
      },
      child: StatusPill(label: label, color: color),
    );
  }

  static String _taskTypeLabel(FinancialTaskType type) {
    return switch (type) {
      FinancialTaskType.cardPayment => 'Tarjeta',
      FinancialTaskType.apartado => 'Apartado',
      FinancialTaskType.saving => 'Colchon',
      FinancialTaskType.investment => 'CETES',
      FinancialTaskType.freeUse => 'Libre',
      FinancialTaskType.manual => 'Manual',
    };
  }

  static IconData _taskTypeIcon(FinancialTaskType type) {
    return switch (type) {
      FinancialTaskType.cardPayment => Icons.credit_card_outlined,
      FinancialTaskType.apartado => Icons.person_outline,
      FinancialTaskType.saving => Icons.shield_outlined,
      FinancialTaskType.investment => Icons.trending_up,
      FinancialTaskType.freeUse => Icons.redeem_outlined,
      FinancialTaskType.manual => Icons.task_alt_outlined,
    };
  }

  static String _taskStatusLabel(FinancialTaskStatus status) {
    return switch (status) {
      FinancialTaskStatus.pending => 'Pendiente',
      FinancialTaskStatus.done => 'Hecha',
      FinancialTaskStatus.partial => 'Parcial',
      FinancialTaskStatus.skipped => 'Omitida',
    };
  }

  static Color _taskTypeColor(
    FinancialTaskType type,
    ColorScheme colorScheme,
  ) {
    return switch (type) {
      FinancialTaskType.cardPayment => colorScheme.error,
      FinancialTaskType.apartado => Colors.blueAccent,
      FinancialTaskType.saving => colorScheme.primary,
      FinancialTaskType.investment => Colors.greenAccent,
      FinancialTaskType.freeUse => Colors.tealAccent,
      FinancialTaskType.manual => colorScheme.secondary,
    };
  }

  static Color _taskStatusColor(
    FinancialTaskStatus status,
    ColorScheme colorScheme,
  ) {
    return switch (status) {
      FinancialTaskStatus.pending => AppColors.pending,
      FinancialTaskStatus.done => colorScheme.primary,
      FinancialTaskStatus.partial => AppColors.freeUse,
      FinancialTaskStatus.skipped => colorScheme.error,
    };
  }

  static String _shortDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
  }
}

class _CompactTaskInfo extends StatelessWidget {
  const _CompactTaskInfo({
    required this.task,
    required this.isDone,
    required this.textTheme,
    required this.typeLabel,
    required this.dueLabel,
    required this.statusLabel,
    required this.statusColor,
    required this.onStatusSelected,
  });

  final FinancialTask task;
  final bool isDone;
  final TextTheme textTheme;
  final String typeLabel;
  final String dueLabel;
  final String statusLabel;
  final Color statusColor;
  final ValueChanged<FinancialTaskStatus> onStatusSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          task.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.titleSmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
            decoration: isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          '$typeLabel  •  $dueLabel',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              CurrencyFormatter.format(task.amount),
              style: textTheme.labelLarge?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
            FinancialTaskTile.statusMenu(
              label: statusLabel,
              color: statusColor,
              onSelected: onStatusSelected,
            ),
          ],
        ),
      ],
    );
  }
}

class _RegularTaskInfo extends StatelessWidget {
  const _RegularTaskInfo({
    required this.task,
    required this.isDone,
    required this.textTheme,
    required this.typeLabel,
    required this.dueLabel,
    required this.statusLabel,
    required this.statusColor,
    required this.onStatusSelected,
  });

  final FinancialTask task;
  final bool isDone;
  final TextTheme textTheme;
  final String typeLabel;
  final String dueLabel;
  final String statusLabel;
  final Color statusColor;
  final ValueChanged<FinancialTaskStatus> onStatusSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  decoration: isDone ? TextDecoration.lineThrough : null,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$typeLabel  •  $dueLabel',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              CurrencyFormatter.format(task.amount),
              style: textTheme.titleSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            FinancialTaskTile.statusMenu(
              label: statusLabel,
              color: statusColor,
              onSelected: onStatusSelected,
            ),
          ],
        ),
      ],
    );
  }
}

/*
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_taskTypeLabel(task.type)}  •  ${task.dueDate == null ? 'Sin limite' : 'Vence ${_shortDate(task.dueDate!)}'}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  CurrencyFormatter.format(task.amount),
                  style: textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                PopupMenuButton<FinancialTaskStatus>(
                  tooltip: 'Cambiar estado',
                  onSelected: onStatusSelected,
                  itemBuilder: (context) {
                    return FinancialTaskStatus.values.map((status) {
                      return PopupMenuItem(
                        value: status,
                        child: Text(_taskStatusLabel(status)),
                      );
                    }).toList();
                  },
                  child: StatusPill(
                    label: _taskStatusLabel(task.status),
                    color: _taskStatusColor(task.status, colorScheme),
                  ),
                ),
              ],
            ),
            IconButton(
              tooltip: 'Editar tarea',
              onPressed: onEdit,
              icon: const Icon(Icons.chevron_right),
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  static String _taskTypeLabel(FinancialTaskType type) {
    return switch (type) {
      FinancialTaskType.cardPayment => 'Tarjeta',
      FinancialTaskType.apartado => 'Apartado',
      FinancialTaskType.saving => 'Colchon',
      FinancialTaskType.investment => 'CETES',
      FinancialTaskType.freeUse => 'Libre',
      FinancialTaskType.manual => 'Manual',
    };
  }

  static IconData _taskTypeIcon(FinancialTaskType type) {
    return switch (type) {
      FinancialTaskType.cardPayment => Icons.credit_card_outlined,
      FinancialTaskType.apartado => Icons.person_outline,
      FinancialTaskType.saving => Icons.shield_outlined,
      FinancialTaskType.investment => Icons.trending_up,
      FinancialTaskType.freeUse => Icons.redeem_outlined,
      FinancialTaskType.manual => Icons.task_alt_outlined,
    };
  }

  static String _taskStatusLabel(FinancialTaskStatus status) {
    return switch (status) {
      FinancialTaskStatus.pending => 'Pendiente',
      FinancialTaskStatus.done => 'Hecha',
      FinancialTaskStatus.partial => 'Parcial',
      FinancialTaskStatus.skipped => 'Omitida',
    };
  }

  static Color _taskTypeColor(
    FinancialTaskType type,
    ColorScheme colorScheme,
  ) {
    return switch (type) {
      FinancialTaskType.cardPayment => colorScheme.error,
      FinancialTaskType.apartado => Colors.blueAccent,
      FinancialTaskType.saving => colorScheme.primary,
      FinancialTaskType.investment => Colors.greenAccent,
      FinancialTaskType.freeUse => Colors.tealAccent,
      FinancialTaskType.manual => colorScheme.secondary,
    };
  }

  static Color _taskStatusColor(
    FinancialTaskStatus status,
    ColorScheme colorScheme,
  ) {
    return switch (status) {
      FinancialTaskStatus.pending => AppColors.pending,
      FinancialTaskStatus.done => colorScheme.primary,
      FinancialTaskStatus.partial => AppColors.freeUse,
      FinancialTaskStatus.skipped => colorScheme.error,
    };
  }

  static String _shortDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
  }
}

*/
class _RingProgressPainter extends CustomPainter {
  const _RingProgressPainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 6;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final backgroundPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..color = AppColors.surfaceSoft;
    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..color = AppColors.primary;

    canvas.drawArc(rect, 0, math.pi * 2, false, backgroundPaint);
    canvas.drawArc(
      rect,
      -math.pi / 2,
      progress.clamp(0, 1) * math.pi * 2,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _MiniPiePainter extends CustomPainter {
  const _MiniPiePainter({
    required this.color,
    required this.percent,
  });

  final Color color;
  final int percent;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final basePaint = Paint()..color = color.withAlpha(55);
    final paint = Paint()..color = color;

    canvas.drawCircle(center, radius, basePaint);
    canvas.drawArc(
      rect,
      -math.pi / 2,
      (percent / 100).clamp(0, 1) * math.pi * 2,
      true,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _MiniPiePainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.percent != percent;
  }
}

class _PlanLinePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withAlpha(24)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var index = 0; index < 7; index++) {
      final inset = index * 18.0;
      canvas.drawArc(
        Rect.fromLTWH(inset, -40 + inset, size.width, size.height),
        math.pi * 0.15,
        math.pi * 1.15,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PlanLinePatternPainter oldDelegate) {
    return false;
  }
}

class _MoneyField extends StatelessWidget {
  const _MoneyField({
    required this.controller,
    required this.label,
  });

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        prefixText: r'$ ',
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        final number = double.tryParse(value?.trim() ?? '');
        if (number == null || number < 0) {
          return 'Ingresa un monto valido';
        }

        return null;
      },
    );
  }
}
