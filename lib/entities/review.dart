import 'dart:convert';
import 'package:stom_club/entities/user.dart';

class Review {
  Review(
      {required this.id,
      required this.commentsCount,
      required this.likesCount,
      required this.dislikesCount,
      required this.createdBy,
      required this.hasMyLike,
      required this.hasMyDislike,
      required this.isDeleted,
      required this.createdAt,
      required this.advantages,
      required this.defects,
      required this.rating,
      required this.product,
      this.attachment});

  int id;
  int commentsCount;
  int likesCount;
  int dislikesCount;
  User createdBy;
  bool hasMyLike;
  bool hasMyDislike;
  bool isDeleted;
  String createdAt;
  String advantages;
  String defects;
  int rating;
  int product;
  String? attachment;

  factory Review.fromRawJson(String str) => Review.fromJson(json.decode(str));

  factory Review.fromJson(Map<String, dynamic> json) => Review(
      id: json["id"],
      commentsCount: json["commentsCount"],
      likesCount: json["likesCount"],
      dislikesCount: json["dislikesCount"],
      createdBy: User.fromJson(json["createdBy"]),
      hasMyLike: json["hasMyLike"],
      hasMyDislike: json["hasMyDislike"],
      isDeleted: json["isDeleted"],
      createdAt: json["createdAt"],
      advantages: json["advantages"],
      defects: json["defects"],
      rating: json["rating"],
      product: json["product"],
      attachment: json["attachment"]);
}
