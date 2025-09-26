// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Author _$AuthorFromJson(Map<String, dynamic> json) => Author(
  id: const ObjectIdConverter().fromJson(json['_id'] as ObjectId?),
  name: json['name'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$AuthorToJson(Author instance) => <String, dynamic>{
  '_id': const ObjectIdConverter().toJson(instance.id),
  'name': instance.name,
  'createdAt': instance.createdAt?.toIso8601String(),
};
