// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'borrow_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BorrowRecord _$BorrowRecordFromJson(Map<String, dynamic> json) => BorrowRecord(
  id: const ObjectIdConverter().fromJson(json['_id'] as ObjectId?),
  user: json['user'] == null
      ? null
      : User.fromJson(json['user'] as Map<String, dynamic>),
  book: json['book'] == null
      ? null
      : Book.fromJson(json['book'] as Map<String, dynamic>),
  borrowedAt: json['borrowed_at'] == null
      ? null
      : DateTime.parse(json['borrowed_at'] as String),
  dueDate: json['due_at'] == null
      ? null
      : DateTime.parse(json['due_at'] as String),
  returnedAt: json['returned_at'] == null
      ? null
      : DateTime.parse(json['returned_at'] as String),
  status: json['status'] as String?,
);

Map<String, dynamic> _$BorrowRecordToJson(BorrowRecord instance) =>
    <String, dynamic>{
      '_id': const ObjectIdConverter().toJson(instance.id),
      'user': instance.user?.toJson(),
      'book': instance.book?.toJson(),
      'borrowed_at': instance.borrowedAt?.toIso8601String(),
      'due_at': instance.dueDate?.toIso8601String(),
      'returned_at': instance.returnedAt?.toIso8601String(),
      'status': instance.status,
    };
