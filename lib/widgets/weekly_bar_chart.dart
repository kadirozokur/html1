import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../utils/date_utils.dart';

class WeeklyBarChart extends StatelessWidget {
  final Map<DateTime, double> data;

  const WeeklyBarChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text('Veri yok'));
    }

    final theme = Theme.of(context);
    final sortedKeys = data.keys.toList()..sort();
    final maxY = (data.values.fold<double>(0, (p, e) => e > p ? e : p)) * 1.2;

    return BarChart(
      BarChartData(
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= sortedKeys.length) {
                  return const SizedBox.shrink();
                }
                final date = sortedKeys[index];
                const weekdays = ['P', 'S', 'Ç', 'P', 'C', 'C', 'P'];
                final label = weekdays[date.weekday - 1];
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    label,
                    style: theme.textTheme.bodySmall,
                  ),
                );
              },
            ),
          ),
        ),
        barGroups: [
          for (var i = 0; i < sortedKeys.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: data[DateRangeUtils.dateOnly(sortedKeys[i])] ?? 0,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                  width: 16,
                  color: theme.colorScheme.primary,
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: maxY == 0 ? 1 : maxY,
                    color: theme.colorScheme.surfaceVariant.withOpacity(0.4),
                  ),
                ),
              ],
            ),
        ],
        maxY: maxY == 0 ? 1 : maxY,
      ),
    );
  }
}

