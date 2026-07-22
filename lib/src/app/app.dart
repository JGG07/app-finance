import 'dart:async';

import 'package:flutter/material.dart';

import '../core/database/app_database.dart';
import '../core/database/repositories/finance_repository.dart';
import '../core/state/finance_state.dart';
import '../core/state/finance_state_provider.dart';
import '../core/theme/app_theme.dart';
import '../features/notifications/services/local_task_notification_scheduler.dart';
import '../features/notifications/services/task_notification_scheduler.dart';
import 'app_startup_gate.dart';
import 'router/app_router.dart';

class AppFinance extends StatefulWidget {
  const AppFinance({
    this.enablePersistence = true,
    this.themeOverride,
    this.notificationScheduler,
    super.key,
  });

  final bool enablePersistence;
  final ThemeData? themeOverride;
  final TaskNotificationScheduler? notificationScheduler;

  @override
  State<AppFinance> createState() => _AppFinanceState();
}

class _AppFinanceState extends State<AppFinance> with WidgetsBindingObserver {
  FinanceRepository? _financeRepository;
  late final FinanceState _financeState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.enablePersistence) {
      final database = AppDatabase();
      final repository = FinanceRepository(database);
      _financeRepository = repository;
      _financeState = FinanceState(
        repository: repository,
        notificationScheduler:
            widget.notificationScheduler ?? LocalTaskNotificationScheduler(),
      );
      unawaited(_financeState.initialize());
    } else {
      _financeState = FinanceState(
        notificationScheduler: widget.notificationScheduler,
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        unawaited(_financeState.flushPendingSaves());
        break;
      case AppLifecycleState.resumed:
        unawaited(_financeState.refreshNotificationPermission());
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    final repository = _financeRepository;
    unawaited(
      _financeState.flushPendingSaves().whenComplete(() async {
        await repository?.close();
      }),
    );
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
        theme: widget.themeOverride ?? AppTheme.light,
        darkTheme: widget.themeOverride ?? AppTheme.dark,
        themeMode: ThemeMode.dark,
        home: AppStartupGate(
          financeState: _financeState,
          child: const AppRouter(),
        ),
      ),
    );
  }
}
