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
}

