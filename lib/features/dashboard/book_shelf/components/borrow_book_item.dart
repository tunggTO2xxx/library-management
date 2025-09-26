import 'package:flutter/material.dart';
import 'package:library_management/common/common_bottom_sheet.dart';
import 'package:library_management/common/gap.dart';
import 'package:library_management/constants/app_colors.dart';
import 'package:library_management/model/borrow_record.dart';
import 'package:library_management/utils/date_time_extension.dart';

class BorrowBookItem extends StatelessWidget {
  const BorrowBookItem({required this.borrowRecord, super.key});

  final BorrowRecord borrowRecord;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
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
                        'Borrower: ${borrowRecord.user?.fullName ?? ''}',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Status: ',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        TextSpan(
                          text: (borrowRecord.status ?? '').toUpperCase(),
                          style: TextStyle(
                            fontSize: 14,
                            color: _getColorForStatus(borrowRecord),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForStatus(BorrowRecord borrowRecord) {
    final status = borrowRecord.status ?? '';
    final now = DateTime.now();

    if (status == 'borrowed') {
      if (now.isBefore(borrowRecord.dueDate ?? now) ||
          now.isSameDay(borrowRecord.dueDate ?? now)) {
        return Colors.green;
      }

      return Colors.red;
    }

    if ((borrowRecord.returnedAt ?? now).isBefore(
          borrowRecord.dueDate ?? now,
        ) ||
        (borrowRecord.returnedAt ?? now).isSameDay(
          borrowRecord.dueDate ?? now,
        )) {
      return Colors.green;
    }

    return Colors.yellow;
  }

  void _showBorrowRecordDetail(BuildContext context) {
    CommonBottomSheet.show(
      context: context,
      height: 330,
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
                    Gap.h4,
                    Text(
                      'Borrower: ${borrowRecord.user?.fullName ?? ''}',
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
