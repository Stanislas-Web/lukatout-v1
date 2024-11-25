// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

News _$NewsFromJson(Map<String, dynamic> json) => News(
      pagination:
          Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
      data: (json['data'] as List<dynamic>)
          .map((e) => Article.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NewsToJson(News instance) => <String, dynamic>{
      'pagination': instance.pagination,
      'data': instance.data,
    };

Pagination _$PaginationFromJson(Map<String, dynamic> json) => Pagination(
      limit: json['limit'] as int,
      offset: json['offset'] as int,
      count: json['count'] as int,
      total: json['total'] as int,
    );

Map<String, dynamic> _$PaginationToJson(Pagination instance) =>
    <String, dynamic>{
      'limit': instance.limit,
      'offset': instance.offset,
      'count': instance.count,
      'total': instance.total,
    };

Article _$ArticleFromJson(Map<String, dynamic> json) => Article(
      author: json['author'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      url: json['url'] as String,
      source: json['source'] as String?,
      image: json['image'] as String?,
      category: json['category'] as String,
      language: json['language'] as String,
      country: json['country'] as String,
      published_at: DateTime.parse(json['published_at'] as String),
    );

Map<String, dynamic> _$ArticleToJson(Article instance) => <String, dynamic>{
      'author': instance.author,
      'title': instance.title,
      'description': instance.description,
      'url': instance.url,
      'source': instance.source,
      'image': instance.image,
      'category': instance.category,
      'language': instance.language,
      'country': instance.country,
      'published_at': instance.published_at.toIso8601String(),
    };
