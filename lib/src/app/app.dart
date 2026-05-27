import 'package:flutter/material.dart';

import '../core/state/finance_state.dart';
import '../core/state/finance_state_provider.dart';
import '../core/theme/app_theme.dart';
import 'router/app_router.dart';

class AppFinance extends StatefulWidget {
  const AppFinance({super.key});

  @override
  State<AppFinance> createState() => _AppFinanceState();
}

class _AppFinanceState extends State<AppFinance> {
  late final FinanceState _financeState;

  @override
  void initState() {
    super.initState();
    _financeState = FinanceState();
  }

  @override
  void dispose() {
    _financeState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FinanceStateProvider(
      notifier: _financeState,
      child: MaterialApp(
        title: 'App Finance',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.dark,
        home: const AppRouter(),
      ),
    );
  }
}
