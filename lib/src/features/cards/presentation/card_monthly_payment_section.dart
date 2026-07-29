import 'package:flutter/material.dart';

import '../../../core/state/finance_state.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../shared/presentation/app_design.dart';
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
    text: currentAmount.toStringAsFixed(2),
  );
  final formKey = GlobalKey<FormState>();
  var selectedSource = state.cardMonthlyPaymentSource(card.id);

  return showDialog<void>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          final estimated = state.estimatedCardMonthlyPayment(card.id);
          final installments = state.monthlyInstallmentPaymentForCard(card.id);
          final estimatedTotal = estimated + installments;

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
                          controller.text = estimatedTotal.toStringAsFixed(2);
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
                      labelText: 'Total del estado de cuenta',
                      helperText:
                          'Captura el total completo a pagar, incluyendo las mensualidades de compras a MSI.',
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
                  if (selectedSource == CreditCardPaymentSource.estimated) ...[
                    Text(
                      'Saldo corriente estimado: ${CurrencyFormatter.format(estimated)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Mensualidades MSI: ${CurrencyFormatter.format(installments)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Total estimado: ${CurrencyFormatter.format(estimatedTotal)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ] else ...[
                    Text(
                      'El total manual o confirmado ya debe incluir las mensualidades MSI.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
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
                    final amount =
                        selectedSource == CreditCardPaymentSource.estimated
                            ? estimatedTotal
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
    final source = state.cardMonthlyPaymentSource(card.id);
    final amount = state.cardMonthlyPaymentAmount(card.id);
    final estimated = state.estimatedCardMonthlyPayment(card.id);
    final installments = state.monthlyInstallmentPaymentForCard(card.id);
    final estimatedTotal = estimated + installments;

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
                    'Pago para no generar intereses',
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
                    label: const Text('Editar'),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              CurrencyFormatter.format(amount),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              creditCardPaymentSourceLabel(source),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: AppSpacing.sm),
            if (source == CreditCardPaymentSource.estimated) ...[
              Text(
                'Saldo corriente estimado: ${CurrencyFormatter.format(estimated)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Mensualidades MSI: ${CurrencyFormatter.format(installments)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Total estimado: ${CurrencyFormatter.format(estimatedTotal)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ] else ...[
              Text(
                'El monto capturado ya incluye las mensualidades MSI.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
