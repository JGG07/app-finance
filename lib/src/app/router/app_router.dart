import 'package:flutter/material.dart';

import '../../features/budgets/presentation/budgets_screen.dart';
import '../../features/cards/presentation/cards_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/plan/presentation/plan_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/transactions/presentation/transactions_screen.dart';
import '../../core/state/finance_state_provider.dart';
import '../../shared/presentation/app_scaffold.dart';

class AppRouter extends StatefulWidget {
  const AppRouter({super.key});

  @override
  State<AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends State<AppRouter> {
  int _selectedIndex = 0;
  String? _highlightedTaskId;
  String? _pendingPaymentCardId;

  @override
  Widget build(BuildContext context) {
    final state = FinanceStateProvider.of(context);
    final requestedTaskId = state.pendingTaskNavigationId;
    if (requestedTaskId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {
          _selectedIndex = 4;
          _highlightedTaskId = requestedTaskId;
        });
        state.consumePendingTaskNavigation();
      });
    }
    final requestedCardId = state.pendingCardPaymentNavigationId;
    if (requestedCardId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {
          _selectedIndex = 3;
          _pendingPaymentCardId = requestedCardId;
        });
        state.consumePendingCardPaymentNavigation();
      });
    }
    final screens = <Widget>[
      DashboardScreen(
        onViewDebts: () => setState(() => _selectedIndex = 3),
        onViewApartados: () => setState(() => _selectedIndex = 2),
        onViewPlan: () => setState(() => _selectedIndex = 4),
      ),
      const TransactionsScreen(),
      const BudgetsScreen(),
      CardsScreen(
        pendingPaymentCardId: _pendingPaymentCardId,
        onPendingPaymentHandled: () {
          if (!mounted || _pendingPaymentCardId == null) return;
          setState(() => _pendingPaymentCardId = null);
        },
      ),
      PlanScreen(highlightedTaskId: _highlightedTaskId),
    ];

    return AppScaffold(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) {
        setState(() => _selectedIndex = index);
      },
      onSettingsSelected: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => Scaffold(
              appBar: AppBar(),
              body: const SettingsScreen(),
            ),
          ),
        );
      },
      child: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
    );
  }
}
