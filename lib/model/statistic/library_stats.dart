import 'package:json_annotation/json_annotation.dart';

part 'library_stats.g.dart';

@JsonSerializable()
class LibraryStats {
  final int? totalBooks;

  final int? borrowedBooks;

  final int? totalAuthors;

  final int? totalCategories;

  final int? totalReaders;

  LibraryStats({
    this.totalBooks,
    this.borrowedBooks,
    this.totalAuthors,
    this.totalCategories,
    this.totalReaders,
  });

  factory LibraryStats.fromJson(Map<String, dynamic> json) =>
      _$LibraryStatsFromJson(json);
  Map<String, dynamic> toJson() => _$LibraryStatsToJson(this);
}
