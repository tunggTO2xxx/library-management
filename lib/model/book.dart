import 'package:json_annotation/json_annotation.dart';
import 'package:library_management/model/author.dart';
import 'package:library_management/model/category.dart';
import 'package:library_management/utils/converter.dart';
import 'package:mongo_dart/mongo_dart.dart';

part 'book.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Book {
  @ObjectIdConverter()
  @JsonKey(name: '_id')
  final String? id;

  final String? title;

  @ObjectIdListConverter()
  @JsonKey(name: 'author_ids')
  final List<String>? authorIds;

  @JsonKey(name: 'authors')
  final List<Author>? authors;

  final String? description;

  @JsonKey(name: 'published_year')
  final int? publishedYear;

  @ObjectIdListConverter()
  @JsonKey(name: 'category_ids')
  final List<String>? categoryIds;

  @JsonKey(name: 'categories')
  final List<Category>? categories;

  final List<String>? tags;

  final String? location;

  @JsonKey(name: 'total_copies')
  final int? totalCopies;

  @JsonKey(name: 'available_copies')
  final int? availableCopies;

  @JsonKey(name: 'image_url')
  final String? imageUrl;

  @DateTimeConverter()
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @DateTimeConverter()
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @JsonKey(name: 'is_delete')
  final bool? isDelete;

  Book({
    this.id,
    this.title,
    this.authorIds,
    this.authors,
    this.description,
    this.publishedYear,
    this.categoryIds,
    this.categories,
    this.tags,
    this.location,
    this.totalCopies,
    this.availableCopies,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
    this.isDelete,
  });

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);

  Map<String, dynamic> toJson() => _$BookToJson(this);
}
