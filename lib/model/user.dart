import 'package:json_annotation/json_annotation.dart';
import 'package:library_management/utils/converter.dart';
import 'package:mongo_dart/mongo_dart.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  @ObjectIdConverter()
  @JsonKey(name: '_id')
  final String? id;

  final String? username;

  @JsonKey(name: 'password_hash')
  final String? passwordHash;

  @JsonKey(name: 'full_name')
  final String? fullName;

  final String? email;

  /// "reader" hoặc "admin"
  final String? role;

  @DateTimeConverter()
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @DateTimeConverter()
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  User({
    this.id,
    this.username,
    this.passwordHash,
    this.fullName,
    this.email,
    this.role,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return _$UserFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
