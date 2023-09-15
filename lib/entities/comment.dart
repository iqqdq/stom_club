import 'dart:convert';
import 'package:stom_club/entities/user.dart';

class Comment {
  Comment(
      {required this.id,
      required this.user,
      required this.isDeleted,
      required this.createdAt,
      required this.comment,
      required this.review,
      this.attachment});

  int id;
  User user;
  bool isDeleted;
  String createdAt;
  String comment;
  int review;
  String? attachment;

  factory Comment.fromRawJson(String str) => Comment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
      id: json["id"],
      user: User.fromJson(json["createdBy"]),
      isDeleted: json["isDeleted"],
      createdAt: json["createdAt"],
      comment: json["comment"],
      review: json["review"],
      attachment: json["attachment"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdBy": user.toJson(),
        "isDeleted": isDeleted,
        "createdAt": createdAt,
        "comment": comment,
        "review": review,
        "attachment": attachment
      };
}
