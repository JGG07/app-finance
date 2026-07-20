import '../../../features/dashboard/domain/surplus_plan.dart';
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
  );
}
