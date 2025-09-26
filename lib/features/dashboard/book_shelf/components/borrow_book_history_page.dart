import 'package:flutter/material.dart';
import 'package:library_management/common/gap.dart';
import 'package:library_management/constants/app_colors.dart';
import 'package:library_management/features/dashboard/book_shelf/components/borrow_book_item.dart';
import 'package:library_management/model/borrow_record.dart';
import 'package:library_management/service/mongo_service.dart';

class BorrowBookHistoryPage extends StatefulWidget {
  const BorrowBookHistoryPage({super.key});

  @override
  State<BorrowBookHistoryPage> createState() => _BorrowBookHistoryPageState();
}

class _BorrowBookHistoryPageState extends State<BorrowBookHistoryPage> {
  late MongoService mongo;
  var _currentIndex = 0;
  var borrowRecords = <BorrowRecord>[];

  @override
  void initState() {
    super.initState();
    mongo = MongoService();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var borrowRecordList = await mongo.getBorrowRecords();
      borrowRecords = [...borrowRecordList];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Borrow Book History'.toUpperCase(),
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        Gap.h20,
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(53),
                topRight: Radius.circular(53),
              ),
            ),
            child: Column(
              children: [
                Gap.h30,
                _buildBorrowBookHistoryTabBar(),
                Gap.h20,
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final borrowRecord = borrowRecords[index];

                      return BorrowBookItem(borrowRecord: borrowRecord);
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    itemCount: borrowRecords.length,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar(String title, int index, {String? status}) {
    return GestureDetector(
      onTap: () async {
        _currentIndex = index;
        var borrowRecordList = await mongo.getBorrowRecords(status: status);
        borrowRecords = [...borrowRecordList];
        setState(() {});
      },
      child: Container(
        width: 95,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: index == _currentIndex
              ? AppColors.bgColor
              : AppColors.tabBarColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: index == _currentIndex ? Colors.white : AppColors.bgColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBorrowBookHistoryTabBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTabBar('All', 0),
        _buildTabBar('Borrow', 1, status: 'borrowed'),
        _buildTabBar('Return', 2, status: 'returned'),
      ],
    );
  }
}
