import 'dart:convert';

class Authorization {
  Authorization({
    required this.id,
    required this.phone,
    required this.isCreated,
  });

  int id;
  String phone;
  bool isCreated;

  factory Authorization.fromRawJson(String str) =>
      Authorization.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Authorization.fromJson(Map<String, dynamic> json) => Authorization(
        id: json["id"],
        phone: json["phone"],
        isCreated: json["isCreated"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "phone": phone,
        "isCreated": isCreated,
      };
}
