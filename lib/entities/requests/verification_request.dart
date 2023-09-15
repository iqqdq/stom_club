import 'dart:convert';

class VerificationReuest {
  VerificationReuest({required this.id, required this.code});

  int id;
  String code;

  factory VerificationReuest.fromRawJson(String str) =>
      VerificationReuest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VerificationReuest.fromJson(Map<String, dynamic> json) =>
      VerificationReuest(
        id: json["id"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {"id": id, "code": code};
}
