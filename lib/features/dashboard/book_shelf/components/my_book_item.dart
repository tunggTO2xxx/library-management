import 'package:flutter/material.dart';
import 'package:library_management/common/common_bottom_sheet.dart';
import 'package:library_management/common/common_button.dart';
import 'package:library_management/common/gap.dart';
import 'package:library_management/constants/app_colors.dart';
import 'package:library_management/features/dashboard/book_shelf/components/progress_bar.dart';
import 'package:library_management/model/borrow_record.dart';
import 'package:library_management/utils/date_time_extension.dart';

class MyBookItem extends StatelessWidget {
  const MyBookItem({super.key, required this.borrowRecord, this.onReturnBook});

  final BorrowRecord borrowRecord;
  final VoidCallback? onReturnBook;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return InkWell(
      onTap: () {
        _showBorrowRecordDetail(context);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            borrowRecord.book?.imageUrl ?? "",
            width: 130,
            height: 180,
            fit: BoxFit.fill,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image),
          ),
          Gap.w10,
          Expanded(
            child: SizedBox(
              height: 180,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        borrowRecord.book?.title ?? '',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gap.h4,
                      Text(
                        borrowRecord.book?.authors?.first.name ?? '',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  ProgressBar(
                    borrowedAt: borrowRecord.borrowedAt ?? now,
                    dueAt: borrowRecord.dueDate ?? now,
                    returnedAt: borrowRecord.returnedAt,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBorrowRecordDetail(BuildContext context) {
    CommonBottomSheet.show(
      context: context,
      height: borrowRecord.status == 'returned' ? 330 : 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                borrowRecord.book?.imageUrl ?? "",
                width: 130,
                height: 180,
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image),
              ),
              Gap.w10,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      borrowRecord.book?.title ?? '',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gap.h4,
                    Text(
                      (borrowRecord.book?.authors ?? []).first.name ?? '',
                      style: TextStyle(fontSize: 14),
                    ),
                    Gap.h4,
                    Text(
                      (borrowRecord.book?.publishedYear ?? 0).toString(),
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Gap.h20,

          _dateTimeWidget(
            title: 'Borrowed Date: ',
            dateTime: borrowRecord.borrowedAt ?? DateTime.now(),
          ),
          Gap.h10,
          _dateTimeWidget(
            title: 'Due Date: ',
            dateTime: borrowRecord.dueDate ?? DateTime.now(),
          ),
          Gap.h10,
          _dateTimeWidget(
            title: 'Returned at: ',
            dateTime: borrowRecord.returnedAt,
          ),

          borrowRecord.status == 'returned'
              ? SizedBox()
              : Column(
                  children: [
                    Gap.h20,
                    CommonButton(
                      height: 48,
                      textButton: 'Return book',
                      colorButton: AppColors.bgColor,
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      onPress: () {
                        onReturnBook?.call();
                      },
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _dateTimeWidget({required String title, DateTime? dateTime}) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: title,
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
          TextSpan(
            text: dateTime != null ? dateTime.toDdMMyyyyHm() : '',
            style: TextStyle(fontSize: 14, color: AppColors.mainColorYellow),
          ),
        ],
      ),
    );
  }
}
