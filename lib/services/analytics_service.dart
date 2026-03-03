import '../models/expense.dart';
import '../utils/date_utils.dart';

class AnalyticsService {
  const AnalyticsService();

  double calculateMonthlyTotal(List<Expense> expenses, DateTime month) {
    final monthRange = DateRangeUtils.monthRange(month);
    return expenses
        .where((e) =>
            !e.date.isBefore(monthRange.start) &&
            !e.date.isAfter(monthRange.end))
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  double calculateWeeklyTotal(List<Expense> expenses, DateTime now) {
    final weekRange = DateRangeUtils.weekRange(now);
    return expenses
        .where(
          (e) =>
              !e.date.isBefore(weekRange.start) &&
              !e.date.isAfter(weekRange.end),
        )
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  double calculateDailyAverage(List<Expense> expenses, DateTime month) {
    final monthRange = DateRangeUtils.monthRange(month);
    final total = calculateMonthlyTotal(expenses, month);
    final daysInMonth =
        monthRange.end.difference(monthRange.start).inDays + 1;
    if (daysInMonth <= 0) return 0;
    return total / daysInMonth;
  }

  Map<DateTime, double> getWeeklyGroupedExpenses(
    List<Expense> expenses,
    DateTime now,
  ) {
    final Map<DateTime, double> result = {};
    final last7Days = DateRangeUtils.lastNDays(now, 7);

    for (final day in last7Days) {
      result[day] = 0.0;
    }

    for (final expense in expenses) {
      final dateOnly = DateRangeUtils.dateOnly(expense.date);
      if (result.containsKey(dateOnly)) {
        result[dateOnly] = (result[dateOnly] ?? 0) + expense.amount;
      }
    }
    return result;
  }

  Map<String, double> getCategoryDistribution(
    List<Expense> expenses,
    DateTime month,
  ) {
    final monthRange = DateRangeUtils.monthRange(month);
    final Map<String, double> result = {};

    for (final e in expenses) {
      if (e.date.isBefore(monthRange.start) || e.date.isAfter(monthRange.end)) {
        continue;
      }
      result[e.category] = (result[e.category] ?? 0) + e.amount;
    }
    return result;
  }
}

