import 'package:flutter/material.dart';

import '../../../core/state/finance_state.dart';
import '../../../core/state/finance_state_provider.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../shared/presentation/app_design.dart';
import '../../notifications/domain/task_reminder.dart';
import '../../subscriptions/domain/subscription_entry.dart';
import 'card_monthly_payment_section.dart';
import '../domain/credit_card.dart';
import '../domain/credit_card_purchase.dart';

class CardsScreen extends StatefulWidget {
  const CardsScreen({
    this.pendingPaymentCardId,
    this.onPendingPaymentHandled,
    super.key,
  });

  final String? pendingPaymentCardId;
  final VoidCallback? onPendingPaymentHandled;

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  String? _lastHandledPendingPaymentCardId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _maybeHandlePendingPayment();
  }

  @override
  void didUpdateWidget(covariant CardsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _maybeHandlePendingPayment();
  }

  void _maybeHandlePendingPayment() {
    final pendingCardId = widget.pendingPaymentCardId;
    if (pendingCardId == null ||
        pendingCardId == _lastHandledPendingPaymentCardId) {
      return;
    }

    final state = FinanceStateProvider.of(context);
    final card = state.creditCardById(pendingCardId);
    if (card == null) {
      _lastHandledPendingPaymentCardId = pendingCardId;
      widget.onPendingPaymentHandled?.call();
      return;
    }

    _lastHandledPendingPaymentCardId = pendingCardId;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await showCardMonthlyPaymentDialog(
        context,
        state: state,
        card: card,
      );
      widget.onPendingPaymentHandled?.call();
    });
  }

  void _showCreditCardDialog(
    BuildContext context,
    FinanceState state, {
    CreditCard? card,
  }) {
    final nameController = TextEditingController(text: card?.name ?? '');
    final limitController = TextEditingController(
      text: card?.creditLimit.toStringAsFixed(0) ?? '',
    );
    final balanceController = TextEditingController(
      text: card?.usedBalance.toStringAsFixed(2) ?? '0',
    );
    final cutDayController = TextEditingController(
      text: card?.statementCutDay.toString() ?? '',
    );
    final formKey = GlobalKey<FormState>();
    final paymentController = TextEditingController();
    var paymentConfirmed = false;
    var remindAfterCut = false;
    var reminderMode = TaskReminderMode.sameDay;
    DateTime? reminderCustomScheduledAt;

    showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            Future<void> pickCustomReminderDate() async {
              final initialDate = reminderCustomScheduledAt ??
                  DateTime.now().add(const Duration(days: 1));
              final date = await showDatePicker(
                context: context,
                initialDate: initialDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
              );
              if (date == null || !context.mounted) {
                return;
              }
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(initialDate),
              );
              if (time == null) {
                return;
              }
              setDialogState(() {
                reminderCustomScheduledAt = DateTime(
                  date.year,
                  date.month,
                  date.day,
                  time.hour,
                  time.minute,
                );
              });
            }

            final hasPayment = paymentController.text.trim().isNotEmpty;
            final canEditUsedBalance =
                card == null || !state.hasLinkedTransactionsForCard(card.id);

            return AlertDialog(
              title: Text(card == null ? 'Nueva tarjeta' : 'Editar tarjeta'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameController,
                        autofocus: card == null,
                        decoration: const InputDecoration(
                          labelText: 'Nombre de la tarjeta',
                          hintText: 'Ej. Tarjeta principal',
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
                        enabled: canEditUsedBalance,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Saldo usado actual',
                          prefixText: r'$ ',
                          helperText: canEditUsedBalance
                              ? null
                              : 'No se puede editar manualmente mientras la tarjeta tenga movimientos asociados.',
                          border: const OutlineInputBorder(),
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
                      if (card == null) ...[
                        const SizedBox(height: 16),
                        ExpansionTile(
                          tilePadding: EdgeInsets.zero,
                          childrenPadding: EdgeInsets.zero,
                          title: const Text('Datos del estado de cuenta'),
                          subtitle: const Text(
                            'Opcional: captura el pago si ya lo conoces.',
                          ),
                          children: [
                            TextFormField(
                              controller: paymentController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              onChanged: (_) => setDialogState(() {}),
                              decoration: const InputDecoration(
                                labelText: 'Pago para no generar intereses',
                                helperText:
                                    'Si lo capturas, debe ser el total completo del estado de cuenta.',
                                prefixText: r'$ ',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if ((value ?? '').trim().isEmpty) {
                                  return null;
                                }
                                return _validateZeroOrPositiveAmount(value);
                              },
                            ),
                            CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              value: hasPayment && paymentConfirmed,
                              onChanged: hasPayment
                                  ? (value) {
                                      setDialogState(() {
                                        paymentConfirmed = value ?? false;
                                      });
                                    }
                                  : null,
                              title: const Text(
                                'Confirmar que el monto corresponde al estado de cuenta',
                              ),
                            ),
                            if (!hasPayment) ...[
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                value: remindAfterCut,
                                onChanged: (value) {
                                  setDialogState(() {
                                    remindAfterCut = value ?? false;
                                  });
                                },
                                title: const Text(
                                  'Recordarme agregarlo despues del corte',
                                ),
                              ),
                              if (remindAfterCut) ...[
                                const SizedBox(height: 8),
                                DropdownButtonFormField<TaskReminderMode>(
                                  initialValue: reminderMode,
                                  decoration: const InputDecoration(
                                    labelText: 'Tipo de recordatorio',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: TaskReminderMode.values.map((mode) {
                                    return DropdownMenuItem(
                                      value: mode,
                                      child: Text(
                                        _reminderModeLabel(mode),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    if (value == null) return;
                                    setDialogState(() {
                                      reminderMode = value;
                                      if (value != TaskReminderMode.custom) {
                                        reminderCustomScheduledAt = null;
                                      }
                                    });
                                  },
                                ),
                                if (reminderMode ==
                                    TaskReminderMode.custom) ...[
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: OutlinedButton.icon(
                                      onPressed: pickCustomReminderDate,
                                      icon: const Icon(Icons.event_outlined),
                                      label: Text(
                                        reminderCustomScheduledAt == null
                                            ? 'Elegir fecha personalizada'
                                            : _formatDateTime(
                                                reminderCustomScheduledAt!,
                                              ),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ],
                          ],
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
                      final name = nameController.text.trim();
                      final creditLimit =
                          double.parse(limitController.text.trim());
                      final usedBalance = double.parse(
                        balanceController.text.trim(),
                      );
                      final statementCutDay = int.parse(
                        cutDayController.text.trim(),
                      );
                      final paymentAmount = hasPayment
                          ? double.parse(paymentController.text.trim())
                          : null;

                      if (card == null) {
                        state.addCreditCard(
                          name: name,
                          creditLimit: creditLimit,
                          usedBalance: usedBalance,
                          statementCutDay: statementCutDay,
                          paymentAmount: paymentAmount,
                          paymentConfirmed: paymentConfirmed,
                          remindAfterCut: remindAfterCut,
                          reminderMode: reminderMode,
                          reminderCustomScheduledAt: reminderCustomScheduledAt,
                        );
                      } else {
                        state.updateCreditCard(
                          card.id,
                          name: name,
                          creditLimit: creditLimit,
                          usedBalance: usedBalance,
                          statementCutDay: statementCutDay,
                        );
                        if (!canEditUsedBalance &&
                            usedBalance != card.usedBalance) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'El saldo usado se sincroniza desde Movimientos y no puede editarse manualmente mientras existan movimientos asociados.',
                              ),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      }
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(card == null ? 'Agregar' : 'Guardar'),
                ),
              ],
            );
          },
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
    var selectedDate = DateTime.now();

    showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Pago a ${card.name}'),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
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
                      validator: (value) {
                        final validation = _validatePositiveAmount(value);
                        if (validation != null) {
                          return validation;
                        }
                        final amount = double.tryParse(value?.trim() ?? '');
                        if (amount != null && amount > card.usedBalance) {
                          return 'El pago no puede ser mayor al saldo usado actual.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.calendar_today_outlined),
                      title: const Text('Fecha'),
                      subtitle: Text(_formatDate(selectedDate)),
                      trailing: TextButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2025),
                            lastDate: DateTime(2035),
                          );
                          if (picked != null) {
                            setDialogState(() => selectedDate = picked);
                          }
                        },
                        child: const Text('Cambiar'),
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
                      final amount = double.parse(amountController.text.trim());
                      final transactionId = state.registerCreditCardPayment(
                        cardId: card.id,
                        amount: amount,
                        date: selectedDate,
                      );
                      if (transactionId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'No se pudo registrar el pago. Verifica el monto y la tarjeta.',
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Se registro ${CurrencyFormatter.format(amount)} en ${card.name}.',
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
                        initialValue: selectedCardId,
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
                        hintText: 'Ej. Musica, almacenamiento, television',
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
                      initialValue: selectedCardId,
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

  void _showInstallmentPurchaseDialog(
    BuildContext context,
    FinanceState state, {
    CreditCardPurchase? purchase,
  }) {
    final nameController = TextEditingController(text: purchase?.title ?? '');
    final amountController = TextEditingController(
      text: purchase?.amount.toStringAsFixed(2) ?? '',
    );
    final totalMonthsController = TextEditingController(
      text: purchase?.installments.toString() ?? '',
    );
    final paidMonthsController = TextEditingController(
      text: purchase?.paidInstallments.toString() ?? '0',
    );
    final notesController = TextEditingController(text: purchase?.notes ?? '');
    final formKey = GlobalKey<FormState>();
    var selectedCardId = purchase?.cardId ?? state.creditCards.first.id;
    var selectedDate = purchase?.date;

    showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final amount = double.tryParse(amountController.text.trim());
            final totalMonths = int.tryParse(totalMonthsController.text.trim());
            final paidMonths = int.tryParse(paidMonthsController.text.trim());
            final canPreview = amount != null &&
                totalMonths != null &&
                paidMonths != null &&
                amount > 0 &&
                totalMonths > 0 &&
                paidMonths >= 0 &&
                paidMonths <= totalMonths;
            final monthlyPayment = canPreview ? amount / totalMonths : 0.0;
            final remainingMonths = canPreview ? totalMonths - paidMonths : 0;
            final remainingAmount = monthlyPayment * remainingMonths;

            return AlertDialog(
              title: Text(
                purchase == null
                    ? 'Nueva compra a meses'
                    : 'Editar compra a meses',
              ),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameController,
                        autofocus: true,
                        decoration: const InputDecoration(
                          labelText: 'Nombre de la compra',
                          hintText: 'Ej. Amazon, celular, muebles',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Ingresa el nombre de la compra';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: selectedCardId,
                        decoration: const InputDecoration(
                          labelText: 'Tarjeta asociada',
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
                        controller: totalMonthsController,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => setDialogState(() {}),
                        decoration: const InputDecoration(
                          labelText: 'Total de meses',
                          border: OutlineInputBorder(),
                        ),
                        validator: _validatePositiveInt,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: paidMonthsController,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => setDialogState(() {}),
                        decoration: const InputDecoration(
                          labelText: 'Meses pagados',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          final paid = int.tryParse(value?.trim() ?? '');
                          final total = int.tryParse(
                            totalMonthsController.text.trim(),
                          );

                          if (paid == null || paid < 0) {
                            return 'Ingresa meses pagados validos';
                          }

                          if (total != null && paid > total) {
                            return 'Los meses pagados no pueden ser mayores al total de meses.';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.calendar_today_outlined),
                        title: const Text('Fecha de compra'),
                        subtitle: Text(_formatDate(selectedDate)),
                        trailing: TextButton(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2035),
                            );

                            if (picked != null) {
                              setDialogState(() => selectedDate = picked);
                            }
                          },
                          child: const Text('Cambiar'),
                        ),
                      ),
                      TextFormField(
                        controller: notesController,
                        minLines: 2,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Notas',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      if (canPreview) ...[
                        const SizedBox(height: 12),
                        _InstallmentPreview(
                          monthlyPayment: monthlyPayment,
                          remainingMonths: remainingMonths,
                          remainingAmount: remainingAmount,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                if (purchase != null)
                  TextButton(
                    onPressed: () {
                      state.deleteCreditCardPurchase(purchase.id);
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
                      final totalMonths = int.parse(
                        totalMonthsController.text.trim(),
                      );
                      final paidMonths = int.parse(
                        paidMonthsController.text.trim(),
                      );

                      if (paidMonths > totalMonths) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Los meses pagados no pueden ser mayores al total de meses.',
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }

                      if (purchase == null) {
                        state.addCreditCardPurchase(
                          cardId: selectedCardId,
                          title: nameController.text.trim(),
                          amount: amount,
                          installments: totalMonths,
                          paidInstallments: paidMonths,
                          date: selectedDate,
                          notes: notesController.text,
                        );
                      } else {
                        state.updateCreditCardPurchase(
                          purchase.id,
                          cardId: selectedCardId,
                          title: nameController.text.trim(),
                          amount: amount,
                          installments: totalMonths,
                          paidInstallments: paidMonths,
                          date: selectedDate,
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

  void _showInstallmentPurchasesSheet(
    BuildContext context,
    FinanceState state,
  ) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;
        final completed = state.completedInstallmentPurchases;

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
                        'Meses sin intereses',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _showInstallmentPurchaseDialog(context, state);
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Nueva'),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Total mensual activo: ${CurrencyFormatter.format(state.totalMonthlyInstallmentPayments)}',
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
                        final activePurchases =
                            state.activeInstallmentPurchasesForCard(card.id);
                        final total = activePurchases.fold<double>(
                          0,
                          (sum, purchase) => sum + purchase.monthlyPayment,
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
                                  if (activePurchases.isEmpty)
                                    Text(
                                      'Sin compras activas a meses.',
                                      style: textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    )
                                  else
                                    ...activePurchases.map((purchase) {
                                      return _InstallmentPurchaseItem(
                                        purchase: purchase,
                                        cardName: card.name,
                                        onEdit: () {
                                          Navigator.of(context).pop();
                                          _showInstallmentPurchaseDialog(
                                            context,
                                            state,
                                            purchase: purchase,
                                          );
                                        },
                                      );
                                    }),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                      if (completed.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Liquidadas',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...completed.map((purchase) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: _InstallmentPurchaseItem(
                              purchase: purchase,
                              cardName: state.creditCardName(purchase.cardId),
                              onEdit: () {
                                Navigator.of(context).pop();
                                _showInstallmentPurchaseDialog(
                                  context,
                                  state,
                                  purchase: purchase,
                                );
                              },
                            ),
                          );
                        }),
                      ],
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

  static String? _validatePositiveInt(String? value) {
    final number = int.tryParse(value?.trim() ?? '');
    if (number == null || number <= 0) {
      return 'Ingresa un numero mayor a 0';
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

  static String _formatDate(DateTime? date) {
    if (date == null) {
      return 'Sin fecha';
    }

    return '${date.day}/${date.month}/${date.year}';
  }

  static String _formatDateTime(DateTime value) {
    return '${_formatDate(value)} '
        '${value.hour.toString().padLeft(2, '0')}:'
        '${value.minute.toString().padLeft(2, '0')}';
  }

  static String _reminderModeLabel(TaskReminderMode mode) {
    return switch (mode) {
      TaskReminderMode.sameDay => 'El mismo dia',
      TaskReminderMode.oneDayBefore => '1 dia antes',
      TaskReminderMode.threeDaysBefore => '3 dias antes',
      TaskReminderMode.custom => 'Personalizado',
    };
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
          subtitle: 'Controla deuda, cortes, pagos estimados y mensualidades.',
          action: IconButton.filled(
            tooltip: 'Nueva tarjeta',
            onPressed: () => _showCreditCardDialog(context, state),
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
        if (state.creditCards.isNotEmpty) ...[
          _QuickActionsCard(
            onPurchase: () => _showPurchaseDialog(context, state),
            onSubscriptions: () => _showSubscriptionsSheet(context, state),
            onInstallments: () => _showInstallmentPurchasesSheet(
              context,
              state,
            ),
            subscriptionsTotal: state.totalMonthlySubscriptions,
            subscriptionsCount: state.subscriptions.length,
          ),
          const SizedBox(height: AppSpacing.md),
          _InstallmentCommitmentsCard(
            monthlyAmount: state.totalMonthlyInstallmentPayments,
            activeCount: state.activeInstallmentPurchaseCount,
            remainingAmount: state.totalRemainingInstallmentAmount,
            onView: () => _showInstallmentPurchasesSheet(context, state),
          ),
        ],
        const SizedBox(height: AppSpacing.xxl),
        AppSectionHeader(
          title: 'Tus tarjetas',
          subtitle: 'Saldo, corte, pagos y ultimas compras por tarjeta.',
          action: AppButton(
            label: 'Nueva',
            icon: Icons.add,
            onPressed: () => _showCreditCardDialog(context, state),
            variant: AppButtonVariant.secondary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (state.creditCards.isEmpty)
          AppCard(
            child: Column(
              children: [
                const AppIconBubble(
                  icon: Icons.credit_card_off_outlined,
                  size: 48,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Todavia no tienes tarjetas registradas.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: AppSpacing.sm),
                const Text(
                  'Agrega una tarjeta para registrar compras, pagos y suscripciones.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  label: 'Agregar tarjeta',
                  icon: Icons.add,
                  onPressed: () => _showCreditCardDialog(context, state),
                ),
              ],
            ),
          ),
        ...state.creditCards.map((card) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: _CreditCardPanel(
              card: card,
              purchases: state.purchasesForCard(card.id),
              subscriptions: state.subscriptionsForCard(card.id),
              onEdit: () => _showCreditCardDialog(
                context,
                state,
                card: card,
              ),
              state: state,
              onPay: () => _showPaymentDialog(context, state, card),
              onSubscriptions: () => _showSubscriptionsSheet(context, state),
              onInstallments: () => _showInstallmentPurchasesSheet(
                context,
                state,
              ),
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

class _InstallmentCommitmentsCard extends StatelessWidget {
  const _InstallmentCommitmentsCard({
    required this.monthlyAmount,
    required this.activeCount,
    required this.remainingAmount,
    required this.onView,
  });

  final double monthlyAmount;
  final int activeCount;
  final double remainingAmount;
  final VoidCallback onView;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return AppCard(
      child: Padding(
        padding: EdgeInsets.zero,
        child: Row(
          children: [
            AppIconBubble(
              icon: Icons.view_timeline_outlined,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Compromisos MSI',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${CurrencyFormatter.format(monthlyAmount)} al mes',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$activeCount compra${activeCount == 1 ? '' : 's'} activa${activeCount == 1 ? '' : 's'} - ${CurrencyFormatter.format(remainingAmount)} pendiente',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: onView,
              child: const Text('Ver compras'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreditCardPanel extends StatelessWidget {
  const _CreditCardPanel({
    required this.state,
    required this.card,
    required this.purchases,
    required this.subscriptions,
    required this.onEdit,
    required this.onPay,
    required this.onSubscriptions,
    required this.onInstallments,
  });

  final FinanceState state;
  final CreditCard card;
  final List<CreditCardPurchase> purchases;
  final List<SubscriptionEntry> subscriptions;
  final VoidCallback onEdit;
  final VoidCallback onPay;
  final VoidCallback onSubscriptions;
  final VoidCallback onInstallments;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final progress = card.utilizationProgress;
    final subscriptionsTotal = subscriptions.fold<double>(
      0,
      (sum, subscription) => sum + subscription.amount,
    );
    final installmentPurchases = purchases.where((purchase) {
      return purchase.isInstallmentPurchase && !purchase.isCompleted;
    }).toList(growable: false);
    final cashPurchases = purchases.where((purchase) {
      return !purchase.isInstallmentPurchase;
    }).toList(growable: false);
    final installmentTotal = installmentPurchases.fold<double>(
      0,
      (sum, purchase) => sum + purchase.monthlyPayment,
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
              label: '% utilizado',
              value: '${card.utilizationPercent.round()}%',
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
                key: ValueKey('card-utilization-progress-${card.id}'),
                value: progress,
                minHeight: 10,
                backgroundColor: colorScheme.outlineVariant.withAlpha(128),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Credito ${card.utilizationPercent.round()}% usado',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 14),
            CardMonthlyPaymentSection(state: state, card: card),
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
                OutlinedButton.icon(
                  onPressed: onInstallments,
                  icon: const Icon(Icons.view_timeline_outlined, size: 18),
                  label: const Text('MSI'),
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
            if (installmentPurchases.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                '${installmentPurchases.length} MSI - ${CurrencyFormatter.format(installmentTotal)} al mes',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            if (cashPurchases.isNotEmpty) ...[
              const SizedBox(height: 14),
              const Divider(),
              const SizedBox(height: 6),
              Text(
                'Ultimas compras',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              ...cashPurchases.take(4).map((purchase) {
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

class _InstallmentPreview extends StatelessWidget {
  const _InstallmentPreview({
    required this.monthlyPayment,
    required this.remainingMonths,
    required this.remainingAmount,
  });

  final double monthlyPayment;
  final int remainingMonths;
  final double remainingAmount;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(
              76,
            ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _InlineMoneyRow(
              label: 'Pago mensual',
              value: CurrencyFormatter.format(monthlyPayment),
            ),
            const SizedBox(height: 6),
            _InlineMoneyRow(
              label: 'Meses restantes',
              value: remainingMonths.toString(),
            ),
            const SizedBox(height: 6),
            _InlineMoneyRow(
              label: 'Pendiente',
              value: CurrencyFormatter.format(remainingAmount),
            ),
          ],
        ),
      ),
    );
  }
}

class _InstallmentPurchaseItem extends StatelessWidget {
  const _InstallmentPurchaseItem({
    required this.purchase,
    required this.cardName,
    required this.onEdit,
  });

  final CreditCardPurchase purchase;
  final String cardName;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final paidText =
        '${purchase.paidInstallments} de ${purchase.installments} meses pagados';
    final remainingText = purchase.isCompleted
        ? 'Liquidada'
        : '${purchase.remainingInstallments} meses restantes';
    final subtitle = [
      cardName,
      '${CurrencyFormatter.format(purchase.amount)} total',
      '${CurrencyFormatter.format(purchase.monthlyPayment)} al mes',
      paidText,
      remainingText,
      'Pendiente: ${CurrencyFormatter.format(purchase.remainingAmount)}',
      if (purchase.notes != null) purchase.notes!,
    ].join('\n');

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: FinancialListItem(
        icon: Icons.view_timeline_outlined,
        title: purchase.title,
        subtitle: subtitle,
        subtitleMaxLines: 7,
        amount: purchase.isCompleted
            ? 'Liquidada'
            : CurrencyFormatter.format(purchase.remainingAmount),
        amountColor: purchase.isCompleted ? colorScheme.onSurfaceVariant : null,
        status: StatusPill(
          label: purchase.isCompleted ? 'Liquidada' : 'Activa',
          color: purchase.isCompleted
              ? colorScheme.onSurfaceVariant
              : colorScheme.primary,
        ),
        trailing: IconButton(
          tooltip: 'Editar compra',
          onPressed: onEdit,
          icon: const Icon(Icons.edit_outlined),
        ),
      ),
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
    required this.onInstallments,
    required this.subscriptionsTotal,
    required this.subscriptionsCount,
  });

  final VoidCallback onPurchase;
  final VoidCallback onSubscriptions;
  final VoidCallback onInstallments;
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
                  OutlinedButton.icon(
                    onPressed: onInstallments,
                    icon: const Icon(Icons.view_timeline_outlined, size: 18),
                    label: const Text('MSI'),
                  ),
                ];

                if (isNarrow) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var index = 0; index < buttons.length; index++) ...[
                        if (index > 0) const SizedBox(height: 8),
                        buttons[index],
                      ],
                    ],
                  );
                }

                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: buttons.map((button) {
                    return SizedBox(width: 160, child: button);
                  }).toList(),
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
        : _formatDate(purchase.date);

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

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'Sin fecha';
    }

    return '${date.day}/${date.month}/${date.year}';
  }
}
