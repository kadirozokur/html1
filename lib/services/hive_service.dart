import 'package:hive_flutter/hive_flutter.dart';

import '../models/expense.dart';

class HiveService {
  HiveService._internal();

  static final HiveService instance = HiveService._internal();

  static const String expensesBoxName = 'expenses';

  late Box<Expense> _expensesBox;

  Box<Expense> get expensesBox => _expensesBox;

  Future<void> init() async {
    _expensesBox = await Hive.openBox<Expense>(expensesBoxName);
  }

  List<Expense> getAllExpenses() {
    return _expensesBox.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> addExpense(Expense expense) async {
    await _expensesBox.put(expense.id, expense);
  }
}

