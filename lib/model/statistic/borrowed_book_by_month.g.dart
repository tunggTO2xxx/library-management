// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'borrowed_book_by_month.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BorrowedBookByMonth _$BorrowedBookByMonthFromJson(Map<String, dynamic> json) =>
    BorrowedBookByMonth(
      borrowCount: (json['borrowCount'] as num?)?.toInt(),
      month: json['month'] as String?,
    );

Map<String, dynamic> _$BorrowedBookByMonthToJson(
  BorrowedBookByMonth instance,
) => <String, dynamic>{
  'borrowCount': instance.borrowCount,
  'month': instance.month,
};
