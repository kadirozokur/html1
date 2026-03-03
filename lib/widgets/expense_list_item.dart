import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../utils/constants.dart';

class ExpenseListItem extends StatelessWidget {
  final Expense expense;

  const ExpenseListItem({
    super.key,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final date = expense.date;
    final displayCategory =
        AppConstants.categoryDisplayNames[expense.category] ??
            expense.category;

    return Card(
      child: ListTile(
        title: Text(
          displayCategory,
          style: theme.textTheme.bodyLarge,
        ),
        subtitle: Text(
          '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}'
          '${expense.note != null && expense.note!.isNotEmpty ? ' • ${expense.note}' : ''}',
        ),
        trailing: Text(
          '₺ ${expense.amount.toStringAsFixed(2)}',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

