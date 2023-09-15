import 'dart:convert';

class ArticleImage {
  ArticleImage({
    required this.id,
    this.isDeleted,
    required this.createdAt,
    this.image,
    required this.isMain,
    required this.article,
  });

  int id;
  bool? isDeleted;
  String createdAt;
  String? image;
  bool isMain;
  int article;

  factory ArticleImage.fromRawJson(String str) =>
      ArticleImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ArticleImage.fromJson(Map<String, dynamic> json) => ArticleImage(
        id: json["id"],
        isDeleted: json["isDeleted"],
        createdAt: json["createdAt"],
        image: json["image"],
        isMain: json["isMain"],
        article: json["article"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "isDeleted": isDeleted,
        "createdAt": createdAt,
        "image": image,
        "isMain": isMain,
        "article": article,
      };
}
