import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartItem {
  final String label;
  final double value;
  final Color color;

  PieChartItem({required this.label, required this.value, required this.color});
}

class CommonPieChart extends StatelessWidget {
  final List<PieChartItem> items;
  final double height;
  final double centerSpaceRadius;
  final String? title;

  const CommonPieChart({
    super.key,
    required this.items,
    this.height = 250,
    this.centerSpaceRadius = 40,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final total = items.fold<double>(0, (sum, item) => sum + item.value);

    if (total == 0) {
      return const Center(child: Text("No data available"));
    }

    return Column(
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
        ],
        SizedBox(
          height: height,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: centerSpaceRadius,
              sections: items.map((item) {
                final percent = (item.value / total * 100).toStringAsFixed(1);

                return PieChartSectionData(
                  value: item.value,
                  color: item.color,
                  title: "$percent%",
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 16,
          runSpacing: 8,
          children: items.map((item) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 12, height: 12, color: item.color),
                const SizedBox(width: 6),
                Text("${item.label} (${item.value.toInt()})"),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
