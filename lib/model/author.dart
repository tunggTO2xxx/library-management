import 'package:json_annotation/json_annotation.dart';
import 'package:library_management/utils/converter.dart';
import 'package:mongo_dart/mongo_dart.dart';

part 'author.g.dart';

@JsonSerializable()
class Author {
  @ObjectIdConverter()
  @JsonKey(name: '_id')
  final String? id;

  final String? name;

  final DateTime? createdAt;

  Author({
    this.id,
    this.name,
    this.createdAt,
  });

  factory Author.fromJson(Map<String, dynamic> json) =>
      _$AuthorFromJson(json);
  Map<String, dynamic> toJson() => _$AuthorToJson(this);
}
