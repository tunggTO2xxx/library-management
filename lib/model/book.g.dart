// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Book _$BookFromJson(Map<String, dynamic> json) => Book(
  id: const ObjectIdConverter().fromJson(json['_id'] as ObjectId?),
  title: json['title'] as String?,
  authorIds: const ObjectIdListConverter().fromJson(
    json['author_ids'] as List?,
  ),
  authors: (json['authors'] as List<dynamic>?)
      ?.map((e) => Author.fromJson(e as Map<String, dynamic>))
      .toList(),
  description: json['description'] as String?,
  publishedYear: (json['published_year'] as num?)?.toInt(),
  categoryIds: const ObjectIdListConverter().fromJson(
    json['category_ids'] as List?,
  ),
  categories: (json['categories'] as List<dynamic>?)
      ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
      .toList(),
  tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
  location: json['location'] as String?,
  totalCopies: (json['total_copies'] as num?)?.toInt(),
  availableCopies: (json['available_copies'] as num?)?.toInt(),
  imageUrl: json['image_url'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  isDelete: json['is_delete'] as bool?,
);

Map<String, dynamic> _$BookToJson(Book instance) => <String, dynamic>{
  '_id': ?const ObjectIdConverter().toJson(instance.id),
  'title': ?instance.title,
  'author_ids': ?const ObjectIdListConverter().toJson(instance.authorIds),
  'authors': ?instance.authors?.map((e) => e.toJson()).toList(),
  'description': ?instance.description,
  'published_year': ?instance.publishedYear,
  'category_ids': ?const ObjectIdListConverter().toJson(instance.categoryIds),
  'categories': ?instance.categories?.map((e) => e.toJson()).toList(),
  'tags': ?instance.tags,
  'location': ?instance.location,
  'total_copies': ?instance.totalCopies,
  'available_copies': ?instance.availableCopies,
  'image_url': ?instance.imageUrl,
  'created_at': ?instance.createdAt?.toIso8601String(),
  'updated_at': ?instance.updatedAt?.toIso8601String(),
  'is_delete': ?instance.isDelete,
};
