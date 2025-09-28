import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CommonBarChart extends StatelessWidget {
  const CommonBarChart({
    super.key,
    required this.data,
    required this.labels,
    this.barColor = Colors.blue,
    this.title,
    this.height = 250,
  });

  /// Dữ liệu: ví dụ [10, 20, 30]
  final List<double> data;

  /// Nhãn dưới trục X: ví dụ ["Tháng 1", "Tháng 2", "Tháng 3"]
  final List<String> labels;

  /// Màu cột
  final Color barColor;

  /// Tiêu đề (optional)
  final String? title;

  /// Chiều cao chart
  final double height;

  @override
  Widget build(BuildContext context) {
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
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              barTouchData: BarTouchData(enabled: true),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 28),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index >= 0 && index < labels.length) {
                        return Text(
                          labels[index],
                          style: const TextStyle(fontSize: 12),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(show: true),
              barGroups: data.asMap().entries.map((entry) {
                final index = entry.key;
                final value = entry.value;
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: value,
                      color: barColor,
                      width: 20,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
