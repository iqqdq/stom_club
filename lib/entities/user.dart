import 'dart:convert';
import 'package:stom_club/entities/profession.dart';

class User {
  User({
    this.id,
    required this.lastName,
    required this.firstName,
    this.profession,
    required this.city,
    this.photo,
    this.email,
    this.vkUrl,
    this.telegramUrl,
  });

  int? id;
  String lastName;
  String firstName;
  Profession? profession;
  String city;
  String? photo;
  String? email;
  String? vkUrl;
  String? telegramUrl;

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        lastName: json["lastName"],
        firstName: json["firstName"],
        profession: json["profession"] == null
            ? null
            : Profession.fromJson(json["profession"]),
        city: json["city"],
        photo: json["photo"],
        email: json["email"],
        vkUrl: json["vkUrl"],
        telegramUrl: json["telegramUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "lastName": lastName,
        "firstName": firstName,
        "profession": profession,
        "city": city,
        "photo": photo,
        "email": email,
        "vkUrl": vkUrl,
        "telegramUrl": telegramUrl,
      };
}
