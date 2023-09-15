import 'dart:convert';

class Manufacturer {
  Manufacturer({
    required this.id,
    required this.isDeleted,
    this.createdAt,
    required this.name,
  });

  int id;
  bool isDeleted;
  String? createdAt;
  String name;

  factory Manufacturer.fromRawJson(String str) =>
      Manufacturer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Manufacturer.fromJson(Map<String, dynamic> json) => Manufacturer(
        id: json["id"],
        isDeleted: json["isDeleted"],
        createdAt: json["createdAt"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "isDeleted": isDeleted,
        "createdAt": createdAt,
        "name": name,
      };
}
