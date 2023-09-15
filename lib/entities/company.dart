import 'dart:convert';
import 'package:stom_club/entities/manager.dart';

class Company {
  Company({
    required this.id,
    required this.manager,
    required this.isDeleted,
    required this.createdAt,
    required this.name,
    required this.description,
  });

  int id;
  Manager manager;
  bool isDeleted;
  String createdAt;
  String name;
  String description;

  factory Company.fromRawJson(String str) => Company.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json["id"],
        manager: Manager.fromJson(json["manager"]),
        isDeleted: json["isDeleted"],
        createdAt: json["createdAt"],
        name: json["name"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "manager": manager.toJson(),
        "isDeleted": isDeleted,
        "createdAt": createdAt,
        "name": name,
        "description": description,
      };
}
