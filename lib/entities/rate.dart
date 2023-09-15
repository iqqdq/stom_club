import 'dart:convert';

class Rate {
  Rate({
    required this.id,
    required this.isDeleted,
    required this.createdAt,
    required this.isLike,
    required this.review,
    required this.createdBy,
  });

  int id;
  bool isDeleted;
  String createdAt;
  bool isLike;
  int review;
  int createdBy;

  factory Rate.fromRawJson(String str) => Rate.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Rate.fromJson(Map<String, dynamic> json) => Rate(
        id: json["id"],
        isDeleted: json["isDeleted"],
        createdAt: json["createdAt"],
        isLike: json["isLike"],
        review: json["review"],
        createdBy: json["createdBy"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "isDeleted": isDeleted,
        "createdAt": createdAt,
        "isLike": isLike,
        "review": review,
        "createdBy": createdBy,
      };
}
