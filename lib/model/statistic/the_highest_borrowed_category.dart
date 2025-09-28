import 'package:json_annotation/json_annotation.dart';

part 'the_highest_borrowed_category.g.dart';

@JsonSerializable()
class TheHighestBorrowedCategory {
  final int? borrowCount;

  final String? type;

  TheHighestBorrowedCategory({this.borrowCount, this.type});

  factory TheHighestBorrowedCategory.fromJson(Map<String, dynamic> json) =>
      _$TheHighestBorrowedCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$TheHighestBorrowedCategoryToJson(this);
}
