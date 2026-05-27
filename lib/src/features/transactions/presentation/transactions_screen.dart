import 'package:flutter/material.dart';

import '../../../core/state/finance_state.dart';
import '../../../core/state/finance_state_provider.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../shared/presentation/app_design.dart';
import '../../budgets/domain/budget_category.dart';
import '../domain/transaction_entry.dart';

enum _TransactionFilter {
  all,
  expenses,
  income,
  cards,
  apartados,
}

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  var _filter = _TransactionFilter.all;

  void _showAddTransactionDialog(BuildContext context, FinanceState state) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    TransactionType selectedType = TransactionType.expense;
    String? selectedCategory;
    DateTime selectedDate = DateTime.now();

    showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final availableCategories = selectedType == TransactionType.income
                ? ['Nomina', 'Rendimientos', 'Otros ingresos']
                : state.categories.map((category) => category.title).toList();
            final categoryOptions =
                availableCategories.isEmpty ? ['General'] : availableCategories;

            if (selectedCategory == null ||
                !categoryOptions.contains(selectedCategory)) {
              selectedCategory = categoryOptions.first;
            }

            return AlertDialog(
              title: const Text('Registrar movimiento'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SegmentedButton<TransactionType>(
                        selected: {selectedType},
                        onSelectionChanged: (newSelection) {
                          setState(() {
                            selectedType = newSelection.first;
                            selectedCategory = null;
                          });
                        },
                        segments: const [
                          ButtonSegment<TransactionType>(
                            value: TransactionType.expense,
                            label: Text('Gasto'),
                            icon: Icon(Icons.remove, size: 16),
                          ),
                          ButtonSegment<TransactionType>(
                            value: TransactionType.income,
                            label: Text('Ingreso'),
                            icon: Icon(Icons.add, size: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      TextFormField(
                        controller: titleController,
                        autofocus: true,
                        decoration: const InputDecoration(
                          labelText: 'Concepto / titulo',
                          hintText: 'Ej. Compra super, consulta, cena',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Ingresa un concepto';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      TextFormField(
                        controller: amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Monto de dinero',
                          prefixText: r'$ ',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Ingresa un monto';
                          }

                          final number = double.tryParse(value);
                          if (number == null || number <= 0) {
                            return 'Ingresa un numero positivo valido';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      DropdownButtonFormField<String>(
                        value: selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'Seccion / categoria',
                        ),
                        items: categoryOptions.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => selectedCategory = value);
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      FinancialListItem(
                        icon: Icons.calendar_today_outlined,
                        title: 'Fecha del movimiento',
                        subtitle:
                            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                        amount: 'Cambiar',
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2025),
                            lastDate: DateTime(2030),
                          );

                          if (picked != null) {
                            setState(() => selectedDate = picked);
                          }
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
                      state.addTransaction(
                        title: titleController.text.trim(),
                        amount: double.parse(amountController.text),
                        categoryTitle: selectedCategory ?? 'General',
                        type: selectedType,
                        date: selectedDate,
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Registrar'),
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
    final transactions = _filteredTransactions(state);
    final monthIncome = state.transactions
        .where((transaction) => transaction.type == TransactionType.income)
        .fold<double>(0, (sum, transaction) => sum + transaction.amount);

    return AppScreen(
      children: [
        AppHeader(
          title: 'Movimientos',
          subtitle: 'Historial claro de gastos, ingresos y apartados.',
          action: IconButton.filled(
            tooltip: 'Nuevo movimiento',
            onPressed: () => _showAddTransactionDialog(context, state),
            icon: const Icon(Icons.add),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _TransactionsSummary(
          spent: state.totalSpent,
          income: monthIncome,
          count: state.transactions.length,
        ),
        const SizedBox(height: AppSpacing.lg),
        _FilterPills(
          selected: _filter,
          onSelected: (filter) => setState(() => _filter = filter),
        ),
        const SizedBox(height: AppSpacing.lg),
        ...transactions.map(
          (transaction) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: _TransactionTile(
              transaction: transaction,
              category: _categoryFor(state, transaction),
              onDelete: () => _confirmDelete(context, state, transaction),
            ),
          ),
        ),
        if (transactions.isEmpty)
          const AppCard(
            child: Text('No hay movimientos para este filtro.'),
          ),
      ],
    );
  }

  List<TransactionEntry> _filteredTransactions(FinanceState state) {
    return state.transactions.where((transaction) {
      final category = transaction.category.toLowerCase();

      return switch (_filter) {
        _TransactionFilter.all => true,
        _TransactionFilter.expenses =>
          transaction.type == TransactionType.expense,
        _TransactionFilter.income => transaction.type == TransactionType.income,
        _TransactionFilter.cards => category.contains('tarjeta'),
        _TransactionFilter.apartados =>
          category.contains('apartado') || category.contains('extra'),
      };
    }).toList(growable: false);
  }

  BudgetCategory? _categoryFor(
    FinanceState state,
    TransactionEntry transaction,
  ) {
    for (final category in state.categories) {
      if (category.title.toLowerCase() == transaction.category.toLowerCase()) {
        return category;
      }
    }

    return null;
  }

  void _confirmDelete(
    BuildContext context,
    FinanceState state,
    TransactionEntry transaction,
  ) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar movimiento'),
          content: Text(
            'Seguro que deseas eliminar "${transaction.title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                state.deleteTransaction(transaction.id);
                Navigator.of(context).pop();
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}

class _TransactionsSummary extends StatelessWidget {
  const _TransactionsSummary({
    required this.spent,
    required this.income,
    required this.count,
  });

  final double spent;
  final double income;
  final int count;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cards = [
          StatCard(
            title: 'Gastado',
            value: CurrencyFormatter.format(spent),
            icon: Icons.trending_down,
            color: AppColors.debt,
          ),
          StatCard(
            title: 'Ingresos extra',
            value: CurrencyFormatter.format(income),
            icon: Icons.trending_up,
            subtitle: '$count movimientos',
            color: AppColors.primary,
          ),
        ];

        return Row(
          children: [
            Expanded(child: cards.first),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: cards.last),
          ],
        );
      },
    );
  }
}

class _FilterPills extends StatelessWidget {
  const _FilterPills({
    required this.selected,
    required this.onSelected,
  });

  final _TransactionFilter selected;
  final ValueChanged<_TransactionFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    final filters = {
      _TransactionFilter.all: 'Todos',
      _TransactionFilter.expenses: 'Gastos',
      _TransactionFilter.income: 'Ingresos',
      _TransactionFilter.cards: 'Tarjetas',
      _TransactionFilter.apartados: 'Apartados',
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.entries.map((entry) {
          final isSelected = selected == entry.key;

          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: ChoiceChip(
              label: Text(entry.value),
              selected: isSelected,
              onSelected: (_) => onSelected(entry.key),
              selectedColor: AppColors.primary.withAlpha(34),
              backgroundColor: AppColors.surface,
              side: const BorderSide(color: AppColors.border),
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: FontWeight.w800,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({
    required this.transaction,
    required this.onDelete,
    this.category,
  });

  final TransactionEntry transaction;
  final BudgetCategory? category;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isExpense = transaction.type == TransactionType.expense;
    final color = isExpense
        ? category?.color ?? AppColors.debt
        : AppColors.primary;

    return FinancialListItem(
      icon: isExpense
          ? Icons.arrow_outward_outlined
          : Icons.call_received_outlined,
      iconColor: color,
      title: transaction.title,
      subtitle:
          '${transaction.category} - ${transaction.date.day}/${transaction.date.month}/${transaction.date.year} - MXN',
      amount:
          '${isExpense ? '-' : '+'}${CurrencyFormatter.format(transaction.amount)}',
      amountColor: isExpense ? AppColors.debt : AppColors.primary,
      status: StatusPill(
        label: isExpense ? 'Gasto' : 'Ingreso',
        color: color,
      ),
      trailing: IconButton(
        tooltip: 'Eliminar',
        onPressed: onDelete,
        icon: const Icon(Icons.delete_outline, size: 18),
        color: AppColors.textSecondary,
      ),
    );
  }
}
