import 'package:json_annotation/json_annotation.dart';
import 'package:library_management/utils/converter.dart';
import 'package:mongo_dart/mongo_dart.dart';

part 'category.g.dart';

@JsonSerializable()
class Category {
  @ObjectIdConverter()
  @JsonKey(name: '_id')
  final String? id;

  final String? name;

  final String? slug;

  Category({
    this.id,
    this.name,
    this.slug,
  });

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
