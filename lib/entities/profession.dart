import 'dart:convert';

class Profession {
  Profession({
    required this.id,
    required this.isDeleted,
    required this.createdAt,
    required this.name,
  });

  int id;
  bool isDeleted;
  String createdAt;
  String name;

  factory Profession.fromRawJson(String str) =>
      Profession.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Profession.fromJson(Map<String, dynamic> json) => Profession(
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
