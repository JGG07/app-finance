import 'package:flutter/material.dart';

import '../../features/budgets/presentation/budgets_screen.dart';
import '../../features/cards/presentation/cards_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/plan/presentation/plan_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/transactions/presentation/transactions_screen.dart';
import '../../shared/presentation/app_scaffold.dart';

class AppRouter extends StatefulWidget {
  const AppRouter({super.key});

  @override
  State<AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends State<AppRouter> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      DashboardScreen(
        onViewPlan: () => setState(() => _selectedIndex = 4),
      ),
      const TransactionsScreen(),
      const BudgetsScreen(),
      const CardsScreen(),
      const PlanScreen(),
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
