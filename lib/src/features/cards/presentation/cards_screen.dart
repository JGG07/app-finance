import 'package:flutter/material.dart';

import '../../../core/state/finance_state.dart';
import '../../../core/state/finance_state_provider.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../shared/presentation/app_design.dart';
import '../../subscriptions/domain/subscription_entry.dart';
import '../domain/credit_card.dart';
import '../domain/credit_card_purchase.dart';

class CardsScreen extends StatelessWidget {
  const CardsScreen({super.key});

  void _showCardBalanceDialog(
    BuildContext context,
    FinanceState state,
    CreditCard card,
  ) {
    final limitController = TextEditingController(
      text: card.creditLimit.toStringAsFixed(0),
    );
    final balanceController = TextEditingController(
      text: card.usedBalance.toStringAsFixed(2),
    );
    final cutDayController = TextEditingController(
      text: card.statementCutDay.toString(),
    );
    final formKey = GlobalKey<FormState>();

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ajustar ${card.name}'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: limitController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Limite de credito',
                    prefixText: r'$ ',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validatePositiveAmount,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: balanceController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Saldo usado actual',
                    prefixText: r'$ ',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateZeroOrPositiveAmount,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: cutDayController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Dia de corte',
                    helperText: 'Ej. 19 para cortar los dias 19',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateStatementCutDay,
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
                  state.updateCreditCard(
                    card.id,
                    creditLimit: double.parse(limitController.text.trim()),
                    usedBalance: double.parse(balanceController.text.trim()),
                    statementCutDay: int.parse(cutDayController.text.trim()),
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

  void _showPaymentDialog(
    BuildContext context,
    FinanceState state,
    CreditCard card,
  ) {
    final amountController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pago a ${card.name}'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: amountController,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Monto pagado',
                prefixText: r'$ ',
                border: OutlineInputBorder(),
              ),
              validator: _validatePositiveAmount,
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
                  state.addCreditCardPayment(card.id, amount);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Se libero ${CurrencyFormatter.format(amount)} en ${card.name}',
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: const Text('Registrar pago'),
            ),
          ],
        );
      },
    );
  }

  void _showPurchaseDialog(BuildContext context, FinanceState state) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    final installmentsController = TextEditingController(text: '1');
    final formKey = GlobalKey<FormState>();
    var selectedCardId = state.creditCards.first.id;
    var selectedDate = DateTime.now();

    showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final amount = double.tryParse(amountController.text.trim());
            final installments =
                int.tryParse(installmentsController.text.trim());
            final monthlyPayment = amount != null &&
                    installments != null &&
                    amount > 0 &&
                    installments > 0
                ? amount / installments
                : null;

            return AlertDialog(
              title: const Text('Nueva compra con tarjeta'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<String>(
                        value: selectedCardId,
                        decoration: const InputDecoration(
                          labelText: 'Tarjeta',
                          border: OutlineInputBorder(),
                        ),
                        items: state.creditCards.map((card) {
                          return DropdownMenuItem(
                            value: card.id,
                            child: Text(card.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setDialogState(() => selectedCardId = value);
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Corte: dia ${state.creditCards.firstWhere((card) => card.id == selectedCardId).statementCutDay}. La mensualidad cuenta un dia despues del corte.',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Compra',
                          hintText: 'Ej. Amazon, farmacia, cafe',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Ingresa el concepto';
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
                        onChanged: (_) => setDialogState(() {}),
                        decoration: const InputDecoration(
                          labelText: 'Monto total',
                          prefixText: r'$ ',
                          border: OutlineInputBorder(),
                        ),
                        validator: _validatePositiveAmount,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: installmentsController,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => setDialogState(() {}),
                        decoration: const InputDecoration(
                          labelText: 'Meses',
                          helperText: 'Usa 1 si no es a meses sin intereses',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          final number = int.tryParse(value?.trim() ?? '');
                          if (number == null || number <= 0) {
                            return 'Ingresa meses validos';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.calendar_today_outlined),
                        title: const Text('Fecha'),
                        subtitle: Text(
                          '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                        ),
                        trailing: TextButton(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2025),
                              lastDate: DateTime(2030),
                            );

                            if (picked != null) {
                              setDialogState(() => selectedDate = picked);
                            }
                          },
                          child: const Text('Cambiar'),
                        ),
                      ),
                      if (monthlyPayment != null) ...[
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            installments == 1
                                ? 'Se cargara ${CurrencyFormatter.format(amount!)} a la tarjeta.'
                                : 'Pagaras ${CurrencyFormatter.format(monthlyPayment)} al mes por $installments meses.',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                          ),
                        ),
                      ],
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
                      final installments = int.parse(
                        installmentsController.text.trim(),
                      );
                      state.addCreditCardPurchase(
                        cardId: selectedCardId,
                        title: titleController.text.trim(),
                        amount: amount,
                        installments: installments,
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

  void _showSubscriptionDialog(
    BuildContext context,
    FinanceState state, {
    SubscriptionEntry? subscription,
  }) {
    final nameController = TextEditingController(
      text: subscription?.name ?? '',
    );
    final amountController = TextEditingController(
      text: subscription?.amount.toStringAsFixed(2) ?? '',
    );
    final formKey = GlobalKey<FormState>();
    var selectedCardId = subscription?.cardId ?? state.creditCards.first.id;

    showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                subscription == null
                    ? 'Nueva suscripcion'
                    : 'Editar suscripcion',
              ),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        labelText: 'Servicio',
                        hintText: 'Ej. ChatGPT, Spotify, iCloud+',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Ingresa el servicio';
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
                        labelText: 'Pago mensual',
                        prefixText: r'$ ',
                        border: OutlineInputBorder(),
                      ),
                      validator: _validatePositiveAmount,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedCardId,
                      decoration: const InputDecoration(
                        labelText: 'Se paga con',
                        border: OutlineInputBorder(),
                      ),
                      items: state.creditCards.map((card) {
                        return DropdownMenuItem(
                          value: card.id,
                          child: Text(card.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() => selectedCardId = value);
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                if (subscription != null)
                  TextButton(
                    onPressed: () {
                      state.deleteSubscription(subscription.id);
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Eliminar',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      final amount = double.parse(amountController.text.trim());

                      if (subscription == null) {
                        state.addSubscription(
                          name: nameController.text.trim(),
                          amount: amount,
                          cardId: selectedCardId,
                        );
                      } else {
                        state.updateSubscription(
                          subscription.id,
                          name: nameController.text.trim(),
                          amount: amount,
                          cardId: selectedCardId,
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

  void _showSubscriptionsSheet(BuildContext context, FinanceState state) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Suscripciones',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _showSubscriptionDialog(context, state);
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Nueva'),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Total mensual: ${CurrencyFormatter.format(state.totalMonthlySubscriptions)}',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      ...state.creditCards.map((card) {
                        final subscriptions = state.subscriptionsForCard(
                          card.id,
                        );
                        final total = subscriptions.fold<double>(
                          0,
                          (sum, subscription) => sum + subscription.amount,
                        );

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: AppCard(
                            child: Padding(
                              padding: EdgeInsets.zero,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      AppIconBubble(
                                        icon: Icons.credit_card,
                                        color: colorScheme.primary,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          card.name,
                                          style:
                                              textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        CurrencyFormatter.format(total),
                                        style: textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  if (subscriptions.isEmpty)
                                    Text(
                                      'Sin suscripciones registradas.',
                                      style: textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    )
                                  else
                                    ...subscriptions.map((subscription) {
                                      return FinancialListItem(
                                        icon: Icons.subscriptions_outlined,
                                        title: subscription.name,
                                        subtitle: card.name,
                                        amount: CurrencyFormatter.format(
                                          subscription.amount,
                                        ),
                                        trailing: IconButton(
                                          tooltip: 'Editar suscripcion',
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            _showSubscriptionDialog(
                                              context,
                                              state,
                                              subscription: subscription,
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.edit_outlined,
                                          ),
                                        ),
                                      );
                                    }),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static String? _validatePositiveAmount(String? value) {
    final number = double.tryParse(value?.trim() ?? '');
    if (number == null || number <= 0) {
      return 'Ingresa un monto positivo valido';
    }

    return null;
  }

  static String? _validateZeroOrPositiveAmount(String? value) {
    final number = double.tryParse(value?.trim() ?? '');
    if (number == null || number < 0) {
      return 'Ingresa un monto valido';
    }

    return null;
  }

  static String? _validateStatementCutDay(String? value) {
    final number = int.tryParse(value?.trim() ?? '');
    if (number == null || number < 1 || number > 31) {
      return 'Ingresa un dia entre 1 y 31';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final state = FinanceStateProvider.of(context);
    final monthlyCommitment =
        state.totalMonthlyInstallmentPayments + state.totalMonthlySubscriptions;

    return AppScreen(
      children: [
          AppHeader(
            title: 'Tarjetas',
            subtitle:
                'Controla deuda, cortes, pagos estimados y mensualidades.',
            action: IconButton.filled(
              tooltip: 'Nueva compra',
              onPressed: () => _showPurchaseDialog(context, state),
              icon: const Icon(Icons.add),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _MonthlyCommitmentCard(
            amount: monthlyCommitment,
            installments: state.totalMonthlyInstallmentPayments,
            subscriptions: state.totalMonthlySubscriptions,
          ),
          const SizedBox(height: AppSpacing.md),
          _MetricGrid(
            children: [
              _MetricTile(
                title: 'Deuda total',
                value: CurrencyFormatter.format(state.totalCreditCardDebt),
                icon: Icons.credit_card,
              ),
              _MetricTile(
                title: 'Disponible',
                value: CurrencyFormatter.format(state.totalAvailableCredit),
                icon: Icons.lock_open_outlined,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _QuickActionsCard(
            onPurchase: () => _showPurchaseDialog(context, state),
            onSubscriptions: () => _showSubscriptionsSheet(context, state),
            subscriptionsTotal: state.totalMonthlySubscriptions,
            subscriptionsCount: state.subscriptions.length,
          ),
          const SizedBox(height: AppSpacing.xxl),
          const AppSectionHeader(
            title: 'Tus tarjetas',
            subtitle: 'Saldo, corte, pagos y ultimas compras por tarjeta.',
          ),
          const SizedBox(height: AppSpacing.md),
          ...state.creditCards.map((card) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: _CreditCardPanel(
                card: card,
                purchases: state.purchasesForCard(card.id),
                subscriptions: state.subscriptionsForCard(card.id),
                onEdit: () => _showCardBalanceDialog(context, state, card),
                onPay: () => _showPaymentDialog(context, state, card),
                onSubscriptions: () => _showSubscriptionsSheet(context, state),
              ),
            );
          }),
        ],
    );
  }
}

class _MonthlyCommitmentCard extends StatelessWidget {
  const _MonthlyCommitmentCard({
    required this.amount,
    required this.installments,
    required this.subscriptions,
  });

  final double amount;
  final double installments;
  final double subscriptions;

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
                Icon(Icons.event_note_outlined, color: colorScheme.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Compromiso mensual',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              CurrencyFormatter.format(amount),
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            _InlineMoneyRow(
              label: 'Meses sin intereses',
              value: CurrencyFormatter.format(installments),
            ),
            const SizedBox(height: 6),
            _InlineMoneyRow(
              label: 'Suscripciones',
              value: CurrencyFormatter.format(subscriptions),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreditCardPanel extends StatelessWidget {
  const _CreditCardPanel({
    required this.card,
    required this.purchases,
    required this.subscriptions,
    required this.onEdit,
    required this.onPay,
    required this.onSubscriptions,
  });

  final CreditCard card;
  final List<CreditCardPurchase> purchases;
  final List<SubscriptionEntry> subscriptions;
  final VoidCallback onEdit;
  final VoidCallback onPay;
  final VoidCallback onSubscriptions;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final progress = card.creditLimit > 0
        ? (card.usedBalance / card.creditLimit).clamp(0.0, 1.0)
        : 0.0;
    final subscriptionsTotal = subscriptions.fold<double>(
      0,
      (sum, subscription) => sum + subscription.amount,
    );

    return AppCard(
      child: Padding(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.credit_card, color: colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    card.name,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Ajustar saldo',
                  onPressed: onEdit,
                  icon: const Icon(Icons.tune, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _CardFactsRow(
              facts: [
                _CardFact(
                  label: 'Corte',
                  value: 'Dia ${card.statementCutDay}',
                ),
                _CardFact(
                  label: 'Limite',
                  value: CurrencyFormatter.format(card.creditLimit),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _InlineMoneyRow(
              label: 'Usado',
              value: CurrencyFormatter.format(card.usedBalance),
            ),
            const SizedBox(height: 6),
            _InlineMoneyRow(
              label: 'Libre',
              value: CurrencyFormatter.format(card.availableCredit),
              valueColor: colorScheme.primary,
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: colorScheme.outlineVariant.withAlpha(128),
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: onPay,
                  icon: const Icon(Icons.payments_outlined, size: 18),
                  label: const Text('Registrar pago'),
                ),
                OutlinedButton.icon(
                  onPressed: onSubscriptions,
                  icon: const Icon(Icons.subscriptions_outlined, size: 18),
                  label: const Text('Suscripciones'),
                ),
              ],
            ),
            if (subscriptions.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                '${subscriptions.length} recurrentes - ${CurrencyFormatter.format(subscriptionsTotal)} al mes',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            if (purchases.isNotEmpty) ...[
              const SizedBox(height: 14),
              const Divider(),
              const SizedBox(height: 6),
              Text(
                'Ultimas compras',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              ...purchases.take(4).map((purchase) {
                return _PurchaseTile(
                  purchase: purchase,
                  statementCutDay: card.statementCutDay,
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 520;

        if (isWide) {
          return Row(
            children: [
              for (var index = 0; index < children.length; index++) ...[
                if (index > 0) const SizedBox(width: 12),
                Expanded(child: children[index]),
              ],
            ],
          );
        }

        return Column(
          children: [
            for (var index = 0; index < children.length; index++) ...[
              if (index > 0) const SizedBox(height: 12),
              children[index],
            ],
          ],
        );
      },
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return AppCard(
      child: Padding(
        padding: EdgeInsets.zero,
        child: Row(
          children: [
            Icon(icon, color: colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: textTheme.labelLarge),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionsCard extends StatelessWidget {
  const _QuickActionsCard({
    required this.onPurchase,
    required this.onSubscriptions,
    required this.subscriptionsTotal,
    required this.subscriptionsCount,
  });

  final VoidCallback onPurchase;
  final VoidCallback onSubscriptions;
  final double subscriptionsTotal;
  final int subscriptionsCount;

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
            Text(
              'Acciones',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 360;
                final buttons = [
                  FilledButton.icon(
                    onPressed: onPurchase,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Compra'),
                  ),
                  OutlinedButton.icon(
                    onPressed: onSubscriptions,
                    icon: const Icon(Icons.subscriptions_outlined, size: 18),
                    label: const Text('Suscripciones'),
                  ),
                ];

                if (isNarrow) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      buttons.first,
                      const SizedBox(height: 8),
                      buttons.last,
                    ],
                  );
                }

                return Row(
                  children: [
                    Expanded(child: buttons.first),
                    const SizedBox(width: 8),
                    Expanded(child: buttons.last),
                  ],
                );
              },
            ),
            const SizedBox(height: 10),
            Text(
              '$subscriptionsCount recurrentes - ${CurrencyFormatter.format(subscriptionsTotal)} al mes',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InlineMoneyRow extends StatelessWidget {
  const _InlineMoneyRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Text(
          value,
          style: textTheme.bodyMedium?.copyWith(
            color: valueColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _CardFactsRow extends StatelessWidget {
  const _CardFactsRow({required this.facts});

  final List<_CardFact> facts;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var index = 0; index < facts.length; index++) ...[
          if (index > 0) const SizedBox(width: 8),
          Expanded(child: facts[index]),
        ],
      ],
    );
  }
}

class _CardFact extends StatelessWidget {
  const _CardFact({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withAlpha(76),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PurchaseTile extends StatelessWidget {
  const _PurchaseTile({
    required this.purchase,
    required this.statementCutDay,
  });

  final CreditCardPurchase purchase;
  final int statementCutDay;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final today = DateTime.now();
    final remainingInstallments = purchase.remainingInstallmentsAsOf(
      today,
      statementCutDay: statementCutDay,
    );
    final paidInstallments = purchase.paidInstallmentsAsOf(
      today,
      statementCutDay: statementCutDay,
    );
    final subtitle = purchase.isInstallmentPurchase
        ? '$remainingInstallments meses restantes - $paidInstallments pagados - ${CurrencyFormatter.format(purchase.monthlyPayment)} al mes'
        : '${purchase.date.day}/${purchase.date.month}/${purchase.date.year}';

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: FinancialListItem(
        icon: purchase.isInstallmentPurchase
            ? Icons.view_timeline_outlined
            : Icons.shopping_bag_outlined,
        title: purchase.title,
        subtitle: subtitle,
        amount: CurrencyFormatter.format(purchase.amount),
        iconColor: colorScheme.primary,
      ),
    );
  }
}
