import 'dart:convert';

class Video {
  Video({
    required this.id,
    required this.isDeleted,
    this.createdAt,
    required this.name,
    required this.videoUrl,
    required this.product,
  });

  int id;
  bool isDeleted;
  String? createdAt;
  String name;
  String videoUrl;
  int product;

  factory Video.fromRawJson(String str) => Video.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        id: json["id"],
        isDeleted: json["isDeleted"],
        createdAt: json["createdAt"],
        name: json["name"],
        videoUrl: json["videoUrl"],
        product: json["product"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "isDeleted": isDeleted,
        "createdAt": createdAt,
        "name": name,
        "videoUrl": videoUrl,
        "product": product,
      };
}
