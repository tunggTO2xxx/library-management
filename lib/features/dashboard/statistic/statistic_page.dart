import 'package:flutter/material.dart';
import 'package:library_management/common/chart/common_bar_chart.dart';
import 'package:library_management/common/chart/common_line_chart.dart';
import 'package:library_management/common/chart/common_pie_chart.dart';
import 'package:library_management/common/gap.dart';
import 'package:library_management/constants/app_colors.dart';
import 'package:library_management/model/statistic/borrowed_book_by_month.dart';
import 'package:library_management/model/statistic/library_stats.dart';
import 'package:library_management/model/statistic/the_highest_borrowed_category.dart';
import 'package:library_management/service/mongo_service.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({super.key});

  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  late MongoService mongo;
  Map<String, dynamic>? _statusBook;
  var _top5HighestBorrowedBook = <TheHighestBorrowedCategory>[];
  var _borrowedBookByMonth = <BorrowedBookByMonth>[];
  LibraryStats? _libraryStats;

  @override
  void initState() {
    super.initState();
    mongo = MongoService();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _statusBook = await mongo.getBorrowStats();
      _top5HighestBorrowedBook = await mongo.getTop5Categories();
      _borrowedBookByMonth = await mongo.getBorrowStatsLast5Months();
      _libraryStats = await mongo.getLibraryStats();

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final dataBarChart = _top5HighestBorrowedBook
        .map((e) => (e.borrowCount ?? 0).toDouble())
        .toList();
    final labelBarChart = _top5HighestBorrowedBook
        .map((e) => e.type ?? '')
        .toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Text(
                  'Library Book Statistics',
                  style: TextStyle(fontSize: 24, color: AppColors.bgColor),
                ),
              ),

              if (_libraryStats != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Gap.h40,
                      Column(
                        children: [
                          _buildStatsItem(
                            title: 'Total Books:',
                            content: (_libraryStats?.totalBooks ?? 0)
                                .toString(),
                          ),
                          _buildStatsItem(
                            title: 'Total Borrowed Books:',
                            content: (_libraryStats?.borrowedBooks ?? 0)
                                .toString(),
                          ),
                          _buildStatsItem(
                            title: 'Total Authors:',
                            content: (_libraryStats?.totalAuthors ?? 0)
                                .toString(),
                          ),
                          _buildStatsItem(
                            title: 'Total Categories:',
                            content: (_libraryStats?.totalCategories ?? 0)
                                .toString(),
                          ),
                          _buildStatsItem(
                            title: 'Total Users:',
                            content: (_libraryStats?.totalReaders ?? 0)
                                .toString(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],

              if (_statusBook != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Gap.h40,
                      CommonPieChart(
                        title: 'Library Book Status Statistics',
                        items: [
                          PieChartItem(
                            label: "Borrowed",
                            value: (_statusBook!['borrowed']).toDouble(),
                            color: Colors.orangeAccent,
                          ),
                          PieChartItem(
                            label: "Available",
                            value: (_statusBook!['available']).toDouble(),
                            color: Colors.teal,
                          ),
                          PieChartItem(
                            label: "Overdue",
                            value: (_statusBook!['overdue']).toDouble(),
                            color: Colors.redAccent,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],

              if (_top5HighestBorrowedBook.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Gap.h40,
                      CommonBarChart(
                        title: "Top 5 Borrowed Book Genres",
                        data: dataBarChart,
                        labels: labelBarChart,
                        barColor: AppColors.mainColorYellow,
                      ),
                    ],
                  ),
                ),
              ],

              if (_borrowedBookByMonth.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Gap.h40,
                      CommonLineChart(
                        title: "Borrowed Books Over 5 Months",
                        data: _borrowedBookByMonth
                            .map(
                              (e) => ChartDataPoint(
                                label: e.month ?? '',
                                value: (e.borrowCount ?? 0).toDouble(),
                              ),
                            )
                            .toList(),
                        lineColor: Colors.green,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsItem({required String title, required String content}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Text(content, style: TextStyle(fontSize: 14, color: AppColors.bgColor)),
      ],
    );
  }
}
