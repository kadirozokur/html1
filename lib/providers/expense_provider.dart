import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/expense.dart';
import '../services/analytics_service.dart';
import '../services/hive_service.dart';

class ExpenseProvider extends ChangeNotifier {
  ExpenseProvider();

  final _hiveService = HiveService.instance;
  final _analytics = const AnalyticsService();
  final _uuid = const Uuid();

  final List<Expense> _expenses = [];

  ThemeMode _themeMode = ThemeMode.system;

  List<Expense> get expenses => List.unmodifiable(_expenses);

  ThemeMode get themeMode => _themeMode;

  Future<void> loadExpenses() async {
    _expenses
      ..clear()
      ..addAll(_hiveService.getAllExpenses());
    notifyListeners();
  }

  Future<void> addExpense({
    required double amount,
    required String category,
    required DateTime date,
    String? note,
  }) async {
    final expense = Expense(
      id: _uuid.v4(),
      amount: amount,
      category: category,
      date: date,
      note: note,
    );
    await _hiveService.addExpense(expense);
    _expenses.insert(0, expense);
    notifyListeners();
  }

  void toggleThemeMode() {
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
    } else if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.dark;
    }
    notifyListeners();
  }

  double get monthlyTotal =>
      _analytics.calculateMonthlyTotal(_expenses, DateTime.now());

  double get weeklyTotal =>
      _analytics.calculateWeeklyTotal(_expenses, DateTime.now());

  double get dailyAverage =>
      _analytics.calculateDailyAverage(_expenses, DateTime.now());

  Map<DateTime, double> get weeklyGroupedExpenses =>
      _analytics.getWeeklyGroupedExpenses(_expenses, DateTime.now());

  Map<String, double> get categoryDistribution =>
      _analytics.getCategoryDistribution(_expenses, DateTime.now());

  List<Expense> get recentExpenses {
    final list = List<Expense>.from(_expenses);
    list.sort((a, b) => b.date.compareTo(a.date));
    if (list.length <= 10) return list;
    return list.sublist(0, 10);
  }

  List<Expense> getExpensesByCategory(String categoryId) {
    return _expenses
        .where((expense) => expense.categoryId == categoryId)
        .toList();
  }

  List<Expense> getExpensesByDateRange(DateTime start, DateTime end) {
    return _expenses
        .where(
          (expense) =>
              !expense.date.isBefore(start) && !expense.date.isAfter(end),
        )
        .toList();
  }

  List<Expense> get thisWeekExpenses {
    final now = DateTime.now();
    final weekday = now.weekday; // 1 = Monday, 7 = Sunday
    final startOfWeek = DateTime(
      now.year,
      now.month,
      now.day - (weekday - 1),
    );
    return getExpensesByDateRange(startOfWeek, now);
  }

  List<Expense> get thisMonthExpenses {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    return getExpensesByDateRange(startOfMonth, now);
  }

  Map<String, List<Expense>> get expensesGroupedByCategory {
    final Map<String, List<Expense>> grouped = {};
    for (final expense in _expenses) {
      final key = expense.categoryId ?? expense.category;
      final list = grouped.putIfAbsent(key, () => <Expense>[]);
      list.add(expense);
    }
    return grouped;
  }

  Map<String, double> get totalByCategory {
    final Map<String, double> totals = {};
    for (final expense in _expenses) {
      final key = expense.categoryId ?? expense.category;
      totals[key] = (totals[key] ?? 0) + expense.amount;
    }
    return totals;
  }
}

