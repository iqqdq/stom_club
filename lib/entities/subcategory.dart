// ignore_for_file: unnecessary_null_in_if_null_operators

import 'dart:convert';

class Subcategory {
  Subcategory({
    required this.id,
    required this.subcategories,
    this.image,
    this.isDeleted,
    this.createdAt,
    required this.name,
    this.lft,
    this.rght,
    required this.treeId,
    required this.level,
    this.parent,
  });

  int id;
  List<Subcategory> subcategories = [];
  String? image;
  bool? isDeleted;
  String? createdAt;
  String name;
  int? lft;
  int? rght;
  int treeId;
  int level;
  int? parent;

  factory Subcategory.fromRawJson(String str) =>
      Subcategory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Subcategory.fromJson(Map<String, dynamic> json) => Subcategory(
        id: json["id"],
        subcategories: List<Subcategory>.from(
            json["subcategories"].map((x) => Subcategory.fromJson(x))),
        image: json["image"] ?? null,
        isDeleted: json["isDeleted"] ?? null,
        createdAt: json["createdAt"] ?? null,
        name: json["name"],
        lft: json["lft"] ?? null,
        rght: json["rght"] ?? null,
        treeId: json["treeId"],
        level: json["level"],
        parent: json["parent"] ?? null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "subcategories":
            List<dynamic>.from(subcategories.map((x) => x.toJson())),
        "image": image,
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
