import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/expense_provider.dart';
import '../screens/add_expense_screen.dart';
import '../utils/constants.dart';
import '../widgets/category_pie_chart.dart';
import '../widgets/expense_list_item.dart';
import '../widgets/summary_card.dart';
import '../widgets/weekly_bar_chart.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Harcamalar'),
        actions: [
          IconButton(
            onPressed: () => provider.toggleThemeMode(),
            icon: Icon(
              provider.themeMode == ThemeMode.dark
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            tooltip: 'Tema değiştir',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.pagePadding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top summary
              Row(
                children: [
                  Expanded(
                    child: SummaryCard(
                      label: 'Bu Ay',
                      amount: provider.monthlyTotal,
                    ),
                  ),
                  const SizedBox(width: AppConstants.itemSpacing),
                  Expanded(
                    child: SummaryCard(
                      label: 'Bu Hafta',
                      amount: provider.weeklyTotal,
                    ),
                  ),
                  const SizedBox(width: AppConstants.itemSpacing),
                  Expanded(
                    child: SummaryCard(
                      label: 'Günlük Ort.',
                      amount: provider.dailyAverage,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.sectionSpacing),

              // Charts
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Son 7 Gün',
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 160,
                              child: WeeklyBarChart(
                                data: provider.weeklyGroupedExpenses,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppConstants.itemSpacing),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kategori Dağılımı (Ay)',
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 160,
                              child: CategoryPieChart(
                                data: provider.categoryDistribution,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppConstants.sectionSpacing),

              // Recent expenses
              Text(
                'Son 10 Harcama',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: AppConstants.itemSpacing),
              if (provider.recentExpenses.isEmpty)
                const Text('Henüz kayıtlı harcama yok.')
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.recentExpenses.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppConstants.itemSpacing),
                  itemBuilder: (context, index) {
                    final expense = provider.recentExpenses[index];
                    return ExpenseListItem(expense: expense);
                  },
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const AddExpenseScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Harcama Ekle'),
      ),
    );
  }
}

