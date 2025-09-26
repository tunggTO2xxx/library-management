import 'package:flutter/material.dart';
import 'package:library_management/common/gap.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({
    super.key,
    required this.borrowedAt,
    required this.dueAt,
    this.returnedAt,
  });

  final DateTime borrowedAt;
  final DateTime dueAt;
  final DateTime? returnedAt;

  @override
  Widget build(BuildContext context) {
    double progress = 0;
    Color color = Colors.yellow;
    String label = "";
    final now = DateTime.now();

    if (returnedAt == null) {
      if (now.isBefore(dueAt)) {
        final total = dueAt.difference(borrowedAt).inMilliseconds;
        final current = now.difference(borrowedAt).inMilliseconds;
        progress = current / total;
        color = Colors.yellow;

        final daysLeft = dueAt.difference(now).inDays;
        label = daysLeft > 0
            ? "$daysLeft ${daysLeft == 1 ? "day" : "days"} left"
            : "Due today";
      } else {
        progress = 1.0;
        color = Colors.red;

        final overdueDays = now.difference(dueAt).inDays;
        label = "Overdue: $overdueDays ${overdueDays == 1 ? "day" : "days"}";
      }
    } else {
      progress = 1.0;
      if (returnedAt!.isBefore(dueAt) || returnedAt!.isAtSameMomentAs(dueAt)) {
        color = Colors.green;
        label = "Returned on time";
      } else {
        color = Colors.red;
        final overdueDays = returnedAt!.difference(dueAt).inDays;
        label =
            "Returned late (Overdue $overdueDays ${overdueDays == 1 ? "day" : "days"})";
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${(progress * 100).toInt()}%'),
        Gap.h10,
        Container(
          height: 10,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress.clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
        Gap.h10,
        Text(label),
      ],
    );
  }
}
