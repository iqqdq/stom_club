import 'dart:convert';
import 'package:stom_club/entities/product_image.dart';

class Product {
  Product({
    required this.id,
    required this.isNew,
    required this.name,
    required this.reviewsCount,
    required this.rating,
    required this.images,
  });

  int id;
  bool isNew;
  String name;
  int reviewsCount;
  double rating;
  List<ProductImage> images;

  factory Product.fromRawJson(String str) => Product.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        isNew: json["isNew"],
        name: json["name"],
        reviewsCount: json["reviewsCount"],
        rating: json["rating"],
        images: List<ProductImage>.from(
            json["images"].map((x) => ProductImage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "isNew": isNew,
        "name": name,
        "reviewsCount": reviewsCount,
        "rating": rating,
        "images": images,
      };
}
