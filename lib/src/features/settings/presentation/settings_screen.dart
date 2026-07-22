import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/state/finance_state.dart';
import '../../../core/state/finance_state_provider.dart';
import '../../../shared/presentation/app_design.dart';
import '../../notifications/domain/task_reminder.dart';
import '../../notifications/services/task_notification_scheduler.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = FinanceStateProvider.of(context);
    return AppScreen(
      children: [
        const AppHeader(
          title: 'Ajustes',
          subtitle: 'Preferencias y configuracion general de la app.',
        ),
        const SizedBox(height: AppSpacing.lg),
        _NotificationSettings(state: state),
        const SizedBox(height: AppSpacing.md),
        const _SettingsOption(
          icon: Icons.payments_outlined,
          title: 'Ingreso mensual',
          subtitle: 'Se edita desde Resumen financiero',
          status: 'Activo',
        ),
        const SizedBox(height: AppSpacing.md),
        const _SettingsOption(
          icon: Icons.category_outlined,
          title: 'Categorias',
          subtitle: 'Administra secciones desde Presupuesto',
          status: 'Presupuesto',
          color: AppColors.apartado,
        ),
        const SizedBox(height: AppSpacing.md),
        const _SettingsOption(
          icon: Icons.credit_card_outlined,
          title: 'Tarjetas',
          subtitle: 'Limites, cortes, pagos y compras',
          status: 'Tarjetas',
          color: AppColors.debt,
        ),
        const SizedBox(height: AppSpacing.md),
        const _SettingsOption(
          icon: Icons.currency_exchange,
          title: 'Moneda',
          subtitle: AppConstants.defaultCurrency,
          status: 'MXN',
        ),
        const SizedBox(height: AppSpacing.md),
        const _SettingsOption(
          icon: Icons.dark_mode_outlined,
          title: 'Tema',
          subtitle: 'Tema oscuro fintech',
          status: 'Oscuro',
          color: AppColors.primary,
        ),
        const SizedBox(height: AppSpacing.md),
        const _SettingsOption(
          icon: Icons.cloud_sync_outlined,
          title: 'Datos / respaldo',
          subtitle: 'Proximamente',
          status: 'Pendiente',
          color: AppColors.pending,
        ),
      ],
    );
  }
}

class _NotificationSettings extends StatelessWidget {
  const _NotificationSettings({required this.state});

  final FinanceState state;

  @override
  Widget build(BuildContext context) {
    final preferences = state.notificationPreferences;
    final permission = state.notificationPermissionStatus;
    final supported = permission != NotificationPermissionStatus.unsupported;
    final time = TimeOfDay(
      hour: preferences.defaultHour,
      minute: preferences.defaultMinute,
    );

    return AppCard(
      child: Material(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notificaciones y recordatorios',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Estado del permiso: ${_permissionLabel(permission)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text('Recordatorios de tareas'),
              subtitle: const Text(
                'Recibe avisos locales antes de tus fechas límite.',
              ),
              value: preferences.enabled && state.notificationsAvailable,
              onChanged: supported
                  ? (enabled) async {
                      if (!enabled) {
                        await state.setTaskRemindersEnabled(false);
                        return;
                      }
                      final granted = await state.enableTaskReminders();
                      if (!context.mounted || granted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Permiso de notificaciones denegado.'),
                        ),
                      );
                    }
                  : null,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.schedule_outlined),
              title: const Text('Hora predeterminada'),
              trailing: Text(time.format(context)),
              onTap: () async {
                final selected = await showTimePicker(
                  context: context,
                  initialTime: time,
                );
                if (selected != null) {
                  state.updateDefaultTaskReminder(
                    hour: selected.hour,
                    minute: selected.minute,
                  );
                }
              },
            ),
            DropdownButtonFormField<TaskReminderMode>(
              initialValue:
                  preferences.defaultReminderMode == TaskReminderMode.custom
                      ? TaskReminderMode.sameDay
                      : preferences.defaultReminderMode,
              decoration: const InputDecoration(
                labelText: 'Aviso predeterminado',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: TaskReminderMode.sameDay,
                  child: Text('El mismo día'),
                ),
                DropdownMenuItem(
                  value: TaskReminderMode.oneDayBefore,
                  child: Text('1 día antes'),
                ),
                DropdownMenuItem(
                  value: TaskReminderMode.threeDaysBefore,
                  child: Text('3 días antes'),
                ),
              ],
              onChanged: (mode) {
                if (mode != null) state.updateDefaultTaskReminder(mode: mode);
              },
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.tonalIcon(
                  onPressed: state.notificationsAvailable
                      ? state.showTestTaskNotification
                      : null,
                  icon: const Icon(Icons.notifications_active_outlined),
                  label: const Text('Enviar notificación de prueba'),
                ),
                OutlinedButton.icon(
                  onPressed:
                      supported ? state.openNotificationSystemSettings : null,
                  icon: const Icon(Icons.settings_outlined),
                  label: const Text('Abrir ajustes del sistema'),
                ),
              ],
            ),
            if (state.notificationError != null) ...[
              const SizedBox(height: 10),
              Text(
                state.notificationError!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static String _permissionLabel(NotificationPermissionStatus status) {
    return switch (status) {
      NotificationPermissionStatus.notConfigured => 'Sin configurar',
      NotificationPermissionStatus.granted => 'Permitido',
      NotificationPermissionStatus.denied => 'Denegado',
      NotificationPermissionStatus.blocked => 'Bloqueado por el sistema',
      NotificationPermissionStatus.unsupported => 'No compatible',
    };
  }
}

class _SettingsOption extends StatelessWidget {
  const _SettingsOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.status,
    this.color = AppColors.primary,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String status;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return FinancialListItem(
      icon: icon,
      iconColor: color,
      title: title,
      subtitle: subtitle,
      amount: '',
      status: StatusPill(label: status, color: color),
      onTap: () {},
    );
  }
}
