// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: const ObjectIdConverter().fromJson(json['_id'] as ObjectId?),
  username: json['username'] as String?,
  passwordHash: json['password_hash'] as String?,
  fullName: json['full_name'] as String?,
  email: json['email'] as String?,
  role: json['role'] as String?,
  createdAt: const DateTimeConverter().fromJson(json['created_at']),
  updatedAt: const DateTimeConverter().fromJson(json['updated_at']),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  '_id': const ObjectIdConverter().toJson(instance.id),
  'username': instance.username,
  'password_hash': instance.passwordHash,
  'full_name': instance.fullName,
  'email': instance.email,
  'role': instance.role,
  'created_at': const DateTimeConverter().toJson(instance.createdAt),
  'updated_at': const DateTimeConverter().toJson(instance.updatedAt),
};
