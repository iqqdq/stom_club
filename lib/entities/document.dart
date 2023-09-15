import 'dart:convert';

class Document {
  Document({
    required this.id,
    this.fileType,
    required this.isDeleted,
    required this.createdAt,
    this.name,
    required this.file,
    required this.product,
  });

  int id;
  String? fileType;
  bool isDeleted;
  String createdAt;
  String? name;
  String file;
  int product;

  factory Document.fromRawJson(String str) =>
      Document.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Document.fromJson(Map<String, dynamic> json) => Document(
      id: json["id"],
      fileType: json["fileType"],
      isDeleted: json["isDeleted"],
      createdAt: json["createdAt"],
      name: json["name"],
      file: json["file"],
      product: json["product"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "fileType": fileType,
        "isDeleted": isDeleted,
        "createdAt": createdAt,
        "name": name,
        "file": file,
        "product": product
      };
}
