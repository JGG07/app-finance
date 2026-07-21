import 'package:flutter/material.dart';

import '../../../core/state/finance_state.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../shared/presentation/app_design.dart';
import '../domain/tanda.dart';
import '../domain/tanda_contribution.dart';
import '../domain/tanda_contribution_link.dart';
import '../domain/tanda_receipt.dart';
import '../domain/tanda_receipt_link.dart';

class TandasSection extends StatelessWidget {
  const TandasSection({required this.state, super.key});

  final FinanceState state;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tandas',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Organiza tus aportaciones y consulta tu turno.',
                    ),
                  ],
                ),
              ),
              AppButton(
                label: 'Nueva tanda',
                icon: Icons.add,
                onPressed: () => _showForm(context),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Cada aportacion registrada se agrega automaticamente a tus movimientos como gasto.\n'
            'La recepcion de la tanda todavia no se registra automaticamente como ingreso.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 16),
          if (state.tandas.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: Text('Aun no tienes tandas registradas.')),
            )
          else ...[
            ...state.activeTandas.map((tanda) => _card(context, tanda)),
            if (state.inactiveTandas.isNotEmpty)
              ExpansionTile(
                title: const Text('Completadas y canceladas'),
                children: state.inactiveTandas
                    .map((tanda) => _card(context, tanda))
                    .toList(),
              ),
          ],
        ],
      ),
    );
  }

  Widget _card(BuildContext context, Tanda tanda) {
    final contributions = state.contributionsForTanda(tanda.id);
    final paid = state.paidContributionsForTanda(tanda.id);
    final next = state.nextPendingContributionForTanda(tanda.id);
    final progress =
        contributions.isEmpty ? 0.0 : paid.length / contributions.length;
    final color = switch (tanda.status) {
      TandaStatus.active => AppColors.primary,
      TandaStatus.completed => Colors.blueAccent,
      TandaStatus.cancelled => AppColors.textSecondary,
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceSoft,
          borderRadius: BorderRadius.circular(AppRadii.lg),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    tanda.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
                StatusPill(label: _status(tanda.status), color: color),
                PopupMenuButton<String>(
                  onSelected: (action) {
                    if (action == 'edit') _showForm(context, tanda: tanda);
                    if (action == 'cancel') state.cancelTanda(tanda.id);
                    if (action == 'delete') _confirmDelete(context, tanda);
                  },
                  itemBuilder: (_) => [
                    if (!tanda.isCompleted &&
                        tanda.status != TandaStatus.cancelled)
                      const PopupMenuItem(value: 'edit', child: Text('Editar')),
                    if (tanda.isActive)
                      const PopupMenuItem(
                        value: 'cancel',
                        child: Text('Cancelar'),
                      ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Eliminar'),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              '${CurrencyFormatter.format(tanda.contributionAmount)} · ${_frequency(tanda.frequency)}',
            ),
            const SizedBox(height: 10),
            Text(
              '${paid.length} de ${contributions.length} aportaciones',
            ),
            const SizedBox(height: 6),
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 10),
            Wrap(
              spacing: 18,
              runSpacing: 6,
              children: [
                Text(
                  'Aportado: ${CurrencyFormatter.format(paid.fold<double>(0, (sum, item) => sum + item.amount))}',
                ),
                Text(
                  'Esperado: ${CurrencyFormatter.format(tanda.totalExpectedAmount)}',
                ),
                Text(
                  'Turno ${tanda.assignedTurn} de ${tanda.participantCount}',
                ),
                Text('Recibes: ${_date(tanda.estimatedReceiveDate)}'),
                Text(
                  'Proxima: ${next == null ? 'Sin pendientes' : _date(next.scheduledDate)}',
                ),
              ],
            ),
            if (tanda.notes?.isNotEmpty ?? false) ...[
              const SizedBox(height: 8),
              Text(tanda.notes!, style: Theme.of(context).textTheme.bodySmall),
            ],
            const SizedBox(height: 12),
            _receiptPanel(context, tanda),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: [
                TextButton.icon(
                  onPressed: () => _showContributions(context, tanda),
                  icon: const Icon(Icons.receipt_long, size: 18),
                  label: const Text('Ver aportaciones'),
                ),
                if (tanda.isActive)
                  FilledButton.icon(
                    onPressed: () =>
                        state.markNextTandaContributionPaid(tanda.id),
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('Registrar aportacion'),
                  ),
                if (paid.isNotEmpty && tanda.status != TandaStatus.cancelled)
                  TextButton.icon(
                    onPressed: () => state.undoLastTandaContribution(tanda.id),
                    icon: const Icon(Icons.undo, size: 18),
                    label: const Text('Deshacer aportacion'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _receiptPanel(BuildContext context, Tanda tanda) {
    final receipt = state.receiptForTanda(tanda.id);
    if (receipt == null) return const SizedBox.shrink();
    final linkStatus = state.tandaReceiptLinkStatus(receipt);
    final statusText = switch (linkStatus) {
      TandaReceiptLinkStatus.notReceived => 'Recepcion pendiente',
      TandaReceiptLinkStatus.linked => 'Recepcion registrada',
      TandaReceiptLinkStatus.missingTransaction => 'Ingreso vinculado faltante',
      TandaReceiptLinkStatus.unlinkedReceived =>
        'Recepcion sin ingreso asociado',
    };
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recepcion de la tanda',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          Text(statusText),
          Text('Esperada para: ${_date(receipt.scheduledDate)}'),
          Text(
            'Monto esperado: ${CurrencyFormatter.format(receipt.amount)}',
          ),
          if (receipt.receivedAt != null)
            Text('Fecha real: ${_date(receipt.receivedAt!)}'),
          if (linkStatus == TandaReceiptLinkStatus.linked)
            const Text('Ingreso agregado a Movimientos'),
          const SizedBox(height: 6),
          if (linkStatus == TandaReceiptLinkStatus.notReceived &&
              tanda.status != TandaStatus.cancelled)
            TextButton(
              onPressed: () => _showReceiptDialog(context, tanda, receipt),
              child: const Text('Registrar recepcion'),
            ),
          if (linkStatus == TandaReceiptLinkStatus.linked)
            TextButton(
              onPressed: () => _confirmUndoReceipt(context, tanda),
              child: const Text('Deshacer recepcion'),
            ),
          if (linkStatus == TandaReceiptLinkStatus.missingTransaction)
            TextButton(
              onPressed: () => state.linkReceivedTandaReceiptToTransaction(
                receiptId: receipt.id,
              ),
              child: const Text('Recrear ingreso'),
            ),
          if (linkStatus == TandaReceiptLinkStatus.unlinkedReceived)
            TextButton(
              onPressed: () => state.linkReceivedTandaReceiptToTransaction(
                receiptId: receipt.id,
              ),
              child: const Text('Registrar como ingreso'),
            ),
        ],
      ),
    );
  }

  Future<void> _showReceiptDialog(
    BuildContext context,
    Tanda tanda,
    TandaReceipt receipt,
  ) async {
    var selectedDate = DateTime.now();
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Registrar recepcion'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Monto: ${CurrencyFormatter.format(receipt.amount)}'),
              Text('Fecha estimada: ${_date(receipt.scheduledDate)}'),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Fecha real'),
                subtitle: Text(_date(selectedDate)),
                onTap: () async {
                  final selected = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (selected != null) {
                    setDialogState(() => selectedDate = selected);
                  }
                },
              ),
              if (selectedDate.isBefore(receipt.scheduledDate))
                const Text(
                  'La fecha seleccionada es anterior a tu turno estimado.',
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                state.markTandaReceiptReceived(
                  tandaId: tanda.id,
                  receivedAt: selectedDate,
                );
                Navigator.pop(context);
              },
              child: const Text('Confirmar recepcion'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmUndoReceipt(BuildContext context, Tanda tanda) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deshacer recepcion'),
        content: const Text(
          'Se eliminara unicamente el ingreso vinculado. Las aportaciones permaneceran intactas.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Deshacer recepcion'),
          ),
        ],
      ),
    );
    if (confirmed ?? false) state.undoTandaReceipt(tanda.id);
  }

  Future<void> _showForm(BuildContext context, {Tanda? tanda}) async {
    final name = TextEditingController(text: tanda?.name ?? '');
    final amount = TextEditingController(
      text: tanda?.contributionAmount.toStringAsFixed(2) ?? '',
    );
    final participants = TextEditingController(
      text: tanda?.participantCount.toString() ?? '',
    );
    final turn =
        TextEditingController(text: tanda?.assignedTurn.toString() ?? '');
    final notes = TextEditingController(text: tanda?.notes ?? '');
    final formKey = GlobalKey<FormState>();
    var frequency = tanda?.frequency ?? TandaFrequency.biweekly;
    var startDate = tanda?.startDate ?? DateTime.now();
    final hasPaid =
        tanda != null && state.paidContributionsForTanda(tanda.id).isNotEmpty;
    final hasReceived =
        tanda != null && (state.receiptForTanda(tanda.id)?.isReceived ?? false);

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) {
          Tanda? preview;
          try {
            preview = Tanda(
              id: 'preview',
              name: name.text,
              contributionAmount: double.parse(amount.text),
              frequency: frequency,
              startDate: startDate,
              participantCount: int.parse(participants.text),
              assignedTurn: int.parse(turn.text),
              completedContributions: tanda?.completedContributions ?? 0,
              status: tanda?.status ?? TandaStatus.active,
              createdAt: tanda?.createdAt ?? DateTime.now(),
            );
          } catch (_) {}

          return AlertDialog(
            title: Text(tanda == null ? 'Nueva tanda' : 'Editar tanda'),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _field(name, 'Nombre', setState),
                    _field(
                      amount,
                      'Monto por aportacion',
                      setState,
                      numeric: true,
                      enabled: !hasPaid && !hasReceived,
                    ),
                    DropdownButtonFormField<TandaFrequency>(
                      initialValue: frequency,
                      decoration:
                          const InputDecoration(labelText: 'Frecuencia'),
                      items: TandaFrequency.values
                          .map(
                            (value) => DropdownMenuItem(
                              value: value,
                              child: Text(_frequency(value)),
                            ),
                          )
                          .toList(),
                      onChanged: hasPaid || hasReceived
                          ? null
                          : (value) => setState(() => frequency = value!),
                    ),
                    _field(
                      participants,
                      'Participantes',
                      setState,
                      numeric: true,
                      enabled: !hasPaid && !hasReceived,
                    ),
                    _field(
                      turn,
                      'Turno asignado',
                      setState,
                      numeric: true,
                      enabled: !hasReceived,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Fecha de inicio'),
                      subtitle: Text(_date(startDate)),
                      onTap: hasPaid || hasReceived
                          ? null
                          : () async {
                              final selected = await showDatePicker(
                                context: context,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                initialDate: startDate,
                              );
                              if (selected != null) {
                                setState(() => startDate = selected);
                              }
                            },
                    ),
                    TextFormField(
                      controller: notes,
                      decoration: const InputDecoration(labelText: 'Notas'),
                    ),
                    if (hasPaid) ...[
                      const SizedBox(height: 12),
                      const Text(
                        'No puedes modificar el calendario o el monto porque ya existen aportaciones registradas.',
                      ),
                    ],
                    if (hasReceived) ...[
                      const SizedBox(height: 12),
                      const Text(
                        'No puedes modificar el monto, calendario o turno porque la recepcion ya fue registrada.',
                      ),
                    ],
                    if (preview != null) ...[
                      const SizedBox(height: 14),
                      Text(
                        'Recibiras aproximadamente: ${CurrencyFormatter.format(preview.totalExpectedAmount)}',
                      ),
                      Text(
                        'Fecha estimada de recepcion: ${_date(preview.estimatedReceiveDate)}',
                      ),
                      Text(
                        'Total de aportaciones: ${preview.participantCount}',
                      ),
                    ],
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () {
                  try {
                    final contribution = double.parse(amount.text.trim());
                    final count = int.parse(participants.text.trim());
                    final assigned = int.parse(turn.text.trim());
                    if (tanda == null) {
                      state.addTanda(
                        name: name.text,
                        contributionAmount: contribution,
                        frequency: frequency,
                        startDate: startDate,
                        participantCount: count,
                        assignedTurn: assigned,
                        notes: notes.text,
                      );
                    } else {
                      state.updateTanda(
                        tanda.id,
                        name: name.text,
                        contributionAmount: contribution,
                        frequency: frequency,
                        startDate: startDate,
                        participantCount: count,
                        assignedTurn: assigned,
                        notes: notes.text,
                      );
                    }
                    Navigator.pop(context);
                  } catch (error) {
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      SnackBar(
                        content: Text(
                          error is ArgumentError
                              ? error.message.toString()
                              : error is StateError
                                  ? error.message
                                  : 'Revisa los campos numericos.',
                        ),
                      ),
                    );
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          );
        },
      ),
    );
  }

  TextFormField _field(
    TextEditingController controller,
    String label,
    StateSetter refresh, {
    bool numeric = false,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: numeric ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(labelText: label),
      enabled: enabled,
      onChanged: (_) => refresh(() {}),
      validator: (value) =>
          value == null || value.trim().isEmpty ? 'Campo obligatorio' : null,
    );
  }

  Future<void> _showContributions(BuildContext context, Tanda tanda) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final contributions = state.contributionsForTanda(tanda.id);
        final next = state.nextPendingContributionForTanda(tanda.id);
        return SafeArea(
          child: FractionallySizedBox(
            heightFactor: 0.8,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Aportaciones de ${tanda.name}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      itemCount: contributions.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final contribution = contributions[index];
                        return _contributionTile(
                          context,
                          contribution,
                          total: contributions.length,
                          highlighted: contribution.id == next?.id,
                        );
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

  Widget _contributionTile(
    BuildContext context,
    TandaContribution contribution, {
    required int total,
    required bool highlighted,
  }) {
    final linkStatus = state.tandaContributionLinkStatus(contribution);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: contribution.isPaid
            ? AppColors.primary.withValues(alpha: 0.12)
            : AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(
          color: highlighted ? AppColors.primary : AppColors.border,
          width: highlighted ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Aportacion ${contribution.sequenceNumber} de $total',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              StatusPill(
                label: contribution.isPaid ? 'Pagada' : 'Pendiente',
                color: contribution.isPaid
                    ? AppColors.primary
                    : AppColors.textSecondary,
              ),
            ],
          ),
          Text(CurrencyFormatter.format(contribution.amount)),
          Text('Programada: ${_date(contribution.scheduledDate)}'),
          if (contribution.paidAt != null)
            Text('Registrada: ${_date(contribution.paidAt!)}'),
          if (contribution.migratedFromLegacyCounter &&
              contribution.paidAt == null)
            const Text('Registro migrado · fecha real desconocida'),
          if (contribution.migratedFromLegacyCounter)
            const Text('Registro migrado'),
          if (linkStatus == TandaContributionLinkStatus.linked)
            const Text('Movimiento registrado'),
          if (linkStatus == TandaContributionLinkStatus.unlinkedPaid)
            const Text('Sin movimiento asociado'),
          if (linkStatus == TandaContributionLinkStatus.missingTransaction)
            const Text('Movimiento faltante'),
          if (linkStatus == TandaContributionLinkStatus.unlinkedPaid ||
              linkStatus == TandaContributionLinkStatus.missingTransaction)
            TextButton(
              onPressed: () => _linkContribution(context, contribution),
              child: Text(
                linkStatus == TandaContributionLinkStatus.missingTransaction
                    ? 'Recrear movimiento'
                    : 'Registrar como movimiento',
              ),
            ),
          if (highlighted)
            const Text(
              'Siguiente aportacion',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
        ],
      ),
    );
  }

  Future<void> _linkContribution(
    BuildContext context,
    TandaContribution contribution,
  ) async {
    final paidAt = contribution.paidAt ??
        await showDatePicker(
          context: context,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          initialDate: DateTime.now(),
          helpText: 'Fecha real del pago',
        );
    if (paidAt == null || !context.mounted) return;
    try {
      state.linkPaidTandaContributionToTransaction(
        contributionId: contribution.id,
        paidAt: paidAt,
      );
      Navigator.pop(context);
    } on Object catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  Future<void> _confirmDelete(BuildContext context, Tanda tanda) async {
    final deleteLinkedTransactions = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar tanda'),
        content: Text(
          'Se eliminara "${tanda.name}" y sus aportaciones. '
          'Puedes conservar los gastos de aportaciones y el ingreso de recepcion '
          'como historial independiente, o eliminar solo los movimientos vinculados.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar todo'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Eliminar y conservar movimientos'),
          ),
        ],
      ),
    );
    if (deleteLinkedTransactions != null) {
      state.deleteTanda(
        tanda.id,
        deleteLinkedTransactions: deleteLinkedTransactions,
      );
    }
  }

  static String _date(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  static String _frequency(TandaFrequency value) => switch (value) {
        TandaFrequency.weekly => 'Semanal',
        TandaFrequency.biweekly => 'Quincenal',
        TandaFrequency.monthly => 'Mensual',
      };
  static String _status(TandaStatus value) => switch (value) {
        TandaStatus.active => 'Activa',
        TandaStatus.completed => 'Completada',
        TandaStatus.cancelled => 'Cancelada',
      };
}
