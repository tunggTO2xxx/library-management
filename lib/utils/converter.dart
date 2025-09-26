import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';

class ObjectIdConverter implements JsonConverter<String?, ObjectId?> {
  const ObjectIdConverter();

  @override
  String? fromJson(ObjectId? objectId) => objectId?.toHexString();

  @override
  ObjectId? toJson(String? id) => id != null ? ObjectId.parse(id) : null;
}

class DateTimeConverter implements JsonConverter<DateTime?, dynamic> {
  const DateTimeConverter();

  @override
  DateTime? fromJson(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value; // mongo_dart có thể trả sẵn DateTime
    return DateTime.tryParse(value.toString());
  }

  @override
  dynamic toJson(DateTime? date) => date?.toIso8601String();
}

class ObjectIdListConverter
    implements JsonConverter<List<String>?, List<dynamic>?> {
  const ObjectIdListConverter();

  @override
  List<String>? fromJson(List<dynamic>? objectIds) {
    if (objectIds == null) return null;
    return objectIds
        .whereType<ObjectId>()
        .map((e) => e.toHexString())
        .toList();
  }

  @override
  List<ObjectId>? toJson(List<String>? ids) {
    return ids?.map((e) => ObjectId.parse(e)).toList();
  }
}
