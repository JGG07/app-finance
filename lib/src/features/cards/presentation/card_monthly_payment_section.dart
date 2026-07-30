import 'package:flutter/material.dart';

import '../../../core/state/finance_state.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../shared/presentation/app_design.dart';
import '../../notifications/domain/task_reminder.dart';
import '../domain/credit_card.dart';
import '../domain/credit_card_monthly_payment.dart';

String creditCardPaymentSourceLabel(CreditCardPaymentSource source) {
  return switch (source) {
    CreditCardPaymentSource.manual => 'Manual',
    CreditCardPaymentSource.confirmed => 'Confirmado',
    CreditCardPaymentSource.estimated => 'Estimado',
  };
}

Future<void> showCardMonthlyPaymentDialog(
  BuildContext context, {
  required FinanceState state,
  required CreditCard card,
}) {
  final currentAmount = state.baseCardMonthlyPaymentAmount(card.id);
  final controller = TextEditingController(
    text: currentAmount == 0 ? '' : currentAmount.toStringAsFixed(2),
  );
  final formKey = GlobalKey<FormState>();
  var selectedSource = state.cardMonthlyPaymentSource(card.id);

  return showDialog<void>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          final installments = state.monthlyInstallmentPaymentForCard(card.id);
          final view = _CardPaymentViewModel.fromState(state, card.id);

          return AlertDialog(
            title: Text('Pago de ${card.name}'),
            content: SingleChildScrollView(
              child: Form(
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
                        labelText: 'Total del estado de cuenta',
                        helperText:
                            'Captura el total completo a pagar, incluyendo las mensualidades de compras a MSI.',
                        prefixText: r'$ ',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (selectedSource ==
                            CreditCardPaymentSource.estimated) {
                          return null;
                        }

                        final number = double.tryParse(value?.trim() ?? '');
                        if (number == null || number < 0) {
                          return 'Ingresa un monto valido';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    if (selectedSource == CreditCardPaymentSource.estimated)
                      _EstimatedPaymentBreakdown(
                        view: view,
                        installments: installments,
                        compact: false,
                      )
                    else
                      Text(
                        'El total manual o confirmado ya debe incluir las mensualidades MSI.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
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
                    final amount =
                        selectedSource == CreditCardPaymentSource.estimated
                            ? view.amount
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

Future<void> showCardPaymentReminderDialog(
  BuildContext context, {
  required FinanceState state,
  required CreditCard card,
}) async {
  final task = state.financialTaskById(state.cardPaymentTaskId(card.id));
  if (task == null) {
    return;
  }

  final reminder = state.taskReminderFor(task.id);
  var reminderEnabled = reminder?.enabled ?? true;
  var reminderMode = reminder?.mode ?? TaskReminderMode.sameDay;
  var reminderHour = reminder?.hour ?? 9;
  var reminderMinute = reminder?.minute ?? 0;
  DateTime? customScheduledAt = reminder?.customScheduledAt;

  final saved = await showDialog<bool>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          Future<void> pickCustomDate() async {
            final initialDate = customScheduledAt ?? task.dueDate!;
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
              initialTime: TimeOfDay(
                hour: customScheduledAt?.hour ?? reminderHour,
                minute: customScheduledAt?.minute ?? reminderMinute,
              ),
            );
            if (time == null) {
              return;
            }
            setDialogState(() {
              customScheduledAt = DateTime(
                date.year,
                date.month,
                date.day,
                time.hour,
                time.minute,
              );
            });
          }

          return AlertDialog(
            title: Text('Recordatorio para ${card.name}'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    value: reminderEnabled,
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Recordarme agregar el pago despues del corte',
                    ),
                    subtitle: const Text(
                      'Puedes usar el dia siguiente al corte o una fecha personalizada.',
                    ),
                    onChanged: (value) {
                      setDialogState(() => reminderEnabled = value);
                    },
                  ),
                  if (reminderEnabled) ...[
                    const SizedBox(height: 12),
                    DropdownButtonFormField<TaskReminderMode>(
                      initialValue: reminderMode,
                      decoration: const InputDecoration(
                        labelText: 'Cuando avisarme',
                        border: OutlineInputBorder(),
                      ),
                      items: TaskReminderMode.values.map((mode) {
                        return DropdownMenuItem(
                          value: mode,
                          child: Text(_reminderModeLabel(mode)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setDialogState(() {
                          reminderMode = value;
                          if (value != TaskReminderMode.custom) {
                            customScheduledAt = null;
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    if (reminderMode == TaskReminderMode.custom) ...[
                      OutlinedButton.icon(
                        onPressed: pickCustomDate,
                        icon: const Icon(Icons.event_outlined),
                        label: Text(
                          customScheduledAt == null
                              ? 'Elegir fecha personalizada'
                              : _formatDateTime(customScheduledAt!),
                        ),
                      ),
                    ] else ...[
                      Text(
                        'Fecha base: ${_formatDate(task.dueDate!)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () async {
                  if (reminderEnabled &&
                      reminderMode == TaskReminderMode.custom &&
                      customScheduledAt == null) {
                    return;
                  }

                  final ok = await state.configureCardPaymentReminder(
                    card.id,
                    enabled: reminderEnabled,
                    mode: reminderMode,
                    hour: reminderHour,
                    minute: reminderMinute,
                    customScheduledAt: customScheduledAt,
                  );
                  if (!context.mounted || !ok) {
                    return;
                  }
                  Navigator.of(context).pop(true);
                },
                child: const Text('Guardar'),
              ),
            ],
          );
        },
      );
    },
  );

  if (saved == true && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          reminderEnabled
              ? 'Recordatorio actualizado para ${card.name}.'
              : 'Recordatorio eliminado para ${card.name}.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class CardMonthlyPaymentSection extends StatelessWidget {
  const CardMonthlyPaymentSection({
    required this.state,
    required this.card,
    this.showEditButton = true,
    super.key,
  });

  final FinanceState state;
  final CreditCard card;
  final bool showEditButton;

  @override
  Widget build(BuildContext context) {
    final view = _CardPaymentViewModel.fromState(state, card.id);
    final taskId = state.cardPaymentTaskId(card.id);
    final task = state.financialTaskById(taskId);
    final reminder = state.taskReminderFor(taskId);
    final scheduledReminder =
        task == null ? null : state.scheduledTaskReminderFor(task);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(
              72,
            ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withAlpha(120),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    view.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
                if (showEditButton)
                  TextButton.icon(
                    onPressed: () => showCardMonthlyPaymentDialog(
                      context,
                      state: state,
                      card: card,
                    ),
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: Text(view.editLabel),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            if (view.showAmount) ...[
              Text(
                CurrencyFormatter.format(view.amount),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: AppSpacing.xs),
            ],
            Text(
              view.status,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: AppSpacing.sm),
            if (view.isEstimated)
              _EstimatedPaymentBreakdown(
                view: view,
                installments: state.monthlyInstallmentPaymentForCard(card.id),
              )
            else
              Text(
                'El monto capturado ya incluye las mensualidades MSI.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            if (view.canRemind && task != null) ...[
              const SizedBox(height: AppSpacing.md),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerLow
                      .withAlpha(140),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recordarme agregar el pago despues del corte',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        reminder == null || !reminder.enabled
                            ? 'Sin recordatorio activo.'
                            : 'Programado para ${scheduledReminder == null ? _formatDate(task.dueDate!) : _formatDateTime(scheduledReminder)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () => showCardPaymentReminderDialog(
                              context,
                              state: state,
                              card: card,
                            ),
                            icon: const Icon(Icons.notifications_outlined),
                            label: Text(
                              reminder == null || !reminder.enabled
                                  ? 'Activar recordatorio'
                                  : 'Editar recordatorio',
                            ),
                          ),
                          if (reminder != null && reminder.enabled)
                            TextButton(
                              onPressed: () async {
                                await state.configureCardPaymentReminder(
                                  card.id,
                                  enabled: false,
                                );
                              },
                              child: const Text('Quitar'),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _EstimatedPaymentBreakdown extends StatelessWidget {
  const _EstimatedPaymentBreakdown({
    required this.view,
    required this.installments,
    this.compact = true,
  });

  final _CardPaymentViewModel view;
  final double installments;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );

    if (view.isPending) {
      return Text(
        'No se ha capturado el total del estado de cuenta actual.',
        style: textStyle,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mensualidades MSI: ${CurrencyFormatter.format(installments)}',
          style: textStyle,
        ),
        SizedBox(height: compact ? AppSpacing.xs : 4),
        Text(
          'Total estimado provisional: ${CurrencyFormatter.format(view.amount)}',
          style: textStyle?.copyWith(fontWeight: FontWeight.w700),
        ),
        SizedBox(height: compact ? AppSpacing.xs : 4),
        Text(
          'Solo incluye las mensualidades MSI registradas. Captura el total del estado de cuenta cuando este disponible.',
          style: textStyle,
        ),
      ],
    );
  }
}

class _CardPaymentViewModel {
  const _CardPaymentViewModel({
    required this.title,
    required this.status,
    required this.amount,
    required this.showAmount,
    required this.isEstimated,
    required this.isPending,
    required this.canRemind,
    required this.editLabel,
  });

  final String title;
  final String status;
  final double amount;
  final bool showAmount;
  final bool isEstimated;
  final bool isPending;
  final bool canRemind;
  final String editLabel;

  static _CardPaymentViewModel fromState(FinanceState state, String cardId) {
    final source = state.cardMonthlyPaymentSource(cardId);
    final amount = state.cardMonthlyPaymentAmount(cardId);
    final isProvisional = state.isCardPaymentProvisional(cardId);

    if (source == CreditCardPaymentSource.manual) {
      return _CardPaymentViewModel(
        title: 'Pago para no generar intereses',
        status: 'Manual',
        amount: amount,
        showAmount: true,
        isEstimated: false,
        isPending: false,
        canRemind: false,
        editLabel: 'Editar',
      );
    }

    if (source == CreditCardPaymentSource.confirmed) {
      return _CardPaymentViewModel(
        title: 'Pago para no generar intereses',
        status: 'Confirmado',
        amount: amount,
        showAmount: true,
        isEstimated: false,
        isPending: false,
        canRemind: false,
        editLabel: 'Editar',
      );
    }

    if (isProvisional) {
      return _CardPaymentViewModel(
        title: 'Pago estimado provisional',
        status: 'Estimado',
        amount: amount,
        showAmount: true,
        isEstimated: true,
        isPending: false,
        canRemind: true,
        editLabel: 'Capturar',
      );
    }

    return const _CardPaymentViewModel(
      title: 'Pago para no generar intereses',
      status: 'Pendiente de capturar',
      amount: 0,
      showAmount: false,
      isEstimated: true,
      isPending: true,
      canRemind: true,
      editLabel: 'Capturar',
    );
  }
}

String _formatDate(DateTime value) {
  final normalized = DateTime(value.year, value.month, value.day);
  return '${normalized.day.toString().padLeft(2, '0')}/'
      '${normalized.month.toString().padLeft(2, '0')}/'
      '${normalized.year}';
}

String _formatDateTime(DateTime value) {
  return '${_formatDate(value)} '
      '${value.hour.toString().padLeft(2, '0')}:'
      '${value.minute.toString().padLeft(2, '0')}';
}

String _reminderModeLabel(TaskReminderMode mode) {
  return switch (mode) {
    TaskReminderMode.sameDay => 'El mismo dia',
    TaskReminderMode.oneDayBefore => '1 dia antes',
    TaskReminderMode.threeDaysBefore => '3 dias antes',
    TaskReminderMode.custom => 'Personalizado',
  };
}
