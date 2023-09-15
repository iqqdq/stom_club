import 'dart:convert';

import 'package:stom_club/entities/article_image.dart';

class Article {
  Article({
    required this.id,
    required this.title,
    required this.createdAt,
    this.category,
    this.text,
    this.images,
  });

  int id;
  String title;
  String createdAt;
  int? category;
  String? text;
  List<ArticleImage>? images;

  factory Article.fromRawJson(String str) => Article.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        id: json["id"],
        title: json["title"],
        createdAt: json["createdAt"],
        category: json["category"],
        text: json["text"],
        images: List<ArticleImage>.from(
            json["images"].map((x) => ArticleImage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "createdAt": createdAt,
        "category": category,
        "text": text,
        "images": images == null
            ? null
            : List<ArticleImage>.from(images!.map((x) => x.toJson())),
      };
}
