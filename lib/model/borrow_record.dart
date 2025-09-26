import 'package:json_annotation/json_annotation.dart';
import 'package:library_management/model/book.dart';
import 'package:library_management/model/user.dart';
import 'package:library_management/utils/converter.dart';
import 'package:mongo_dart/mongo_dart.dart';

part 'borrow_record.g.dart';

@JsonSerializable(explicitToJson: true)
class BorrowRecord {
  @ObjectIdConverter()
  @JsonKey(name: '_id')
  final String? id;

  final User? user;

  final Book? book;

  @JsonKey(name: 'borrowed_at')
  final DateTime? borrowedAt;

  @JsonKey(name: 'due_at')
  final DateTime? dueDate;

  @JsonKey(name: 'returned_at')
  final DateTime? returnedAt;

  final String? status;

  BorrowRecord({
    this.id,
    this.user,
    this.book,
    this.borrowedAt,
    this.dueDate,
    this.returnedAt,
    this.status,
  });

  factory BorrowRecord.fromJson(Map<String, dynamic> json) =>
      _$BorrowRecordFromJson(json);

  Map<String, dynamic> toJson() => _$BorrowRecordToJson(this);
}
