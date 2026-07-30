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

enum _TransactionEntryFormKind {
  expense,
  income,
  cardPayment,
}

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  static const _categoryColors = <Color>[
    Color(0xFF1B7F5C),
    Color(0xFF0288D1),
    Color(0xFFE53935),
    Color(0xFFF57C00),
    Color(0xFF7B1FA2),
    Color(0xFF00796B),
  ];

  var _filter = _TransactionFilter.all;

  Future<void> _showTransactionDialog(
    BuildContext context,
    FinanceState state, {
    TransactionEntry? transaction,
    String? preferredCardId,
    _TransactionEntryFormKind? initialKind,
  }) async {
    final titleController =
        TextEditingController(text: transaction?.title ?? '');
    final amountController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final initialAmount = transaction?.amount;
    if (initialAmount != null) {
      amountController.text = initialAmount.toStringAsFixed(2);
    }

    var selectedKind = initialKind ?? _formKindForTransaction(transaction);
    String? selectedCategory =
        transaction == null || transaction.type == TransactionType.cardPayment
            ? null
            : transaction.category;
    String? selectedCardId = transaction?.creditCardId ?? preferredCardId;
    var useCreditCardForExpense = transaction?.isCreditCardPurchase ?? false;
    DateTime selectedDate = transaction?.date ?? DateTime.now();

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final categoryOptions =
                state.categories.map((category) => category.title).toList();
            final hasCards = state.creditCards.isNotEmpty;

            if (selectedCategory != null &&
                !categoryOptions.contains(selectedCategory)) {
              selectedCategory = null;
            }
            if (selectedCardId != null &&
                state.creditCardById(selectedCardId!) == null) {
              selectedCardId = null;
            }
            if (selectedKind == _TransactionEntryFormKind.cardPayment &&
                !hasCards) {
              selectedCardId = null;
            }
            if (selectedKind != _TransactionEntryFormKind.expense) {
              useCreditCardForExpense = false;
            }

            final selectedCard = selectedCardId == null
                ? null
                : state.creditCardById(selectedCardId!);
            final cardErrorText = !hasCards
                ? 'No hay tarjetas registradas.'
                : selectedCard == null
                    ? 'Selecciona una tarjeta.'
                    : null;

            return AlertDialog(
              title: Text(
                transaction == null
                    ? 'Registrar movimiento'
                    : 'Editar movimiento',
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SegmentedButton<_TransactionEntryFormKind>(
                        selected: {selectedKind},
                        onSelectionChanged: (newSelection) {
                          setState(() {
                            selectedKind = newSelection.first;
                            if (selectedKind ==
                                _TransactionEntryFormKind.cardPayment) {
                              selectedCategory = null;
                              useCreditCardForExpense = false;
                            }
                            if (selectedKind ==
                                _TransactionEntryFormKind.income) {
                              selectedCardId = null;
                            }
                          });
                        },
                        segments: const [
                          ButtonSegment<_TransactionEntryFormKind>(
                            value: _TransactionEntryFormKind.expense,
                            label: Text('Gasto'),
                            icon: Icon(Icons.remove, size: 16),
                          ),
                          ButtonSegment<_TransactionEntryFormKind>(
                            value: _TransactionEntryFormKind.income,
                            label: Text('Ingreso'),
                            icon: Icon(Icons.add, size: 16),
                          ),
                          ButtonSegment<_TransactionEntryFormKind>(
                            value: _TransactionEntryFormKind.cardPayment,
                            label: Text('Pago a tarjeta'),
                            icon: Icon(Icons.credit_card_outlined, size: 16),
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
                      if (selectedKind == _TransactionEntryFormKind.cardPayment)
                        Column(
                          children: [
                            if (!hasCards)
                              const _InlineInfoMessage(
                                text:
                                    'No hay tarjetas registradas. Agrega una tarjeta antes de capturar un pago.',
                              )
                            else
                              DropdownButtonFormField<String>(
                                initialValue: selectedCardId,
                                decoration: const InputDecoration(
                                  labelText: 'Tarjeta a pagar',
                                ),
                                items: state.creditCards.map((card) {
                                  return DropdownMenuItem(
                                    value: card.id,
                                    child: Text(card.name),
                                  );
                                }).toList(),
                                validator: (_) => cardErrorText,
                                onChanged: (value) {
                                  setState(() => selectedCardId = value);
                                },
                              ),
                          ],
                        )
                      else if (categoryOptions.isEmpty)
                        _EmptyCategoryField(
                          onCreate: () async {
                            final category = await _showCategoryEditorDialog(
                              context,
                              state,
                            );
                            if (category != null) {
                              setState(() => selectedCategory = category.title);
                            }
                          },
                        )
                      else ...[
                        DropdownButtonFormField<String>(
                          key: ValueKey(selectedCategory),
                          initialValue: selectedCategory,
                          decoration: const InputDecoration(
                            labelText: 'Seccion / categoria',
                          ),
                          hint: const Text('Selecciona una categoria'),
                          items: categoryOptions.map((category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                          validator: (value) =>
                              value == null ? 'Selecciona una categoria' : null,
                          onChanged: (value) {
                            setState(() => selectedCategory = value);
                          },
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        if (selectedKind == _TransactionEntryFormKind.expense)
                          Column(
                            children: [
                              SwitchListTile(
                                contentPadding: EdgeInsets.zero,
                                value: useCreditCardForExpense,
                                title:
                                    const Text('Compra con tarjeta de credito'),
                                subtitle: const Text(
                                  'Si la activas, el saldo utilizado de la tarjeta se actualiza automaticamente.',
                                ),
                                onChanged: hasCards
                                    ? (value) {
                                        setState(() {
                                          useCreditCardForExpense = value;
                                          if (!value) {
                                            selectedCardId = null;
                                          } else {
                                            selectedCardId ??=
                                                state.creditCards.first.id;
                                          }
                                        });
                                      }
                                    : null,
                              ),
                              if (!hasCards)
                                const _InlineInfoMessage(
                                  text:
                                      'No hay tarjetas registradas. Este gasto se guardara sin tarjeta hasta que agregues una.',
                                ),
                              if (useCreditCardForExpense && hasCards) ...[
                                const SizedBox(height: AppSpacing.sm),
                                DropdownButtonFormField<String>(
                                  initialValue: selectedCardId,
                                  decoration: const InputDecoration(
                                    labelText: 'Tarjeta asociada',
                                  ),
                                  items: state.creditCards.map((card) {
                                    return DropdownMenuItem(
                                      value: card.id,
                                      child: Text(card.name),
                                    );
                                  }).toList(),
                                  validator: (_) => selectedCardId == null
                                      ? 'Selecciona una tarjeta.'
                                      : null,
                                  onChanged: (value) {
                                    setState(() => selectedCardId = value);
                                  },
                                ),
                              ],
                            ],
                          ),
                        if (selectedKind != _TransactionEntryFormKind.expense)
                          const SizedBox(height: AppSpacing.xs),
                        Row(
                          children: [
                            TextButton.icon(
                              onPressed: () async {
                                final category =
                                    await _showCategoryEditorDialog(
                                  context,
                                  state,
                                );
                                if (category != null) {
                                  setState(
                                    () => selectedCategory = category.title,
                                  );
                                }
                              },
                              icon: const Icon(Icons.add, size: 18),
                              label: const Text('Nueva categoria'),
                            ),
                            const Spacer(),
                            TextButton.icon(
                              onPressed: () async {
                                await _showCategoryManagerDialog(
                                  context,
                                  state,
                                );
                                setState(() {});
                              },
                              icon:
                                  const Icon(Icons.settings_outlined, size: 18),
                              label: const Text('Administrar'),
                            ),
                          ],
                        ),
                      ],
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
                  onPressed: categoryOptions.isEmpty &&
                          selectedKind != _TransactionEntryFormKind.cardPayment
                      ? null
                      : () {
                          if (!(formKey.currentState?.validate() ?? false)) {
                            return;
                          }

                          final amount = double.parse(amountController.text);
                          final title = titleController.text.trim();
                          final categoryTitle = selectedKind ==
                                  _TransactionEntryFormKind.cardPayment
                              ? FinanceState.cardPaymentCategoryTitle
                              : selectedCategory!;
                          final type = switch (selectedKind) {
                            _TransactionEntryFormKind.expense =>
                              TransactionType.expense,
                            _TransactionEntryFormKind.income =>
                              TransactionType.income,
                            _TransactionEntryFormKind.cardPayment =>
                              TransactionType.cardPayment,
                          };
                          final cardTransactionKind = switch (selectedKind) {
                            _TransactionEntryFormKind.expense =>
                              useCreditCardForExpense
                                  ? CardTransactionKind.purchase
                                  : null,
                            _TransactionEntryFormKind.income => null,
                            _TransactionEntryFormKind.cardPayment =>
                              CardTransactionKind.payment,
                          };
                          final creditCardId = selectedKind ==
                                  _TransactionEntryFormKind.cardPayment
                              ? selectedCardId
                              : useCreditCardForExpense
                                  ? selectedCardId
                                  : null;

                          final ok = transaction == null
                              ? state.addTransaction(
                                    title: title,
                                    amount: amount,
                                    categoryTitle: categoryTitle,
                                    type: type,
                                    date: selectedDate,
                                    creditCardId: creditCardId,
                                    cardTransactionKind: cardTransactionKind,
                                  ) !=
                                  null
                              : state.updateTransaction(
                                  transaction.id,
                                  title: title,
                                  amount: amount,
                                  categoryTitle: categoryTitle,
                                  type: type,
                                  date: selectedDate,
                                  creditCardId: creditCardId,
                                  cardTransactionKind: cardTransactionKind,
                                );

                          if (!ok) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'No se pudo guardar el movimiento. Verifica la tarjeta, el monto y la relacion seleccionada.',
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            return;
                          }
                          Navigator.of(context).pop();
                        },
                  child: Text(transaction == null ? 'Registrar' : 'Guardar'),
                ),
              ],
            );
          },
        );
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      titleController.dispose();
      amountController.dispose();
    });
  }

  _TransactionEntryFormKind _formKindForTransaction(
    TransactionEntry? transaction,
  ) {
    if (transaction == null) {
      return _TransactionEntryFormKind.expense;
    }
    return switch (transaction.type) {
      TransactionType.income => _TransactionEntryFormKind.income,
      TransactionType.expense => _TransactionEntryFormKind.expense,
      TransactionType.cardPayment => _TransactionEntryFormKind.cardPayment,
    };
  }

  Future<BudgetCategory?> _showCategoryEditorDialog(
    BuildContext context,
    FinanceState state, {
    BudgetCategory? category,
  }) async {
    final titleController = TextEditingController(text: category?.title ?? '');
    final limitController = TextEditingController(
      text: category == null || category.limit == 0
          ? ''
          : category.limit.toStringAsFixed(0),
    );
    final formKey = GlobalKey<FormState>();
    var selectedColor = category?.color ?? _categoryColors.first;

    final result = await showDialog<BudgetCategory>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                category == null ? 'Nueva categoria' : 'Editar categoria',
              ),
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
                          labelText: 'Nombre de la categoria',
                          hintText: 'Ej. Comida, Transporte, Nomina',
                        ),
                        validator: (value) {
                          final title = value?.trim() ?? '';
                          if (title.isEmpty) {
                            return 'Ingresa un nombre';
                          }
                          final duplicate = state.categories.any((item) {
                            return item.id != category?.id &&
                                item.title.toLowerCase() == title.toLowerCase();
                          });
                          return duplicate ? 'Esta categoria ya existe' : null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      TextFormField(
                        controller: limitController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Presupuesto mensual (opcional)',
                          prefixText: r'$ ',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return null;
                          }
                          final number = double.tryParse(value);
                          return number == null || number < 0
                              ? 'Ingresa cero o un numero positivo'
                              : null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'Color',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Wrap(
                        spacing: AppSpacing.sm,
                        children: _categoryColors.map((color) {
                          return InkWell(
                            onTap: () =>
                                setDialogState(() => selectedColor = color),
                            customBorder: const CircleBorder(),
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: selectedColor == color
                                    ? Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        width: 3,
                                      )
                                    : null,
                              ),
                              child: selectedColor == color
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
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () {
                    if (!(formKey.currentState?.validate() ?? false)) {
                      return;
                    }
                    final title = titleController.text.trim();
                    final limit = double.tryParse(limitController.text) ?? 0;
                    if (category == null) {
                      state.addCategory(title, limit, selectedColor);
                    } else {
                      state.updateCategory(
                        category.id,
                        title: title,
                        limit: limit,
                        color: selectedColor,
                      );
                    }
                    final saved = state.categories.firstWhere(
                      (item) => item.id == category?.id,
                      orElse: () => state.categories.last,
                    );
                    Navigator.of(dialogContext).pop(saved);
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      titleController.dispose();
      limitController.dispose();
    });
    return result;
  }

  Future<void> _showCategoryManagerDialog(
    BuildContext context,
    FinanceState state,
  ) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Administrar categorias'),
              content: SizedBox(
                width: 420,
                child: state.categories.isEmpty
                    ? const Text('Aun no hay categorias.')
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.categories.length,
                        itemBuilder: (context, index) {
                          final category = state.categories[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading:
                                CircleAvatar(backgroundColor: category.color),
                            title: Text(category.title),
                            subtitle: Text(
                              category.limit > 0
                                  ? 'Presupuesto: ${CurrencyFormatter.format(category.limit)}'
                                  : 'Sin presupuesto definido',
                            ),
                            trailing: category.isProtected
                                ? const Tooltip(
                                    message:
                                        'Esta categoria no se puede modificar ni eliminar',
                                    child: Icon(Icons.lock_outline),
                                  )
                                : PopupMenuButton<String>(
                                    onSelected: (action) async {
                                      if (action == 'edit') {
                                        await _showCategoryEditorDialog(
                                          context,
                                          state,
                                          category: category,
                                        );
                                      } else {
                                        final confirmed =
                                            await showDialog<bool>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text(
                                              'Eliminar categoria',
                                            ),
                                            content: Text(
                                              'Se eliminara "${category.title}". '
                                              'Los movimientos existentes conservaran '
                                              'su nombre en el historial.',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(false),
                                                child: const Text('Cancelar'),
                                              ),
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(true),
                                                child: const Text('Eliminar'),
                                              ),
                                            ],
                                          ),
                                        );
                                        if (confirmed == true) {
                                          state.deleteCategory(category.id);
                                        }
                                      }
                                      setDialogState(() {});
                                    },
                                    itemBuilder: (context) => const [
                                      PopupMenuItem(
                                        value: 'edit',
                                        child: Text('Editar'),
                                      ),
                                      PopupMenuItem(
                                        value: 'delete',
                                        child: Text('Eliminar'),
                                      ),
                                    ],
                                  ),
                          );
                        },
                      ),
              ),
              actions: [
                TextButton.icon(
                  onPressed: () async {
                    await _showCategoryEditorDialog(context, state);
                    setDialogState(() {});
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Nueva'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Listo'),
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
    final monthIncome = state.transactionsForSelectedPeriod
        .where((transaction) => transaction.type == TransactionType.income)
        .fold<double>(0, (sum, transaction) => sum + transaction.amount);

    return AppScreen(
      children: [
        AppHeader(
          title: 'Movimientos',
          subtitle: 'Historial claro de gastos, ingresos y apartados.',
          action: IconButton.filled(
            tooltip: 'Nuevo movimiento',
            onPressed: () => _showTransactionDialog(context, state),
            icon: const Icon(Icons.add),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _TransactionsSummary(
          spent: state.totalExpenses,
          income: monthIncome,
          count: state.transactionsForSelectedPeriod.length,
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
              onEdit: () => _showTransactionDialog(
                context,
                state,
                transaction: transaction,
              ),
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
    return state.transactionsForSelectedPeriod.where((transaction) {
      final category = transaction.category.toLowerCase();

      return switch (_filter) {
        _TransactionFilter.all => true,
        _TransactionFilter.expenses => _isExpenseTransaction(transaction),
        _TransactionFilter.income => transaction.type == TransactionType.income,
        _TransactionFilter.cards => transaction.isCreditCardTransaction,
        _TransactionFilter.apartados =>
          category.contains('apartado') || category.contains('extra'),
      };
    }).toList(growable: false);
  }

  bool _isExpenseTransaction(TransactionEntry transaction) {
    return transaction.type == TransactionType.expense;
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
          content: Text(_deleteWarningText(transaction)),
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

  String _deleteWarningText(TransactionEntry transaction) {
    if (transaction.isCreditCardPurchase) {
      return 'Seguro que deseas eliminar "${transaction.title}"? '
          'Tambien se descontara este importe del saldo utilizado de la tarjeta.';
    }
    if (transaction.isCreditCardPayment) {
      return 'Seguro que deseas eliminar "${transaction.title}"? '
          'Tambien se restaurara este importe en el saldo utilizado de la tarjeta.';
    }
    return 'Seguro que deseas eliminar "${transaction.title}"?';
  }
}

class _EmptyCategoryField extends StatelessWidget {
  const _EmptyCategoryField({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Aun no hay categorias',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: AppSpacing.xs),
          const Text('Crea la primera para registrar este movimiento.'),
          const SizedBox(height: AppSpacing.sm),
          FilledButton.tonalIcon(
            onPressed: onCreate,
            icon: const Icon(Icons.add),
            label: const Text('Crear categoria'),
          ),
        ],
      ),
    );
  }
}

class _InlineInfoMessage extends StatelessWidget {
  const _InlineInfoMessage({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
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
            title: 'Gastos',
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
    required this.onEdit,
    required this.onDelete,
    this.category,
  });

  final TransactionEntry transaction;
  final BudgetCategory? category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    final isCardPayment = transaction.type == TransactionType.cardPayment;
    final color = isIncome
        ? AppColors.primary
        : isCardPayment
            ? AppColors.primary
            : category?.color ?? AppColors.debt;
    final statusLabel = switch (transaction.type) {
      TransactionType.expense =>
        transaction.isCreditCardPurchase ? 'Compra con tarjeta' : 'Gasto',
      TransactionType.income => 'Ingreso',
      TransactionType.cardPayment => 'Pago tarjeta',
    };
    final icon = switch (transaction.type) {
      TransactionType.expense => Icons.arrow_outward_outlined,
      TransactionType.income => Icons.call_received_outlined,
      TransactionType.cardPayment => Icons.payments_outlined,
    };
    final amountPrefix = isIncome ? '+' : '-';

    return FinancialListItem(
      icon: icon,
      iconColor: color,
      title: transaction.title,
      subtitle:
          '${transaction.category} - ${transaction.date.day}/${transaction.date.month}/${transaction.date.year} - MXN',
      amount: '$amountPrefix${CurrencyFormatter.format(transaction.amount)}',
      amountColor: isIncome ? AppColors.primary : AppColors.debt,
      status: StatusPill(
        label: statusLabel,
        color: color,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: 'Editar',
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined, size: 18),
            color: AppColors.textSecondary,
          ),
          IconButton(
            tooltip: 'Eliminar',
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline, size: 18),
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
