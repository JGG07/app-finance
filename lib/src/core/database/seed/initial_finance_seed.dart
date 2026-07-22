import '../../../features/dashboard/domain/surplus_plan.dart';
import '../../../features/notifications/domain/notification_preferences.dart';
import '../finance_snapshot.dart';

FinanceSnapshot initialFinanceSeed({
  SurplusPlanType planType = SurplusPlanType.unconfigured,
}) {
  return FinanceSnapshot(
    monthlyIncome: 0,
    categories: [],
    transactions: [],
    plannedExpenses: [],
    creditCards: [],
    creditCardPurchases: [],
    subscriptions: [],
    cardMonthlyPayments: [],
    monthlyExtras: [],
    surplusPlan: SurplusPlan(type: planType),
    manualTasks: [],
    taskOverrides: {},
    notificationPreferences: const NotificationPreferences(),
    taskReminders: [],
    tandas: [],
    tandaContributions: [],
    tandaReceipts: [],
  );
}
