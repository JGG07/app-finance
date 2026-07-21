import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../shared/presentation/app_design.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScreen(
      children: [
        AppHeader(
          title: 'Ajustes',
          subtitle: 'Preferencias y configuracion general de la app.',
        ),
        SizedBox(height: AppSpacing.lg),
        _SettingsOption(
          icon: Icons.payments_outlined,
          title: 'Ingreso mensual',
          subtitle: 'Se edita desde Resumen financiero',
          status: 'Activo',
        ),
        SizedBox(height: AppSpacing.md),
        _SettingsOption(
          icon: Icons.category_outlined,
          title: 'Categorias',
          subtitle: 'Administra secciones desde Presupuesto',
          status: 'Presupuesto',
          color: AppColors.apartado,
        ),
        SizedBox(height: AppSpacing.md),
        _SettingsOption(
          icon: Icons.credit_card_outlined,
          title: 'Tarjetas',
          subtitle: 'Limites, cortes, pagos y compras',
          status: 'Tarjetas',
          color: AppColors.debt,
        ),
        SizedBox(height: AppSpacing.md),
        _SettingsOption(
          icon: Icons.currency_exchange,
          title: 'Moneda',
          subtitle: AppConstants.defaultCurrency,
          status: 'MXN',
        ),
        SizedBox(height: AppSpacing.md),
        _SettingsOption(
          icon: Icons.dark_mode_outlined,
          title: 'Tema',
          subtitle: 'Tema oscuro fintech',
          status: 'Oscuro',
          color: AppColors.primary,
        ),
        SizedBox(height: AppSpacing.md),
        _SettingsOption(
          icon: Icons.cloud_sync_outlined,
          title: 'Datos / respaldo',
          subtitle: 'Proximamente',
          status: 'Pendiente',
          color: AppColors.pending,
        ),
        SizedBox(height: AppSpacing.md),
        _SettingsOption(
          icon: Icons.tune_outlined,
          title: 'Preferencias',
          subtitle: 'Alertas y privacidad proximamente',
          status: 'Pronto',
          color: AppColors.investment,
        ),
      ],
    );
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
