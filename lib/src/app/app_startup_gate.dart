import 'package:flutter/material.dart';

import '../core/state/finance_state.dart';
import '../features/dashboard/domain/surplus_plan.dart';
import '../shared/presentation/app_design.dart';

class AppStartupGate extends StatelessWidget {
  const AppStartupGate({
    required this.financeState,
    required this.child,
    super.key,
  });

  final FinanceState financeState;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: financeState,
      builder: (context, _) {
        if (financeState.isLoading) {
          return const _StartupLoadingScreen();
        }

        if (!financeState.isInitialized) {
          final loadError = financeState.loadError;
          if (loadError != null) {
            return _StartupErrorScreen(
              error: loadError,
              onRetry: financeState.initialize,
            );
          }

          return const _StartupLoadingScreen();
        }

        if (financeState.surplusPlan.type == SurplusPlanType.unconfigured) {
          return _PlanSetupScreen(financeState: financeState);
        }

        return _StartupReadyScreen(
          financeState: financeState,
          child: child,
        );
      },
    );
  }
}

class _PlanSetupScreen extends StatelessWidget {
  const _PlanSetupScreen({required this.financeState});

  final FinanceState financeState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: AppCard(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                child: Column(
                  children: [
                    const AppIconBubble(
                      icon: Icons.savings_outlined,
                      color: AppColors.primary,
                      size: 64,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      'Como quieres organizar tu dinero?',
                      textAlign: TextAlign.center,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w900,
                              ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Puedes comenzar con un plan de ahorro e inversion o mantener todo el sobrante como dinero libre. Podras cambiarlo despues desde Plan.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.45,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => financeState.updateSurplusPlan(
                          SurplusPlanType.balanced,
                        ),
                        icon: const Icon(Icons.trending_up_rounded),
                        label: const Text('Quiero un plan de ahorro'),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => financeState.updateSurplusPlan(
                          SurplusPlanType.none,
                        ),
                        icon: const Icon(
                          Icons.account_balance_wallet_outlined,
                        ),
                        label: const Text('Prefiero continuar sin plan'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StartupReadyScreen extends StatelessWidget {
  const _StartupReadyScreen({
    required this.financeState,
    required this.child,
  });

  final FinanceState financeState;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final saveError = financeState.saveError;
    if (saveError == null) {
      return child;
    }

    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        MaterialBanner(
          backgroundColor: colorScheme.errorContainer,
          leading: Icon(
            Icons.sync_problem_rounded,
            color: colorScheme.onErrorContainer,
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'No pudimos guardar tus cambios',
                style: TextStyle(
                  color: colorScheme.onErrorContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Tus cambios siguen en esta sesion. Reintenta antes de cerrar la app.',
                style: TextStyle(color: colorScheme.onErrorContainer),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                saveError,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onErrorContainer,
                    ),
              ),
            ],
          ),
          actions: [
            TextButton.icon(
              onPressed:
                  financeState.isRetryingSave ? null : financeState.retrySave,
              icon: financeState.isRetryingSave
                  ? const SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.refresh_rounded),
              label: Text(
                financeState.isRetryingSave ? 'Guardando' : 'Reintentar',
              ),
            ),
          ],
        ),
        Expanded(child: child),
      ],
    );
  }
}

class _StartupLoadingScreen extends StatelessWidget {
  const _StartupLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _StartupLayout(
        icon: CircularProgressIndicator(),
        title: 'Cargando tus finanzas',
        message: 'Estamos preparando tu informacion guardada.',
      ),
    );
  }
}

class _StartupErrorScreen extends StatelessWidget {
  const _StartupErrorScreen({
    required this.error,
    required this.onRetry,
  });

  final String error;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _StartupLayout(
        icon: const AppIconBubble(
          icon: Icons.cloud_off_rounded,
          color: AppColors.danger,
          size: 52,
        ),
        title: 'No pudimos cargar tus datos',
        message:
            'No hicimos ningun cambio. Revisa el detalle e intenta de nuevo.',
        detail: error,
        action: FilledButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Reintentar'),
        ),
      ),
    );
  }
}

class _StartupLayout extends StatelessWidget {
  const _StartupLayout({
    required this.icon,
    required this.title,
    required this.message,
    this.detail,
    this.action,
  });

  final Widget icon;
  final String title;
  final String message;
  final String? detail;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                const SizedBox(height: AppSpacing.xxl),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: textTheme.headlineSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                if (detail != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadii.md),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      detail!,
                      textAlign: TextAlign.center,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
                if (action != null) ...[
                  const SizedBox(height: AppSpacing.xxl),
                  action!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
