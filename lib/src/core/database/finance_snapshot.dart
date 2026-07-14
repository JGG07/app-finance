import '../../features/budgets/domain/budget_category.dart';
import '../../features/budgets/domain/monthly_extra.dart';
import '../../features/cards/domain/credit_card.dart';
import '../../features/cards/domain/credit_card_monthly_payment.dart';
import '../../features/cards/domain/credit_card_purchase.dart';
import '../../features/dashboard/domain/surplus_plan.dart';
import '../../features/planning/domain/planned_expense.dart';
import '../../features/subscriptions/domain/subscription_entry.dart';
import '../../features/tasks/domain/financial_task.dart';
import '../../features/transactions/domain/transaction_entry.dart';

class FinanceSnapshot {
  const FinanceSnapshot({
    required this.monthlyIncome,
    required this.categories,
    required this.transactions,
    required this.plannedExpenses,
    required this.creditCards,
    required this.creditCardPurchases,
    required this.subscriptions,
    required this.cardMonthlyPayments,
    required this.monthlyExtras,
    required this.surplusPlan,
    required this.manualTasks,
    required this.taskOverrides,
  });

  final double monthlyIncome;
  final List<BudgetCategory> categories;
  final List<TransactionEntry> transactions;
  final List<PlannedExpense> plannedExpenses;
  final List<CreditCard> creditCards;
  final List<CreditCardPurchase> creditCardPurchases;
  final List<SubscriptionEntry> subscriptions;
  final List<CreditCardMonthlyPayment> cardMonthlyPayments;
  final List<MonthlyExtra> monthlyExtras;
  final SurplusPlan surplusPlan;
  final List<FinancialTask> manualTasks;
  final Map<String, FinancialTaskOverride> taskOverrides;
}
