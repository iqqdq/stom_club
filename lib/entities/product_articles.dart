import 'dart:convert';

import 'package:stom_club/entities/article_image.dart';

class ProductArticles {
  ProductArticles({
    required this.articles,
  });

  List<ProductArticle> articles;

  factory ProductArticles.fromRawJson(String str) =>
      ProductArticles.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductArticles.fromJson(Map<String, dynamic> json) =>
      ProductArticles(
        articles: List<ProductArticle>.from(
            json["articles"].map((x) => ProductArticle.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "articles": List<dynamic>.from(articles.map((x) => x.toJson())),
      };
}

class ProductArticle {
  ProductArticle({
    required this.id,
    required this.title,
    required this.createdAt,
    this.category,
    required this.images,
  });

  int id;
  String title;
  String createdAt;
  int? category;
  List<ArticleImage> images;

  factory ProductArticle.fromRawJson(String str) =>
      ProductArticle.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductArticle.fromJson(Map<String, dynamic> json) => ProductArticle(
        id: json["id"],
        title: json["title"],
        createdAt: json["createdAt"],
        category: json["category"],
        images: List<ArticleImage>.from(
            json["images"].map((x) => ArticleImage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "createdAt": createdAt,
        "category": category,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
      };
}
