import 'dart:convert';

class Advertising {
  Advertising({
    required this.id,
    required this.isDeleted,
    required this.title,
    this.product,
    this.createdAt,
    this.text,
    this.url,
    this.image,
  });

  int id;
  bool isDeleted;
  String title;
  int? product;
  String? createdAt;
  String? text;
  String? url;
  String? image;

  factory Advertising.fromRawJson(String str) =>
      Advertising.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Advertising.fromJson(Map<String, dynamic> json) => Advertising(
        id: json["id"],
        isDeleted: json["isDeleted"],
        createdAt: json["createdAt"],
        title: json["title"],
        text: json["text"],
        url: json["url"],
        image: json["image"],
        product: json["product"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "isDeleted": isDeleted,
        "createdAt": createdAt,
        "title": title,
        "text": text,
        "url": url,
        "image": image,
        "product": product
      };
}
