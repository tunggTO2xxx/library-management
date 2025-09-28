// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'the_highest_borrowed_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TheHighestBorrowedCategory _$TheHighestBorrowedCategoryFromJson(
  Map<String, dynamic> json,
) => TheHighestBorrowedCategory(
  borrowCount: (json['borrowCount'] as num?)?.toInt(),
  type: json['type'] as String?,
);

Map<String, dynamic> _$TheHighestBorrowedCategoryToJson(
  TheHighestBorrowedCategory instance,
) => <String, dynamic>{
  'borrowCount': instance.borrowCount,
  'type': instance.type,
};
