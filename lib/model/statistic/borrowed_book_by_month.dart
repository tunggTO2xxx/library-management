import 'package:json_annotation/json_annotation.dart';

part 'borrowed_book_by_month.g.dart';

@JsonSerializable()
class BorrowedBookByMonth {
  final int? borrowCount;

  final String? month;

  BorrowedBookByMonth({this.borrowCount, this.month});

  factory BorrowedBookByMonth.fromJson(Map<String, dynamic> json) =>
      _$BorrowedBookByMonthFromJson(json);
  Map<String, dynamic> toJson() => _$BorrowedBookByMonthToJson(this);
}
