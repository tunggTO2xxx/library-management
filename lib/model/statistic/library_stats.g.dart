// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LibraryStats _$LibraryStatsFromJson(Map<String, dynamic> json) => LibraryStats(
  totalBooks: (json['totalBooks'] as num?)?.toInt(),
  borrowedBooks: (json['borrowedBooks'] as num?)?.toInt(),
  totalAuthors: (json['totalAuthors'] as num?)?.toInt(),
  totalCategories: (json['totalCategories'] as num?)?.toInt(),
  totalReaders: (json['totalReaders'] as num?)?.toInt(),
);

Map<String, dynamic> _$LibraryStatsToJson(LibraryStats instance) =>
    <String, dynamic>{
      'totalBooks': instance.totalBooks,
      'borrowedBooks': instance.borrowedBooks,
      'totalAuthors': instance.totalAuthors,
      'totalCategories': instance.totalCategories,
      'totalReaders': instance.totalReaders,
    };
