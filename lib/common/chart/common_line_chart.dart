import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartDataPoint {
  final String label;
  final double value;

  ChartDataPoint({required this.label, required this.value});
}

class CommonLineChart extends StatelessWidget {
  final List<ChartDataPoint> data;
  final String? title;
  final Color lineColor;

  const CommonLineChart({
    super.key,
    required this.data,
    this.title,
    this.lineColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
        const SizedBox(height: 20),
        SizedBox(
          height: 300,
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: true),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1, // only show each index once
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index >= 0 && index < data.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            data[index].label,
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 35, // make space for y labels
                    interval: _getYInterval(),
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 12),
                      );
                    },
                  ),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.black26),
              ),
              lineBarsData: [
                LineChartBarData(
                  isCurved: true,
                  color: lineColor,
                  barWidth: 3,
                  dotData: const FlDotData(show: true),
                  spots: List.generate(
                    data.length,
                    (index) => FlSpot(index.toDouble(), data[index].value),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  double _getYInterval() {
    if (data.isEmpty) return 1;
    final maxValue = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    // divide into ~5 steps
    return (maxValue / 5).ceilToDouble().clamp(1, double.infinity);
  }
}
