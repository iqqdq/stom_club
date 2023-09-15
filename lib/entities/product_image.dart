import 'dart:convert';

class ProductImage {
  ProductImage({
    required this.id,
    required this.isDeleted,
    required this.createdAt,
    required this.image,
    required this.isMain,
    required this.product,
  });

  int id;
  bool isDeleted;
  String createdAt;
  String image;
  bool isMain;
  int product;

  factory ProductImage.fromRawJson(String str) =>
      ProductImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductImage.fromJson(Map<String, dynamic> json) => ProductImage(
        id: json["id"],
        isDeleted: json["isDeleted"],
        createdAt: json["createdAt"],
        image: json["image"],
        isMain: json["isMain"],
        product: json["product"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "isDeleted": isDeleted,
        "createdAt": createdAt,
        "image": image,
        "isMain": isMain,
        "product": product,
      };
}
