import 'package:flutter/material.dart';

import 'finance_state.dart';

class FinanceStateProvider extends InheritedNotifier<FinanceState> {
  const FinanceStateProvider({
    required super.child,
    super.notifier,
    super.key,
  });

  static FinanceState of(BuildContext context, {bool listen = true}) {
    if (listen) {
      final provider =
          context.dependOnInheritedWidgetOfExactType<FinanceStateProvider>();
      assert(provider != null, 'No FinanceStateProvider found in context');
      return provider!.notifier!;
    } else {
      final element = context
          .getElementForInheritedWidgetOfExactType<FinanceStateProvider>();
      assert(element != null, 'No FinanceStateProvider found in context');
      final provider = element!.widget as FinanceStateProvider;
      return provider.notifier!;
    }
  }
}
