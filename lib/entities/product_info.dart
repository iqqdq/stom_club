import 'dart:convert';
import 'package:stom_club/entities/document.dart';
import 'package:stom_club/entities/product_articles.dart';
import 'package:stom_club/entities/product_image.dart';
import 'package:stom_club/entities/manufacturer.dart';
import 'package:stom_club/entities/video.dart';

class ProductInfo {
  ProductInfo(
      {required this.id,
      required this.isNew,
      required this.images,
      this.documents,
      required this.articles,
      required this.video,
      this.manufacturer,
      this.productSubcategory,
      required this.reviewsCount,
      required this.rating,
      required this.oneStar,
      required this.twoStars,
      required this.threeStars,
      required this.fourStars,
      required this.fiveStars,
      required this.isDeleted,
      required this.createdAt,
      required this.name,
      required this.description,
      required this.releaseForm,
      required this.specifications,
      required this.properties,
      required this.purpose,
      required this.compound,
      required this.notes,
      required this.contraindications,
      required this.sideEffects,
      required this.terms});

  int id;
  bool isNew;
  List<ProductImage> images;
  List<Document>? documents;
  ProductArticles articles;
  List<Video> video;
  Manufacturer? manufacturer;
  ProductSubcategory? productSubcategory;
  int reviewsCount;
  double rating;
  int oneStar;
  int twoStars;
  int threeStars;
  int fourStars;
  int fiveStars;
  bool isDeleted;
  String createdAt;
  String name;
  String description;
  String releaseForm;
  String specifications;
  String properties;
  String purpose;
  String compound;
  String notes;
  String contraindications;
  String sideEffects;
  String terms;

  factory ProductInfo.fromRawJson(String str) =>
      ProductInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductInfo.fromJson(Map<String, dynamic> json) => ProductInfo(
        id: json["id"],
        isNew: json["isNew"],
        images: List<ProductImage>.from(
            json["images"].map((x) => ProductImage.fromJson(x))),
        documents: json["documents"] == null
            ? null
            : List<Document>.from(
                json["documents"].map((x) => Document.fromJson(x))),
        articles: ProductArticles.fromJson(json),
        video: List<Video>.from(json["video"].map((x) => Video.fromJson(x))),
        manufacturer: json["manufacturer"] == null
            ? null
            : Manufacturer.fromJson(json["manufacturer"]),
        productSubcategory: json["category"] == null
            ? null
            : ProductSubcategory.fromJson(json["category"]),
        reviewsCount: json["reviewsCount"],
        rating: json["rating"],
        oneStar: json["oneStar"],
        twoStars: json["twoStars"],
        threeStars: json["threeStars"],
        fourStars: json["fourStars"],
        fiveStars: json["fiveStars"],
        isDeleted: json["isDeleted"],
        createdAt: json["createdAt"],
        name: json["name"],
        description: json["description"],
        releaseForm: json["releaseForm"],
        specifications: json["specifications"],
        properties: json["properties"],
        purpose: json["purpose"],
        compound: json["compound"],
        notes: json["notes"],
        contraindications: json["contraindications"],
        sideEffects: json["sideEffects"],
        terms: json["terms"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "isNew": isNew,
        "images": List<ProductImage>.from(images.map((x) => x.toJson())),
        "documents": List<Document>.from(images.map((x) => x.toJson())),
        "articles": articles.toJson(),
        "video": List<Video>.from(video.map((x) => x.toJson())),
        "manufacturer": manufacturer == null ? null : manufacturer!.toJson(),
        "category":
            productSubcategory == null ? null : productSubcategory!.toJson(),
        "reviewsCount": reviewsCount,
        "rating": rating,
        "isDeleted": isDeleted,
        "createdAt": createdAt,
        "name": name,
        "description": description,
        "releaseForm": releaseForm,
        "specifications": specifications,
        "properties": properties,
        "purpose": purpose,
        "compound": compound,
        "notes": notes,
        "contraindications": contraindications,
        "sideEffects": sideEffects,
        "terms": terms,
      };
}

class ProductSubcategory {
  ProductSubcategory({
    required this.id,
    required this.isDeleted,
    this.createdAt,
    required this.name,
    this.lft,
    this.rght,
    required this.treeId,
    this.level,
    this.parent,
  });

  int id;
  bool isDeleted;
  String? createdAt;
  String name;
  int? lft;
  int? rght;
  int treeId;
  int? level;
  int? parent;

  factory ProductSubcategory.fromRawJson(String str) =>
      ProductSubcategory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductSubcategory.fromJson(Map<String, dynamic> json) =>
      ProductSubcategory(
        id: json["id"],
        isDeleted: json["isDeleted"],
        createdAt: json["createdAt"],
        name: json["name"],
        lft: json["lft"],
        rght: json["rght"],
        treeId: json["treeId"],
        level: json["level"],
        parent: json["parent"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "isDeleted": isDeleted,
        "createdAt": createdAt,
        "name": name,
        "lft": lft,
        "rght": rght,
        "treeId": treeId,
        "level": level,
        "parent": parent,
      };
}
