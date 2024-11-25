import 'package:json_annotation/json_annotation.dart';

part 'news.g.dart';

@JsonSerializable()
class News {
  final Pagination pagination;
  final List<Article> data;

  News({required this.pagination, required this.data});

  factory News.fromJson(Map<String, dynamic> json) => _$NewsFromJson(json);

  Map<String, dynamic> toJson() => _$NewsToJson(this);
}

@JsonSerializable()
class Pagination {
  final int limit;
  final int offset;
  final int count;
  final int total;

  Pagination({
    required this.limit,
    required this.offset,
    required this.count,
    required this.total,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      _$PaginationFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationToJson(this);
}

@JsonSerializable()
class Article {
  final String? author;
  final String title;
  final String? description;
  final String url;
  final String? source;
  final String? image;
  final String category;
  final String language;
  final String country;
  // needs to check again
  final DateTime published_at;
  Article({
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.source,
    required this.image,
    required this.category,
    required this.language,
    required this.country,
    required this.published_at,
  });

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleToJson(this);
}
