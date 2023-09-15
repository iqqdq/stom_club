import 'dart:convert';
import 'package:stom_club/entities/profession.dart';

class Manager {
  Manager(
      {required this.lastName,
      this.middleName,
      required this.firstName,
      required this.profession,
      required this.photo,
      required this.city,
      this.email,
      this.telegramUrl,
      this.vkUrl});

  String lastName;
  String? middleName;
  String firstName;
  Profession profession;
  String? photo;
  String? city;
  String? email;
  String? vkUrl;
  String? telegramUrl;

  factory Manager.fromRawJson(String str) => Manager.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Manager.fromJson(Map<String, dynamic> json) => Manager(
        lastName: json["lastName"],
        middleName: json["middleName"],
        firstName: json["firstName"],
        profession: Profession.fromJson(json["profession"]),
        photo: json["photo"],
        city: json["city"],
        email: json["email"],
        vkUrl: json["vkUrl"],
        telegramUrl: json["telegramUrl"],
      );

  Map<String, dynamic> toJson() => {
        "lastName": lastName,
        "middleName": middleName,
        "firstName": firstName,
        "profession": profession.toJson(),
        "photo": photo,
        "city": city,
        "email": email,
        "vkUrl": vkUrl,
        "telegramUrl": telegramUrl
      };
}
