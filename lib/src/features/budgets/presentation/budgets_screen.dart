import 'package:flutter/material.dart';

import '../../../core/state/finance_state.dart';
import '../../../core/state/finance_state_provider.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../shared/presentation/app_design.dart';
import '../domain/budget_category.dart';
import '../domain/monthly_extra.dart';

class BudgetsScreen extends StatelessWidget {
  const BudgetsScreen({super.key});

  static const List<Map<String, dynamic>> _curatedColors = [
    {'name': 'Verde', 'color': Color(0xFF1B7F5C)},
    {'name': 'Azul', 'color': Color(0xFF0288D1)},
    {'name': 'Rojo', 'color': Color(0xFFE53935)},
    {'name': 'Naranja', 'color': Color(0xFFF57C00)},
    {'name': 'Amatista', 'color': Color(0xFF7B1FA2)},
    {'name': 'Menta', 'color': Color(0xFF00796B)},
  ];

  void _showAddCategoryDialog(BuildContext context, FinanceState state) {
    final titleController = TextEditingController();
    final limitController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    Color selectedColor = _curatedColors.first['color'] as Color;

    showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Nueva seccion de presupuesto'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: titleController,
                        autofocus: true,
                        decoration: const InputDecoration(
                          labelText: 'Nombre de la seccion',
                          hintText: 'Ej. Psicologa, Limpieza, Comida',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Ingresa un nombre';
                          }

                          final exists = state.categories.any((category) {
                            return category.title.toLowerCase() ==
                                value.trim().toLowerCase();
                          });

                          if (exists) {
                            return 'Esta seccion ya existe';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: limitController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Limite de dinero / presupuesto',
                          prefixText: r'$ ',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Ingresa un limite';
                          }

                          final number = double.tryParse(value);
                          if (number == null || number <= 0) {
                            return 'Ingresa un numero positivo valido';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Color visual',
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _curatedColors.map((colorMap) {
                          final color = colorMap['color'] as Color;
                          final isSelected = selectedColor == color;

                          return GestureDetector(
                            onTap: () {
                              setState(() => selectedColor = color);
                            },
                            child: AnimatedContainer(
                              width: 38,
                              height: 38,
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: isSelected
                                    ? Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        width: 3,
                                      )
                                    : null,
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 18,
                                    )
                                  : null,
                            ),
                          );
                        }).toList(),
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
                      state.addCategory(
                        titleController.text.trim(),
                        double.parse(limitController.text),
                        selectedColor,
                      );
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Seccion "${titleController.text}" agregada',
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  child: const Text('Agregar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditCategoryDialog(
    BuildContext context,
    FinanceState state,
    BudgetCategory category,
  ) {
    final limitController = TextEditingController(
      text: category.limit.toStringAsFixed(0),
    );
    final formKey = GlobalKey<FormState>();

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar limite: ${category.title}'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: limitController,
              autofocus: true,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Nuevo limite de dinero',
                prefixText: r'$ ',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Ingresa un limite';
                }

                final number = double.tryParse(value);
                if (number == null || number <= 0) {
                  return 'Ingresa un numero positivo valido';
                }

                return null;
              },
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
                  state.updateCategory(
                    category.id,
                    limit: double.parse(limitController.text),
                  );
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Seccion "${category.title}" actualizada'),
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
  }

  void _showMonthlyExtraDialog(
    BuildContext context,
    FinanceState state, {
    MonthlyExtra? extra,
  }) {
    final nameController = TextEditingController(text: extra?.name ?? '');
    final amountController = TextEditingController(
      text: extra?.amount.toStringAsFixed(2) ?? '',
    );
    final personController = TextEditingController(text: extra?.person ?? '');
    final notesController = TextEditingController(text: extra?.notes ?? '');
    final formKey = GlobalKey<FormState>();
    var selectedStatus = extra?.status ?? MonthlyExtraStatus.reserved;
    var includedInPlan = extra?.includedInPlan ?? true;

    showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                extra == null ? 'Nuevo extra / apartado' : 'Editar extra',
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameController,
                        autofocus: true,
                        decoration: const InputDecoration(
                          labelText: 'Nombre',
                          hintText: 'Ej. Ahorro, regalo, mantenimiento',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Ingresa un nombre';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Monto',
                          prefixText: r'$ ',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          final number = double.tryParse(value?.trim() ?? '');
                          if (number == null || number <= 0) {
                            return 'Ingresa un monto valido';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<MonthlyExtraStatus>(
                        value: selectedStatus,
                        decoration: const InputDecoration(
                          labelText: 'Estado',
                          border: OutlineInputBorder(),
                        ),
                        items: MonthlyExtraStatus.values.map((status) {
                          return DropdownMenuItem(
                            value: status,
                            child: Text(_extraStatusLabel(status)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setDialogState(() => selectedStatus = value);
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: personController,
                        decoration: const InputDecoration(
                          labelText: 'Persona opcional',
                          hintText: 'Ej. Familiar o proveedor',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: notesController,
                        minLines: 1,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Notas opcionales',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Incluir en planeado'),
                        value: includedInPlan,
                        onChanged: (value) {
                          setDialogState(() => includedInPlan = value);
                        },
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

                      if (extra == null) {
                        state.addMonthlyExtra(
                          name: nameController.text.trim(),
                          amount: amount,
                          status: selectedStatus,
                          includedInPlan: includedInPlan,
                          person: personController.text,
                          notes: notesController.text,
                        );
                      } else {
                        state.updateMonthlyExtra(
                          extra.id,
                          name: nameController.text.trim(),
                          amount: amount,
                          status: selectedStatus,
                          includedInPlan: includedInPlan,
                          person: personController.text,
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

  @override
  Widget build(BuildContext context) {
    final state = FinanceStateProvider.of(context);

    return AppScreen(
      children: [
        AppHeader(
          title: 'Presupuesto',
          subtitle: 'Divide tu nomina en secciones claras y apartados del mes.',
          action: IconButton.filled(
            tooltip: 'Nueva seccion',
            onPressed: () => _showAddCategoryDialog(context, state),
            icon: const Icon(Icons.add),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _BudgetSummaryCard(
          total: state.totalAllocated,
          spent: state.totalSpent,
          available: state.totalAllocated - state.totalSpent,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppSectionHeader(
          title: 'Categorias',
          subtitle: 'Limite, gastado y disponible por seccion.',
          action: AppButton(
            label: 'Nueva',
            icon: Icons.add,
            onPressed: () => _showAddCategoryDialog(context, state),
            variant: AppButtonVariant.secondary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (state.categories.isEmpty)
          const _EmptyBudgetList()
        else
          ...state.categories.map((category) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _BudgetProgressCard(
                category: category,
                onEdit: () {
                  _showEditCategoryDialog(context, state, category);
                },
                onDelete: () {
                  _showDeleteCategoryDialog(context, state, category);
                },
              ),
            );
          }),
        const SizedBox(height: AppSpacing.sm),
        _MonthlyExtrasSection(
          extras: state.monthlyExtras,
          total: state.totalMonthlyExtras,
          onAdd: () => _showMonthlyExtraDialog(context, state),
          onEdit: (extra) => _showMonthlyExtraDialog(
            context,
            state,
            extra: extra,
          ),
          onDelete: state.deleteMonthlyExtra,
          onMarkDelivered: state.markMonthlyExtraDelivered,
        ),
      ],
    );
  }

  void _showDeleteCategoryDialog(
    BuildContext context,
    FinanceState state,
    BudgetCategory category,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar seccion'),
          content: Text(
            'Seguro que deseas eliminar la seccion "${category.title}"? '
            'Los movimientos no se borraran, pero se desvincularan del presupuesto.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                state.deleteCategory(category.id);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Seccion "${category.title}" eliminada'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Text(
                'Eliminar',
                style: TextStyle(color: colorScheme.error),
              ),
            ),
          ],
        );
      },
    );
  }

  static String _extraStatusLabel(MonthlyExtraStatus status) {
    return switch (status) {
      MonthlyExtraStatus.reserved => 'Apartado',
      MonthlyExtraStatus.toDeliver => 'Por entregar',
      MonthlyExtraStatus.delivered => 'Entregado',
      MonthlyExtraStatus.paid => 'Pagado',
    };
  }
}

class _EmptyBudgetList extends StatelessWidget {
  const _EmptyBudgetList();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
        child: Column(
          children: [
            const AppIconBubble(
              icon: Icons.pie_chart_outline_rounded,
              size: 56,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'No tienes secciones de gastos creadas',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Presiona "Nueva seccion" para distribuir tu nomina.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BudgetSummaryCard extends StatelessWidget {
  const _BudgetSummaryCard({
    required this.total,
    required this.spent,
    required this.available,
  });

  final double total;
  final double spent;
  final double available;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 640;
        final cards = [
          StatCard(
            title: 'Total presupuestado',
            value: CurrencyFormatter.format(total),
            icon: Icons.pie_chart_outline,
            color: AppColors.apartado,
          ),
          StatCard(
            title: 'Gastado',
            value: CurrencyFormatter.format(spent),
            icon: Icons.trending_down,
            color: AppColors.debt,
          ),
          StatCard(
            title: 'Disponible',
            value: CurrencyFormatter.format(available),
            icon: Icons.account_balance_wallet_outlined,
            color: available < 0 ? AppColors.danger : AppColors.primary,
          ),
        ];

        if (!isWide) {
          const gap = AppSpacing.md;
          final itemWidth = (constraints.maxWidth - gap) / 2;

          return Column(
            children: [
              Row(
                children: [
                  SizedBox(width: itemWidth, child: cards[0]),
                  const SizedBox(width: gap),
                  SizedBox(width: itemWidth, child: cards[1]),
                ],
              ),
              const SizedBox(height: gap),
              SizedBox(width: double.infinity, child: cards[2]),
            ],
          );
        }

        return Row(
          children: [
            for (var index = 0; index < cards.length; index++) ...[
              if (index > 0) const SizedBox(width: AppSpacing.md),
              Expanded(child: cards[index]),
            ],
          ],
        );
      },
    );
  }
}

class _BudgetProgressCard extends StatelessWidget {
  const _BudgetProgressCard({
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  final BudgetCategory category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final progress = category.limit > 0
        ? (category.spent / category.limit).clamp(0.0, 1.0)
        : 0.0;
    final isExceeded = category.spent > category.limit;
    final displayPercent = category.limit > 0
        ? ((category.spent / category.limit) * 100).round()
        : 0;

    return AppCard(
      child: Padding(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      AppIconBubble(
                        icon: Icons.folder_outlined,
                        color: category.color,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          category.title,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, size: 20),
                  padding: EdgeInsets.zero,
                  onSelected: (value) {
                    if (value == 'edit') {
                      onEdit();
                    }
                    if (value == 'delete') {
                      onDelete();
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 18),
                          SizedBox(width: 8),
                          Text('Editar limite'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline,
                            color: colorScheme.error,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Eliminar seccion',
                            style: TextStyle(color: colorScheme.error),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${CurrencyFormatter.format(category.spent)} gastado',
                  style: textTheme.bodyMedium?.copyWith(
                    color:
                        isExceeded ? colorScheme.error : colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Limite: ${CurrencyFormatter.format(category.limit)}',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadii.pill),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 12,
                color: isExceeded ? AppColors.danger : category.color,
                backgroundColor: AppColors.surfaceSoft,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    isExceeded
                        ? 'Limite excedido por ${CurrencyFormatter.format(category.spent - category.limit)}'
                        : 'Disponible: ${CurrencyFormatter.format(category.limit - category.spent)}',
                    style: textTheme.bodySmall?.copyWith(
                      color: isExceeded
                          ? colorScheme.error
                          : colorScheme.onSurfaceVariant,
                      fontWeight:
                          isExceeded ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                Text(
                  '$displayPercent%',
                  style: textTheme.labelSmall?.copyWith(
                    color:
                        isExceeded ? colorScheme.error : colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthlyExtrasSection extends StatelessWidget {
  const _MonthlyExtrasSection({
    required this.extras,
    required this.total,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
    required this.onMarkDelivered,
  });

  final List<MonthlyExtra> extras;
  final double total;
  final VoidCallback onAdd;
  final ValueChanged<MonthlyExtra> onEdit;
  final ValueChanged<String> onDelete;
  final ValueChanged<String> onMarkDelivered;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return AppCard(
      child: Padding(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const AppIconBubble(
                  icon: Icons.savings_outlined,
                  color: AppColors.apartado,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Extras / Apartados del mes',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Total: ${CurrencyFormatter.format(total)}',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton.filledTonal(
                  tooltip: 'Agregar extra',
                  onPressed: onAdd,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (extras.isEmpty)
              Text(
                'Sin extras registrados este mes.',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              )
            else
              ...extras.map((extra) {
                return _MonthlyExtraTile(
                  extra: extra,
                  onEdit: () => onEdit(extra),
                  onDelete: () => onDelete(extra.id),
                  onMarkDelivered: () => onMarkDelivered(extra.id),
                );
              }),
          ],
        ),
      ),
    );
  }
}

class _MonthlyExtraTile extends StatelessWidget {
  const _MonthlyExtraTile({
    required this.extra,
    required this.onEdit,
    required this.onDelete,
    required this.onMarkDelivered,
  });

  final MonthlyExtra extra;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onMarkDelivered;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final subtitleParts = [
      _extraStatusLabel(extra.status),
      if (extra.person != null) 'Para ${extra.person}',
      if (!extra.includedInPlan) 'Fuera del planeado',
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: FinancialListItem(
        icon: extra.status == MonthlyExtraStatus.delivered ||
                extra.status == MonthlyExtraStatus.paid
            ? Icons.check_circle_outline
            : Icons.inventory_2_outlined,
        iconColor: AppColors.apartado,
        title: extra.name,
        subtitle: subtitleParts.join(' - '),
        amount: CurrencyFormatter.format(extra.amount),
        status: StatusPill(
          label: _extraStatusLabel(extra.status),
          color: extra.status == MonthlyExtraStatus.delivered ||
                  extra.status == MonthlyExtraStatus.paid
              ? AppColors.primary
              : AppColors.pending,
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, size: 20),
          onSelected: (value) {
            if (value == 'delivered') {
              onMarkDelivered();
            }
            if (value == 'edit') {
              onEdit();
            }
            if (value == 'delete') {
              onDelete();
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'delivered',
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline, size: 18),
                  SizedBox(width: 8),
                  Text('Marcar entregado'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit_outlined, size: 18),
                  SizedBox(width: 8),
                  Text('Editar'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(
                    Icons.delete_outline,
                    color: colorScheme.error,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Eliminar',
                    style: TextStyle(color: colorScheme.error),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _extraStatusLabel(MonthlyExtraStatus status) {
    return switch (status) {
      MonthlyExtraStatus.reserved => 'Apartado',
      MonthlyExtraStatus.toDeliver => 'Por entregar',
      MonthlyExtraStatus.delivered => 'Entregado',
      MonthlyExtraStatus.paid => 'Pagado',
    };
  }
}
